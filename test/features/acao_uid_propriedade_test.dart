import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Toda ação precisa nascer com `uidPropriedadePath`.
///
/// O produtor enxerga as ações filtrando por `uidPropriedade` (download, pull e
/// escuta em tempo real). Ação gravada sem esse vínculo é invisível para ele:
/// DG+, DG−, confirma PP, secagem e aborto nunca apareceram no prontuário do
/// produtor por causa disso.
///
/// O campo é opcional na entidade — `fromFirestore` precisa aceitar documentos
/// antigos sem ele —, então o tipo não garante nada e a garantia fica aqui.
void main() {
  test('todo widget que cria ação passa uidPropriedadePath', () {
    final faltando = <String>[];

    for (final arquivo in Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final fonte = arquivo.readAsStringSync();
      final criaAcao = fonte.contains('AcaoEntity(');
      if (!criaAcao) continue;
      if (!fonte.contains('uidPropriedadePath')) {
        faltando.add(arquivo.path);
      }
    }

    expect(faltando, isEmpty,
        reason: 'ação criada sem uidPropriedadePath fica invisível ao produtor');
  });
}
