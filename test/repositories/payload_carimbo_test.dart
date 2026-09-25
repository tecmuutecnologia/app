import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/queue_payload_codec.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/data/objectbox/objectbox_service.dart';
import 'package:tecmuu/data/objectbox/offline_first_sync_service.dart';
import 'package:tecmuu/data/objectbox/repositories/index.dart';

class _FakeObjectBox extends Fake implements ObjectBoxService {}

class _FakeSync extends Fake implements OfflineFirstSyncService {}

class _FakeFirestore extends Fake implements FirebaseFirestore {}

/// O pull incremental filtra por `lastModified`. Documento gravado sem ele é
/// invisível aos outros aparelhos até o próximo login.
///
/// O carimbo morava no `firestorePayloadFor` padrão da base, e os repositórios
/// que o sobrescrevem para reanexar referências (animal, ação, ação sanitária,
/// propriedade) o perdiam. Foi o que fez a bezerra de um parto registrado
/// online nunca chegar ao segundo aparelho.
void main() {
  final objectBox = _FakeObjectBox();
  final sync = _FakeSync();
  final firestore = _FakeFirestore();

  group('payload de gravação direta carrega lastModified', () {
    test('animal', () {
      final repo = AnimalRepository(
          objectBox: objectBox, syncService: sync, firestore: firestore);
      expect(repo.payloadParaGravar(AnimalEntity(nomeAnimal: '002')),
          contains('lastModified'));
    });

    test('ação', () {
      final repo = AcaoRepository(
          objectBox: objectBox, syncService: sync, firestore: firestore);
      expect(repo.payloadParaGravar(AcaoEntity()), contains('lastModified'));
    });

    test('ação sanitária', () {
      final repo = AcaoSanitarioRepository(
          objectBox: objectBox, syncService: sync, firestore: firestore);
      expect(repo.payloadParaGravar(AcaoSanitarioEntity()),
          contains('lastModified'));
    });

    test('propriedade', () {
      final repo = PropriedadeRepository(
          objectBox: objectBox, syncService: sync, firestore: firestore);
      expect(repo.payloadParaGravar(PropriedadeEntity()),
          contains('lastModified'));
    });
  });

  group('payload da fila', () {
    // A fila é serializada em JSON e `FieldValue.serverTimestamp()` não é
    // serializável. O executor da fila carimba na hora de gravar.
    test('é serializável pelo codec da fila', () {
      final repo = FinanceiroRepository(
          objectBox: objectBox, syncService: sync, firestore: firestore);
      expect(
          () => QueuePayloadCodec.encode(
              repo.payloadParaFila(FinanceiroEntity())),
          returnsNormally);
    });
  });
}
