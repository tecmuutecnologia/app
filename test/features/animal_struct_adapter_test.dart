import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/index.dart';
import 'package:tecmuu/features/animais/application/animal_struct_adapter.dart';

/// Valida o mapeamento de campos escalares do adapter AnimalEntity ->
/// AnimaisProdutoresStruct. Os campos de referência (uidAnimal/
/// uidTecnicoPropriedade) usam FirebaseFirestore.instance e são exercitados em
/// device; aqui usamos paths nulos para focar nos campos de dados.
void main() {
  test('mapeia os campos de dados do animal', () {
    final e = AnimalEntity(
      nomeAnimal: 'Mimosa',
      racaAnimal: 'Holandesa',
      status: 'Prenha',
      grupoAnimal: 'Vacas',
      brincoAnimal: 12,
      brincoAnimalOrder: 12,
      nomeBrincoConcat: 'Mimosa - 12',
      liberaInseminacao: true,
      totalPartos: 3,
      idGrupoAnimal: 1,
      // parentPath/firestoreId/uidTecnicoPropriedadePath nulos => refs nulas
    );

    final s = animalEntityToStruct(e);

    expect(s.nomeAnimal, 'Mimosa');
    expect(s.racaAnimal, 'Holandesa');
    expect(s.status, 'Prenha');
    expect(s.grupoAnimal, 'Vacas');
    expect(s.brincoAnimal, 12);
    expect(s.nomeBrincoConcat, 'Mimosa - 12');
    expect(s.liberaInseminacao, true);
    expect(s.totalPartos, 3);
    expect(s.idGrupoAnimal, 1);
    // Sem paths/ids, as referências (DocumentReference) ficam nulas — não tocam
    // o Firebase. (Getters de String do struct FlutterFlow retornam '' p/ nulo.)
    expect(s.uidAnimal, isNull);
    expect(s.uidTecnicoPropriedade, isNull);
    expect(s.uidAnimalOffline, '');
  });
}
