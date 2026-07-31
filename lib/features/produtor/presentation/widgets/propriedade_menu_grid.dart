import 'package:flutter/material.dart';
import '/core/ui/menu_acao_card.dart';
import '/domain/animais/classificacao_animal.dart';
import '/features/animais/application/animal_struct_adapter.dart';

import '/data/backend.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/custom_functions.dart' as functions;
import '/features/animais/presentation/pages/lista_animais_page.dart';
import '/features/calendario_sanitario/presentation/pages/calendario_sanitario_page.dart';
import '/features/diagnostico_gestacao/presentation/pages/diagnosticogestacao_page.dart';
import '/features/exame_ginecologico/presentation/pages/exame_ginecologico_page.dart';
import '/features/financeiro/presentation/pages/relatorio_financeiro_page.dart';
import '/features/inseminacoes/presentation/pages/lista_inseminacoes_page.dart';
import '/features/prenhas/presentation/pages/animais_prenhas_page.dart';
import '/features/receituario/presentation/pages/receituarios_lista_page.dart';
import '/features/recria/presentation/pages/recriacao_page.dart';
import '/features/relatorios/presentation/pages/indices_zootecnicos_page.dart';
import '/features/relatorios/presentation/pages/listacompleta_page.dart';
import '/features/relatorios/presentation/pages/resumo_rebanho_page.dart';
import '/features/secas/presentation/pages/secas_page.dart';

import '../utils/navigation_params.dart';

/// Widget que renderiza o grid completo de menu com todos os itens.
///
/// Este widget encapsula toda a lógica de construção do GridView e seus itens,
/// tornando o widget principal muito mais limpo.
class PropriedadeMenuGrid extends StatelessWidget {
  const PropriedadeMenuGrid({
    super.key,
    required this.animaisRecordList,
    required this.navigationParams,
    required this.isOnline,
    required this.animationsMap,
  });

  final List<AnimaisProdutoresRecord> animaisRecordList;
  final PropriedadeNavigationParams navigationParams;
  final bool isOnline;
  final Map<String, AnimationInfo> animationsMap;

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.zero,
      gridDelegate: menuAcaoGridDelegate,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        // 1. Animais
        _buildAnimaisCard(context),

        // 2. Inseminações
        _buildInseminacoesCard(context),

        // 3. Diagnóstico Gestação
        _buildDiagnosticoCard(context),

        // 4. Vacas Prenhas
        _buildVacasPrenhasCard(context),

        // 5. Secas
        _buildSecasCard(context),

        // 6. Exame Ginecológico
        _buildExameGinecologicoCard(context),

        // 7. Recria
        _buildRecriaCard(context),

        // 8. Lista Completa
        _buildListaCompletaCard(context),

        // 9. Receituário (apenas online)
        if (isOnline) _buildReceituarioCard(context),

        // 10. Resumo Rebanho (apenas online)
        if (isOnline) _buildResumoRebanhoCard(context),

        // 11. Calendário Sanitário (apenas online)
        if (isOnline) _buildCalendarioSanitarioCard(context),

        // 12. Índices Zootécnicos
        _buildIndicesZootecnicosCard(context),

