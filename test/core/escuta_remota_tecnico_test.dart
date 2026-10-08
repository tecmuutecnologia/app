import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/escuta_remota.dart';
import 'package:tecmuu/data/objectbox/entities/propriedade_entity.dart';
import 'package:tecmuu/data/objectbox/entities/visita_entities.dart';

/// A acao que o PRODUTOR lanca vira `tratamento` + `recomendacao`, subcolecoes
/// da propriedade. O tecnico recebia `animais`, `acoes` e `visitas`, mas nunca
/// essas duas — nem em tempo real, nem no pull, porque as duas coisas sao
/// alimentadas por esta mesma lista de alvos. No aparelho dele o receituario do
/// dia aparecia com as acoes (PP, DG+) e sem os tratamentos (CG II, pre-parto).
void main() {
  PropriedadeEntity prop(String id, String tecnico) =>
      PropriedadeEntity(firestoreId: id, parentPath: tecnico);

  ResumoVisitaEntity visita(String propriedadePath, DateTime quando) =>
      ResumoVisitaEntity(
        parentPath: 'resumo_da_visita',
        uidPropriedadePath: propriedadePath,
        dtVisita: quando,
      );

  const tecnico = 'tecnico/t1';
  const propriedade = 'tecnico/t1/propriedades/p1';
  final agora = DateTime(2026, 10, 8, 12);

  group('propriedadesComVisitaRecente', () {
    test('inclui propriedade com visita de hoje', () {
      final r = propriedadesComVisitaRecente(
        [visita(propriedade, agora)],
        agora: agora,
      );

      expect(r, {propriedade});
    });

    test('exclui visita antiga: nao vale abrir consulta para o que nao muda',
        () {
      final r = propriedadesComVisitaRecente(
        [visita(propriedade, agora.subtract(const Duration(days: 60)))],
        agora: agora,
      );

      expect(r, isEmpty);
    });

    test('ignora visita apagada', () {
      final v = visita(propriedade, agora)..isDeleted = true;

      expect(propriedadesComVisitaRecente([v], agora: agora), isEmpty);
    });

    test('nao repete a mesma propriedade com varias visitas', () {
      final r = propriedadesComVisitaRecente(
        [visita(propriedade, agora), visita(propriedade, agora)],
        agora: agora,
      );

      expect(r, hasLength(1));
    });
  });

  group('alvosDeEscuta no aparelho do tecnico', () {
    List<AlvoEscuta> alvosTecnico({Set<String> comVisita = const {}}) =>
        alvosDeEscuta(
          tecnicoPath: tecnico,
          propriedades: [prop('p1', tecnico)],
          propriedadesComVisita: comVisita,
        );

    test('sem visita recente nao cria alvo de tratamento', () {
      final tipos = alvosTecnico().map((a) => a.tipo).toSet();

      expect(tipos.contains(TipoEscuta.tratamentos), isFalse);
      expect(tipos.contains(TipoEscuta.recomendacoes), isFalse);
    });

    test('com visita recente passa a cobrir tratamentos e recomendacoes', () {
      final alvos = alvosTecnico(comVisita: {propriedade});

      final tratamento =
          alvos.firstWhere((a) => a.tipo == TipoEscuta.tratamentos);
      final recomendacao =
          alvos.firstWhere((a) => a.tipo == TipoEscuta.recomendacoes);

      expect(tratamento.colecaoPath, '$propriedade/tratamentos');
      expect(recomendacao.colecaoPath, '$propriedade/recomendacoes');
    });

    test('esses alvos sao APENAS de pull: nao abrem listener', () {
      // Um tecnico com 30 propriedades abriria 60 conexoes de tempo real. O
      // pull incremental cobre o mesmo dado sem segurar conexao nenhuma.
      final alvos = alvosTecnico(comVisita: {propriedade});

      for (final a in alvos.where((a) =>
          a.tipo == TipoEscuta.tratamentos ||
          a.tipo == TipoEscuta.recomendacoes)) {
        expect(a.apenasPull, isTrue);
      }
    });

    test('os alvos que ja existiam continuam escutando em tempo real', () {
      final alvos = alvosTecnico(comVisita: {propriedade});

      for (final a in alvos.where((a) =>
          a.tipo == TipoEscuta.animais ||
          a.tipo == TipoEscuta.acoes ||
          a.tipo == TipoEscuta.visitas)) {
        expect(a.apenasPull, isFalse);
      }
    });
  });

  group('alvosDeEscuta no aparelho do produtor', () {
    test('segue escutando tratamentos em tempo real, como antes', () {
      final alvos = alvosDeEscuta(
        tecnicoPath: null,
        propriedades: [prop('p1', tecnico)],
      );

      final tratamento =
          alvos.firstWhere((a) => a.tipo == TipoEscuta.tratamentos);

      expect(tratamento.apenasPull, isFalse);
    });
  });

  group('chave da marca de sincronizacao', () {
    test('alvo de pull tem marca PROPRIA, nao a da etapa', () {
      // A marca de `financeiro` ja avancou por causa das visitas. Se um alvo
      // novo herdasse essa marca, a janela do primeiro pull comecaria depois
      // dos tratamentos que ja existem — e eles nunca desceriam.
      const alvo = AlvoEscuta(
        tipo: TipoEscuta.tratamentos,
        colecaoPath: 'tecnico/t1/propriedades/p1/tratamentos',
        apenasPull: true,
      );

      expect(chaveDeMarca(alvo, 'etapa_financeiro'),
          'pull_tecnico/t1/propriedades/p1/tratamentos');
    });

    test('alvo de escuta continua na marca da etapa', () {
      const alvo = AlvoEscuta(
        tipo: TipoEscuta.visitas,
        colecaoPath: 'resumo_da_visita',
      );

      expect(chaveDeMarca(alvo, 'etapa_financeiro'), 'etapa_financeiro');
    });
  });
}
