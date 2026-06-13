import 'package:flutter/material.dart';
import '/domain/animais/classificacao_animal.dart';
import '/features/animais/application/animal_struct_adapter.dart';

import '/data/backend.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/custom_functions.dart' as functions;
import '/index.dart';

import 'menu_item_card.dart';
import 'menu_item_card_with_badge.dart';
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
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
    return MenuItemCard(
      icon: Icons.format_list_numbered,
      label: 'Animais',
      onTap: () => _navigateToAnimais(context),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!);
  }

  void _navigateToAnimais(BuildContext context) async {
    final appState = FFAppState();

    if (isOnline) {
      // Verifica se precisa sincronizar
      if (appState.animaisProdutoresOffline.isEmpty && true && true) {
        context.pushNamed(
          ListaAnimaisWidget.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: const Text('Sincronize os dados primeiro!'),
              content: const Text('Sincronize offline com o online.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    } else {
      context.pushNamed(
        ListaAnimaisWidget.routeName,
        queryParameters: navigationParams.toQueryParameters(),
      );
    }
  }

  Widget _buildInseminacoesCard(BuildContext context) {
    final appState = FFAppState();
    final onlineCount = animaisRecordList
        .where((e) =>
            ((ehVaca(e.grupoAnimal)) || (ehNovilha(e.grupoAnimal))) &&
            ((ehVazia(e.status)) ||
                (ehInseminada(e.status)) ||
                (ehInseminadaPP(e.status))))
        .toList()
        .length;

    final offlineCount = appState.animaisProdutoresOffline
        .where((e) =>
            (e.uidTecnicoPropriedade == navigationParams.uidPropriedade) &&
            ((ehVaca(e.grupoAnimal)) || (ehNovilha(e.grupoAnimal))) &&
            ((ehVazia(e.status)) ||
                (ehInseminada(e.status)) ||
                (ehInseminadaPP(e.status))))
        .toList()
        .length;

    final badgeCount = isOnline
        ? onlineCount.toString()
        : (onlineCount + offlineCount).toString();

    return MenuItemCardWithBadge(
      icon: Icons.vaccines,
      label: 'Inseminações',
      iconSize: 22.0,
      badgeCount: badgeCount,
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
        .length
        .toString();

    return MenuItemCardWithBadge(
      icon: Icons.medical_information_outlined,
      label: 'Diagnóstico\nGestação',
      badgeCount: count,
      onTap: () {
        context.pushNamed(
          DiagnosticogestacaoPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation3']!);
  }

  Widget _buildVacasPrenhasCard(BuildContext context) {
    final appState = FFAppState();

    String getBadgeCount() {
      if (isOnline) {
        return animaisRecordList
            .where((e) => (ehPrenha(e.status)) && (ehVaca(e.grupoAnimal)))
            .toList()
            .length
            .toString();
      } else {
        final existentesCount = animaisProdutoresExistentesObjectBox()
            .where((e) =>
                (e.uidTecnicoPropriedade == navigationParams.uidPropriedade) &&
                (ehVaca(e.grupoAnimal)) &&
                (ehPrenha(e.status)))
            .toList()
            .length;

        final offlineCount = appState.animaisProdutoresOffline
            .where((e) =>
                (e.uidTecnicoPropriedade == navigationParams.uidPropriedade) &&
                (ehVaca(e.grupoAnimal)) &&
                (ehPrenha(e.status)))
            .toList()
            .length;

        return (existentesCount + offlineCount).toString();
      }
    }

    return MenuItemCardWithBadge(
      icon: Icons.monitor_heart_outlined,
      label: 'Vacas Prenhas',
      badgeCount: getBadgeCount(),
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
        .length
        .toString();

    return MenuItemCardWithBadge(
      icon: Icons.alarm_add_sharp,
      label: 'Secas',
      badgeCount: count,
      onTap: () {
        context.pushNamed(
          SecasWidget.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation5']!);
  }

  Widget _buildExameGinecologicoCard(BuildContext context) {
    final appState = FFAppState();

    String getBadgeCount() {
      final onlineCount = animaisRecordList
          .where((e) =>
              (ehVazia(e.status)) &&
              ((ehNovilha(e.grupoAnimal)) || (ehVaca(e.grupoAnimal))) &&
              (e.dtInducaoLactacao == null))
          .toList()
          .length;

      if (isOnline) {
        return onlineCount.toString();
      } else {
        final offlineCount = appState.animaisProdutoresOffline
            .where((e) =>
                (e.uidTecnicoPropriedade == navigationParams.uidPropriedade) &&
                ((ehVaca(e.grupoAnimal)) || (ehNovilha(e.grupoAnimal))) &&
                (ehVazia(e.status)) &&
                (e.dtInducaoLactacao == null))
            .toList()
            .length;

        return (onlineCount + offlineCount).toString();
      }
    }

    return MenuItemCardWithBadge(
      icon: Icons.medical_services,
      label: 'Exame\nGinecológico',
      badgeCount: getBadgeCount(),
      onTap: () {
        context.pushNamed(
          ExameGinecologicoPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation6']!);
  }

  Widget _buildRecriaCard(BuildContext context) {
    final appState = FFAppState();

    String getBadgeCount() {
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

      if (isOnline) {
        return onlineCount.toString();
      } else {
        final offlineCount = appState.animaisProdutoresOffline
            .where((e) =>
                (e.uidTecnicoPropriedade == navigationParams.uidPropriedade) &&
                (((ehTouros(e.grupoAnimal)) &&
                        (e.liberaInseminacao == false)) ||
                    ((ehNovilha(e.grupoAnimal)) &&
                        (e.dtInducaoLactacao == null)) ||
                    (ehBezerras(e.grupoAnimal)) ||
                    (ehBezerros(e.grupoAnimal))) &&
                ((!ehDescarte(e.status)) && (e.status != 'Pré Parto')))
            .toList()
            .length;

        return (onlineCount + offlineCount).toString();
      }
    }

    return MenuItemCardWithBadge(
      icon: Icons.compare_arrows_sharp,
      label: 'Recria',
      badgeCount: getBadgeCount(),
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
        .length
        .toString();

    return MenuItemCardWithBadge(
      icon: Icons.list_alt_sharp,
      label: 'Lista completa',
      badgeCount: count,
      onTap: () {
        context.pushNamed(
          ListacompletaWidget.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation8']!);
  }

  Widget _buildReceituarioCard(BuildContext context) {
    return MenuItemCard(
      icon: Icons.summarize,
      label: 'Receituário',
      iconSize: 30.0,
      onTap: () {
        context.pushNamed(
          ReceituariosListaPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation9']!);
  }

  Widget _buildResumoRebanhoCard(BuildContext context) {
    return MenuItemCard(
      icon: Icons.summarize_outlined,
      label: 'Resumo Rebanho',
      iconSize: 30.0,
      onTap: () {
        context.pushNamed(
          ResumoRebanhoWidget.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation10']!);
  }

  Widget _buildCalendarioSanitarioCard(BuildContext context) {
    return MenuItemCard(
      icon: Icons.calendar_today,
      label: 'Calendário Sanitário',
      iconSize: 28.0,
      onTap: () {
        context.pushNamed(
          CalendarioSanitarioPage.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation11']!);
  }

  Widget _buildIndicesZootecnicosCard(BuildContext context) {
    return MenuItemCard(
      icon: Icons.folder_copy_outlined,
      label: 'Indíces Zootécnicos',
      iconSize: 30.0,
      onTap: () {
        context.pushNamed(
          IndicesZootecnicosWidget.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation12']!);
  }

  Widget _buildFinanceiroCard(BuildContext context) {
    return MenuItemCard(
      icon: Icons.attach_money_sharp,
      label: 'Financeiro',
      iconSize: 30.0,
      onTap: () {
        context.pushNamed(
          RelatorioFinanceiroWidget.routeName,
          queryParameters: navigationParams.toQueryParameters(),
        );
      },
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation13']!);
  }
}
