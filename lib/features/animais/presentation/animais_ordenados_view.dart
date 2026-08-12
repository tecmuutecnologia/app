import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/schema/structs/animais_produtores_struct.dart';
import '../application/animais_providers.dart';
import '../application/animal_struct_adapter.dart';

/// Lista de animais lida do ObjectBox de forma reativa, ja ordenada.
///
/// Existe para telas que montavam a lista uma unica vez no `initState`. Aquilo
/// era uma fotografia: registrar uma inseminacao gravava no ObjectBox, a tela
/// chamava `setState`, e o card era redesenhado a partir das MESMAS copias em
/// memoria — o rotulo novo so aparecia ao sair e voltar da tela.
///
/// Nao desenha o card: quem usa passa o `builder`. Assim esta view fica sem
/// dependencia de Firestore e pode ser testada com o provider sobrescrito.
class AnimaisOrdenadosView extends ConsumerWidget {
  const AnimaisOrdenadosView({
    super.key,
    required this.comparador,
    required this.builder,
  });

  /// Ordem da lista. Fica com quem chama porque a direcao e estado da tela.
  final int Function(AnimaisProdutoresStruct, AnimaisProdutoresStruct)
      comparador;

  final Widget Function(BuildContext, List<AnimaisProdutoresStruct>) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // `valueOrNull` e nao `when`: enquanto o primeiro evento nao chega, lista
    // vazia e o estado correto — a tela ja tem seu proprio esqueleto.
    final animais = ref.watch(animaisTodosProvider).valueOrNull ?? const [];

    final lista = animais.map(animalEntityToStruct).toList()..sort(comparador);

    return builder(context, lista);
  }
}
