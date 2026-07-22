import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Verde de sucesso — independente do laranja/roxo da marca.
const Color _kSucessoVerde = Color(0xFF2ECC71);

/// Mostra uma animação de SUCESSO centralizada na tela: um check verde que
/// surge (escala com curva elástica + fade) e uma mensagem abaixo, sobre um
/// leve scrim. Some sozinha em [duracao].
///
/// Usa o `rootOverlay`, então a animação SOBREVIVE a um `pop()`/`push()` logo
/// em seguida — ela toca por cima da transição de tela, sem bloquear a
/// navegação (fire-and-forget). Substitui o snackbar de rodapé.
void mostrarSucessoOverlay(
  BuildContext context, {
  String mensagem = 'Animal cadastrado com sucesso!',
  Duration duracao = const Duration(milliseconds: 2600),
}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;

  late final OverlayEntry entry;
  var removido = false;
  void remover() {
    if (removido) return;
    removido = true;
    entry.remove();
  }

  entry = OverlayEntry(
    builder: (context) =>
        _SucessoOverlayContent(mensagem: mensagem, duracao: duracao),
  );

  overlay.insert(entry);
  Timer(duracao, remover);
}

class _SucessoOverlayContent extends StatelessWidget {
  const _SucessoOverlayContent({required this.mensagem, required this.duracao});

  final String mensagem;
  final Duration duracao;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 26.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 28.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84.0,
                height: 84.0,
                decoration: const BoxDecoration(
                  color: _kSucessoVerde,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 52.0,
                ),
              )
                  .animate()
                  .scale(
                    duration: 550.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(1.0, 1.0),
                  )
                  .fadeIn(duration: 200.ms),
              const SizedBox(height: 16.0),
              Text(
                mensagem,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ).animate().fadeIn(delay: 200.ms, duration: 300.ms).moveY(
                    begin: 8.0,
                    end: 0.0,
                    delay: 200.ms,
                    duration: 300.ms,
                    curve: Curves.easeOut,
                  ),
            ],
          ),
        )
            // O card entra suave, permanece e sai com fade — o hold é derivado
            // da duração total (entrada 180ms + hold + saída 300ms = total), para
            // o fade-out terminar junto com a remoção do OverlayEntry.
            .animate()
            .fadeIn(duration: 180.ms)
            .then(
                delay: Duration(
                    milliseconds:
                        (duracao.inMilliseconds - 180 - 300).clamp(0, 60000)))
            .fadeOut(duration: 300.ms),
      ),
    );
  }
}
