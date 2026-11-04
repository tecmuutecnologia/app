import '/core/ui/cabecalho_tela.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/features/prontuario/presentation/widgets/ficha_clinica.dart';
import 'package:flutter/material.dart';

/// Todas as ações sanitárias de um tipo (Vacina, Exame ou Doença) de um
/// animal. É o "Ver mais" dessas seções do prontuário, que antes abria a
/// página de Cios por falta de uma tela própria.
class PronSanitarioPage extends StatelessWidget {
  const PronSanitarioPage({
    super.key,
    required this.uidPropriedade,
    required this.uidAnimaisProdutores,
    required this.tipoAcao,
  });

  final DocumentReference? uidPropriedade;
  final DocumentReference? uidAnimaisProdutores;

  /// Valor gravado em `tipoAcao`: 'Vacina', 'Exame' ou 'Doença'.
  final String? tipoAcao;

  static String routeName = 'pronSanitario';
  static String routePath = '/pronSanitario';

  String get _titulo => switch (tipoAcao) {
        'Vacina' => 'Vacinas',
        'Exame' => 'Exames',
        'Doença' => 'Doenças',
        _ => 'Ações sanitárias',
      };

  IdentidadeSecao get _identidade => switch (tipoAcao) {
        'Exame' => IdentidadeSecao.exames,
        'Doença' => IdentidadeSecao.doencas,
        _ => IdentidadeSecao.vacinas,
      };

  @override
  Widget build(BuildContext context) {
    final caminhoAnimal = uidAnimaisProdutores?.path;
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: CabecalhoTela(titulo: _titulo),
      body: SafeArea(
        top: false,
        child: StreamBuilder<List<AcaoSanitarioEntity>>(
          stream: AcaoSanitarioRepository()
              .watchByParentPath(uidPropriedade?.path ?? ''),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final itens = snapshot.data!
                .where((e) =>
                    !e.isDeleted &&
                    e.tipoAcao == tipoAcao &&
                    caminhoAnimal != null &&
                    e.uidAnimalAnimaisProdutoresPath == caminhoAnimal)
                .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              children: [
                AppCard(
                  child: itens.isEmpty
                      ? const SecaoVazia()
                      : Column(
                          children: [
                            for (final item in itens)
                              LinhaProntuario(
                                identidade: _identidade,
                                data: item.dtAcaoFormatada ?? '',
                                titulo: item.acao ?? '',
                                detalhe: (item.obsVisita?.isEmpty ?? true)
                                    ? null
                                    : item.obsVisita,
                              ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
