import 'package:tecmuu/backend/backend.dart';
import 'package:tecmuu/data/index.dart';

/// Adapter para migrar gradualmente de Firestore para ObjectBox
///
/// Esta classe fornece métodos compatíveis com o código existente
/// mas usa ObjectBox internamente para melhor performance e offline-first
class FirestoreToObjectBoxAdapter {
  static final _personRepo = PersonRepository();
  static final _tecnicoRepo = TecnicoRepository();
  static final _produtorRepo = ProdutorRepository();
  static final _propriedadesRepo = PropriedadesRepository();
  static final _animaisRepo = AnimaisProdutoresRepository();

  /// Busca Person usando ObjectBox em vez de Firestore
  static Future<List<PersonRecord>> queryPersonLocal({
    String? uid,
    String? email,
    String? empresa,
  }) async {
    List<PersonEntity> entities;

    if (uid != null) {
      // Busca por UID não está implementada no PersonRepository ainda
      // Por enquanto, retorna lista vazia ou busca todos e filtra
      entities = await _personRepo.getAll();
      entities = entities.where((e) => e.uid == uid).toList();
    } else if (email != null) {
      entities = await _personRepo.getAll();
      entities = entities.where((e) => e.email == email).toList();
    } else if (empresa != null) {
      entities = await _personRepo.getByEmpresa(empresa);
    } else {
      entities = await _personRepo.getAll();
    }

    // Converte de Entity para Record (mantém compatibilidade)
    return entities.map((e) => _personEntityToRecord(e)).toList();
  }

  /// Busca Tecnico usando ObjectBox
  static Future<List<TecnicoRecord>> queryTecnicoLocal({
    String? uidPerson,
    bool? liberado,
  }) async {
    List<TecnicoEntity> entities;

    if (uidPerson != null) {
      final entity = await _tecnicoRepo.getByUidPerson(uidPerson);
      entities = entity != null ? [entity] : [];
    } else if (liberado != null && liberado) {
      entities = await _tecnicoRepo.getLiberados();
    } else {
      entities = await _tecnicoRepo.getAll();
    }

    return entities.map((e) => _tecnicoEntityToRecord(e)).toList();
  }

  /// Busca Produtor usando ObjectBox
  static Future<List<ProdutorRecord>> queryProdutorLocal({
    String? uidPerson,
    String? uidTecnico,
    bool? liberado,
  }) async {
    List<ProdutorEntity> entities;

    if (uidPerson != null) {
      final entity = await _produtorRepo.getByUidPerson(uidPerson);
      entities = entity != null ? [entity] : [];
    } else if (uidTecnico != null) {
      entities = await _produtorRepo.getByTecnico(uidTecnico);
    } else if (liberado != null && liberado) {
      entities = await _produtorRepo.getLiberados();
    } else {
      entities = await _produtorRepo.getAll();
    }

    return entities.map((e) => _produtorEntityToRecord(e)).toList();
  }

  /// Busca Propriedades usando ObjectBox
  static Future<List<PropriedadesRecord>> queryPropriedadesLocal({
    String? tecnicoRef,
    String? produtorRef,
    String? cpf,
  }) async {
    List<PropriedadesEntity> entities;

    if (tecnicoRef != null) {
      entities = await _propriedadesRepo.getByTecnico(tecnicoRef);
    } else if (produtorRef != null) {
      entities = await _propriedadesRepo.getByProdutor(produtorRef);
    } else if (cpf != null) {
      final entity = await _propriedadesRepo.getByCpf(cpf);
      entities = entity != null ? [entity] : [];
    } else {
      entities = await _propriedadesRepo.getAll();
    }

    return entities.map((e) => _propriedadesEntityToRecord(e)).toList();
  }

  /// Busca Animais usando ObjectBox
  static Future<List<AnimaisProdutoresRecord>> queryAnimaisLocal({
    String? propriedadeRef,
    int? brinco,
    String? status,
  }) async {
    List<AnimaisProdutoresEntity> entities;

    if (propriedadeRef != null) {
      entities = await _animaisRepo.getByPropriedade(propriedadeRef);
    } else if (brinco != null) {
      final entity = await _animaisRepo.getByBrinco(brinco);
      entities = entity != null ? [entity] : [];
    } else if (status != null) {
      entities = await _animaisRepo.getByStatus(status);
    } else {
      entities = await _animaisRepo.getAll();
    }

    return entities.map((e) => _animaisEntityToRecord(e)).toList();
  }

  // Conversores Entity -> Record (mantém compatibilidade com código existente)

  static PersonRecord _personEntityToRecord(PersonEntity entity) {
    // TODO: Criar DocumentReference mock ou usar dados locais
    // Por enquanto, retorna com dados básicos
    throw UnimplementedError('Conversão Entity->Record em desenvolvimento');
  }

  static TecnicoRecord _tecnicoEntityToRecord(TecnicoEntity entity) {
    throw UnimplementedError('Conversão Entity->Record em desenvolvimento');
  }

  static ProdutorRecord _produtorEntityToRecord(ProdutorEntity entity) {
    throw UnimplementedError('Conversão Entity->Record em desenvolvimento');
  }

  static PropriedadesRecord _propriedadesEntityToRecord(
      PropriedadesEntity entity) {
    throw UnimplementedError('Conversão Entity->Record em desenvolvimento');
  }

  static AnimaisProdutoresRecord _animaisEntityToRecord(
      AnimaisProdutoresEntity entity) {
    throw UnimplementedError('Conversão Entity->Record em desenvolvimento');
  }
}
