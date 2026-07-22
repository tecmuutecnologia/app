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
}
