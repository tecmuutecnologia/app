import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/data/objectbox/objectbox_service.dart';
import 'package:tecmuu/data/objectbox/offline_first_sync_service.dart';
import 'package:tecmuu/data/objectbox/repositories/index.dart';

class _FakeObjectBox extends Fake implements ObjectBoxService {}

class _FakeSync extends Fake implements OfflineFirstSyncService {}

// ignore: subtype_of_sealed_class
class _FakeDocRef extends Fake
    implements DocumentReference<Map<String, dynamic>> {
  _FakeDocRef(this.path);

  @override
  final String path;
}

// ignore: subtype_of_sealed_class
class _FakeFirestore extends Fake implements FirebaseFirestore {
  @override
  DocumentReference<Map<String, dynamic>> doc(String path) => _FakeDocRef(path);
}

String? _path(Object? valor) => (valor as DocumentReference?)?.path;

/// As entidades guardam vínculos como CAMINHO (`uidPropriedadePath`); o
/// Firestore espera `DocumentReference`. Quem reanexa é o repositório, porque é
/// por ele que passam as duas gravações: a criação online (`pushCreate`) e o
/// reenvio do que ficou pendente.
///
/// Enquanto a reanexação existia só no `OfflineFirstSyncService`, uma visita
/// criada ONLINE subia sem `uidPropriedade` — e o download de visitas filtra
/// justamente por esse campo. O receituário não chegava ao produtor, e o
/// próprio técnico o perderia no login seguinte.
void main() {
  final objectBox = _FakeObjectBox();
  final sync = _FakeSync();
  final firestore = _FakeFirestore();

  test('resumo da visita leva propriedade, técnico, visita e datas', () {
    final repo = ResumoVisitaRepository(
        objectBox: objectBox, syncService: sync, firestore: firestore);

    final payload = repo.payloadParaGravar(ResumoVisitaEntity(
      uidPropriedadePath: 'tecnico/T1/propriedades/P1',
      uidTecnicoPath: 'tecnico/T1',
      uidResumoDaVisitaPath: 'resumo_da_visita/V1',
      dtVisita: DateTime.utc(2026, 9, 24),
      dtVisitaFormatado: '24/09/2026',
    ));

    expect(_path(payload['uidPropriedade']), 'tecnico/T1/propriedades/P1');
    expect(_path(payload['uidTecnico']), 'tecnico/T1');
    expect(_path(payload['uidResumoDaVisita']), 'resumo_da_visita/V1');
    expect(payload['dtVisita'], Timestamp.fromDate(DateTime.utc(2026, 9, 24)));
    expect(payload['dtVisitaFormatado'], '24/09/2026');
  });

  test('tratamento leva animal, visita e ação lançada', () {
    final repo = TratamentoRepository(
        objectBox: objectBox, syncService: sync, firestore: firestore);

    final payload = repo.payloadParaGravar(TratamentoEntity(
      uidAnimalPath: 'tecnico/T1/animaisProdutores/A1',
      uidResumoDaVisitaPath: 'resumo_da_visita/V1',
      uidAcaoLancadaPath: 'tecnico/T1/acoes/AC1',
      tipoAcao: 'Secagem',
    ));

    expect(_path(payload['uidAnimal']), 'tecnico/T1/animaisProdutores/A1');
    expect(_path(payload['uidResumoDaVisita']), 'resumo_da_visita/V1');
    expect(_path(payload['uidAcaoLancada']), 'tecnico/T1/acoes/AC1');
    expect(payload['tipoAcao'], 'Secagem');
  });

  test('financeiro leva propriedade e técnico', () {
    final repo = FinanceiroRepository(
        objectBox: objectBox, syncService: sync, firestore: firestore);

    final payload = repo.payloadParaGravar(FinanceiroEntity(
      uidPropriedadePath: 'tecnico/T1/propriedades/P1',
      uidTecnicoPath: 'tecnico/T1',
    ));

    expect(_path(payload['uidPropriedade']), 'tecnico/T1/propriedades/P1');
    expect(_path(payload['uidTecnico']), 'tecnico/T1');
  });
}
