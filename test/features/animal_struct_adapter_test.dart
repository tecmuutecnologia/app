import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/data/schema/structs/index.dart';
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

  // O adapter é a PONTE PERMANENTE entity<->struct (struct = view-model offline
  // da UI legada; entity = fonte ObjectBox). Este teste trava a SIMETRIA de
  // campos: se alguém adicionar/renomear um campo num lado e esquecer o adapter,
  // um destes valores deixa de bater. Cobre todos os campos de DATA/escalares
  // (as referências uidAnimal/uidTecnicoPropriedade dependem do Firestore e são
  // exercitadas em device; a identidade firestoreId NÃO faz round-trip de
  // propósito — structToAnimalEntityOffline é p/ animal criado offline).
  test('round-trip entity -> struct -> entity preserva os campos de dados', () {
    final original = AnimalEntity(
      // path nulo: a ref uidTecnicoPropriedade usa FirebaseFirestore.instance
      // (device-only). Aqui focamos os campos de dados/escalares.
      uidTecnicoPropriedadePath: null,
      uidAnimalOffline: 'offline_xyz',
      nomeAnimal: 'Estrela',
      racaAnimal: 'Girolando',
      pesoAnimal: '450',
      dtNascimento: '01/01/2020',
      touro: 'Touro X',
      vaca: 'Vaca Y',
      status: 'Prenha',
      grupoAnimal: 'Vacas',
      dtUltimaInseminacao: '10/02/2024',
      dtUltimoParto: '05/01/2023',
      liberaInseminacao: true,
      dtPartoPrevisto: '10/11/2024',
      dtSecPrevista: '10/09/2024',
      dtPrePartoPrevista: '01/11/2024',
      dtPP: '02/02/2024',
      dtDgMais: '03/03/2024',
      dtDgMenos: '04/04/2024',
      dtAborto: '05/05/2024',
      dtSecagem: '06/06/2024',
      dtUltimoPP: '07/07/2024',
      nomeTouroUltimaInseminacao: 'Touro Z',
      totalInseminacoes: 4,
      totalPartos: 3,
      dtPreParto: '08/08/2024',
      motivoDescarteAnimal: '',
      dtDescarteAnimal: '',
      dtUltimaAcao: '09/09/2024',
      compararDtUltimaInseminacao: DateTime(2024, 2, 10),
      nomeBrincoConcat: 'Estrela - 99',
      idGrupoAnimal: 6,
      dtUltimoPartoContingencia: '05/01/2023',
      idStatusAnimal: 3,
      dtInducaoLactacao: DateTime(2024, 11, 11),
      dtDesmame: DateTime(2024, 12, 12),
      brincoAnimal: 99,
      brincoAnimalOrder: 99,
    );

    // entity -> struct -> entity (caminho offline reusa o uidAnimalOffline).
    final struct = animalEntityToStruct(original);
    final back =
        structToAnimalEntityOffline(struct, parentPath: 'tecnico/abc');

    expect(back.uidTecnicoPropriedadePath, original.uidTecnicoPropriedadePath);
    expect(back.uidAnimalOffline, original.uidAnimalOffline);
    expect(back.nomeAnimal, original.nomeAnimal);
    expect(back.racaAnimal, original.racaAnimal);
    expect(back.pesoAnimal, original.pesoAnimal);
    expect(back.dtNascimento, original.dtNascimento);
    expect(back.touro, original.touro);
    expect(back.vaca, original.vaca);
    expect(back.status, original.status);
    expect(back.grupoAnimal, original.grupoAnimal);
    expect(back.dtUltimaInseminacao, original.dtUltimaInseminacao);
    expect(back.dtUltimoParto, original.dtUltimoParto);
    expect(back.liberaInseminacao, original.liberaInseminacao);
    expect(back.dtPartoPrevisto, original.dtPartoPrevisto);
    expect(back.dtSecPrevista, original.dtSecPrevista);
    expect(back.dtPrePartoPrevista, original.dtPrePartoPrevista);
    expect(back.dtPP, original.dtPP);
    expect(back.dtDgMais, original.dtDgMais);
    expect(back.dtDgMenos, original.dtDgMenos);
    expect(back.dtAborto, original.dtAborto);
    expect(back.dtSecagem, original.dtSecagem);
    expect(back.dtUltimoPP, original.dtUltimoPP);
    expect(back.nomeTouroUltimaInseminacao,
        original.nomeTouroUltimaInseminacao);
    expect(back.totalInseminacoes, original.totalInseminacoes);
    expect(back.totalPartos, original.totalPartos);
    expect(back.dtPreParto, original.dtPreParto);
    expect(back.dtUltimaAcao, original.dtUltimaAcao);
    expect(back.compararDtUltimaInseminacao,
        original.compararDtUltimaInseminacao);
    expect(back.nomeBrincoConcat, original.nomeBrincoConcat);
    expect(back.idGrupoAnimal, original.idGrupoAnimal);
    expect(back.dtUltimoPartoContingencia,
        original.dtUltimoPartoContingencia);
    expect(back.idStatusAnimal, original.idStatusAnimal);
    expect(back.dtInducaoLactacao, original.dtInducaoLactacao);
    expect(back.dtDesmame, original.dtDesmame);
    expect(back.brincoAnimal, original.brincoAnimal);
    expect(back.brincoAnimalOrder, original.brincoAnimalOrder);
  });
}
