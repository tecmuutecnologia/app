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

      expect(alvos, [
        const AlvoEscuta(
          tipo: TipoEscuta.animais,
          colecaoPath: 'tecnico/T1/animaisProdutores',
        ),
        const AlvoEscuta(
          tipo: TipoEscuta.acoes,
          colecaoPath: 'tecnico/T1/acoes',
        ),
      ]);
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

      expect(alvos.map((a) => a.propriedadePath),
          everyElement('tecnico/T1/propriedades/P1'));
      expect(alvos, hasLength(2));
    });

    test('técnico novo, sem propriedades, continua escutando o dele', () {
      final alvos =
          alvosDeEscuta(tecnicoPath: 'tecnico/T1', propriedades: const []);

      expect(alvos.map((a) => a.colecaoPath),
          ['tecnico/T1/animaisProdutores', 'tecnico/T1/acoes']);
    });
  });

  group('alvosDeEscuta — produtor', () {
    test('escuta só a(s) propriedade(s) dele, sob o técnico dono', () {
      final alvos = alvosDeEscuta(
        tecnicoPath: null,
        propriedades: [_prop('P1', 'tecnico/T1')],
      );

      expect(alvos, [
        const AlvoEscuta(
          tipo: TipoEscuta.animais,
          colecaoPath: 'tecnico/T1/animaisProdutores',
          campoPropriedade: 'uidTecnicoPropriedade',
          propriedadePath: 'tecnico/T1/propriedades/P1',
        ),
        const AlvoEscuta(
          tipo: TipoEscuta.acoes,
          colecaoPath: 'tecnico/T1/acoes',
          campoPropriedade: 'uidPropriedade',
          propriedadePath: 'tecnico/T1/propriedades/P1',
        ),
      ]);
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

  test('parentPath do documento: o técnico dono da coleção', () {
    const alvo = AlvoEscuta(
      tipo: TipoEscuta.animais,
      colecaoPath: 'tecnico/T1/animaisProdutores',
    );
    expect(alvo.parentPath, 'tecnico/T1');
  });
}
