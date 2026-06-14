import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/animais_providers.dart';

/// Lista de animais de uma propriedade, alimentada pelo `AnimalRepository`
/// (ObjectBox) via Riverpod — piloto de migração da LEITURA de uma tela de lista
/// para a camada offline-first.
///
/// Autocontido: recebe o [propriedadePath] e renderiza a lista reativa. Pode
/// substituir, de forma incremental, o `StreamBuilder`/`FFAppState` das telas
/// de lista existentes (ex.: lista_animais). Não escreve nada.
class AnimalListView extends ConsumerWidget {
  const AnimalListView({super.key, required this.propriedadePath});

  /// Path do documento da propriedade no Firestore (parentPath dos animais).
  final String propriedadePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animaisAsync =
        ref.watch(animaisByPropriedadeProvider(propriedadePath));

    return animaisAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(
        child: Text('Erro ao carregar animais'),
      ),
      data: (animais) {
        if (animais.isEmpty) {
          return const Center(child: Text('Nenhum animal cadastrado'));
        }
        return ListView.builder(
          itemCount: animais.length,
          itemBuilder: (context, index) {
            final animal = animais[index];
            final titulo = animal.nomeBrincoConcat?.isNotEmpty == true
                ? animal.nomeBrincoConcat!
                : (animal.nomeAnimal ?? 'Animal sem nome');
            return ListTile(
              leading: const Icon(Icons.pets),
              title: Text(titulo),
              subtitle: Text(animal.status ?? ''),
              trailing: Text('Brinco ${animal.brincoAnimal}'),
            );
          },
        );
      },
    );
  }
}
