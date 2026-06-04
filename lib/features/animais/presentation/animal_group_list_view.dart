import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/animais_providers.dart';

/// Lista de animais de UMA aba (grupo) de uma propriedade, lida do
/// `AnimalRepository` (ObjectBox) via Riverpod — fonte ÚNICA, funciona online e
/// offline, e reage a edições locais (ex.: o `editar_animal` agora grava no
/// ObjectBox).
///
/// Piloto para substituir a leitura de uma aba da `lista_animais` (ex.: Vacas),
/// eliminando a dualidade StreamBuilder(Firestore)+FFAppState daquela aba.
///
/// [onTapAnimal] recebe o `firestoreId` do animal tocado, para a tela
/// reconstruir a navegação/ações existentes (ex.: abrir prontuário).
class AnimalGroupListView extends ConsumerWidget {
  const AnimalGroupListView({
    super.key,
    required this.propriedadePath,
    required this.grupo,
    this.onTapAnimal,
  });

  /// Path do documento da propriedade (parentPath dos animais).
  final String propriedadePath;

  /// Nome do grupo da aba (ex.: 'Vacas', 'Novilhas', 'Touros').
  final String grupo;

  /// Callback opcional ao tocar num animal (recebe o firestoreId).
  final void Function(String firestoreId)? onTapAnimal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animaisAsync = ref.watch(
      animaisByGrupoProvider(
        (propriedadePath: propriedadePath, grupo: grupo),
      ),
    );

    return animaisAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Erro ao carregar animais')),
      data: (animais) {
        if (animais.isEmpty) {
          return Center(child: Text('Nenhum animal no grupo $grupo'));
        }
        return ListView.builder(
          itemCount: animais.length,
          itemBuilder: (context, index) {
            final animal = animais[index];
            final titulo = animal.nomeBrincoConcat?.isNotEmpty == true
                ? animal.nomeBrincoConcat!
                : (animal.nomeAnimal ?? 'Animal sem nome');
            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.pets),
                title: Text(titulo),
                subtitle: Text(
                  [
                    if ((animal.status ?? '').isNotEmpty) animal.status!,
                    if ((animal.racaAnimal ?? '').isNotEmpty) animal.racaAnimal!,
                  ].join(' • '),
                ),
                trailing: Text('Brinco ${animal.brincoAnimal}'),
                onTap: animal.firestoreId == null || onTapAnimal == null
                    ? null
                    : () => onTapAnimal!(animal.firestoreId!),
              ),
            );
          },
        );
      },
    );
  }
}
