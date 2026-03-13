import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_animations.dart';

/// Helper para criar as animações padronizadas usadas nos cards do menu.
///
/// Este mixin fornece um método para criar múltiplas animações de
/// fade + move de forma consistente.
mixin MenuAnimationsMixin on TickerProviderStateMixin {
  /// Cria um mapa de animações para containers com efeito de fade in + slide up.
  ///
  /// [count] é o número de animações a serem criadas (containerOnPageLoadAnimation1, 2, 3...).
  Map<String, AnimationInfo> createContainerAnimations(int count) {
    final Map<String, AnimationInfo> animations = {};

    for (int i = 1; i <= count; i++) {
      animations['containerOnPageLoadAnimation$i'] = AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 90.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      );
    }

    return animations;
  }

  /// Configuração padrão de animação para um único container.
  static AnimationInfo get defaultContainerAnimation => AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 90.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      );
}

/// Extensão para facilitar a aplicação de animações nos widgets.
extension AnimatedWidgetExtension on Widget {
  /// Aplica a animação padrão de container ao widget.
  Widget withDefaultAnimation(AnimationInfo? animation) {
    if (animation == null) return this;
    return animateOnPageLoad(animation);
  }
}
