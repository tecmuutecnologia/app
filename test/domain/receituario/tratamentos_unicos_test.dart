import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/domain/receituario/tratamentos_unicos.dart';

TratamentoEntity _trat({
  String? firestoreId,
  String? animal = 'tecnico/T1/animaisProdutores/A1',
  String tipo = 'IATF',
  String visita = 'resumo_da_visita/V1',
  String? obs = '',
  String? brinco = '6331',
  String? nome,
}) =>
    TratamentoEntity(
      firestoreId: firestoreId,
      uidAnimalPath: animal,
      tipoAcao: tipo,
      uidResumoDaVisitaPath: visita,
      observacaoAcao: obs,
      brincoAnimal: brinco,
      nomeAnimal: nome,
    );

/// Corridas antigas do sync deixaram documentos de tratamento repetidos no
/// Firestore (visita de 16/10/2026: 47 tratamentos de IATF para 32 animais). O
/// app ignora exclusões remotas, então aparelhos que já os baixaram continuam
/// com as cópias mesmo depois da limpeza no servidor.
void main() {
  test('mesmo animal, tipo e visita aparece uma vez só', () {
    final lista = tratamentosUnicos([
      _trat(firestoreId: 'X1'),
      _trat(firestoreId: 'X2'),
    ]);

    expect(lista.map((t) => t.firestoreId), ['X1']);
  });

  test('animais diferentes continuam todos', () {
    final lista = tratamentosUnicos([
      _trat(firestoreId: 'X1', animal: 'a/A1'),
      _trat(firestoreId: 'X2', animal: 'a/A2'),
    ]);

    expect(lista, hasLength(2));
  });

  test('observação diferente não é duplicata', () {
    final lista = tratamentosUnicos([
      _trat(firestoreId: 'X1', obs: '10/11/2026'),
      _trat(firestoreId: 'X2', obs: '24/11/2026'),
    ]);

    expect(lista, hasLength(2));
  });

  test('tipos diferentes do mesmo animal continuam', () {
    final lista = tratamentosUnicos([
      _trat(firestoreId: 'X1', tipo: 'IATF'),
      _trat(firestoreId: 'X2', tipo: 'CG II'),
    ]);

    expect(lista, hasLength(2));
  });

  test('sem vínculo com o animal, compara por brinco e nome', () {
    final lista = tratamentosUnicos([
      _trat(firestoreId: 'X1', animal: null, brinco: '317', nome: 'Renato'),
      _trat(firestoreId: 'X2', animal: null, brinco: '317', nome: 'Renato'),
      _trat(firestoreId: 'X3', animal: null, brinco: '318', nome: 'Renato'),
    ]);

    expect(lista.map((t) => t.firestoreId), ['X1', 'X3']);
  });
}
