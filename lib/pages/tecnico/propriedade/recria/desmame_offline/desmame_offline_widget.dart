// Arquivo de compatibilidade - redireciona para o DesmameWidget unificado
// Este arquivo existe apenas para manter compatibilidade com código antigo
// TODO: Atualizar todos os usos para DesmameWidget com mode: DesmameMode.offlineNew

import '/backend/backend.dart';
import 'package:flutter/material.dart';
import '../desmame/desmame_widget.dart';

/// @deprecated Use DesmameWidget com mode: DesmameMode.offlineNew
class DesmameOfflineWidget extends StatelessWidget {
  const DesmameOfflineWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    required this.nomeAnimal,
    required this.brincoAnimal,
    required this.grupoAnimal,
    required this.uidAnimalOffline,
    required this.itemUidIndex,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final String? nomeAnimal;
  final String? brincoAnimal;
  final String? grupoAnimal;
  final String? uidAnimalOffline;
  final int? itemUidIndex;

  @override
  Widget build(BuildContext context) {
    return DesmameWidget(
      mode: DesmameMode.offlineNew,
      uidPropriedade: uidPropriedade,
      nomePropriedade: nomePropriedade,
      uidTecnico: uidTecnico,
      emailPropriedade: emailPropriedade,
      visitaPresencial: visitaPresencial,
      diasDg: diasDg,
      nomeAnimal: nomeAnimal,
      brincoAnimal: brincoAnimal,
      grupoAnimal: grupoAnimal,
      uidAnimalOffline: uidAnimalOffline,
      itemUidIndex: itemUidIndex,
    );
  }
}
