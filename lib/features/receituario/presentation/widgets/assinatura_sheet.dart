import '/data/backend.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_button.dart';
import '/core/ui/app_card.dart';
import '/core/ui/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signature/signature.dart';

import '../../application/assinar_resumo.dart';

/// Painel de coleta de assinatura (técnico ou produtor) do resumo da visita.
///
/// Os dois widgets de assinatura eram cópias idênticas que só diferiam na cor
/// do botão (marrom num, laranja no outro); agora ambos delegam para este.
class AssinaturaSheet extends StatefulWidget {
  const AssinaturaSheet({
    super.key,
    required this.uidResumoVisita,
    required this.assinante,
  });

  final DocumentReference? uidResumoVisita;
  final Assinante assinante;

  @override
  State<AssinaturaSheet> createState() => _AssinaturaSheetState();
}

class _AssinaturaSheetState extends State<AssinaturaSheet> {
  static const _altura = 160.0;

  late final SignatureController _controller = SignatureController(
    penStrokeWidth: 2.5,
    penColor: const Color(0xFF14181B),
    exportBackgroundColor: Colors.white,
  );

  bool _salvando = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _titulo => widget.assinante == Assinante.tecnico
      ? 'Assinatura do técnico'
      : 'Assinatura do produtor';

  Future<void> _confirmar() async {
    if (_salvando) return;
    final png = await _controller.toPngBytes(height: 120);
    if (!mounted) return;
    if (png == null) {
      showUploadMessage(
        context,
        'Arquivo vazio. Por favor, envie uma assinatura válida.',
      );
      return;
    }
    setState(() => _salvando = true);
    // Offline-first: grava no aparelho e fecha na hora; o upload ao Storage
    // corre em segundo plano (ver assinarResumo).
    final salvo = await assinarResumo(
      firestoreIdResumo: widget.uidResumoVisita?.id,
      png: png,
      assinante: widget.assinante,
    );
    if (!mounted) return;
    if (!salvo) {
      setState(() => _salvando = false);
      showUploadMessage(
          context, 'Resumo da visita não encontrado no aparelho.');
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: tema.secondaryBackground,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTokens.radius + 8.0)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: tema.alternate,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const MenuIconTile(
                      icon: Icons.draw_rounded,
                      size: 40.0,
                      iconSize: 22.0,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _titulo,
                            style: tema.titleMedium.override(
                              font: GoogleFonts.readexPro(
                                  fontWeight: FontWeight.w600),
                              // titleMedium do tema é branco (feito p/ appbar).
                              color: tema.primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Assine com o dedo no quadro abaixo',
                            style: tema.bodySmall.override(
                              font: GoogleFonts.readexPro(),
                              color: tema.secondaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
                    border: Border.all(color: tema.alternate, width: 1.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Signature(
                        controller: _controller,
                        backgroundColor: Colors.white,
                        height: _altura,
                      ),
                      Positioned(
                        right: 4.0,
                        top: 4.0,
                        child: TextButton.icon(
                          onPressed: _controller.clear,
                          style: TextButton.styleFrom(
                            foregroundColor: tema.secondaryText,
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 18.0),
                          label: const Text('Limpar'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                AppButton(
                  text: _salvando ? 'Salvando…' : 'Confirmar assinatura',
                  icon: Icons.check_rounded,
                  onPressed: _salvando ? null : _confirmar,
                ),
                const SizedBox(height: 12.0),
                AppButton(
                  text: 'Cancelar',
                  tipo: AppButtonTipo.secundario,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
