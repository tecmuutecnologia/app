import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../objectbox.g.dart';
import 'entities/index.dart';

/// Serviço singleton para gerenciamento do ObjectBox
class ObjectBoxService {
  static ObjectBoxService? _instance;
  static Store? _store;

  // Boxes para entidades principais
  late final Box<PersonEntity> personBox;
  late final Box<TecnicoEntity> tecnicoBox;
  late final Box<ProdutorEntity> produtorBox;
  late final Box<PropriedadeEntity> propriedadeBox;
  late final Box<AnimalEntity> animalBox;
  late final Box<SyncMetadataEntity> syncMetadataBox;
  late final Box<PendingOperationEntity> pendingOperationBox;

  // Boxes para ações e visitas
  late final Box<AcaoEntity> acaoBox;
  late final Box<AcaoDaVisitaEntity> acaoDaVisitaBox;
  late final Box<ResumoVisitaEntity> resumoVisitaBox;
  late final Box<RecomendacaoEntity> recomendacaoBox;

  // Boxes para tratamentos e sanitário
  late final Box<TratamentoEntity> tratamentoBox;
  late final Box<AcaoSanitarioEntity> acaoSanitarioBox;

  // Box para financeiro
  late final Box<FinanceiroEntity> financeiroBox;

  // Boxes para tabelas de referência
  late final Box<GrupoEntity> grupoBox;
  late final Box<RacaEntity> racaBox;
  late final Box<StatusAnimalEntity> statusAnimalBox;
  late final Box<StatusProdutivoEntity> statusProdutivoBox;
  late final Box<TipoAcaoEntity> tipoAcaoBox;
  late final Box<CalendarioSanitarioEntity> calendarioSanitarioBox;
  late final Box<CidadeEntity> cidadeBox;

  ObjectBoxService._();

  /// Obtém a instância singleton do ObjectBoxService
  static ObjectBoxService get instance {
    if (_instance == null) {
      throw StateError(
        'ObjectBoxService não foi inicializado. '
        'Chame ObjectBoxService.initialize() primeiro.',
      );
    }
    return _instance!;
  }

  /// Verifica se o ObjectBox foi inicializado
  static bool get isInitialized => _instance != null && _store != null;

  /// Inicializa o ObjectBox
  static Future<ObjectBoxService> initialize() async {
    if (_instance != null && _store != null) {
      return _instance!;
    }

    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, 'tecmuu_objectbox');

    _store = await openStore(directory: dbPath);
    _instance = ObjectBoxService._();

    // Inicializa os boxes principais
    _instance!.personBox = _store!.box<PersonEntity>();
    _instance!.tecnicoBox = _store!.box<TecnicoEntity>();
    _instance!.produtorBox = _store!.box<ProdutorEntity>();
    _instance!.propriedadeBox = _store!.box<PropriedadeEntity>();
    _instance!.animalBox = _store!.box<AnimalEntity>();
    _instance!.syncMetadataBox = _store!.box<SyncMetadataEntity>();
    _instance!.pendingOperationBox = _store!.box<PendingOperationEntity>();

    // Boxes para ações e visitas
    _instance!.acaoBox = _store!.box<AcaoEntity>();
    _instance!.acaoDaVisitaBox = _store!.box<AcaoDaVisitaEntity>();
    _instance!.resumoVisitaBox = _store!.box<ResumoVisitaEntity>();
    _instance!.recomendacaoBox = _store!.box<RecomendacaoEntity>();

    // Boxes para tratamentos e sanitário
    _instance!.tratamentoBox = _store!.box<TratamentoEntity>();
    _instance!.acaoSanitarioBox = _store!.box<AcaoSanitarioEntity>();

    // Box para financeiro
    _instance!.financeiroBox = _store!.box<FinanceiroEntity>();

    // Boxes para tabelas de referência
    _instance!.grupoBox = _store!.box<GrupoEntity>();
    _instance!.racaBox = _store!.box<RacaEntity>();
    _instance!.statusAnimalBox = _store!.box<StatusAnimalEntity>();
    _instance!.statusProdutivoBox = _store!.box<StatusProdutivoEntity>();
    _instance!.tipoAcaoBox = _store!.box<TipoAcaoEntity>();
    _instance!.calendarioSanitarioBox =
        _store!.box<CalendarioSanitarioEntity>();
    _instance!.cidadeBox = _store!.box<CidadeEntity>();

    return _instance!;
  }

  /// Obtém o Store do ObjectBox
  Store get store {
    if (_store == null) {
      throw StateError('ObjectBox Store não está disponível');
    }
    return _store!;
  }

  /// Fecha a conexão com o ObjectBox
  static void close() {
    _store?.close();
    _store = null;
    _instance = null;
  }

  /// Limpa todos os dados do banco local
  Future<void> clearAllData() async {
    // Entidades principais
    personBox.removeAll();
    tecnicoBox.removeAll();
    produtorBox.removeAll();
    propriedadeBox.removeAll();
    animalBox.removeAll();
    syncMetadataBox.removeAll();
    pendingOperationBox.removeAll();

    // Ações e visitas
    acaoBox.removeAll();
    acaoDaVisitaBox.removeAll();
    resumoVisitaBox.removeAll();
    recomendacaoBox.removeAll();

    // Tratamentos e sanitário
    tratamentoBox.removeAll();
    acaoSanitarioBox.removeAll();

    // Financeiro
    financeiroBox.removeAll();

    // Tabelas de referência
    grupoBox.removeAll();
    racaBox.removeAll();
    statusAnimalBox.removeAll();
    statusProdutivoBox.removeAll();
    tipoAcaoBox.removeAll();
    calendarioSanitarioBox.removeAll();
    cidadeBox.removeAll();
  }

  /// Limpa dados de um usuário específico (para logout)
  Future<void> clearUserData(String userUid) async {
    // Remove dados relacionados ao usuário
    final persons =
        personBox.query(PersonEntity_.uid.equals(userUid)).build().find();
    personBox.removeMany(persons.map((e) => e.id).toList());

    // Remove operações pendentes
    pendingOperationBox.removeAll();

    // Reseta metadados de sincronização
    syncMetadataBox.removeAll();
  }
}
