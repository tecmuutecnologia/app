import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecmuu/app/router/destino_inicial.dart';
import 'package:tecmuu/app/router/nav.dart';
import 'package:tecmuu/features/sincronizacao/presentation/pages/sync_page.dart';

void main() {
  group('destinoDeAbertura', () {
    test('deslogado fica na tela inicial', () {
      expect(
        destinoDeAbertura(logado: false, destinoGuardado: '/dashboardTecnico'),
        isNull,
        reason: 'sessao encerrada nao pode reabrir no destino do dono anterior',
      );
    });

    test('logado vai direto ao destino guardado, sem consultar nada', () {
      expect(
        destinoDeAbertura(logado: true, destinoGuardado: '/dashboardTecnico'),
        '/dashboardTecnico',
      );
    });

    test('logado sem destino guardado passa pela sincronizacao', () {
      // Instalacao que ainda nao sincronizou. A tela de sync descobre o papel
      // e grava o destino para as proximas aberturas.
      expect(
        destinoDeAbertura(logado: true, destinoGuardado: null),
        SyncPage.routePath,
      );
    });

    test('destino guardado igual a raiz nao vira laco', () {
      expect(
        destinoDeAbertura(logado: true, destinoGuardado: '/'),
        SyncPage.routePath,
      );
    });
  });

  group('DestinoInicial', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await DestinoInicial.inicializar();
    });

    test('guarda, le e limpa a localizacao', () async {
      expect(DestinoInicial.valor, isNull);

      await DestinoInicial.guardar('/inicioPropriedadeProdutor?uid=abc');
      expect(DestinoInicial.valor, '/inicioPropriedadeProdutor?uid=abc');

      await DestinoInicial.limpar();
      expect(DestinoInicial.valor, isNull,
          reason: 'o logout tem de zerar o destino do aparelho');
    });
  });
}
