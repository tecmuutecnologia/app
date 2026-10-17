import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/gravar_no_id_definitivo.dart';

class _Gravacao {
  _Gravacao(this.path, this.merge);
  final String path;
  final bool merge;
}

// ignore: subtype_of_sealed_class
class _FakeDocRef extends Fake
    implements DocumentReference<Map<String, dynamic>> {
  _FakeDocRef(this._firestore, this.path);
  final _FakeFirestore _firestore;

  @override
  final String path;

  @override
  String get id => path.split('/').last;

  @override
  Future<void> set(Map<String, dynamic> data, [SetOptions? options]) async {
    if (_firestore.falharGravacao) throw StateError('sem rede');
    _firestore.gravacoes.add(_Gravacao(path, options?.merge ?? false));
  }
}

// ignore: subtype_of_sealed_class
class _FakeColecao extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  _FakeColecao(this._firestore, this.path);
  final _FakeFirestore _firestore;

  @override
  final String path;

  @override
  DocumentReference<Map<String, dynamic>> doc([String? id]) =>
      _FakeDocRef(_firestore, '$path/${id ?? 'GERADO${++_firestore.gerados}'}');

  @override
  Future<DocumentReference<Map<String, dynamic>>> add(
      Map<String, dynamic> data) async {
    _firestore.adds++;
    return doc();
  }
}

// ignore: subtype_of_sealed_class
class _FakeFirestore extends Fake implements FirebaseFirestore {
  final gravacoes = <_Gravacao>[];
  var gerados = 0;
  var adds = 0;
  var falharGravacao = false;

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _FakeColecao(this, path);

  @override
  DocumentReference<Map<String, dynamic>> doc(String path) =>
      _FakeDocRef(this, path);
}

/// O laço de sync criava com `collection.add()`: cada tentativa gerava um
/// documento novo. Um reenvio (rodada repetida, envio da tela ainda em voo)
/// virava um tratamento a mais no receituário.
void main() {
  const colecao = 'tecnico/T1/propriedades/P1/tratamentos';

  test('sem id: gera um, fixa no local e grava com set(merge)', () async {
    final fs = _FakeFirestore();
    String? idLocal;

    final id = await gravarNoIdDefinitivo(
      firestore: fs,
      colecaoPath: colecao,
      firestoreId: null,
      payload: const {'tipoAcao': 'IATF'},
      fixarIdLocal: (novo) => idLocal = novo,
    );

    expect(idLocal, id);
    expect(fs.adds, 0);
    expect(fs.gravacoes.single.path, '$colecao/$id');
    expect(fs.gravacoes.single.merge, true);
  });

  test('reenviar a mesma entidade grava no mesmo documento', () async {
    final fs = _FakeFirestore();
    String? idLocal;

    for (var i = 0; i < 2; i++) {
      await gravarNoIdDefinitivo(
        firestore: fs,
        colecaoPath: colecao,
        firestoreId: idLocal,
        payload: const {'tipoAcao': 'IATF'},
        fixarIdLocal: (novo) => idLocal = novo,
      );
    }

    expect(fs.gravacoes.map((g) => g.path).toSet(), {'$colecao/$idLocal'});
    expect(fs.gerados, 1);
  });

  test('com id pré-gerado: cria o documento que ainda não existe', () async {
    final fs = _FakeFirestore();
    var fixou = false;

    await gravarNoIdDefinitivo(
      firestore: fs,
      colecaoPath: colecao,
      firestoreId: 'PRE',
      payload: const {'tipoAcao': 'IATF'},
      fixarIdLocal: (_) => fixou = true,
    );

    // `update` falharia com NOT_FOUND num documento criado offline.
    expect(fs.gravacoes.single.path, '$colecao/PRE');
    expect(fs.gravacoes.single.merge, true);
    expect(fixou, false);
  });

  test('falha na gravação mantém o id fixado para a próxima tentativa',
      () async {
    final fs = _FakeFirestore()..falharGravacao = true;
    String? idLocal;

    await expectLater(
      gravarNoIdDefinitivo(
        firestore: fs,
        colecaoPath: colecao,
        firestoreId: null,
        payload: const {'tipoAcao': 'IATF'},
        fixarIdLocal: (novo) => idLocal = novo,
      ),
      throwsStateError,
    );

    expect(idLocal, isNotNull);
  });
}
