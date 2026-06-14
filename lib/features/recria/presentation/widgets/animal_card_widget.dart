import 'package:flutter/material.dart';
import '/domain/animais/classificacao_animal.dart';
import 'package:flip_card/flip_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/custom_functions.dart' as functions;
import '/index.dart';

// Imports para bottom sheets online
import '/features/diagnostico_gestacao/presentation/widgets/dg_mais_widget.dart';
import '/features/diagnostico_gestacao/presentation/widgets/dg_menos_widget.dart';
import '/features/exame_ginecologico/presentation/widgets/nova_acao_exame_ginecologico_widget.dart';
import '/features/inseminacoes/presentation/widgets/nova_inseminacao_widget.dart';
import '/features/prenhas/presentation/widgets/registro_aborto_widget.dart';
import 'desmame_widget.dart';
import '/features/secas/presentation/widgets/registrar_parto_widget.dart';
import '/features/secas/presentation/widgets/registrar_pre_parto_widget.dart';

// Imports para bottom sheets offline (novos)

/// Cores constantes para botões de ação
class ActionButtonColors {
  static const Color inseminar = Color(0xFF7E39EF);
  static const Color dgMais = Color(0xFF048508);
  static const Color dgMenos = Color(0xFFAE0303);
  static const Color acao = Color(0xFF1A03E9);
  static const Color parto = Color(0xFF048508);
  static const Color preParto = Color(0xFF1A03E9);
  static const Color aborto = Color(0xFFAE0303);
  static const Color desmamar = Color(0xFF048508);
}

/// Modelo de dados unificado para animal (online ou offline)
class AnimalData {
  final String grupoAnimal;
  final String nomeAnimal;
  final int? brincoAnimal;
  final String nomeBrincoConcat;
  final String status;
  final String? dtNascimento;
  final String? dtUltimaInseminacao;
  final String? dtUltimoPartoContingencia;
  final String? dtUltimoParto;
  final String? dtPrePartoPrevista;
  final String? dtPartoPrevisto;
  final String? dtUltimaAcao;
  final String? dtInducaoLactacao;
  final String? nomeTouroUltimaInseminacao;
  final int? brincoAnimalOrder;
  final bool liberaInseminacao;
  final DocumentReference? reference;
  final int? itemIndex;
  final String? uidAnimalOffline;
  final DocumentReference? uidTecnicoPropriedade;

  const AnimalData({
    required this.grupoAnimal,
    required this.nomeAnimal,
    this.brincoAnimal,
    required this.nomeBrincoConcat,
    required this.status,
    this.dtNascimento,
    this.dtUltimaInseminacao,
    this.dtUltimoPartoContingencia,
    this.dtUltimoParto,
    this.dtPrePartoPrevista,
    this.dtPartoPrevisto,
    this.dtUltimaAcao,
    this.dtInducaoLactacao,
    this.nomeTouroUltimaInseminacao,
    this.brincoAnimalOrder,
    this.liberaInseminacao = false,
    this.reference,
    this.itemIndex,
    this.uidAnimalOffline,
    this.uidTecnicoPropriedade,
  });

  bool get isOnline => reference != null;
  bool get isExistingOffline =>
      uidAnimalOffline != null && uidAnimalOffline!.isNotEmpty;
}

/// Widget de Card do Animal - versão unificada
class AnimalCardWidget extends StatelessWidget {
  final AnimalData animal;
  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final bool isOnline;