        // 13. Financeiro (apenas online)
        if (isOnline) _buildFinanceiroCard(context),
      ],
    );
  }

  Widget _buildAnimaisCard(BuildContext context) {
    return MenuAcaoCard(
      icone: Icons.format_list_numbered,
      rotulo: 'Animais',
      onTap: () => _navigateToAnimais(context),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!);
  }

  void _navigateToAnimais(BuildContext context) async {
    // Animais criados offline vão direto ao ObjectBox e sincronizam ao
    // reconectar — não há mais fila no FFAppState a forçar sync antes de abrir.
    context.pushNamed(
      ListaAnimaisPage.routeName,
      queryParameters: navigationParams.toQueryParameters(),
    );
  }

  Widget _buildInseminacoesCard(BuildContext context) {
    final onlineCount = animaisRecordList
        .where((e) =>
            ((ehVaca(e.grupoAnimal)) || (ehNovilha(e.grupoAnimal))) &&
            ((ehVazia(e.status)) ||
                (ehInseminada(e.status)) ||
                (ehInseminadaPP(e.status))))
        .toList()
        .length;

    return MenuAcaoCard(
      icone: Icons.vaccines,
      rotulo: 'Inseminações',
      contador: onlineCount,
      onTap: () {
        context.pushNamed(
          ListaInseminacoesPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!);
  }

  Widget _buildDiagnosticoCard(BuildContext context) {
    final count = animaisRecordList
        .where((e) => valueOrDefault<bool>(
              (e.dtUltimaInseminacao != '') &&
                  ((ehVaca(e.grupoAnimal)) || (ehNovilha(e.grupoAnimal))) &&
                  ((ehInseminada(e.status)) || (ehInseminadaPP(e.status))) &&
                  (functions.converterStringParaData(
                          e.dtUltimaInseminacao, navigationParams.diasDg!) <=
                      functions.obterDataAtual()),
              true,
            ))
        .toList()
        .length;

    return MenuAcaoCard(
      icone: Icons.medical_information_outlined,
      rotulo: 'Diagnóstico Gestação',
      contador: count,
      onTap: () {
        context.pushNamed(
          DiagnosticogestacaoPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation3']!);
  }

  Widget _buildVacasPrenhasCard(BuildContext context) {
    int getBadgeCount() {
      if (isOnline) {
        return animaisRecordList
            .where(
                (e) => (ehPrenha(e.status)) && (ehVacaOuNovilha(e.grupoAnimal)))
            .toList()
            .length;
      } else {
        final existentesCount = animaisProdutoresExistentesObjectBox()
            .where((e) =>
                (e.uidTecnicoPropriedade == navigationParams.uidPropriedade) &&
                (ehVacaOuNovilha(e.grupoAnimal)) &&
                (ehPrenha(e.status)))
            .toList()
            .length;

        return existentesCount;
      }
    }

    return MenuAcaoCard(
      icone: Icons.monitor_heart_outlined,
      rotulo: 'Prenhas',
      contador: getBadgeCount(),
      onTap: () {
        context.pushNamed(
          AnimaisPrenhasPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation4']!);
  }

  Widget _buildSecasCard(BuildContext context) {
    final count = animaisRecordList
        .where((e) =>
            ((ehVaca(e.grupoAnimal)) && (ehSeca(e.status))) ||
            (e.status == 'Pré Parto') ||
            (ehDescarte(e.status)) ||
            ((ehVazia(e.status)) && (e.dtInducaoLactacao != null)))
        .toList()
        .length;

    return MenuAcaoCard(
      icone: Icons.alarm_add_sharp,
      rotulo: 'Secas',
      contador: count,
      onTap: () {
        context.pushNamed(
          SecasPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation5']!);
  }

  Widget _buildExameGinecologicoCard(BuildContext context) {
    int getBadgeCount() {
      final onlineCount = animaisRecordList
          .where((e) =>
              (ehVazia(e.status)) &&
              ((ehNovilha(e.grupoAnimal)) || (ehVaca(e.grupoAnimal))) &&
              (e.dtInducaoLactacao == null))
          .toList()
          .length;

      return onlineCount;
    }

    return MenuAcaoCard(
      icone: Icons.medical_services,
      rotulo: 'Exame Ginecológico',
      contador: getBadgeCount(),
      onTap: () {
        context.pushNamed(
          ExameGinecologicoPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation6']!);
  }

  Widget _buildRecriaCard(BuildContext context) {
    int getBadgeCount() {
      final onlineCount = animaisRecordList
          .where((e) =>
              (((ehTouros(e.grupoAnimal)) && (e.liberaInseminacao == false)) ||
                  ((ehNovilha(e.grupoAnimal)) &&
                      (e.dtInducaoLactacao == null)) ||
                  (ehBezerras(e.grupoAnimal)) ||
                  (ehBezerros(e.grupoAnimal))) &&
              ((!ehDescarte(e.status)) && (e.status != 'Pré Parto')))
          .toList()
          .length;

      return onlineCount;
    }

    return MenuAcaoCard(
      icone: Icons.compare_arrows_sharp,
      rotulo: 'Recria',
      contador: getBadgeCount(),
      onTap: () {
        context.pushNamed(
          RecriacaoPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation7']!);
  }

  Widget _buildListaCompletaCard(BuildContext context) {
    final count = animaisRecordList
        .where((e) =>
            ((ehNovilha(e.grupoAnimal)) || (ehVaca(e.grupoAnimal))) &&
            (!ehDescarte(e.status)))
        .toList()
        .length;

    return MenuAcaoCard(
      icone: Icons.list_alt_sharp,
      rotulo: 'Lista completa',
      contador: count,
      onTap: () {
        context.pushNamed(
          ListacompletaPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation8']!);
  }

  Widget _buildReceituarioCard(BuildContext context) {
    return MenuAcaoCard(
      icone: Icons.summarize,
      rotulo: 'Receituário',
      onTap: () {
        context.pushNamed(
          ReceituariosListaPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation9']!);
  }

  Widget _buildResumoRebanhoCard(BuildContext context) {
    return MenuAcaoCard(
      icone: Icons.summarize_outlined,
      rotulo: 'Resumo Rebanho',
      onTap: () {
        context.pushNamed(
          ResumoRebanhoPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation10']!);
  }

  Widget _buildCalendarioSanitarioCard(BuildContext context) {
    return MenuAcaoCard(
      icone: Icons.calendar_today,
      rotulo: 'Calendário Sanitário',
      onTap: () {
        context.pushNamed(
          CalendarioSanitarioPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation11']!);
  }

  Widget _buildIndicesZootecnicosCard(BuildContext context) {
    return MenuAcaoCard(
      icone: Icons.folder_copy_outlined,
      rotulo: 'Índices Zootécnicos',
      onTap: () {
        context.pushNamed(
          IndicesZootecnicosPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation12']!);
  }

  Widget _buildFinanceiroCard(BuildContext context) {
    return MenuAcaoCard(
      icone: Icons.attach_money_sharp,
      rotulo: 'Financeiro',
      onTap: () {
        context.pushNamed(
          RelatorioFinanceiroPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation13']!);
  }
}
