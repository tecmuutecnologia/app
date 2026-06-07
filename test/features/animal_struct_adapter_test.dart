import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/index.dart';
import 'package:tecmuu/backend/schema/structs/index.dart';
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

  test(
      'animalEntityToStruct carrega o uidAnimalOffline do animal criado offline',
      () {
    final e = AnimalEntity(
      uidAnimalOffline: 'offline_123',
      nomeAnimal: 'Nova',
      // firestoreId null => animal criado offline ainda não sincronizado
    );
    final s = animalEntityToStruct(e);
    expect(s.uidAnimalOffline, 'offline_123');
    expect(s.uidAnimal, isNull); // sem firestoreId, sem ref
  });

  test('structToAnimalEntityOffline: struct -> entity com uid offline gerado',
      () {
    final s = AnimaisProdutoresStruct(
      nomeAnimal: 'Boneca',
      racaAnimal: 'Jersey',
      status: 'Vazia',
      grupoAnimal: 'Vacas',
      brincoAnimal: 7,
      brincoAnimalOrder: 7,
      liberaInseminacao: true,
      totalPartos: 2,
      idStatusAnimal: 2,
    );

    final e = structToAnimalEntityOffline(s, parentPath: 'tecnico/abc');

    // Animal criado offline: vai sob o técnico, sem firestoreId ainda.
    expect(e.parentPath, 'tecnico/abc');
    expect(e.firestoreId, isNull);
    expect(e.nomeAnimal, 'Boneca');
    expect(e.racaAnimal, 'Jersey');
    expect(e.status, 'Vazia');
    expect(e.grupoAnimal, 'Vacas');
    expect(e.brincoAnimal, 7);
    expect(e.liberaInseminacao, true);
    expect(e.totalPartos, 2);
    expect(e.idStatusAnimal, 2);
    // uidAnimalOffline gerado (o struct não tinha).
    expect(e.uidAnimalOffline, isNotNull);
    expect(e.uidAnimalOffline!.startsWith('offline_'), true);
  });

  test('structToAnimalEntityOffline: reaproveita o uidAnimalOffline do struct',
      () {
    final s = AnimaisProdutoresStruct(
      uidAnimalOffline: 'meu_id_local',
      nomeAnimal: 'X',
    );
    final e = structToAnimalEntityOffline(s, parentPath: 'tecnico/abc');
    expect(e.uidAnimalOffline, 'meu_id_local');
  });
}
