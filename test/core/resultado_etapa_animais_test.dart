import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/resultado_etapa_animais.dart';

/// A etapa de animais do produtor consulta um alvo por propriedade e engolia
/// qualquer erro que não fosse de cota: a etapa terminava marcada como
/// concluída com zero animais, e a tela dizia "pronto". Falhar em TODOS os
/// alvos não é um contratempo — é a etapa não ter acontecido.
void main() {
  group('erroFatalDaEtapaAnimais', () {
    final erro = Exception('permission-denied');

    test('todos os alvos falharam: a etapa falhou', () {
      expect(
        erroFatalDaEtapaAnimais(alvos: 2, falhas: 2, primeiroErro: erro),
        erro,
      );
    });

    test('falha parcial não derruba a etapa', () {
      expect(
        erroFatalDaEtapaAnimais(alvos: 2, falhas: 1, primeiroErro: erro),
        isNull,
      );
    });

    test('sem alvos não há falha — produtor sem propriedade sincronizada', () {
      expect(
        erroFatalDaEtapaAnimais(alvos: 0, falhas: 0, primeiroErro: null),
        isNull,
      );
    });

    test('rebanho legitimamente vazio não é erro', () {
      expect(
        erroFatalDaEtapaAnimais(alvos: 1, falhas: 0, primeiroErro: null),
        isNull,
      );
    });
  });
}
