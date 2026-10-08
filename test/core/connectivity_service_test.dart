import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/connectivity/connectivity_service.dart';

/// Testes da lógica de decisão do `ConnectivityService`, com as sondas de
/// plugin injetadas — sem depender de rede/hardware real.
void main() {
  group('ConnectivityService.checkConnection', () {
    test('retorna false quando não há interface de rede', () async {
      final service = ConnectivityService(
        probeConnectivity: () async => ConnectivityResult.none,
        probeInternetAccess: () async =>
            fail('não deve checar acesso real sem interface'),
        connectivityChanges: const Stream.empty(),
      );

      expect(await service.checkConnection(), false);
    });

    test('retorna true com interface e acesso real à internet', () async {
      final service = ConnectivityService(
        probeConnectivity: () async => ConnectivityResult.wifi,
        probeInternetAccess: () async => true,
        connectivityChanges: const Stream.empty(),
      );

      expect(await service.checkConnection(), true);
    });

    test('retorna false com interface mas SEM acesso real (Wi-Fi sem saída)',
        () async {
      final service = ConnectivityService(
        probeConnectivity: () async => ConnectivityResult.wifi,
        probeInternetAccess: () async => false,
        connectivityChanges: const Stream.empty(),
      );

      expect(await service.checkConnection(), false);
    });
  });

  group('ConnectivityService.onStatusChange', () {
    test(
        'status reflete a INTERFACE (não a sonda profunda), p/ não dar '
        'falso-offline estando online', () async {
      final changes = StreamController<ConnectivityResult>();

      final service = ConnectivityService(
        probeConnectivity: () async => ConnectivityResult.wifi,
        // Sonda profunda SEMPRE falsa: simula hosts de checagem bloqueados na
        // rede do usuário. NÃO deve pintar a UI de offline havendo interface.
        probeInternetAccess: () async => false,
        connectivityChanges: changes.stream,
      );

      final emitted = <bool>[];
      final sub = service.onStatusChange.listen(emitted.add);

      await service.start(); // interface wifi -> online (true), apesar da sonda

      // Cai a interface -> offline.
      changes.add(ConnectivityResult.none);
      await Future<void>.delayed(Duration.zero);

      // Volta a interface (dados) -> online de novo, MESMO com a sonda falsa.
      changes.add(ConnectivityResult.mobile);
      await Future<void>.delayed(Duration.zero);

      expect(emitted, [true, false, true]);
      expect(service.isOnline, true);

      await sub.cancel();
      await changes.close();
      await service.dispose();
    });
  });

  group('ConnectivityService recuperação sem evento', () {
    // O `connectivity_plus` perde a transição de volta em certas condições
    // (conhecido no simulador iOS — plus_plugins#479 — e observado em device).
    // Sem rede de segurança, um evento perdido congela a UI em "offline" E o
    // motor de sync, cujo push é gated no mesmo estado, até o app reiniciar.

    test('recheck() reconcilia o estado quando o evento nunca chega', () async {
      var interface = ConnectivityResult.wifi;
      final changes = StreamController<ConnectivityResult>();

      final service = ConnectivityService(
        probeConnectivity: () async => interface,
        probeInternetAccess: () async => true,
        connectivityChanges: changes.stream,
      );

      final emitted = <bool>[];
      final sub = service.onStatusChange.listen(emitted.add);

      await service.start();

      // A interface cai e o evento CHEGA: vai para offline normalmente.
      interface = ConnectivityResult.none;
      changes.add(ConnectivityResult.none);
      await Future<void>.delayed(Duration.zero);

      // A interface volta, mas o evento SOME — é o caso que travava o banner.
      interface = ConnectivityResult.wifi;
      await service.recheck();
      await Future<void>.delayed(Duration.zero); // entrega do broadcast

      expect(emitted, [true, false, true]);
      expect(service.isOnline, true);

      await sub.cancel();
      await changes.close();
      await service.dispose();
    });

    test('o re-check periódico se recupera sozinho', () async {
      var interface = ConnectivityResult.none;

      final service = ConnectivityService(
        probeConnectivity: () async => interface,
        probeInternetAccess: () async => true,
        connectivityChanges: const Stream.empty(),
        recheckInterval: const Duration(milliseconds: 20),
      );

      final emitted = <bool>[];
      final sub = service.onStatusChange.listen(emitted.add);

      await service.start(); // sem interface -> offline
      expect(service.isOnline, false);

      // Volta a rede sem nenhum evento no stream: só o timer pode perceber.
      interface = ConnectivityResult.wifi;
      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(service.isOnline, true);
      expect(emitted, [false, true]);

      await sub.cancel();
      await service.dispose();
    });

    test('re-check repetido no mesmo estado não emite ruído', () async {
      final service = ConnectivityService(
        probeConnectivity: () async => ConnectivityResult.wifi,
        probeInternetAccess: () async => true,
        connectivityChanges: const Stream.empty(),
      );

      final emitted = <bool>[];
      final sub = service.onStatusChange.listen(emitted.add);

      await service.start();
      await service.recheck();
      await service.recheck();

      expect(emitted, [true]);

      await sub.cancel();
      await service.dispose();
    });
  });

  group('ConnectivityService escape do offline preso', () {
    // No simulador iOS o `connectivity_plus` fica preso em `none` depois que o
    // Wi-Fi volta — stream E sonda de interface (medido: 2min sem corrigir).
    // Perguntar de novo para a mesma fonte que mente não destrava nada.
    //
    // A sonda profunda é usada de forma ASSIMÉTRICA, o que preserva a decisão
    // de projeto original: ela NUNCA pinta a UI de offline (falhar é ambíguo —
    // pode ser host bloqueado), mas ter internet de fato é prova direta de que
    // estamos online, então serve para SAIR de um offline preso.

    test('sai do offline quando a interface mente mas há internet', () async {
      final service = ConnectivityService(
        probeConnectivity: () async => ConnectivityResult.none, // mente
        probeInternetAccess: () async => true, // mas há internet de fato
        connectivityChanges: const Stream.empty(),
        recheckInterval: const Duration(milliseconds: 20),
      );

      final emitted = <bool>[];
      final sub = service.onStatusChange.listen(emitted.add);

      await service.start(); // interface none -> offline
      expect(service.isOnline, false);

      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(service.isOnline, true, reason: 'a sonda profunda deve destravar');
      expect(emitted, [false, true]);

      await sub.cancel();
      await service.dispose();
    });

    test('permanece offline quando não há interface NEM internet', () async {
      final service = ConnectivityService(
        probeConnectivity: () async => ConnectivityResult.none,
        probeInternetAccess: () async => false,
        connectivityChanges: const Stream.empty(),
        recheckInterval: const Duration(milliseconds: 20),
      );

      final emitted = <bool>[];
      final sub = service.onStatusChange.listen(emitted.add);

      await service.start();
      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(service.isOnline, false);
      expect(emitted, [false], reason: 'offline real não deve oscilar');

      await sub.cancel();
      await service.dispose();
    });

    test('queda para offline NÃO consulta a sonda profunda', () async {
      // Ir para offline continua decidido só pela interface: rápido e sem I/O.
      final changes = StreamController<ConnectivityResult>();
      final service = ConnectivityService(
        probeConnectivity: () async => ConnectivityResult.wifi,
        probeInternetAccess: () async =>
            fail('a queda não pode depender da sonda profunda'),
        connectivityChanges: changes.stream,
      );

      final emitted = <bool>[];
      final sub = service.onStatusChange.listen(emitted.add);

      await service.start();
      changes.add(ConnectivityResult.none);
      await Future<void>.delayed(Duration.zero);

      expect(emitted, [true, false]);

      await sub.cancel();
      await changes.close();
      await service.dispose();
    });
  });
}
