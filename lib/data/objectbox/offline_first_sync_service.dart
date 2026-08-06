import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../core/sync/alvos_animais_produtor.dart';
import '../../core/sync/queue_payload_codec.dart';
import '../../core/sync/reconciliacao_animais.dart';
import '../../core/sync/sync_etapa.dart';
import '../../core/sync/sync_exceptions.dart';
import '../../core/sync/upsert_referencia.dart';
import 'objectbox_service.dart';
import 'entities/index.dart';
import '../../objectbox.g.dart' hide Query;

/// Callback para reportar progresso da sincronização
typedef SyncProgressCallback = void Function(String message, double progress);

/// Serviço completo de sincronização offline-first
/// Faz download de todos os dados do Firestore ao acessar o app
/// Trabalha localmente com ObjectBox
/// Sincroniza alterações quando online
class OfflineFirstSyncService {
  static OfflineFirstSyncService? _instance;

  final ObjectBoxService _objectBox;
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _periodicSyncTimer;

  final _statusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get statusStream => _statusController.stream;

  final _progressController = StreamController<SyncProgress>.broadcast();
  Stream<SyncProgress> get progressStream => _progressController.stream;

  SyncStatus _currentStatus = SyncStatus.idle;
  SyncStatus get currentStatus => _currentStatus;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  /// Último usuário sincronizado. Guardado para que o listener de reconexão
  /// (que não recebe o uid) consiga rebaixar dados como o do técnico.
  String? _lastUserId;

  bool _initialSyncComplete = false;
  bool get initialSyncComplete => _initialSyncComplete;

  OfflineFirstSyncService._({
    required ObjectBoxService objectBox,
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  })  : _objectBox = objectBox,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _connectivity = connectivity ?? Connectivity();

