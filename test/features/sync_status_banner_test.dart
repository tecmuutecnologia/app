import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/di/providers.dart';
import 'package:tecmuu/features/shared/widgets/sync_status_banner.dart';

/// Valida o piloto de wiring UI<->offline-first ponta a ponta: o
/// `SyncStatusBanner` reage ao `isOnlineProvider` (sobrescrito no teste), sem
/// depender de rede/ObjectBox reais.
void main() {
  Future<void> pumpBanner(WidgetTester tester, {required bool online}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isOnlineProvider.overrideWith((ref) => Stream<bool>.value(online)),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SyncStatusBanner()),
        ),
      ),
    );
    await tester.pump(); // deixa o stream emitir o primeiro valor
  }

  testWidgets('mostra o aviso quando offline', (tester) async {
    await pumpBanner(tester, online: false);
    expect(find.text('Sem conexão — trabalhando offline'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
  });

  testWidgets('fica invisível quando online', (tester) async {
    await pumpBanner(tester, online: true);
    expect(find.textContaining('Sem conexão'), findsNothing);
    expect(find.byIcon(Icons.cloud_off_rounded), findsNothing);
  });
}
