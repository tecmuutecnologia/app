import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/data/objectbox/entities/index.dart';
import 'widgets/descarte_animal_widget.dart';
import 'widgets/vender_animal_widget.dart';

/// Abre o formulário de VENDA do animal. Devolve `true` se a venda foi
/// gravada. A propriedade da venda é a do próprio animal
/// (`uidTecnicoPropriedade`).
Future<bool> abrirVenda(BuildContext context, AnimalEntity animal) async {
  final propriedadePath = animal.uidTecnicoPropriedadePath;
  if (propriedadePath == null || propriedadePath.isEmpty) return false;
  final gravou = await showModalBottomSheet<bool>(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Padding(
      padding: MediaQuery.viewInsetsOf(context),
      child: VenderAnimalWidget(
          animal: animal, propriedadePath: propriedadePath),
    ),
  );
  return gravou ?? false;
}

/// Abre o formulário de DESCARTE (motivo + data) do animal. Devolve `true` se
/// o descarte foi gravado.
Future<bool> abrirDescarte(BuildContext context, AnimalEntity animal) async {
  if (animal.firestoreId == null || animal.parentPath == null) return false;
  final gravou = await showModalBottomSheet<bool>(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: false,
    context: context,
    builder: (context) => Padding(
      padding: MediaQuery.viewInsetsOf(context),
      child: DescarteAnimalWidget(
        uidPropriedade: null,
        nomePropriedade: null,
        uidTecnico: null,
        emailPropriedade: null,
        // Animais vivem sob o técnico (parentPath do animal).
        uidAnimaisProdutores: FirebaseFirestore.instance
            .doc('${animal.parentPath}/animaisProdutores/${animal.firestoreId}'),
        grupoPredominante: animal.grupoAnimal,
        nomeAnimal: animal.nomeAnimal ?? '',
        visitaPresencial: false,
        diasDg: '',
      ),
    ),
  );
  return gravou ?? false;
}
