import 'package:flutter/material.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import 'package:provider/provider.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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
  final bool isOnline;
  final bool ascending;

  const AnimalListWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    this.filterCategory,
    this.isOnline = true,
    this.ascending = true,
  });

  @override
  Widget build(BuildContext context) {
    return isOnline ? _buildOnlineList(context) : _buildOfflineList(context);
  }

  Widget _buildOnlineList(BuildContext context) {
    return StreamBuilder<List<AnimaisProdutoresRecord>>(
      stream: queryAnimaisProdutoresRecord(
        parent: uidTecnico,
        queryBuilder: (animaisProdutoresRecord) {
          var query = animaisProdutoresRecord.where(
            'uidTecnicoPropriedade',
            isEqualTo: uidPropriedade,
          );

          if (filterCategory != null && filterCategory != 'Todos') {
            query = query.where('grupoAnimal', isEqualTo: filterCategory);
          }

          return query;
        },
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingIndicator();
        }

        List<AnimaisProdutoresRecord> records = snapshot.data!.toList();

        // Ordenação para Novilhas
        if (filterCategory == 'Novilhas') {
          records.sort((a, b) =>
              _compareNovilhasByInseminacao(a, b, ascending: ascending));
        }

        if (records.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            final animal = AnimalData(
              grupoAnimal: record.grupoAnimal,
              nomeAnimal: record.nomeAnimal,
              brincoAnimal: record.brincoAnimal,
              nomeBrincoConcat: record.nomeBrincoConcat,
              status: record.status,
              dtNascimento: record.dtNascimento,
              dtUltimaInseminacao: record.dtUltimaInseminacao,
              dtUltimoPartoContingencia: record.dtUltimoPartoContingencia,
              dtUltimoParto: record.dtUltimoParto,
              dtPrePartoPrevista: record.dtPrePartoPrevista,
              dtPartoPrevisto: record.dtPartoPrevisto,
              dtUltimaAcao: record.dtUltimaAcao,
              dtInducaoLactacao: record.dtInducaoLactacao != null
                  ? DateFormat('dd/MM/yyyy').format(record.dtInducaoLactacao!)
                  : null,
              nomeTouroUltimaInseminacao: record.nomeTouroUltimaInseminacao,
              brincoAnimalOrder: record.brincoAnimalOrder,
              liberaInseminacao: record.liberaInseminacao,
              reference: record.reference,
            );

            return AnimalCardWidget(
              animal: animal,
              uidPropriedade: uidPropriedade,
              nomePropriedade: nomePropriedade,
              uidTecnico: uidTecnico,
              emailPropriedade: emailPropriedade,
              visitaPresencial: visitaPresencial,
              diasDg: diasDg,
              isOnline: true,
            );
          },
        );
      },
    );
  }

  Widget _buildOfflineList(BuildContext context) {
    return Builder(
      builder: (context) {
        final appState = context.watch<FFAppState>();

        // Processar animais existentes (offline)
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

        // Processar animais novos criados offline
        final newAnimals = appState.animaisProdutoresOffline
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
            .map((entry) => _mapNewToAnimalData(entry.value, entry.key))
            .toList();

        final allAnimals = [...existingAnimals, ...newAnimals];

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
              isOnline: false,
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
      itemIndex: index,
      uidAnimalOffline: item.uidAnimalOffline,
      uidTecnicoPropriedade: item.uidTecnicoPropriedade,
    );
  }

  AnimalData _mapNewToAnimalData(dynamic item, int index) {
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
      itemIndex: index,
      uidTecnicoPropriedade: item.uidTecnicoPropriedade,
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 50.0,
        height: 50.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF75E38)),
        ),
      ),
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

  int _compareNovilhasByInseminacao(
    AnimaisProdutoresRecord a,
    AnimaisProdutoresRecord b, {
    required bool ascending,
  }) {
    final dateA = _parseInseminacaoDate(a.dtUltimaInseminacao);
    final dateB = _parseInseminacaoDate(b.dtUltimaInseminacao);

    if (dateA == null && dateB == null) {
      return a.nomeBrincoConcat
          .toLowerCase()
          .compareTo(b.nomeBrincoConcat.toLowerCase());
    }
    if (dateA == null) return 1;
    if (dateB == null) return -1;

    final dateComparison = dateA.compareTo(dateB);
    return ascending ? dateComparison : -dateComparison;
  }
}
