import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/escuta_remota.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';

PropriedadeEntity _prop(String id, String tecnicoPath) =>
    PropriedadeEntity(firestoreId: id, parentPath: tecnicoPath);

/// O que cada aparelho escuta para receber, em tempo real, o que outro aparelho
/// gravou. Os filtros por `lastModified` ficam a cargo de quem abre o listener;
/// aqui se decide ONDE escutar e com qual filtro de propriedade.
void main() {
  group('ehAparelhoDeTecnico', () {
    test('sem documento de técnico é aparelho de produtor', () {
      expect(
        ehAparelhoDeTecnico(
            tecnicoPath: null, propriedades: [_prop('P1', 'tecnico/T1')]),
        false,
      );
    });

    test('técnico dono de alguma propriedade local', () {
      expect(
        ehAparelhoDeTecnico(
            tecnicoPath: 'tecnico/T1',
            propriedades: [_prop('P1', 'tecnico/T1')]),
        true,
      );
    });

    test('técnico fantasma (não é dono de nenhuma) não conta', () {
      expect(
        ehAparelhoDeTecnico(
            tecnicoPath: 'tecnico/FANTASMA',
            propriedades: [_prop('P1', 'tecnico/T1')]),
        false,
      );
    });

    test('técnico sem propriedade nenhuma conta (conta nova)', () {
      expect(
        ehAparelhoDeTecnico(tecnicoPath: 'tecnico/T1', propriedades: const []),
        true,
      );
    });
  });

  group('alvosDeEscuta — técnico', () {
    test('escuta animais e ações do rebanho inteiro dele', () {
      final alvos = alvosDeEscuta(
        tecnicoPath: 'tecnico/T1',
        propriedades: [_prop('P1', 'tecnico/T1')],
      );

      expect(
        alvos.where(
            (a) => a.tipo == TipoEscuta.animais || a.tipo == TipoEscuta.acoes),
        [
          const AlvoEscuta(
            tipo: TipoEscuta.animais,
            colecaoPath: 'tecnico/T1/animaisProdutores',
          ),
          const AlvoEscuta(
            tipo: TipoEscuta.acoes,
            colecaoPath: 'tecnico/T1/acoes',
          ),
        ],
        reason: 'sem filtro de propriedade: o técnico vê o rebanho dele',
      );
    });
  });

  group('alvosDeEscuta — técnico fantasma', () {
    // Conta de produtor com um documento de técnico sobrando (uidPerson dele,
    // nenhuma propriedade). O download já decide pelo papel do login, mas a
    // escuta roda fora do login: sem esta regra ela escutava o técnico vazio e
    // o produtor nunca recebia a bezerra.
    test('técnico que não é dono de nenhuma propriedade local é ignorado', () {
      final alvos = alvosDeEscuta(
        tecnicoPath: 'tecnico/FANTASMA',
        propriedades: [_prop('P1', 'tecnico/T1')],
      );

      // Cai no recorte de produtor: nada aponta para o fantasma, e o filtro é a
      // propriedade sob o técnico que a possui.
      expect(alvos.map((a) => a.colecaoPath),
          everyElement(isNot(contains('FANTASMA'))));
      expect(alvos.map((a) => a.valorRefPath),
          everyElement(isNot(contains('FANTASMA'))));
      expect(
          alvos.where((a) => a.tipo == TipoEscuta.animais).single.valorRefPath,
          'tecnico/T1/propriedades/P1');
    });

    test('técnico novo, sem propriedades, continua escutando o dele', () {
      final alvos =
          alvosDeEscuta(tecnicoPath: 'tecnico/T1', propriedades: const []);

      expect(alvos.map((a) => a.colecaoPath), [
        'tecnico/T1/animaisProdutores',
        'tecnico/T1/acoes',
        'resumo_da_visita',
      ]);
    });
  });

  group('alvosDeEscuta — produtor', () {
    test('escuta só a(s) propriedade(s) dele, sob o técnico dono', () {
      final alvos = alvosDeEscuta(
        tecnicoPath: null,
        propriedades: [_prop('P1', 'tecnico/T1')],
      );

      expect(
        alvos.where(
            (a) => a.tipo == TipoEscuta.animais || a.tipo == TipoEscuta.acoes),
        [
          const AlvoEscuta(
            tipo: TipoEscuta.animais,
            colecaoPath: 'tecnico/T1/animaisProdutores',
            campoFiltro: 'uidTecnicoPropriedade',
            valorRefPath: 'tecnico/T1/propriedades/P1',
          ),
          const AlvoEscuta(
            tipo: TipoEscuta.acoes,
            colecaoPath: 'tecnico/T1/acoes',
            campoFiltro: 'uidPropriedade',
            valorRefPath: 'tecnico/T1/propriedades/P1',
          ),
        ],
      );
    });

    test('propriedade ainda não enviada não gera escuta', () {
      expect(
        alvosDeEscuta(
          tecnicoPath: null,
          propriedades: [PropriedadeEntity(parentPath: 'tecnico/T1')],
        ),
        isEmpty,
      );
    });
  });

  group('receituário — produtor', () {
    test('escuta visitas, tratamentos e recomendações da propriedade', () {
      final alvos = alvosDeEscuta(
        tecnicoPath: null,
        propriedades: [_prop('P1', 'tecnico/T1')],
      );

      expect(
        alvos.where((a) => a.tipo == TipoEscuta.visitas).single,
        const AlvoEscuta(
          tipo: TipoEscuta.visitas,
          colecaoPath: 'resumo_da_visita',
          campoFiltro: 'uidPropriedade',
          valorRefPath: 'tecnico/T1/propriedades/P1',
        ),
      );
      expect(
        alvos.where((a) => a.tipo == TipoEscuta.tratamentos).single.colecaoPath,
        'tecnico/T1/propriedades/P1/tratamentos',
      );
      expect(
        alvos
            .where((a) => a.tipo == TipoEscuta.recomendacoes)
            .single
            .colecaoPath,
        'tecnico/T1/propriedades/P1/recomendacoes',
      );
    });
  });

  group('receituário — técnico', () {
    // Tratamentos e recomendações são subcoleção de cada propriedade: escutá-las
    // numa conta com 38 propriedades abriria 76 conexões — o problema que o pull
    // incremental veio resolver. O técnico EMITE o receituário; basta a visita,
    // que cobre um segundo aparelho dele com uma escuta só.
    test('escuta só as visitas, filtradas pelo próprio técnico', () {
      final alvos = alvosDeEscuta(
        tecnicoPath: 'tecnico/T1',
        propriedades: [_prop('P1', 'tecnico/T1')],
      );

      expect(
        alvos.where((a) => a.tipo == TipoEscuta.visitas).single,
        const AlvoEscuta(
          tipo: TipoEscuta.visitas,
          colecaoPath: 'resumo_da_visita',
          campoFiltro: 'uidTecnico',
          valorRefPath: 'tecnico/T1',
        ),
      );
      expect(alvos.where((a) => a.tipo == TipoEscuta.tratamentos), isEmpty);
      expect(alvos.where((a) => a.tipo == TipoEscuta.recomendacoes), isEmpty);
    });
  });

  test('parentPath de coleção top-level é ela mesma', () {
    const alvo = AlvoEscuta(
      tipo: TipoEscuta.visitas,
      colecaoPath: 'resumo_da_visita',
    );
    expect(alvo.parentPath, 'resumo_da_visita');
  });

  test('parentPath do documento: o técnico dono da coleção', () {
    const alvo = AlvoEscuta(
      tipo: TipoEscuta.animais,
      colecaoPath: 'tecnico/T1/animaisProdutores',
    );
    expect(alvo.parentPath, 'tecnico/T1');
  });
}
