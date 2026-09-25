import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O prontuário e a edição de animal leem do ObjectBox, não do Firestore.
///
/// `AnimaisProdutoresRecord.getDocument()` é um `.snapshots()` ao vivo: fora do
/// modelo offline-first, gasta um listener de rede por tela e, offline, depende
/// do cache interno do Firestore — animal nunca aberto online ficava preso no
/// spinner. Nas cinco telas `pron_*` o documento era lido e **descartado**.
void main() {
  const telas = [
    'lib/features/prontuario/presentation/pages/prontuario_animal_page.dart',
    'lib/features/prontuario/presentation/pages/pron_acoes_page.dart',
    'lib/features/prontuario/presentation/pages/pron_cios_page.dart',
    'lib/features/prontuario/presentation/pages/pron_inseminacoes_page.dart',
    'lib/features/prontuario/presentation/pages/pron_diag_gestacao_page.dart',
    'lib/features/prontuario/presentation/pages/pron_abortos_page.dart',
    'lib/features/animais/presentation/pages/editar_animal_page.dart',
  ];

  test('nenhuma delas lê o animal do Firestore', () {
    final comFirestore = [
      for (final tela in telas)
        if (File(tela).readAsStringSync().contains('AnimaisProdutoresRecord.getDocument'))
          tela,
    ];

    expect(comFirestore, isEmpty);
  });
}