  const AnimalCardWidget({
    super.key,
    required this.animal,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowAnimal()) return const SizedBox.shrink();

    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.VERTICAL,
      speed: 100,
      front: _buildFrontCard(context),
      back: _buildBackCard(context),
    );
  }

  bool _shouldShowAnimal() {
    final isValidGroup = (ehTouros(animal.grupoAnimal) &&
            !animal.liberaInseminacao) ||
        (ehNovilha(animal.grupoAnimal) && animal.dtInducaoLactacao == null) ||
        ehBezerras(animal.grupoAnimal) ||
        ehBezerros(animal.grupoAnimal);

    final isValidStatus =
        !ehDescarte(animal.status) && animal.status != 'Pré Parto';
    return isValidGroup && isValidStatus;
  }

  Widget _buildFrontCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: GridView(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 2.0,
                ),
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  _buildAnimalBadge(context),
                  _buildAnimalName(context),
                  _buildActionIcons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalBadge(BuildContext context) {
    Color groupColor;
    switch (animal.grupoAnimal) {
      case 'Vacas':
        groupColor = const Color(0xFF048508);
        break;
      case 'Novilhas':
        groupColor = const Color(0xFFFF0076);
        break;
      default:
        groupColor = FlutterFlowTheme.of(context).tertiary;
    }

    String abbreviation;
    switch (animal.grupoAnimal) {
      case 'Touros':
        abbreviation = 'TOU';
        break;
      case 'Bezerras':
        abbreviation = 'BZA';
        break;
      case 'Bezerros':
        abbreviation = 'BZO';
        break;
      case 'Novilhas':
        abbreviation = 'NOV';
        break;
      default:
        abbreviation = 'N/C';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration:
                  BoxDecoration(color: groupColor, shape: BoxShape.circle),
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Text(
                abbreviation,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.readexPro(),
                      color: Colors.white,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            if (ehBezerros(animal.grupoAnimal))
              Icon(Icons.male,
                  color: FlutterFlowTheme.of(context).primary, size: 24.0),
            if (ehBezerras(animal.grupoAnimal))
              const Icon(Icons.female, color: Color(0xFFD901A6), size: 24.0),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimalName(BuildContext context) {
    final isBezerra =
        ehBezerras(animal.grupoAnimal) || ehBezerros(animal.grupoAnimal);

    String baseName;
    if (animal.nomeAnimal.isNotEmpty &&
        animal.brincoAnimal != null &&
        animal.brincoAnimal != -1) {
      baseName = '${animal.nomeAnimal} - ${animal.brincoAnimal}';
    } else if (animal.nomeAnimal.isNotEmpty) {
      baseName = animal.nomeAnimal;
    } else {
      baseName = animal.brincoAnimal?.toString() ?? '';
    }

    final displayName = isBezerra ? baseName : '$baseName - ${animal.status}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                font: GoogleFonts.readexPro(),
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }

  Widget _buildActionIcons(BuildContext context) {
    final dtUltimaAcao = animal.dtUltimaAcao;
    final showCheck = dtUltimaAcao != null &&
        dtUltimaAcao.isNotEmpty &&
        functions.verificaDataAcaoDataAtual(dtUltimaAcao) == true;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
              child: Icon(Icons.add_circle_sharp,
                  color: FlutterFlowTheme.of(context).tertiary, size: 30.0),
            ),
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => _navigateToProntuario(context),
                  child: FaIcon(FontAwesomeIcons.squarePollHorizontal,
                      color: FlutterFlowTheme.of(context).tertiary, size: 30.0),
                ),
              ),
            ),
            if (showCheck)
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                child: Icon(Icons.check_circle,
                    color: Color(0xFF048508), size: 30.0),
              ),
          ],
        ),
      ],
    );
  }

  void _navigateToProntuario(BuildContext context) {
    if (isOnline && animal.reference != null) {
      context.pushNamed(
        ProntuarioAnimalPage.routeName,
        queryParameters: {
          'uidPropriedade':
              serializeParam(uidPropriedade, ParamType.DocumentReference),
          'nomePropriedade': serializeParam(nomePropriedade, ParamType.String),
          'uidTecnico': serializeParam(uidTecnico, ParamType.DocumentReference),
          'emailPropriedade':
              serializeParam(emailPropriedade, ParamType.String),
          'uidAnimaisProdutores':
              serializeParam(animal.reference, ParamType.DocumentReference),
          'grupoPredominante':
              serializeParam(animal.grupoAnimal, ParamType.String),
          'visitaPresencial': serializeParam(visitaPresencial, ParamType.bool),
          'diasDg': serializeParam(diasDg, ParamType.String),
        }.withoutNulls,
      );
    }
  }

  Widget _buildBackCard(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: _buildActionButtons(context),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (ehTouros(animal.grupoAnimal)) {
      return _buildTouroButtons(context);
    } else if (ehBezerras(animal.grupoAnimal) ||
        ehBezerros(animal.grupoAnimal)) {
      return _buildBezerroButtons(context);
    } else if (ehNovilha(animal.grupoAnimal)) {
      return _buildNovilhaButtons(context);
    }
    return _buildDefaultButtons(context);
  }

  Widget _buildTouroButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'Ação', Icons.add_alert,
                ActionButtonColors.acao, () => _showExameGinecologico(context)),
            if (ehInseminada(animal.status) || ehInseminadaPP(animal.status))
              _buildStatusCheck(context),
          ],
        ),
      ],
    );
  }

  Widget _buildBezerroButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
          child: Text(
            'Data nascimento: ${animal.dtNascimento ?? 'N/D'}',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(),
                fontSize: 12.0,
                letterSpacing: 0.0),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(context, 'Desmamar', Icons.pause,
                  ActionButtonColors.desmamar, () => _showDesmame(context)),
              const SizedBox(width: 10),
              _buildButton(
                  context,
                  'Ação',
                  Icons.add_alert,
                  ActionButtonColors.acao,
                  () => _showExameGinecologico(context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNovilhaButtons(BuildContext context) {
    switch (animal.status) {
      case 'Vazia':
        return _buildVaziaButtons(context);
      case 'Inseminada':
      case 'Inseminada PP':
        return _buildInseminadaButtons(context);
      case 'Prenha':
        return _buildPrenhaButtons(context);
      case 'Seca':
        return _buildSecaButtons(context);
      default:
        return _buildDefaultButtons(context);
    }
  }

  Widget _buildVaziaButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInfoRow(context),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'Inseminar', Icons.playlist_add,
                ActionButtonColors.inseminar, () => _showInseminacao(context)),
            const SizedBox(width: 10),
            _buildButton(context, 'Ação', Icons.add_alert,
                ActionButtonColors.acao, () => _showExameGinecologico(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildInseminadaButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInseminacaoInfo(context),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'DG +', Icons.check_circle,
                ActionButtonColors.dgMais, () => _showDgMais(context),
                width: 80),
            const SizedBox(width: 10),
            _buildButton(context, 'DG -', Icons.cancel_rounded,
                ActionButtonColors.dgMenos, () => _showDgMenos(context),
                width: 80),
            const SizedBox(width: 10),
            _buildButton(context, 'Ação', Icons.add_alert,
                ActionButtonColors.acao, () => _showExameGinecologico(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildPrenhaButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPrevisaoInfo(context),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'Aborto', Icons.cancel_sharp,
                ActionButtonColors.aborto, () => _showAborto(context)),
            const SizedBox(width: 10),
            _buildButton(context, 'Parto', Icons.add_alert,
                ActionButtonColors.parto, () => _showParto(context)),
            const SizedBox(width: 10),
            _buildButton(context, 'Pré-parto', Icons.check,
                ActionButtonColors.preParto, () => _showPreParto(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildSecaButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPrevisaoInfo(context),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'Parto', Icons.add_alert,
                ActionButtonColors.parto, () => _showParto(context)),
            const SizedBox(width: 10),
            _buildButton(context, 'Pré-parto', Icons.check,
                ActionButtonColors.preParto, () => _showPreParto(context)),
            const SizedBox(width: 10),
            _buildButton(context, 'Aborto', Icons.cancel_sharp,
                ActionButtonColors.aborto, () => _showAborto(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'Ação', Icons.add_alert,
                ActionButtonColors.acao, () => _showExameGinecologico(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    final del = animal.dtUltimoParto != null && animal.dtUltimoParto!.isNotEmpty
        ? functions.calcularDiferencaEmDias(animal.dtUltimoParto!).toString()
        : 'N/D';

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('DEL: $del',
              style: FlutterFlowTheme.of(context)
                  .bodyMedium
                  .override(font: GoogleFonts.readexPro(), fontSize: 12.0)),
          Text('Último parto: ${animal.dtUltimoPartoContingencia ?? 'N/D'}',
              style: FlutterFlowTheme.of(context)
                  .bodyMedium
                  .override(font: GoogleFonts.readexPro(), fontSize: 12.0)),
        ],
      ),
    );
  }

  Widget _buildInseminacaoInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
      child: Text('Inseminada em: ${animal.dtUltimaInseminacao ?? 'N/D'}',
          style: FlutterFlowTheme.of(context)
              .bodyMedium
              .override(font: GoogleFonts.readexPro(), fontSize: 12.0)),
    );
  }

  Widget _buildPrevisaoInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Inseminada em: ${animal.dtUltimaInseminacao ?? 'N/D'}',
            style: FlutterFlowTheme.of(context)
                .bodyMedium
                .override(font: GoogleFonts.readexPro(), fontSize: 12.0)),
        Text('Pré parto prev.: ${animal.dtPrePartoPrevista ?? 'N/D'}',
            style: FlutterFlowTheme.of(context)
                .bodyMedium
                .override(font: GoogleFonts.readexPro(), fontSize: 12.0)),
        Text('Parto previsto: ${animal.dtPartoPrevisto ?? 'N/D'}',
            style: FlutterFlowTheme.of(context)
                .bodyMedium
                .override(font: GoogleFonts.readexPro(), fontSize: 12.0)),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon,
      Color color, VoidCallback onPressed,
      {double width = 100}) {
    return FFButtonWidget(
      onPressed: onPressed,
      text: text,
      icon: Icon(icon, size: 15.0),
      options: FFButtonOptions(
        width: width,
        height: 25.0,
        padding: EdgeInsets.zero,
        iconPadding: EdgeInsets.zero,
        color: color,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
            font: GoogleFonts.readexPro(),
            color: Colors.white,
            fontSize: 12.0,
            letterSpacing: 0.0),
        elevation: 3.0,
        borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildStatusCheck(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
      child: Icon(Icons.check_sharp,
          color: FlutterFlowTheme.of(context).success, size: 24.0),
    );
  }

  // ===== Métodos de ação =====

  void _showExameGinecologico(BuildContext context) {
    _showSheet(context, _getExameGinecologicoWidget());
  }

  void _showDesmame(BuildContext context) {
    _showSheet(context, _getDesmameWidget());
  }

  void _showInseminacao(BuildContext context) {
    _showSheet(context, _getInseminacaoWidget());
  }

  void _showDgMais(BuildContext context) {
    _showSheet(context, _getDgMaisWidget());
  }

  void _showDgMenos(BuildContext context) {
    _showSheet(context, _getDgMenosWidget());
  }

  void _showParto(BuildContext context) {
    _showSheet(context, _getPartoWidget());
  }

  void _showPreParto(BuildContext context) {
    _showSheet(context, _getPrePartoWidget());
  }

  void _showAborto(BuildContext context) {
    _showSheet(context, _getAbortoWidget());
  }

  void _showSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (ctx) => GestureDetector(
        onTap: () {
          FocusScope.of(ctx).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(padding: MediaQuery.viewInsetsOf(ctx), child: child),
      ),
    );
  }

  Widget _getExameGinecologicoWidget() {
    return NovaAcaoExameGinecologicoWidget(
      uidPropriedade: uidPropriedade!,
      nomePropriedade: nomePropriedade!,
      uidTecnico: uidTecnico!,
      emailPropriedade: emailPropriedade!,
      visitaPresencial: visitaPresencial!,
      diasDg: diasDg!,
      uidAnimaisProdutores: animal.reference,
      nomeAnimal: animal.nomeAnimal,
      brincoAnimal: animal.brincoAnimal?.toString() ?? '',
      grupoAnimal: animal.grupoAnimal,
    );
  }

  Widget _getDesmameWidget() {
    // O modo "online" agora é offline-first (grava no ObjectBox e enfileira o
    // sync), então cobre tanto o caso online quanto o de animal existente
    // offline. Só o animal criado offline (sem ref Firestore) usa offlineNew.
    final DesmameMode mode = (isOnline || animal.isExistingOffline)
        ? DesmameMode.online
        : DesmameMode.offlineNew;

    return DesmameWidget(
      mode: mode,
      uidPropriedade: uidPropriedade!,
      nomePropriedade: nomePropriedade!,
      uidTecnico: uidTecnico!,
      emailPropriedade: emailPropriedade!,
      visitaPresencial: visitaPresencial!,
      diasDg: diasDg!,
      nomeAnimal: animal.nomeAnimal,
      brincoAnimal: animal.brincoAnimal?.toString() ?? '',
      grupoAnimal: animal.grupoAnimal,
      // Parâmetros condicionais
      uidAnimaisProdutores:
          isOnline || animal.isExistingOffline ? animal.reference : null,
      uidAnimalOffline: !isOnline && !animal.isExistingOffline
          ? animal.uidAnimalOffline
          : null,
      itemUidIndex: !isOnline ? animal.itemIndex : null,
    );
  }

  Widget _getInseminacaoWidget() {
    return NovaInseminacaoWidget(
      uidPropriedade: uidPropriedade!,
      nomePropriedade: nomePropriedade!,
      uidTecnico: uidTecnico!,
      emailPropriedade: emailPropriedade!,
      uidAnimaisProdutores: animal.reference,
      grupoPredominante: animal.grupoAnimal,
      nomeAnimal: animal.nomeAnimal,
      visitaPresencial: visitaPresencial!,
      dtUltimaInseminacao: animal.dtUltimaInseminacao ?? '',
      brincoAnimal: animal.brincoAnimal?.toString() ?? '',
      diasDg: diasDg!,
    );
  }

  Widget _getDgMaisWidget() {
    return DgMaisWidget(
      uidPropriedade: uidPropriedade!,
      nomePropriedade: nomePropriedade!,
      uidTecnico: uidTecnico!,
      emailPropriedade: emailPropriedade!,
      visitaPresencial: visitaPresencial!,
      diasDg: diasDg!,
      uidAnimaisProdutores: animal.reference,
      grupoPredominante: animal.grupoAnimal,
      nomeAnimal: animal.nomeAnimal,
    );
  }

  Widget _getDgMenosWidget() {
    return DgMenosWidget(
      uidPropriedade: uidPropriedade!,
      nomePropriedade: nomePropriedade!,
      uidTecnico: uidTecnico!,
      emailPropriedade: emailPropriedade!,
      visitaPresencial: visitaPresencial!,
      uidAnimaisProdutores: animal.reference,
      grupoPredominante: animal.grupoAnimal,
      nomeAnimal: animal.nomeAnimal,
    );
  }

  Widget _getPartoWidget() {
    return RegistrarPartoWidget(
      uidPropriedade: uidPropriedade!,
      nomePropriedade: nomePropriedade!,
      uidTecnico: uidTecnico!,
      emailPropriedade: emailPropriedade!,
      visitaPresencial: visitaPresencial!,
      diasDg: diasDg!,
      uidAnimaisProdutores: animal.reference,
      nomeVacaAtual: animal.nomeAnimal,
      nomeTourtoUltimaInseminacao: animal.nomeTouroUltimaInseminacao ?? '',
      brincoVacaAtual: animal.brincoAnimal?.toString() ?? '',
    );
  }

  Widget _getPrePartoWidget() {
    final dtPreParto = animal.dtPrePartoPrevista;
    final convertedDate = dtPreParto != null && dtPreParto.isNotEmpty
        ? functions.converteDataStringDate(dtPreParto)
        : null;

    return RegistrarPrePartoWidget(
      uidPropriedade: uidPropriedade!,
      nomePropriedade: nomePropriedade!,
      uidTecnico: uidTecnico!,
      emailPropriedade: emailPropriedade!,
      visitaPresencial: visitaPresencial!,
      diasDg: diasDg!,
      uidAnimaisProdutores: animal.reference,
      nomeAnimal: animal.nomeAnimal,
      brincoAnimal: animal.brincoAnimalOrder?.toString() ?? '',
      grupoAnimal: animal.grupoAnimal,
      dtPrePartoPrevista: convertedDate,
    );
  }

  Widget _getAbortoWidget() {
    return RegistroAbortoWidget(
      uidPropriedade: uidPropriedade!,
      nomePropriedade: nomePropriedade!,
      uidTecnico: uidTecnico!,
      emailPropriedade: emailPropriedade!,
      visitaPresencial: visitaPresencial!,
      diasDg: diasDg!,
      uidAnimaisProdutores: animal.reference,
      nomeAnimal: animal.nomeAnimal,
    );
  }
}
