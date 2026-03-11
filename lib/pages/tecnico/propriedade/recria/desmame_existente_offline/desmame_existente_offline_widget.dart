// Arquivo de compatibilidade - redireciona para o DesmameWidget unificado
// Este arquivo existe apenas para manter compatibilidade com código antigo
// TODO: Atualizar todos os usos para DesmameWidget com mode: DesmameMode.offlineExisting

import '/backend/backend.dart';
import 'package:flutter/material.dart';
import '../desmame/desmame_widget.dart';

/// @deprecated Use DesmameWidget com mode: DesmameMode.offlineExisting
class DesmameExistenteOfflineWidget extends StatelessWidget {
  const DesmameExistenteOfflineWidget({
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
    required this.uidAnimaisProdutores,
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
  final DocumentReference? uidAnimaisProdutores;
  final int? itemUidIndex;

  @override
  Widget build(BuildContext context) {
    return DesmameWidget(
      mode: DesmameMode.offlineExisting,
      uidPropriedade: uidPropriedade,
      nomePropriedade: nomePropriedade,
      uidTecnico: uidTecnico,
      emailPropriedade: emailPropriedade,
      visitaPresencial: visitaPresencial,
      diasDg: diasDg,
      nomeAnimal: nomeAnimal,
      brincoAnimal: brincoAnimal,
      grupoAnimal: grupoAnimal,
      uidAnimaisProdutores: uidAnimaisProdutores,
      itemUidIndex: itemUidIndex,
    );
  }
}
