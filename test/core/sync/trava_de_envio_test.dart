import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/trava_de_envio.dart';

/// Duas sincronizações em paralelo liam os mesmos tratamentos ainda sem
/// `firestoreId` e cada uma criava o seu documento: o receituário de uma
/// visita chegou com 47 tratamentos de IATF para 32 animais. Os gatilhos
/// (timer, reconexão, `queueOperation`, logout) disparam sem coordenação, então
/// quem impede a corrida é a trava.
void main() {
  group('executar', () {
    test('duas chamadas simultâneas não rodam o corpo em paralelo', () async {
      final trava = TravaDeEnvio();
      var rodando = 0;
      var picoDeParalelismo = 0;

      Future<void> corpo() async {
        rodando++;
        if (rodando > picoDeParalelismo) picoDeParalelismo = rodando;
        await Future<void>.delayed(const Duration(milliseconds: 10));
        rodando--;
      }

      await Future.wait([trava.executar(corpo), trava.executar(corpo)]);

      expect(picoDeParalelismo, 1);
    });

    test('erro numa execução não trava as seguintes', () async {
      final trava = TravaDeEnvio();

      final falha = trava.executar<void>(() async => throw StateError('rede'));
      final depois = trava.executar(() async => 'ok');

      await expectLater(falha, throwsStateError);
      expect(await depois, 'ok');
    });
  });

  group('agendar', () {
    test('chamadas durante uma rodada viram UMA rodada a mais', () async {
      final trava = TravaDeEnvio();
      final liberar = Completer<void>();
      var rodadas = 0;

      Future<void> sync() async {
        rodadas++;
        if (rodadas == 1) await liberar.future;
      }

      final primeira = trava.agendar(sync);
      await Future<void>.delayed(Duration.zero);
      // Timer, reconexão e fila chegando enquanto a primeira ainda envia.
      final outras = [trava.agendar(sync), trava.agendar(sync)];
      liberar.complete();
      await Future.wait([primeira, ...outras]);

      expect(rodadas, 2);
    });

    test('pedido feito depois que a rodada começou não se perde', () async {
      final trava = TravaDeEnvio();
      final liberar = Completer<void>();
      final vistos = <int>[];
      var pendencias = 1;

      Future<void> sync() async {
        vistos.add(pendencias);
        if (vistos.length == 1) await liberar.future;
      }

      final primeira = trava.agendar(sync);
      await Future<void>.delayed(Duration.zero);
      // Um tratamento novo entra depois que a rodada já leu as pendências.
      pendencias = 2;
      final segunda = trava.agendar(sync);
      liberar.complete();
      await Future.wait([primeira, segunda]);

      expect(vistos, [1, 2]);
    });

    test('agendar não roda em paralelo com executar', () async {
      final trava = TravaDeEnvio();
      var rodando = 0;
      var picoDeParalelismo = 0;

      Future<void> corpo() async {
        rodando++;
        if (rodando > picoDeParalelismo) picoDeParalelismo = rodando;
        await Future<void>.delayed(const Duration(milliseconds: 10));
        rodando--;
      }

      await Future.wait([trava.agendar(corpo), trava.executar(corpo)]);

      expect(picoDeParalelismo, 1);
    });
  });
}
