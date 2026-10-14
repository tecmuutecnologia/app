import 'package:flutter/material.dart';
import '/features/recria/application/filtros_recria.dart';
import '/features/animais/application/ordenacao_animais.dart';
import '/features/animais/application/animal_struct_adapter.dart';

import '/data/backend.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import 'animal_card_widget.dart';

/// Widget que exibe a lista de animais (online ou offline)
class AnimalListWidget extends StatelessWidget {
  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final String? filterCategory;

  /// Busca e ordem da tela de Animais (mesma regra: [aplicarBuscaEOrdemPor]).
  final OrdemAnimais ordem;
  final bool crescente;
  final String busca;
  final VoidCallback? onAcaoConcluida;

  const AnimalListWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    this.filterCategory,
    this.ordem = OrdemAnimais.nome,
    this.crescente = true,
    this.busca = '',
    this.onAcaoConcluida,
  });

  @override
  Widget build(BuildContext context) => _buildLista(context);

  /// Fonte única ObjectBox (offline-first), igual às demais telas.
  ///
  /// Antes o modo online usava um `StreamBuilder` do Firestore: as ações
  /// gravavam primeiro no ObjectBox, mas a lista lia do Firestore, então só
  /// refletia a mudança depois que o sync subisse.
  Widget _buildLista(BuildContext context) {
    return Builder(
      builder: (context) {
        final existingAnimals = animaisProdutoresExistentesObjectBox()
            .asMap()
            .entries
            .where((entry) {
              final item = entry.value;
              if (item.uidTecnicoPropriedade != uidPropriedade) return false;
              // Semen nao se recria: e insumo de inseminacao.
              if (!ehDaRecria(item.grupoAnimal)) return false;
              if (filterCategory != null &&
                  filterCategory != 'Todos' &&
                  item.grupoAnimal != filterCategory) return false;
              return true;
            })
            .map((entry) => _mapExistingToAnimalData(entry.value, entry.key))
            .toList();

        // Animais criados offline agora entram no ObjectBox (vêm em
        // existingAnimals via getAll), não há mais lista separada no FFAppState.
        final allAnimals = aplicarBuscaEOrdemPor<AnimalData>(
          existingAnimals,
          titulo: (a) => a.tituloExibido,
          nome: (a) => a.nomeAnimal,
          brinco: (a) => a.brincoAnimal,
          dataInseminacao: (a) => _dataDdMmAaaa(a.dtUltimaInseminacao),
          ordem: ordem,
          crescente: crescente,
          busca: busca,
        );

        if (allAnimals.isEmpty) {
          return _buildEmptyState(context);
        }

        // Unico scrollable da tela, abaixo do cabecalho fixo de busca/abas.
        return ListView.builder(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 24.0),
          scrollDirection: Axis.vertical,
          itemCount: allAnimals.length,
          itemBuilder: (context, index) {
            final animal = allAnimals[index];
            return AnimalCardWidget(
              animal: animal,
              uidPropriedade: uidPropriedade,
              nomePropriedade: nomePropriedade,
              uidTecnico: uidTecnico,
              emailPropriedade: emailPropriedade,
              visitaPresencial: visitaPresencial,
              diasDg: diasDg,
              onAcaoConcluida: onAcaoConcluida,
            );
          },
        );
      },
    );
  }

  AnimalData _mapExistingToAnimalData(dynamic item, int index) {
    return AnimalData(
      grupoAnimal: item.grupoAnimal ?? '',
      nomeAnimal: item.nomeAnimal ?? '',
      brincoAnimal: item.brincoAnimal,
      nomeBrincoConcat: item.nomeBrincoConcat ?? '',
      status: item.status ?? '',
      dtNascimento: item.dtNascimento,
      dtUltimaInseminacao: item.dtUltimaInseminacao,
      dtUltimoPartoContingencia: item.dtUltimoPartoContingencia,
      dtUltimoParto: item.dtUltimoParto,
      dtPrePartoPrevista: item.dtPrePartoPrevista,
      dtPartoPrevisto: item.dtPartoPrevisto,
      dtUltimaAcao: item.dtUltimaAcao,
      dtInducaoLactacao: item.dtInducaoLactacao,
      nomeTouroUltimaInseminacao: item.nomeTouroUltimaInseminacao,
      brincoAnimalOrder: item.brincoAnimalOrder,
      liberaInseminacao: item.liberaInseminacao ?? false,
      // Sem isto `reference` ficava sempre null: o prontuário não abria e o
      // desmame roteava todo animal como "criado offline".
      reference: item.uidAnimal,
      itemIndex: index,
      uidAnimalOffline: item.uidAnimalOffline,
      uidTecnicoPropriedade: item.uidTecnicoPropriedade,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Nenhum animal encontrado',
          style: FlutterFlowTheme.of(context).bodyMedium,
        ),
      ),
    );
  }

  /// `dd/MM/yyyy` do struct; vazio, `0` ou malformado contam como sem data.
  static DateTime? _dataDdMmAaaa(String? texto) {
    final partes = (texto ?? '').trim().split('/');
    if (partes.length != 3) return null;
    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final ano = int.tryParse(partes[2]);
    if (dia == null || mes == null || ano == null) return null;
    return DateTime(ano, mes, dia);
  }
}
