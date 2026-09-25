import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:objectbox/objectbox.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/data/objectbox/offline_first_sync_service.dart';
import 'package:tecmuu/data/objectbox/repositories/base_sync_repository.dart';

class _FakeBox extends Fake implements Box<RecomendacaoEntity> {
  final gravadas = <RecomendacaoEntity>[];

  @override
  int put(RecomendacaoEntity object, {PutMode mode = PutMode.put}) {
    gravadas.add(object);
    return gravadas.length;
  }
}

// ignore: subtype_of_sealed_class
class _FakeDocRef extends Fake
    implements DocumentReference<Map<String, dynamic>> {
  @override
  String get id => 'ID_REAL_DO_FIRESTORE';
}

// ignore: subtype_of_sealed_class
class _FakeColecao extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) => _FakeDocRef();
}

// ignore: subtype_of_sealed_class
class _FakeFirestore extends Fake implements FirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _FakeColecao();
}

/// Sync offline que registra o que foi enfileirado.
class _SyncOffline extends Fake implements OfflineFirstSyncService {
  String? documentPath;
  String? firestoreId;

  @override
  bool get isOnline => false;

  @override
  void queueOperation({
    required String operationType,
    required String collectionName,
    required String documentPath,
    String? firestoreId,
    Map<String, dynamic>? data,
    int priority = 3,
  }) {
    this.documentPath = documentPath;
    this.firestoreId = firestoreId;
  }
}

class _RepoTeste extends BaseSyncRepository<RecomendacaoEntity> {
  _RepoTeste({required this.box, super.syncService, super.firestore});

  @override
  final Box<RecomendacaoEntity> box;

  @override
  String get collectionName => 'recomendacoes';
}

/// O id local do ObjectBox NUNCA pode virar id de documento no Firestore.
///
/// A fila usava `'<colecao>/<entity.id>'` quando a entidade não tinha
/// `firestoreId`: a primeira recomendação de qualquer aparelho ia para o
/// documento `1`. Dois aparelhos na mesma propriedade sobrescreviam a
/// recomendação um do outro, e o id local não serve de identidade em lugar
/// nenhum fora daquele aparelho.
void main() {
  test('cria com id real do Firestore, não com o id local', () async {
    final box = _FakeBox();
    final sync = _SyncOffline();
    final repo = _RepoTeste(
        box: box, syncService: sync, firestore: _FakeFirestore());

    final entity = RecomendacaoEntity(
      parentPath: 'tecnico/T1/propriedades/P1',
      tituloRecomendacao: 'Secagem',
    );

    await repo.add(entity);

    expect(sync.documentPath,
        'tecnico/T1/propriedades/P1/recomendacoes/ID_REAL_DO_FIRESTORE');
    expect(sync.firestoreId, 'ID_REAL_DO_FIRESTORE');
    expect(entity.firestoreId, 'ID_REAL_DO_FIRESTORE',
        reason: 'o local tem de guardar o mesmo id que foi para a fila');
  });
}
