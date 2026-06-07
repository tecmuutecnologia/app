import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../core/sync/queue_payload_codec.dart';
import 'objectbox_service.dart';
import 'entities/index.dart';
import '../../objectbox.g.dart';

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
        }

        _updateStatus(_isOnline ? SyncStatus.idle : SyncStatus.offline);
      },
    );
  }

  void _updateStatus(SyncStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  void _reportProgress(String message, double progress, {String? collection}) {
    _progressController.add(SyncProgress(
      message: message,
      progress: progress,
      collection: collection,
    ));
    debugPrint('📊 $message (${(progress * 100).toStringAsFixed(1)}%)');
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
    if (!_isOnline) {
      debugPrint('📴 Offline - download adiado');
      _updateStatus(SyncStatus.offline);
      return;
    }

    _updateStatus(SyncStatus.syncing);
    _reportProgress('Iniciando download completo...', 0.0);

    try {
      // 1. Baixa tabelas de referência primeiro (são usadas por outras entidades)
      await _downloadReferenceTables();
      _reportProgress('Tabelas de referência baixadas', 0.15);

      // 2. Sincroniza Person do usuário
      await _downloadPerson(userId);
      _reportProgress('Dados do usuário baixados', 0.20);

      // 3. Sincroniza Tecnico se existir
      final tecnicoRef = await _downloadTecnico(userId);
      _reportProgress('Dados do técnico baixados', 0.30);

      // 4. Se for técnico, baixa todos os produtores vinculados
      if (tecnicoRef != null) {
        await _downloadProdutoresDoTecnico(tecnicoRef);
        _reportProgress('Produtores baixados', 0.50);
      } else {
        // Se for produtor, baixa seus próprios dados
        await _downloadProdutor(userId);
        _reportProgress('Dados do produtor baixados', 0.50);
      }

      // 5. Baixa todas as propriedades
      await _downloadTodasPropriedades();
      _reportProgress('Propriedades baixadas', 0.60);

      // 6. Baixa todos os animais (subcoleção 'animaisProdutores' do técnico)
      await _downloadTodosAnimais(tecnicoRef);
      _reportProgress('Animais baixados', 0.70);

      // 7. Baixa ações e tratamentos
      await _downloadAcoesETratamentos(tecnicoRef);
      _reportProgress('Ações e tratamentos baixados', 0.85);

      // 8. Baixa dados financeiros e visitas
      await _downloadFinanceiroEVisitas();
      _reportProgress('Dados financeiros e visitas baixados', 0.95);

      // Marca sincronização inicial como completa
      _updateSyncMetadata('initial_download', DateTime.now(), complete: true);
      _initialSyncComplete = true;

      _reportProgress('Download completo finalizado!', 1.0);
      _updateStatus(SyncStatus.completed);
    } catch (e) {
      debugPrint('❌ Erro no download completo: $e');
      _updateStatus(SyncStatus.error);
      rethrow;
    }
  }

  /// Baixa tabelas de referência (grupos, raças, status, etc.)
  Future<void> _downloadReferenceTables() async {
    // Grupos
    final grupos = await _firestore.collection('grupo').get();
    for (final doc in grupos.docs) {
      final entity = GrupoEntity.fromFirestore(doc.data(), doc.id);
      _objectBox.grupoBox.put(entity);
    }
    debugPrint('📦 ${grupos.docs.length} grupos baixados');

    // Raças
    final racas = await _firestore.collection('racas').get();
    for (final doc in racas.docs) {
      final entity = RacaEntity.fromFirestore(doc.data(), doc.id);
      _objectBox.racaBox.put(entity);
    }
    debugPrint('📦 ${racas.docs.length} raças baixadas');

    // Status Animais
    final statusAnimais = await _firestore.collection('status_animais').get();
    for (final doc in statusAnimais.docs) {
      final entity = StatusAnimalEntity.fromFirestore(doc.data(), doc.id);
      _objectBox.statusAnimalBox.put(entity);
    }
    debugPrint('📦 ${statusAnimais.docs.length} status animais baixados');

    // Status Produtivo
    final statusProdutivo =
        await _firestore.collection('status_produtivo').get();
    for (final doc in statusProdutivo.docs) {
      final entity = StatusProdutivoEntity.fromFirestore(doc.data(), doc.id);
      _objectBox.statusProdutivoBox.put(entity);
    }
    debugPrint('📦 ${statusProdutivo.docs.length} status produtivo baixados');

    // Tipo Ações
    final tipoAcoes = await _firestore.collection('tipo_acoes').get();
    for (final doc in tipoAcoes.docs) {
      final entity = TipoAcaoEntity.fromFirestore(doc.data(), doc.id);
      _objectBox.tipoAcaoBox.put(entity);
    }
    debugPrint('📦 ${tipoAcoes.docs.length} tipos de ações baixados');

    // Calendário Sanitário
    final calendario =
        await _firestore.collection('calendario_sanitario').get();
    for (final doc in calendario.docs) {
      final entity =
          CalendarioSanitarioEntity.fromFirestore(doc.data(), doc.id);
      _objectBox.calendarioSanitarioBox.put(entity);
    }
    debugPrint(
        '📦 ${calendario.docs.length} itens do calendário sanitário baixados');

    // Cidades
    final cidades = await _firestore.collection('cidades').get();
    for (final doc in cidades.docs) {
      final entity = CidadeEntity.fromFirestore(doc.data(), doc.id);
      _objectBox.cidadeBox.put(entity);
    }
    debugPrint('📦 ${cidades.docs.length} cidades baixadas');
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

  /// Baixa todas as propriedades dos produtores locais
  Future<void> _downloadTodasPropriedades() async {
    final produtores = _objectBox.produtorBox.getAll();
    int totalProps = 0;

    for (final produtor in produtores) {
      if (produtor.firestoreId == null) continue;

      final produtorRef =
          _firestore.collection('produtor').doc(produtor.firestoreId);
      final snapshot = await produtorRef.collection('propriedades').get();

      for (final doc in snapshot.docs) {
        final existing = _objectBox.propriedadeBox
            .query(PropriedadeEntity_.firestoreId.equals(doc.id))
            .build()
            .findFirst();

        if (existing != null) {
          existing.updateFromFirestore(doc.data());
          _objectBox.propriedadeBox.put(existing);
        } else {
          final entity = PropriedadeEntity.fromFirestore(
            doc.data(),
            doc.id,
            produtorRef.path,
          );
          _objectBox.propriedadeBox.put(entity);
        }
        totalProps++;
      }
    }
    debugPrint('🏡 $totalProps propriedade(s) baixada(s)');
  }

  /// Baixa todos os animais das propriedades locais
  /// Baixa os animais do técnico.
  ///
  /// Os animais vivem na subcoleção `animaisProdutores` do documento do TÉCNICO
  /// (não da propriedade); cada animal referencia sua propriedade no campo
  /// `uidTecnicoPropriedade`. Por isso o `parentPath` da entidade é o path do
  /// documento do técnico — o que também alinha os paths de sincronização e de
  /// edição (`<parentPath>/animaisProdutores/<id>`).
  Future<void> _downloadTodosAnimais(DocumentReference? tecnicoRef) async {
    if (tecnicoRef == null) return;
    int totalAnimais = 0;

    final snapshot = await tecnicoRef.collection('animaisProdutores').get();
    for (final doc in snapshot.docs) {
      final existing = _objectBox.animalBox
          .query(AnimalEntity_.firestoreId.equals(doc.id))
          .build()
          .findFirst();

      if (existing != null) {
        existing.updateFromFirestore(doc.data());
        _objectBox.animalBox.put(existing);
      } else {
        final entity = AnimalEntity.fromFirestore(
          doc.data(),
          doc.id,
          tecnicoRef.path,
        );
        _objectBox.animalBox.put(entity);
      }
      totalAnimais++;
    }
    debugPrint('🐄 $totalAnimais animal(is) baixado(s)');
  }

  /// Baixa ações e tratamentos.
  ///
  /// As AÇÕES vivem na subcoleção `acoes` do TÉCNICO
  /// (`tecnico/{id}/acoes`), cada uma com `uidAnimalAnimaisProdutores` e
  /// `uidPropriedade` ligando ao animal/propriedade — por isso o `parentPath`
  /// da AcaoEntity é o path do técnico. Tratamentos e ações sanitárias seguem
  /// como subcoleções do animal.
  Future<void> _downloadAcoesETratamentos(DocumentReference? tecnicoRef) async {
    int totalAcoes = 0;
    int totalTratamentos = 0;

    // Ações do técnico.
    if (tecnicoRef != null) {
      try {
        final acoesSnapshot = await tecnicoRef.collection('acoes').get();
        for (final doc in acoesSnapshot.docs) {
          final entity =
              AcaoEntity.fromFirestore(doc.data(), doc.id, tecnicoRef.path);
          _objectBox.acaoBox.put(entity);
          totalAcoes++;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar ações: $e');
      }
    }

    final animais = _objectBox.animalBox.getAll();
    for (final animal in animais) {
      if (animal.firestoreId == null || animal.parentPath == null) continue;

      final animalRef = _firestore
          .doc('${animal.parentPath}/animaisProdutores/${animal.firestoreId}');

      // Baixa tratamentos do animal
      try {
        final tratamentosSnapshot =
            await animalRef.collection('tratamentos').get();
        for (final doc in tratamentosSnapshot.docs) {
          final entity = TratamentoEntity.fromFirestore(
            doc.data(),
            doc.id,
            parentPath: animalRef.path,
          );
          _objectBox.tratamentoBox.put(entity);
          totalTratamentos++;
        }
      } catch (e) {
        debugPrint(
            '⚠️ Erro ao baixar tratamentos do animal ${animal.firestoreId}: $e');
      }

      // Baixa ações sanitárias
      try {
        final sanitarioSnapshot =
            await animalRef.collection('acoes_sanitario').get();
        for (final doc in sanitarioSnapshot.docs) {
          final entity = AcaoSanitarioEntity.fromFirestore(
            doc.data(),
            doc.id,
            parentPath: animalRef.path,
          );
          _objectBox.acaoSanitarioBox.put(entity);
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar ações sanitárias: $e');
      }
    }

    debugPrint(
        '📋 $totalAcoes ação(ões) e $totalTratamentos tratamento(s) baixados');
  }

  /// Baixa dados financeiros e visitas
  Future<void> _downloadFinanceiroEVisitas() async {
    final propriedades = _objectBox.propriedadeBox.getAll();
    int totalFinanceiro = 0;
    int totalVisitas = 0;
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

      // Baixa resumos de visitas
      try {
        final visitasSnapshot =
            await propRef.collection('resumo_da_visita').get();
        for (final doc in visitasSnapshot.docs) {
          final entity = ResumoVisitaEntity.fromFirestore(
            doc.data(),
            doc.id,
            parentPath: propRef.path,
          );
          _objectBox.resumoVisitaBox.put(entity);
          totalVisitas++;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar visitas: $e');
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
      // Sincroniza entidades com needsSync = true
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

  /// Sincroniza animais modificados localmente
  Future<void> _syncModifiedAnimals() async {
    final modified = _objectBox.animalBox
        .query(AnimalEntity_.needsSync.equals(true))
        .build()
        .find();

    for (final animal in modified) {
      try {
        if (animal.firestoreId != null && animal.parentPath != null) {
          final docRef = _firestore.doc(
            '${animal.parentPath}/animaisProdutores/${animal.firestoreId}',
          );
          await docRef.update(animal.toFirestore());
          animal.needsSync = false;
          animal.lastSynced = DateTime.now();
          _objectBox.animalBox.put(animal);
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

  /// Sincroniza ações modificadas localmente
  Future<void> _syncModifiedAcoes() async {
    final modified = _objectBox.acaoBox
        .query(AcaoEntity_.needsSync.equals(true))
        .build()
        .find();

    for (final acao in modified) {
      try {
        if (acao.firestoreId != null && acao.parentPath != null) {
          final docRef = _firestore.doc(
            '${acao.parentPath}/acoes/${acao.firestoreId}',
          );
          await docRef.update(_acaoPayload(acao));
          acao.needsSync = false;
          acao.lastSynced = DateTime.now();
          _objectBox.acaoBox.put(acao);
        } else if (acao.firestoreId == null &&
            acao.parentPath != null &&
            !acao.isDeleted) {
          // Nova ação - criar no Firestore (não ressuscita soft-delete pendente)
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
          await docRef.update(tratamento.toFirestore());
          tratamento.needsSync = false;
          tratamento.lastSynced = DateTime.now();
          _objectBox.tratamentoBox.put(tratamento);
        } else if (tratamento.firestoreId == null &&
            tratamento.parentPath != null &&
            !tratamento.isDeleted) {
          final collectionRef =
              _firestore.collection('${tratamento.parentPath}/tratamentos');
          final docRef = await collectionRef.add(tratamento.toFirestore());
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
        if (fin.firestoreId != null && fin.parentPath != null) {
          final docRef = _firestore.doc(
            '${fin.parentPath}/financeiro/${fin.firestoreId}',
          );
          await docRef.update(fin.toFirestore());
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

  /// Sincroniza visitas modificadas
  Future<void> _syncModifiedVisitas() async {
    final modified = _objectBox.resumoVisitaBox
        .query(ResumoVisitaEntity_.needsSync.equals(true))
        .build()
        .find();

    for (final visita in modified) {
      try {
        if (visita.firestoreId != null && visita.parentPath != null) {
          final docRef = _firestore.doc(
            '${visita.parentPath}/resumo_da_visita/${visita.firestoreId}',
          );
          await docRef.update(visita.toFirestore());
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
        if (data != null) await docRef.set(data);
        break;
      case 'UPDATE':
        if (data != null) await docRef.update(data);
        break;
      case 'DELETE':
        await docRef.delete();
        break;
    }
  }

  // ==========================================================================
  // VERIFICAÇÃO E SINCRONIZAÇÃO INCREMENTAL
  // ==========================================================================

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

/// Progresso da sincronização
class SyncProgress {
  final String message;
  final double progress;
  final String? collection;

  SyncProgress({
    required this.message,
    required this.progress,
    this.collection,
  });
}