  static OfflineFirstSyncService get instance {
    if (_instance == null) {
      throw StateError(
        'OfflineFirstSyncService não foi inicializado. '
        'Chame OfflineFirstSyncService.initialize() primeiro.',
      );
    }
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  static Future<OfflineFirstSyncService> initialize({
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  }) async {
    if (_instance != null) {
      return _instance!;
    }

    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    _instance = OfflineFirstSyncService._(
      objectBox: ObjectBoxService.instance,
      firestore: firestore,
      connectivity: connectivity,
    );

    await _instance!._setupConnectivityListener();

    return _instance!;
  }

  Future<void> _setupConnectivityListener() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        final wasOffline = !_isOnline;
        _isOnline = result != ConnectivityResult.none;

        if (_isOnline && wasOffline) {
          debugPrint('🔄 Conexão restaurada - sincronizando pendências');
          await syncPendingChangesToFirestore();
          // Rebaixa os dados do técnico (limites/plano podem ter mudado no
          // Firestore enquanto offline).
          if (_lastUserId != null) {
            await refreshTecnico(_lastUserId!);
          }
        }

        _updateStatus(_isOnline ? SyncStatus.idle : SyncStatus.offline);
      },
    );
  }

  void _updateStatus(SyncStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  SyncProgress? _lastProgress;

  /// Ultimo progresso emitido. A tela de sincronizacao pode montar depois do
  /// primeiro evento; sem isto ela renderizaria vazia ate o proximo lote.
  SyncProgress? get lastProgress => _lastProgress;

  void _reportProgress(
    SyncEtapa etapa,
    String message, {
    int? atual,
    int? total,
  }) {
    final progresso = SyncProgress(
      etapa: etapa,
      message: message,
      progress: progressoGlobal(etapa, atual: atual, total: total),
      atual: atual,
      total: total,
    );
    _lastProgress = progresso;
    _progressController.add(progresso);
    debugPrint(
        '📊 $message (${(progresso.progress * 100).toStringAsFixed(1)}%)');
  }

  // ==========================================================================
  // DOWNLOAD COMPLETO DO FIRESTORE (inicial ou ao trocar de dispositivo)
  // ==========================================================================

  /// Faz download completo de todos os dados do Firestore
  /// Deve ser chamado no login ou quando dados locais não existem
  Future<void> performFullDownload({
    required String userId,
    SyncProgressCallback? onProgress,
  }) async {
    _lastUserId = userId;
    if (!_isOnline) {
      debugPrint('📴 Offline - download adiado');
      _updateStatus(SyncStatus.offline);
      throw const SyncOfflineException();
    }

    _updateStatus(SyncStatus.syncing);
    _reportProgress(SyncEtapa.referencias, 'Tabelas de referência');

    try {
      // 1. Baixa tabelas de referência primeiro (são usadas por outras entidades)
      await _downloadReferenceTables();

      // 2. Sincroniza Person do usuário
      _reportProgress(SyncEtapa.usuario, 'Seus dados');
      await _downloadPerson(userId);

      // 3. Sincroniza Tecnico se existir
      _reportProgress(SyncEtapa.tecnico, 'Dados do técnico');
      final tecnicoRef = await _downloadTecnico(userId);

      // 4. Se for técnico, baixa todos os produtores vinculados
      _reportProgress(SyncEtapa.produtores, 'Produtores');
      if (tecnicoRef != null) {
        await _downloadProdutoresDoTecnico(tecnicoRef);
      } else {
        // Se for produtor, baixa seus próprios dados
        await _downloadProdutor(userId);
      }

      // 5. Baixa todas as propriedades
      _reportProgress(SyncEtapa.propriedades, 'Propriedades');
      await _downloadTodasPropriedades(tecnicoRef, userId);

      // 6. Baixa todos os animais (subcoleção 'animaisProdutores' do técnico)
      await _downloadTodosAnimais(tecnicoRef);

      // 7. Baixa ações e tratamentos
      await _downloadAcoes(tecnicoRef);

      // 8. Baixa dados financeiros e visitas
      _reportProgress(SyncEtapa.financeiro, 'Financeiro e visitas');
      await _downloadFinanceiroEVisitas();

      // Marca sincronização inicial como completa
      _updateSyncMetadata('initial_download', DateTime.now(), complete: true);
      // O download acima já gravou as propriedades no path correto — dispensa o
      // reparo pontual em instalações novas.
      _updateSyncMetadata(_kReparoPathPropriedades, DateTime.now(),
          complete: true);
      _initialSyncComplete = true;

      _reportProgress(SyncEtapa.financeiro, 'Concluído', atual: 1, total: 1);
      _updateStatus(SyncStatus.completed);
    } on SyncOfflineException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Erro no download completo: $e');
      _updateStatus(SyncStatus.error);
      throw SyncFalhaException(_lastProgress?.etapa, e);
    }
  }

  /// Baixa tabelas de referência (grupos, raças, status, etc.)
  /// Cada tabela é gravada com [_gravarReferencias], que reaproveita o `id`
  /// local do registro já existente. Sem isso o `put` insere de novo e viola o
  /// índice único de `firestoreId` no segundo download completo do aparelho —
  /// derrubando o download inteiro aqui no primeiro passo, antes de qualquer
  /// propriedade ou animal descer.
  Future<void> _downloadReferenceTables() async {
    // Grupos
    final grupos = await _firestore.collection('grupo').get();
    _gravarReferencias<GrupoEntity>(
      _objectBox.grupoBox,
      grupos.docs.map((d) => GrupoEntity.fromFirestore(d.data(), d.id)),
      (e) => e.firestoreId,
      (e) => e.id,
      (e, id) => e.id = id,
    );
    debugPrint('📦 ${grupos.docs.length} grupos baixados');

    // Raças
    final racas = await _firestore.collection('racas').get();
    _gravarReferencias<RacaEntity>(
      _objectBox.racaBox,
      racas.docs.map((d) => RacaEntity.fromFirestore(d.data(), d.id)),
      (e) => e.firestoreId,
      (e) => e.id,
      (e, id) => e.id = id,
    );
    debugPrint('📦 ${racas.docs.length} raças baixadas');

    // Status Animais
    final statusAnimais = await _firestore.collection('status_animais').get();
    _gravarReferencias<StatusAnimalEntity>(
      _objectBox.statusAnimalBox,
      statusAnimais.docs
          .map((d) => StatusAnimalEntity.fromFirestore(d.data(), d.id)),
      (e) => e.firestoreId,
      (e) => e.id,
      (e, id) => e.id = id,
    );
    debugPrint('📦 ${statusAnimais.docs.length} status animais baixados');

    // Status Produtivo
    final statusProdutivo =
        await _firestore.collection('status_produtivo').get();
    _gravarReferencias<StatusProdutivoEntity>(
      _objectBox.statusProdutivoBox,
      statusProdutivo.docs
          .map((d) => StatusProdutivoEntity.fromFirestore(d.data(), d.id)),
      (e) => e.firestoreId,
      (e) => e.id,
      (e, id) => e.id = id,
    );
    debugPrint('📦 ${statusProdutivo.docs.length} status produtivo baixados');

    // Tipo Ações
    final tipoAcoes = await _firestore.collection('tipo_acoes').get();
    _gravarReferencias<TipoAcaoEntity>(
      _objectBox.tipoAcaoBox,
      tipoAcoes.docs.map((d) => TipoAcaoEntity.fromFirestore(d.data(), d.id)),
      (e) => e.firestoreId,
      (e) => e.id,
      (e, id) => e.id = id,
    );
    debugPrint('📦 ${tipoAcoes.docs.length} tipos de ações baixados');

    // Calendário Sanitário
    final calendario =
        await _firestore.collection('calendario_sanitario').get();
    _gravarReferencias<CalendarioSanitarioEntity>(
      _objectBox.calendarioSanitarioBox,
      calendario.docs
          .map((d) => CalendarioSanitarioEntity.fromFirestore(d.data(), d.id)),
      (e) => e.firestoreId,
      (e) => e.id,
      (e, id) => e.id = id,
    );
    debugPrint(
        '📦 ${calendario.docs.length} itens do calendário sanitário baixados');

    // Cidades
    final cidades = await _firestore.collection('cidades').get();
    _gravarReferencias<CidadeEntity>(
      _objectBox.cidadeBox,
      cidades.docs.map((d) => CidadeEntity.fromFirestore(d.data(), d.id)),
      (e) => e.firestoreId,
      (e) => e.id,
      (e, id) => e.id = id,
    );
    debugPrint('📦 ${cidades.docs.length} cidades baixadas');
  }

  /// Grava uma tabela de referência como upsert: quem já existe é atualizado,
  /// quem é novo é inserido.
  void _gravarReferencias<T>(
    Box<T> box,
    Iterable<T> baixados,
    String? Function(T) firestoreIdDe,
    int Function(T) idDe,
    void Function(T, int) definirId,
  ) {
    final lista = baixados.toList();
    reaproveitarIds<T>(
      existentes: box.getAll(),
      baixados: lista,
      firestoreIdDe: firestoreIdDe,
      idDe: idDe,
      definirId: definirId,
    );
    box.putMany(lista);
  }

  /// Baixa dados de Person do usuário
  Future<void> _downloadPerson(String userId) async {
    final snapshot = await _firestore
        .collection('person')
        .where('uid', isEqualTo: userId)
        .get();

    for (final doc in snapshot.docs) {
      _upsertPerson(doc);
    }
    debugPrint('👤 ${snapshot.docs.length} pessoa(s) baixada(s)');
  }

  void _upsertPerson(QueryDocumentSnapshot doc) {
    final existing = _objectBox.personBox
        .query(PersonEntity_.firestoreId.equals(doc.id))
        .build()
        .findFirst();

    if (existing != null) {
      existing.updateFromFirestore(doc.data() as Map<String, dynamic>);
      _objectBox.personBox.put(existing);
    } else {
      final entity = PersonEntity.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
      _objectBox.personBox.put(entity);
    }
  }

  /// Baixa dados de Técnico
  Future<DocumentReference?> _downloadTecnico(String userId) async {
    final snapshot = await _firestore
        .collection('tecnico')
        .where('uidPerson', isEqualTo: userId)
        .get();

    DocumentReference? tecnicoRef;

    for (final doc in snapshot.docs) {
      tecnicoRef = doc.reference;

      final existing = _objectBox.tecnicoBox
          .query(TecnicoEntity_.firestoreId.equals(doc.id))
          .build()
          .findFirst();

      if (existing != null) {
        existing.updateFromFirestore(doc.data());
        _objectBox.tecnicoBox.put(existing);
      } else {
        final entity = TecnicoEntity.fromFirestore(doc.data(), doc.id);
        _objectBox.tecnicoBox.put(entity);
      }
    }

    debugPrint('👨‍⚕️ ${snapshot.docs.length} técnico(s) baixado(s)');
    return tecnicoRef;
  }

  /// Baixa todos os produtores vinculados a um técnico
  Future<void> _downloadProdutoresDoTecnico(
      DocumentReference tecnicoRef) async {
    final snapshot = await _firestore
        .collection('produtor')
        .where('uidTecnico', isEqualTo: tecnicoRef)
        .get();

    for (final doc in snapshot.docs) {
      _upsertProdutor(doc);
    }
    debugPrint('🌾 ${snapshot.docs.length} produtor(es) do técnico baixado(s)');
  }

  /// Baixa dados de Produtor do próprio usuário
  Future<void> _downloadProdutor(String userId) async {
    final personSnapshot = await _firestore
        .collection('person')
        .where('uid', isEqualTo: userId)
        .limit(1)
        .get();

    if (personSnapshot.docs.isEmpty) return;

    final personRef = personSnapshot.docs.first.reference;

    final snapshot = await _firestore
        .collection('produtor')
        .where('uidPerson', isEqualTo: personRef)
        .get();

    for (final doc in snapshot.docs) {
      _upsertProdutor(doc);
    }
    debugPrint('🌾 ${snapshot.docs.length} produtor(es) baixado(s)');
  }

  void _upsertProdutor(QueryDocumentSnapshot doc) {
    final existing = _objectBox.produtorBox
        .query(ProdutorEntity_.firestoreId.equals(doc.id))
        .build()
        .findFirst();

    if (existing != null) {
      existing.updateFromFirestore(doc.data() as Map<String, dynamic>);
      _objectBox.produtorBox.put(existing);
    } else {
      final entity = ProdutorEntity.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
      _objectBox.produtorBox.put(entity);
    }
  }

  /// Baixa as propriedades do usuário logado.
  ///
  /// As propriedades vivem na subcoleção `propriedades` do documento do TÉCNICO
  /// (`tecnico/{id}/propriedades`) — o mesmo caminho que a UI usa para criar e
  /// ler propriedades. O `parentPath` é derivado do próprio documento, para que
  /// os paths de sincronização e de edição não possam divergir.
  Future<void> _downloadTodasPropriedades(
    DocumentReference? tecnicoRef,
    String userId,
  ) async {
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

    if (tecnicoRef != null) {
      docs = (await tecnicoRef.collection('propriedades').get()).docs;
    } else {
      // Usuário produtor: não tem subcoleção própria. Encontra suas propriedades
      // pelo vínculo `uidPersonProdutor`, sob qualquer técnico.
      final personSnapshot = await _firestore
          .collection('person')
          .where('uid', isEqualTo: userId)
          .limit(1)
          .get();

      if (personSnapshot.docs.isEmpty) {
        debugPrint('🏡 0 propriedade(s) baixada(s) — person não encontrado');
        return;
      }

      docs = (await _firestore
              .collectionGroup('propriedades')
              .where('uidPersonProdutor',
                  isEqualTo: personSnapshot.docs.first.reference)
              .get())
          .docs;
    }

    for (final doc in docs) {
      final parentPath = doc.reference.parent.parent!.path;

      final existing = _objectBox.propriedadeBox
          .query(PropriedadeEntity_.firestoreId.equals(doc.id))
          .build()
          .findFirst();

      if (existing != null) {
        existing.updateFromFirestore(doc.data());
        // Corrige registros legados gravados com o path do produtor.
        existing.parentPath = parentPath;
        _objectBox.propriedadeBox.put(existing);
      } else {
        _objectBox.propriedadeBox.put(
          PropriedadeEntity.fromFirestore(doc.data(), doc.id, parentPath),
        );
      }
    }
    debugPrint('🏡 ${docs.length} propriedade(s) baixada(s)');
  }

  /// Baixa todos os animais das propriedades locais
  /// Baixa os animais do técnico.
  ///
  /// Os animais vivem na subcoleção `animaisProdutores` do documento do TÉCNICO
  /// (não da propriedade); cada animal referencia sua propriedade no campo
  /// `uidTecnicoPropriedade`. Por isso o `parentPath` da entidade é o path do
  /// documento do técnico — o que também alinha os paths de sincronização e de
  /// edição (`<parentPath>/animaisProdutores/<id>`).
  /// Quem entra como PRODUTOR não tem documento de técnico, e antes o download
  /// desistia na primeira linha (`if (tecnicoRef == null) return`) — o produtor
  /// ficava só com os animais criados offline naquele aparelho. Ele chega no
  /// rebanho pelo caminho das propriedades dele, que o download anterior já
  /// gravou com o `parentPath` do técnico dono, e busca filtrando por
  /// propriedade: o que enxerga é o dele, não o rebanho inteiro do técnico.
  Future<void> _downloadTodosAnimais(DocumentReference? tecnicoRef) async {
    int totalAnimais = 0;

    if (tecnicoRef != null) {
      final colecao = tecnicoRef.collection('animaisProdutores');
      final total = (await colecao.count().get()).count ?? 0;
      totalAnimais = await _baixarAnimaisPaginado(
        colecao,
        tecnicoRef.path,
        total,
        0,
      );
    } else {
      // Produtor: chega no rebanho pelo caminho das propriedades dele, e
      // filtrando por propriedade — enxerga o dele, nao o rebanho do tecnico.
      final alvos = alvosAnimaisProdutor(_objectBox.propriedadeBox.getAll());

      final consultas = {
        for (final alvo in alvos)
          alvo: _firestore
              .doc(alvo.tecnicoPath)
              .collection('animaisProdutores')
              .where('uidTecnicoPropriedade',
                  isEqualTo: _firestore.doc(alvo.propriedadePath)),
      };

      var total = 0;
      for (final consulta in consultas.values) {
        total += (await consulta.count().get()).count ?? 0;
      }

      for (final entrada in consultas.entries) {
        try {
          totalAnimais = await _baixarAnimaisPaginado(
            entrada.value,
            entrada.key.tecnicoPath,
            total,
            totalAnimais,
          );
        } catch (e) {
          debugPrint(
              '⚠️ Erro ao baixar animais de ${entrada.key.propriedadePath}: $e');
        }
      }
    }

    debugPrint('🐄 $totalAnimais animal(is) baixado(s)');
  }

  /// Tamanho do lote de download e gravacao. 250 e nao 500 por causa do ritmo:
  /// cada lote e uma amostra para o estimador, e com 500 haveria so 6 amostras
  /// em 3000 animais — o ritmo mal apareceria antes de terminar.
  static const int _loteDownload = 250;

  /// Baixa animais em paginas, reportando progresso a cada lote. Devolve o
  /// acumulado atualizado.
  Future<int> _baixarAnimaisPaginado(
    Query<Map<String, dynamic>> consulta,
    String parentPath,
    int total,
    int acumulado,
  ) async {
    DocumentSnapshot? ultimo;

    while (true) {
      var pagina = consulta.orderBy(FieldPath.documentId).limit(_loteDownload);
      if (ultimo != null) pagina = pagina.startAfterDocument(ultimo);

      final snapshot = await pagina.get();
      if (snapshot.docs.isEmpty) break;

      acumulado += _salvarAnimais(snapshot.docs, parentPath);
      ultimo = snapshot.docs.last;

      _reportProgress(
        SyncEtapa.animais,
        'Animais',
        atual: acumulado,
        total: total,
      );

      // Devolve a isolate principal ao event loop para a UI respirar entre
      // lotes; sem isso a barra de progresso nao anima.
      await Future<void>.delayed(Duration.zero);

      if (snapshot.docs.length < _loteDownload) break;
    }

    return acumulado;
  }

  /// Grava um lote de animais baixados numa unica transacao.
  ///
  /// A versao anterior fazia, por animal, uma query e um `put` — 3000 queries e
  /// 3000 transacoes na isolate principal, o que congelava a UI thread por
  /// dezenas de segundos no primeiro login de um tecnico grande.
  int _salvarAnimais(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String parentPath,
  ) {
    if (docs.isEmpty) return 0;

    final ids = docs.map((d) => d.id).toList();
    final existentes = _objectBox.animalBox
        .query(AnimalEntity_.firestoreId.oneOf(ids))
        .build()
        .find();

    final aGravar = reconciliarAnimais(
      docs: docs.map((d) => DocAnimal(d.id, d.data())).toList(),
      existentesPorFirestoreId: {
        for (final e in existentes) e.firestoreId!: e,
      },
      parentPath: parentPath,
    );

    _objectBox.animalBox.putMany(aGravar);
    return docs.length;
  }

  /// Baixa ações e tratamentos.
  ///
  /// As AÇÕES vivem na subcoleção `acoes` do TÉCNICO
  /// (`tecnico/{id}/acoes`), cada uma com `uidAnimalAnimaisProdutores` e
  /// `uidPropriedade` ligando ao animal/propriedade — por isso o `parentPath`
  /// da AcaoEntity é o path do técnico. Tratamentos, ações sanitárias e
  /// recomendações são subcoleções da PROPRIEDADE e vêm em
  /// `_downloadFinanceiroEVisitas`.
  Future<void> _downloadAcoes(DocumentReference? tecnicoRef) async {
    int totalAcoes = 0;

    // Ações do técnico.
    if (tecnicoRef != null) {
      try {
        final colecao = tecnicoRef.collection('acoes');
        final total = (await colecao.count().get()).count ?? 0;
        DocumentSnapshot? ultimo;

        while (true) {
          var pagina =
              colecao.orderBy(FieldPath.documentId).limit(_loteDownload);
          if (ultimo != null) pagina = pagina.startAfterDocument(ultimo);

          final snapshot = await pagina.get();
          if (snapshot.docs.isEmpty) break;

          _objectBox.acaoBox.putMany([
            for (final doc in snapshot.docs)
              AcaoEntity.fromFirestore(doc.data(), doc.id, tecnicoRef.path),
          ]);

          totalAcoes += snapshot.docs.length;
          ultimo = snapshot.docs.last;

          _reportProgress(
            SyncEtapa.acoes,
            'Ações e tratamentos',
            atual: totalAcoes,
            total: total,
          );
          await Future<void>.delayed(Duration.zero);

          if (snapshot.docs.length < _loteDownload) break;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar ações: $e');
      }
    } else {
      // Produtor: mesma lacuna dos animais. Sem isto o histórico do prontuário
      // chega vazio, mesmo com os animais já baixados.
      for (final alvo
          in alvosAnimaisProdutor(_objectBox.propriedadeBox.getAll())) {
        try {
          final acoesSnapshot = await _firestore
              .doc(alvo.tecnicoPath)
              .collection('acoes')
              .where('uidPropriedade',
                  isEqualTo: _firestore.doc(alvo.propriedadePath))
              .get();
          for (final doc in acoesSnapshot.docs) {
            _objectBox.acaoBox.put(
              AcaoEntity.fromFirestore(doc.data(), doc.id, alvo.tecnicoPath),
            );
            totalAcoes++;
          }
        } catch (e) {
          debugPrint('⚠️ Erro ao baixar ações de ${alvo.propriedadePath}: $e');
        }
      }
    }

    debugPrint('📋 $totalAcoes ação(ões) baixada(s)');
  }

  /// Baixa dados financeiros e visitas
  Future<void> _downloadFinanceiroEVisitas() async {
    final propriedades = _objectBox.propriedadeBox.getAll();
    int totalFinanceiro = 0;
    int totalVisitas = 0;
    int totalTratamentos = 0;
    int totalRecomendacoes = 0;

    for (final prop in propriedades) {
      if (prop.firestoreId == null || prop.parentPath == null) continue;

      final propRef =
          _firestore.doc('${prop.parentPath}/propriedades/${prop.firestoreId}');

      // Baixa dados financeiros
      try {
        final financeiroSnapshot = await propRef.collection('financeiro').get();
        for (final doc in financeiroSnapshot.docs) {
          final entity = FinanceiroEntity.fromFirestore(
            doc.data(),
            doc.id,
            parentPath: propRef.path,
          );
          _objectBox.financeiroBox.put(entity);
          totalFinanceiro++;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar financeiro: $e');
      }

      // Baixa ações sanitárias (subcoleção da PROPRIEDADE; antes o download
      // varria `animal/acoes_sanitario`, coleção que nada escreve).
      try {
        final sanitarioSnapshot =
            await propRef.collection('acoesSanitario').get();
        for (final doc in sanitarioSnapshot.docs) {
          final entity = AcaoSanitarioEntity.fromFirestore(
            doc.data(),
            doc.id,
            parentPath: propRef.path,
          );
          _objectBox.acaoSanitarioBox.put(entity);
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar ações sanitárias: $e');
      }

      // Baixa resumos de visitas. `resumo_da_visita` é TOP-LEVEL no
      // Firestore (o app grava com FirebaseFirestore.instance.collection),
      // não subcoleção da propriedade — antes o download procurava aninhado e
      // por isso a tabela local ficava vazia. O recorte por propriedade vira
      // filtro na query.
      try {
        final visitasSnapshot = await _firestore
            .collection('resumo_da_visita')
            .where('uidPropriedade', isEqualTo: propRef)
            .get();
        for (final doc in visitasSnapshot.docs) {
          final entity = ResumoVisitaEntity.fromFirestore(
            doc.data(),
            doc.id,
            parentPath: 'resumo_da_visita',
          );
          _objectBox.resumoVisitaBox.put(entity);
          totalVisitas++;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar visitas: $e');
      }

      // Baixa tratamentos. Passam a ser subcoleção da PROPRIEDADE (antes o
      // download varria animal/tratamentos); o vínculo com a visita é o campo
      // `uidResumoDaVisita`.
      try {
        final tratamentosSnapshot =
            await propRef.collection('tratamentos').get();
        for (final doc in tratamentosSnapshot.docs) {
          final entity = TratamentoEntity.fromFirestore(
            doc.data(),
            doc.id,
            parentPath: propRef.path,
          );
          _objectBox.tratamentoBox.put(entity);
          totalTratamentos++;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar tratamentos: $e');
      }

      // Baixa recomendações
      try {
        final recomendacoesSnapshot =
            await propRef.collection('recomendacoes').get();
        for (final doc in recomendacoesSnapshot.docs) {
          final entity = RecomendacaoEntity.fromFirestore(
            doc.data(),
            doc.id,
            parentPath: propRef.path,
          );
          _objectBox.recomendacaoBox.put(entity);
          totalRecomendacoes++;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar recomendações: $e');
      }

      // Baixa ações da visita
      try {
        final acoesDaVisitaSnapshot =
            await propRef.collection('acoes_da_visita').get();
        for (final doc in acoesDaVisitaSnapshot.docs) {
          final entity = AcaoDaVisitaEntity.fromFirestore(
            doc.data(),
            doc.id,
            propRef.path,
          );
          _objectBox.acaoDaVisitaBox.put(entity);
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar ações da visita: $e');
      }
    }

    debugPrint('💰 $totalFinanceiro registro(s) financeiro(s) baixados');
    debugPrint('💊 $totalTratamentos tratamento(s) baixados');
    debugPrint(
        '📝 $totalVisitas visita(s) e $totalRecomendacoes recomendação(ões) baixadas');
  }

  // ==========================================================================
  // SINCRONIZAÇÃO DE ALTERAÇÕES LOCAIS PARA O FIRESTORE
  // ==========================================================================

  /// Sincroniza todas as alterações pendentes para o Firestore
  Future<void> syncPendingChangesToFirestore() async {
    if (!_isOnline) {
      debugPrint('📴 Offline - sincronização adiada');
      return;
    }

    _updateStatus(SyncStatus.syncing);

    try {
      // Sincroniza entidades com needsSync = true. Propriedades primeiro: seus
      // filhos referenciam o path da propriedade (o Firestore não valida a
      // existência da ref, mas manter a ordem é mais coerente).
      await _syncModifiedPropriedades();
      await _syncModifiedAnimals();
      await _syncModifiedAcoes();
      await _syncModifiedTratamentos();
      await _syncModifiedFinanceiro();
      await _syncModifiedVisitas();

      // Processa operações pendentes na fila
      await _processPendingOperations();

      _updateStatus(SyncStatus.completed);
      debugPrint('✅ Sincronização de alterações concluída');
    } catch (e) {
      debugPrint('❌ Erro na sincronização: $e');
      _updateStatus(SyncStatus.error);
    }
  }

  /// Payload da propriedade, reanexando o produtor (`uidPersonProdutor`) quando
  /// já vinculado. Alinhado com `PropriedadeRepository.firestorePayloadFor`.
  Map<String, dynamic> _propriedadePayload(PropriedadeEntity prop) {
    final data = prop.toFirestore();
    if (prop.uidPersonProdutorPath != null) {
      data['uidPersonProdutor'] = _firestore.doc(prop.uidPersonProdutorPath!);
    }
    return data;
  }

  /// Sincroniza propriedades modificadas localmente. A propriedade nasce com um
  /// firestoreId real e sobe sozinha ao reconectar (sem depender da ativação),
  /// via `set(merge)` idempotente. Backfill: propriedade legada sem firestoreId
  /// ganha um id gerado aqui.
  Future<void> _syncModifiedPropriedades() async {
    final modified = _objectBox.propriedadeBox
        .query(PropriedadeEntity_.needsSync.equals(true))
        .build()
        .find();

    for (final prop in modified) {
      try {
        if (prop.parentPath == null) continue;
        prop.firestoreId ??=
            _firestore.collection('${prop.parentPath}/propriedades').doc().id;

        // set-merge cobre create e update (incl. soft-delete via isDeleted no
        // payload) sem apagar o uidPersonProdutor vinculado na ativação.
        await _firestore
            .doc('${prop.parentPath}/propriedades/${prop.firestoreId}')
            .set(_propriedadePayload(prop), SetOptions(merge: true));
        prop.needsSync = false;
        prop.lastSynced = DateTime.now();
        _objectBox.propriedadeBox.put(prop);
      } catch (e) {
        debugPrint('❌ Erro ao sincronizar propriedade ${prop.firestoreId}: $e');
      }
    }

    if (modified.isNotEmpty) {
      debugPrint('🏡 ${modified.length} propriedade(s) sincronizada(s)');
    }
  }

  /// Sincroniza animais modificados localmente
  Future<void> _syncModifiedAnimals() async {
    final modified = _objectBox.animalBox
        .query(AnimalEntity_.needsSync.equals(true))
        .build()
        .find();

    for (final animal in modified) {
      try {
        if (animal.firestoreId != null && animal.parentPath != null) {
          // set-merge cobre create (id pré-gerado) e update idempotentemente.
          final docRef = _firestore.doc(
            '${animal.parentPath}/animaisProdutores/${animal.firestoreId}',
          );
          await docRef.set(_animalPayload(animal), SetOptions(merge: true));
          animal.needsSync = false;
          animal.lastSynced = DateTime.now();
          _objectBox.animalBox.put(animal);
        } else if (animal.firestoreId == null &&
            animal.parentPath != null &&
            !animal.isDeleted) {
          // Novo animal (criado offline) - criar no Firestore e reconciliar.
          final collectionRef =
              _firestore.collection('${animal.parentPath}/animaisProdutores');
          final docRef = await collectionRef.add(_animalPayload(animal));
          animal.firestoreId = docRef.id;
          animal.needsSync = false;
          animal.lastSynced = DateTime.now();
          _objectBox.animalBox.put(animal);
          _resolveAcoesParaAnimalSincronizado(animal);
        }
      } catch (e) {
        debugPrint('❌ Erro ao sincronizar animal ${animal.firestoreId}: $e');
      }
    }

    if (modified.isNotEmpty) {
      debugPrint('🐄 ${modified.length} animal(is) sincronizado(s)');
    }
  }

  /// Payload da ação para o Firestore, reanexando as referências
  /// (`DocumentReference`) que a entity pura não constrói — `uidAnimalAnimaisProdutores`
  /// e `uidPropriedade`. Mantém o laço por-entidade alinhado com
  /// `AcaoRepository.firestorePayloadFor` (sem o qual as ações sincronizadas por
  /// aqui perderiam o vínculo com o animal/propriedade).
  Map<String, dynamic> _acaoPayload(AcaoEntity acao) {
    final data = acao.toFirestore();
    if (acao.uidAnimalAnimaisProdutoresPath != null) {
      data['uidAnimalAnimaisProdutores'] =
          _firestore.doc(acao.uidAnimalAnimaisProdutoresPath!);
    }
    if (acao.uidPropriedadePath != null) {
      data['uidPropriedade'] = _firestore.doc(acao.uidPropriedadePath!);
    }
    return data;
  }

  /// Payload do animal para o Firestore, reanexando o vínculo com a propriedade
  /// (`uidTecnicoPropriedade` como `DocumentReference`) que a entity pura não
  /// constrói. Sem isto, animal criado offline sobe SEM o vínculo. Alinhado com
  /// `AnimalRepository.firestorePayloadFor`.
  Map<String, dynamic> _animalPayload(AnimalEntity animal) {
    final data = animal.toFirestore();
    if (animal.uidTecnicoPropriedadePath != null) {
      data['uidTecnicoPropriedade'] =
          _firestore.doc(animal.uidTecnicoPropriedadePath!);
    }
    return data;
  }

  /// Sincroniza ações modificadas localmente
  Future<void> _syncModifiedAcoes() async {
    final modified = _objectBox.acaoBox
        .query(AcaoEntity_.needsSync.equals(true))
        .build()
        .find();

    for (final acao in modified) {
      try {
        if (acao.firestoreId != null &&
            acao.parentPath != null &&
            _acaoVinculoResolvido(acao)) {
          // set-merge cobre create (id pré-gerado) e update. A guarda de vínculo
          // segura ações sobre animal-offline LEGADO até o animal subir e a
          // cascata preencher `uidAnimalAnimaisProdutoresPath`.
          final docRef = _firestore.doc(
            '${acao.parentPath}/acoes/${acao.firestoreId}',
          );
          await docRef.set(_acaoPayload(acao), SetOptions(merge: true));
          acao.needsSync = false;
          acao.lastSynced = DateTime.now();
          _objectBox.acaoBox.put(acao);
        } else if (acao.firestoreId == null &&
            acao.parentPath != null &&
            !acao.isDeleted &&
            _acaoVinculoResolvido(acao)) {
          // Nova ação - criar no Firestore (não ressuscita soft-delete pendente;
          // não cria se o vínculo com animal-offline ainda não foi resolvido).
          final collectionRef =
              _firestore.collection('${acao.parentPath}/acoes');
          final docRef = await collectionRef.add(_acaoPayload(acao));
          acao.firestoreId = docRef.id;
          acao.needsSync = false;
          acao.lastSynced = DateTime.now();
          _objectBox.acaoBox.put(acao);
        }
      } catch (e) {
        debugPrint('❌ Erro ao sincronizar ação ${acao.firestoreId}: $e');
      }
    }

    if (modified.isNotEmpty) {
      debugPrint('📋 ${modified.length} ação(ões) sincronizada(s)');
    }
  }

  /// `true` se a ação NÃO tem dependência pendente de um animal criado offline:
  /// ou não referencia animal-offline (`uidAnimalOffline` vazio), ou o vínculo
  /// já foi resolvido (`uidAnimalAnimaisProdutoresPath` preenchido pela cascata
  /// [_resolveAcoesParaAnimalSincronizado] quando o animal sincronizou).
  ///
  /// Segura a criação de uma ação sobre animal-offline até o animal subir, para
  /// não gravar no Firestore uma ação SEM a `DocumentReference` do animal.
  bool _acaoVinculoResolvido(AcaoEntity acao) =>
      acao.uidAnimalOffline == null ||
      acao.uidAnimalOffline!.isEmpty ||
      acao.uidAnimalAnimaisProdutoresPath != null;

  /// Quando um animal criado offline finalmente sobe e ganha `firestoreId`,
  /// preenche o vínculo (`uidAnimalAnimaisProdutoresPath`) das ações criadas
  /// referenciando esse animal só pela identidade local (`uidAnimalOffline`) e
  /// as remarca para sync. Como `_syncModifiedAnimals` roda ANTES de
  /// `_syncModifiedAcoes` no mesmo ciclo, essas ações são criadas logo em
  /// seguida já com a `DocumentReference` correta do animal.
  void _resolveAcoesParaAnimalSincronizado(AnimalEntity animal) {
    final uidOffline = animal.uidAnimalOffline;
    if (uidOffline == null ||
        uidOffline.isEmpty ||
        animal.firestoreId == null) {
      return;
    }
    final novoPath =
        '${animal.parentPath}/animaisProdutores/${animal.firestoreId}';
    final pendentes = _objectBox.acaoBox
        .query(AcaoEntity_.uidAnimalOffline.equals(uidOffline))
        .build()
        .find()
        .where((a) => a.uidAnimalAnimaisProdutoresPath == null && !a.isDeleted)
        .toList();
    for (final acao in pendentes) {
      acao.uidAnimalAnimaisProdutoresPath = novoPath;
      acao.needsSync = true;
      _objectBox.acaoBox.put(acao);
    }
    if (pendentes.isNotEmpty) {
      debugPrint(
          '🔗 ${pendentes.length} ação(ões) vinculada(s) ao animal recém-sincronizado');
    }
  }

  /// Sincroniza tratamentos modificados localmente
  Future<void> _syncModifiedTratamentos() async {
    final modified = _objectBox.tratamentoBox
        .query(TratamentoEntity_.needsSync.equals(true))
        .build()
        .find();

    for (final tratamento in modified) {
      try {
        if (tratamento.firestoreId != null && tratamento.parentPath != null) {
          final docRef = _firestore.doc(
            '${tratamento.parentPath}/tratamentos/${tratamento.firestoreId}',
          );
          await docRef.update(_payloadTratamento(tratamento));
          tratamento.needsSync = false;
          tratamento.lastSynced = DateTime.now();
          _objectBox.tratamentoBox.put(tratamento);
        } else if (tratamento.firestoreId == null &&
            tratamento.parentPath != null &&
            !tratamento.isDeleted) {
          final collectionRef =
              _firestore.collection('${tratamento.parentPath}/tratamentos');
          final docRef =
              await collectionRef.add(_payloadTratamento(tratamento));
          tratamento.firestoreId = docRef.id;
          tratamento.needsSync = false;
          tratamento.lastSynced = DateTime.now();
          _objectBox.tratamentoBox.put(tratamento);
        }
      } catch (e) {
        debugPrint(
            '❌ Erro ao sincronizar tratamento ${tratamento.firestoreId}: $e');
      }
    }

    if (modified.isNotEmpty) {
      debugPrint('💊 ${modified.length} tratamento(s) sincronizado(s)');
    }
  }

  /// Sincroniza dados financeiros modificados
  Future<void> _syncModifiedFinanceiro() async {
    final modified = _objectBox.financeiroBox
        .query(FinanceiroEntity_.needsSync.equals(true))
        .build()
        .find();

    for (final fin in modified) {
      try {
        // O entity guarda os caminhos; o Firestore espera DocumentReference.
        // Sem reanexar, as telas que filtram por `uidPropriedade` (indices
        // zootecnicos) nao encontrariam o documento.
        Map<String, dynamic> payload(FinanceiroEntity e) => {
              ...e.toFirestore(),
              if (e.uidPropriedadePath != null)
                'uidPropriedade': _firestore.doc(e.uidPropriedadePath!),
              if (e.uidTecnicoPath != null)
                'uidTecnico': _firestore.doc(e.uidTecnicoPath!),
            };

        if (fin.firestoreId != null && fin.parentPath != null) {
          final docRef = _firestore.doc(
            '${fin.parentPath}/financeiro/${fin.firestoreId}',
          );
          await docRef.update(payload(fin));
          fin.needsSync = false;
          fin.lastSynced = DateTime.now();
          _objectBox.financeiroBox.put(fin);
        } else if (fin.firestoreId == null &&
            fin.parentPath != null &&
            !fin.isDeleted) {
          // Novo registro (criado offline) - criar no Firestore e reconciliar.
          final collectionRef =
              _firestore.collection('${fin.parentPath}/financeiro');
          final docRef = await collectionRef.add(payload(fin));
          fin.firestoreId = docRef.id;
          fin.needsSync = false;
          fin.lastSynced = DateTime.now();
          _objectBox.financeiroBox.put(fin);
        }
      } catch (e) {
        debugPrint('❌ Erro ao sincronizar financeiro ${fin.firestoreId}: $e');
      }
    }

    if (modified.isNotEmpty) {
      debugPrint(
          '💰 ${modified.length} registro(s) financeiro(s) sincronizado(s)');
    }
  }

  /// Reanexa as referências do tratamento (guardadas como caminho).
  Map<String, dynamic> _payloadTratamento(TratamentoEntity t) => {
        ...t.toFirestore(),
        if (t.uidAnimalPath != null)
          'uidAnimal': _firestore.doc(t.uidAnimalPath!),
        if (t.uidResumoDaVisitaPath != null)
          'uidResumoDaVisita': _firestore.doc(t.uidResumoDaVisitaPath!),
        if (t.uidAcaoLancadaPath != null)
          'uidAcaoLancada': _firestore.doc(t.uidAcaoLancadaPath!),
        if (t.compararDtUltimaInseminacao != null)
          'compararDtUltimaInseminacao':
              Timestamp.fromDate(t.compararDtUltimaInseminacao!),
      };

  /// Reanexa referências e Timestamps que o entity guarda como caminho/data.
  Map<String, dynamic> _payloadVisita(ResumoVisitaEntity v) => {
        ...v.toFirestore(),
        if (v.uidPropriedadePath != null)
          'uidPropriedade': _firestore.doc(v.uidPropriedadePath!),
        if (v.uidTecnicoPath != null)
          'uidTecnico': _firestore.doc(v.uidTecnicoPath!),
        if (v.uidResumoDaVisitaPath != null)
          'uidResumoDaVisita': _firestore.doc(v.uidResumoDaVisitaPath!),
        if (v.dtVisita != null) 'dtVisita': Timestamp.fromDate(v.dtVisita!),
        if (v.dtAssinatura != null)
          'dtAssinatura': Timestamp.fromDate(v.dtAssinatura!),
      };

  /// Sincroniza visitas modificadas
  Future<void> _syncModifiedVisitas() async {
    final modified = _objectBox.resumoVisitaBox
        .query(ResumoVisitaEntity_.needsSync.equals(true))
        .build()
        .find();

    for (final visita in modified) {
      try {
        if (visita.firestoreId != null && visita.parentPath != null) {
          final docRef =
              _firestore.doc('resumo_da_visita/${visita.firestoreId}');
          // `set(merge)` e não `update`: com id pré-gerado o documento pode
          // ainda não existir no Firestore na primeira subida.
          await docRef.set(_payloadVisita(visita), SetOptions(merge: true));
          visita.needsSync = false;
          visita.lastSynced = DateTime.now();
          _objectBox.resumoVisitaBox.put(visita);
        } else if (visita.firestoreId == null &&
            visita.parentPath != null &&
            !visita.isDeleted) {
          // Nova visita (criada offline) - criar no Firestore e reconciliar.
          final collectionRef = _firestore.collection('resumo_da_visita');
          final docRef = await collectionRef.add(_payloadVisita(visita));
          visita.firestoreId = docRef.id;
          visita.needsSync = false;
          visita.lastSynced = DateTime.now();
          _objectBox.resumoVisitaBox.put(visita);
        }
      } catch (e) {
        debugPrint('❌ Erro ao sincronizar visita ${visita.firestoreId}: $e');
      }
    }

    if (modified.isNotEmpty) {
      debugPrint('📝 ${modified.length} visita(s) sincronizada(s)');
    }
  }

  /// Processa operações pendentes da fila
  Future<void> _processPendingOperations() async {
    final pendingOps = _objectBox.pendingOperationBox
        .query()
        .order(PendingOperationEntity_.priority)
        .order(PendingOperationEntity_.createdAt)
        .build()
        .find();

    for (final op in pendingOps) {
      try {
        await _executePendingOperation(op);
        _objectBox.pendingOperationBox.remove(op.id);
      } catch (e) {
        op.retryCount++;
        op.lastError = e.toString();
        _objectBox.pendingOperationBox.put(op);

        if (op.retryCount >= 5) {
          debugPrint('⚠️ Operação ${op.id} excedeu máximo de tentativas');
        }
      }
    }

    if (pendingOps.isNotEmpty) {
      debugPrint(
          '📤 ${pendingOps.length} operação(ões) pendente(s) processada(s)');
    }
  }

  Future<void> _executePendingOperation(PendingOperationEntity op) async {
    if (op.documentPath == null) return;

    final docRef = _firestore.doc(op.documentPath!);
    final data =
        op.dataJson != null ? QueuePayloadCodec.decode(op.dataJson!) : null;

    switch (op.operationType) {
      case 'CREATE':
        await _executeQueuedCreate(op, docRef, data);
        break;
      case 'UPDATE':
        if (data != null) await docRef.update(data);
        break;
      case 'DELETE':
        await docRef.delete();
        break;
    }
  }

  /// Executa um CREATE da fila relendo o ESTADO ATUAL da entity (em vez do
  /// snapshot capturado no enqueue) e reconciliando a entity local depois.
  ///
  /// Duas correções num passo, válidas para os repositórios SEM laço próprio
  /// (os com laço não enfileiram CREATE):
  /// 1. **Snapshot velho**: a fila guardava o payload do momento do enqueue, então
  ///    uma edição feita offline DEPOIS do enqueue e ANTES do reconnect se perdia.
  ///    Relendo `entity.toFirestore()` aqui, o doc sobe com o estado mais recente.
  /// 2. **Reconcile**: a fila não gravava `firestoreId`/`needsSync` de volta —
  ///    deixando a entity dirty (edição futura virava no-op; duplicata via
  ///    listener). Como o doc é criado em `.../{collectionName}/{objectboxId}`,
  ///    `docRef.id` é o `firestoreId` e o id local é o último segmento do path.
  ///
  /// Se a entity foi soft-deletada offline antes do 1º sync, NÃO a cria (não
  /// ressuscita). Para coleções sem acessor (ex.: tabelas de referência) cai no
  /// snapshot da fila, sem reconciliar.
  Future<void> _executeQueuedCreate(
    PendingOperationEntity op,
    DocumentReference<Map<String, dynamic>> docRef,
    Map<String, dynamic>? snapshot,
  ) async {
    final objectboxId = int.tryParse(op.documentPath?.split('/').last ?? '');
    final accessor = _accessorFor(op.collectionName);
    final current = (accessor != null && objectboxId != null)
        ? accessor.get(objectboxId)
        : null;

    if (current != null && current.isDeleted) return; // não ressuscita

    final payload = current?.toFirestore() ?? snapshot;
    if (payload == null) return;
    await docRef.set(payload);

    if (current != null && accessor != null) {
      current.firestoreId = docRef.id;
      current.needsSync = false;
      current.lastSynced = DateTime.now();
      accessor.put(current);
    }
  }

  /// Acessor `get`/`put` tipado da box de uma coleção SEM laço próprio. Retorna
  /// `null` para coleções com laço (que não passam CREATE pela fila) e tabelas
  /// de referência. Reusado para reler o estado atual e reconciliar no CREATE.
  ({SyncableEntity? Function(int id) get, void Function(SyncableEntity e) put})?
      _accessorFor(String? collectionName) {
    switch (collectionName) {
      case 'person':
        return (
          get: _objectBox.personBox.get,
          put: (e) => _objectBox.personBox.put(e as PersonEntity),
        );
      case 'tecnico':
        return (
          get: _objectBox.tecnicoBox.get,
          put: (e) => _objectBox.tecnicoBox.put(e as TecnicoEntity),
        );
      case 'produtor':
        return (
          get: _objectBox.produtorBox.get,
          put: (e) => _objectBox.produtorBox.put(e as ProdutorEntity),
        );
      case 'propriedades':
        return (
          get: _objectBox.propriedadeBox.get,
          put: (e) => _objectBox.propriedadeBox.put(e as PropriedadeEntity),
        );
      case 'acoes_da_visita':
        return (
          get: _objectBox.acaoDaVisitaBox.get,
          put: (e) => _objectBox.acaoDaVisitaBox.put(e as AcaoDaVisitaEntity),
        );
      case 'acoesSanitario':
        return (
          get: _objectBox.acaoSanitarioBox.get,
          put: (e) => _objectBox.acaoSanitarioBox.put(e as AcaoSanitarioEntity),
        );
      case 'recomendacoes':
        return (
          get: _objectBox.recomendacaoBox.get,
          put: (e) => _objectBox.recomendacaoBox.put(e as RecomendacaoEntity),
        );
    }
    return null;
  }

  // ==========================================================================
  // VERIFICAÇÃO E SINCRONIZAÇÃO INCREMENTAL
  // ==========================================================================

  /// Marca de reparo (uma vez por instalação) do path das propriedades.
  static const _kReparoPathPropriedades = 'reparo_path_propriedades_v1';

  /// Reparo pontual para instalações que já sincronizaram antes da correção:
  /// o download antigo lia as propriedades de `produtor/{id}/propriedades` (path
  /// errado) e gravava o `parentPath` do produtor, então elas nunca casavam com
  /// as queries da UI (que usam `tecnico/{id}`). Re-baixa SÓ as propriedades,
  /// corrigindo o `parentPath` — não força um download completo.
  Future<void> repararPathPropriedades(String userId) async {
    if (!_isOnline) return;

    final marca = _objectBox.syncMetadataBox
        .query(
            SyncMetadataEntity_.collectionName.equals(_kReparoPathPropriedades))
        .build()
        .findFirst();
    if (marca != null && marca.initialSyncComplete) return;

    try {
      final tecnicoRef = await _downloadTecnico(userId);
      await _downloadTodasPropriedades(tecnicoRef, userId);
      _updateSyncMetadata(_kReparoPathPropriedades, DateTime.now(),
          complete: true);
      debugPrint('🛠️ Reparo do path das propriedades concluído');
    } catch (e) {
      // Sem marcar como concluído: tenta de novo no próximo login.
      debugPrint('⚠️ Falha ao reparar o path das propriedades: $e');
    }
  }

  /// Rebaixa apenas os dados do técnico do Firestore (limites/plano, contadores)
  /// e atualiza a `TecnicoEntity` local. Diferente do técnico, esses valores
  /// costumam mudar no backend (mudança de plano) sem qualquer escrita no app,
  /// então precisam ser puxados; o `performFullDownload` só roda no 1º login.
  /// Chamado ao abrir o app (logado) e ao voltar online. No-op se offline.
  Future<void> refreshTecnico(String userId) async {
    if (!_isOnline) return;
    _lastUserId = userId;
    // Um download completo em progresso já baixa o técnico — evita corrida de
    // escrita concorrente na mesma box.
    if (_currentStatus == SyncStatus.syncing) return;
    try {
      await _downloadTecnico(userId);
      debugPrint('👨‍⚕️ Dados do técnico atualizados');
    } catch (e) {
      debugPrint('⚠️ Falha ao atualizar dados do técnico: $e');
    }
  }

  /// Verifica se precisa de sincronização inicial
  bool needsInitialSync() {
    final metadata = _objectBox.syncMetadataBox
        .query(SyncMetadataEntity_.collectionName.equals('initial_download'))
        .build()
        .findFirst();

    return metadata == null || !metadata.initialSyncComplete;
  }

  /// Inicia sincronização periódica em background
  void startPeriodicSync({Duration interval = const Duration(minutes: 5)}) {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(interval, (_) async {
      if (_isOnline) {
        await syncPendingChangesToFirestore();
      }
    });
  }

  /// Para sincronização periódica
  void stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }

  void _updateSyncMetadata(
    String collection,
    DateTime timestamp, {
    bool complete = false,
  }) {
    var metadata = _objectBox.syncMetadataBox
        .query(SyncMetadataEntity_.collectionName.equals(collection))
        .build()
        .findFirst();

    if (metadata == null) {
      metadata = SyncMetadataEntity(
        collectionName: collection,
        lastFullSync: timestamp,
        initialSyncComplete: complete,
      );
    } else {
      metadata.lastFullSync = timestamp;
      if (complete) metadata.initialSyncComplete = true;
    }

    _objectBox.syncMetadataBox.put(metadata);
  }

  /// Adiciona operação à fila de pendências (para operações offline)
  void queueOperation({
    required String operationType,
    required String collectionName,
    required String documentPath,
    String? firestoreId,
    Map<String, dynamic>? data,
    int priority = 3,
  }) {
    final op = PendingOperationEntity(
      operationType: operationType,
      collectionName: collectionName,
      documentPath: documentPath,
      firestoreId: firestoreId,
      dataJson: data != null ? QueuePayloadCodec.encode(data) : null,
      createdAt: DateTime.now(),
      priority: priority,
    );

    _objectBox.pendingOperationBox.put(op);

    if (_isOnline) {
      syncPendingChangesToFirestore();
    }
  }

  /// Limpa todos os dados locais (para logout)
  Future<void> clearLocalData() async {
    await _objectBox.clearAllData();
    _initialSyncComplete = false;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
    _statusController.close();
    _progressController.close();
    _instance = null;
  }
}

/// Status da sincronização
enum SyncStatus {
  idle,
  syncing,
  completed,
  error,
  offline,
}

/// Progresso da sincronizacao. Carrega apenas fatos — etapa e quantos de
/// quantos. Ritmo e ETA sao derivados na apresentacao pelo `SyncRateEstimator`.
class SyncProgress {
  const SyncProgress({
    required this.etapa,
    required this.message,
    required this.progress,
    this.atual,
    this.total,
  });

  final SyncEtapa etapa;
  final String message;
  final double progress;

  /// Preenchidos so nas etapas que sabem contar (animais, acoes).
  final int? atual;
  final int? total;
}
