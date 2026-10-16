import '/data/backend.dart';
import 'package:flutter/material.dart';

import '../../application/assinar_resumo.dart';
import 'assinatura_sheet.dart';

/// Painel de assinatura do produtor. Mantido como atalho de [AssinaturaSheet]
/// para não mudar quem já abre este widget.
class AssinaturaProdutorWidget extends StatelessWidget {
  const AssinaturaProdutorWidget({
    super.key,
    required this.uidResumoVisita,
  });

  final DocumentReference? uidResumoVisita;

  @override
  Widget build(BuildContext context) => AssinaturaSheet(
        uidResumoVisita: uidResumoVisita,
        assinante: Assinante.produtor,
      );
}
