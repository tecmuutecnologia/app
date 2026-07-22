import 'package:flutter/material.dart';
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
  final bool ascending;
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
    this.ascending = true,
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
              if (filterCategory != null &&
                  filterCategory != 'Todos' &&
                  item.grupoAnimal != filterCategory) return false;
              return true;
            })
            .map((entry) => _mapExistingToAnimalData(entry.value, entry.key))
            .toList();

        // Animais criados offline agora entram no ObjectBox (vêm em
        // existingAnimals via getAll), não há mais lista separada no FFAppState.
        final allAnimals = existingAnimals;
        _ordenar(allAnimals);

        if (allAnimals.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
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

  /// Mesma regra de ordenação do modo online, aplicada sobre `AnimalData`.
  void _ordenar(List<AnimalData> animais) {
    if (filterCategory == 'Novilhas') {
      animais.sort((a, b) {
        final dateA = _parseInseminacaoDate(a.dtUltimaInseminacao);
        final dateB = _parseInseminacaoDate(b.dtUltimaInseminacao);
        if (dateA == null && dateB == null) {
          return a.nomeBrincoConcat
              .toLowerCase()
              .compareTo(b.nomeBrincoConcat.toLowerCase());
        }
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        final c = dateA.compareTo(dateB);
        return ascending ? c : -c;
      });
    } else {
      animais.sort((a, b) {
        final c = a.nomeBrincoConcat
            .toLowerCase()
            .compareTo(b.nomeBrincoConcat.toLowerCase());
        return ascending ? c : -c;
      });
    }
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

  DateTime? _parseInseminacaoDate(String? rawDate) {
    if (rawDate == null) return null;
    final normalized = rawDate.trim();
    if (normalized.isEmpty || normalized == '0') return null;

    final parts = normalized.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
}
