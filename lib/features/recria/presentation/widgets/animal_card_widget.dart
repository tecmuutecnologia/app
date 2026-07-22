import 'package:flutter/material.dart';
import '/domain/animais/classificacao_animal.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/custom_functions.dart' as functions;
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';

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
    return _cartao(context);
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

  /// Cartão único, no mesmo padrão das telas de Inseminações, Diagnóstico de
  /// Gestação, Prenhas, Secas e Exame Ginecológico.
  ///
  /// Antes era um `FlipCard`: a frente trazia avatar/nome num GridView 3x1 de
  /// células fixas e as AÇÕES ficavam no VERSO, dentro de um `Container` de
  /// 100x100 fixos. Ou seja, para agir sobre o animal o usuário precisava
  /// descobrir sozinho que o cartão virava, e os botões ainda apareciam
  /// espremidos. Tudo passa a ficar visível de uma vez.
  Widget _cartao(BuildContext context) {
    final info = _infoTiles(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: AppTokens.softShadow(context),
          borderRadius: BorderRadius.circular(AppTokens.radius),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            // Toque no cartão abre o prontuário — mesmo gesto das demais telas.
            onTap: () => _navigateToProntuario(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _avatarGrupo(context),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 0.0, 0.0),
                        child: _cabecalho(context),
                      ),
                    ),
                  ],
                ),
                if (info.isNotEmpty) ...[
                  const SizedBox(height: 12.0),
                  _faixaInfo(context, info),
                ],
                const SizedBox(height: 12.0),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Nome + brinco, com o status como selo (antes vinha concatenado no texto,
  /// "Mimosa - 12 - Prenha", competindo com o nome).
  Widget _cabecalho(BuildContext context) {
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

    final dtUltimaAcao = animal.dtUltimaAcao;
    final feitaHoje = dtUltimaAcao != null &&
        dtUltimaAcao.isNotEmpty &&
        functions.verificaDataAcaoDataAtual(dtUltimaAcao) == true;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                baseName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (feitaHoje) _selo(context, 'Hoje', const Color(0xFF048508)),
          ],
        ),
        if (!isBezerra && animal.status.isNotEmpty) ...[
          const SizedBox(height: 4.0),
          Text(
            animal.status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ],
    );
  }

  /// Selo textual. Substitui os ícones soltos de 30px (um check verde sem
  /// rótulo) que não diziam a que se referiam.
  Widget _selo(BuildContext context, String texto, Color cor) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 3.0, 8.0, 3.0),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: cor, size: 13.0),
          const SizedBox(width: 4.0),
          Text(
            texto,
            style: FlutterFlowTheme.of(context).labelSmall.override(
                  font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                  color: cor,
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  /// Avatar circular do grupo (TOU/BZA/BZO/NOV), com o símbolo de sexo do
  /// bezerro sobreposto em vez de solto ao lado.
  Widget _avatarGrupo(BuildContext context) {
    Color groupColor;
    switch (animal.grupoAnimal) {
      case 'Vacas':
        groupColor = AppTokens.brand;
        break;
      case 'Novilhas':
        groupColor = AppTokens.secondary;
        break;
      default:
        groupColor = FlutterFlowTheme.of(context).secondaryText;
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

    return SizedBox(
      width: 44.0,
      height: 44.0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44.0,
            height: 44.0,
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
          if (ehBezerros(animal.grupoAnimal) || ehBezerras(animal.grupoAnimal))
            Positioned(
              right: -2.0,
              bottom: -2.0,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  ehBezerros(animal.grupoAnimal) ? Icons.male : Icons.female,
                  color: ehBezerros(animal.grupoAnimal)
                      ? FlutterFlowTheme.of(context).primary
                      : const Color(0xFFD901A6),
                  size: 14.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Datas relevantes conforme grupo/status, na faixa padrão das demais telas.
  List<Widget> _infoTiles(BuildContext context) {
    if (ehBezerros(animal.grupoAnimal) || ehBezerras(animal.grupoAnimal)) {
      return [
        _tileInfo(context, 'Nascimento', animal.dtNascimento ?? '',
            alinhaInicio: true),
      ];
    }
    if (ehNovilha(animal.grupoAnimal)) {
      switch (animal.status) {
        case 'Vazia':
          final del =
              animal.dtUltimoParto != null && animal.dtUltimoParto!.isNotEmpty
                  ? functions
                      .calcularDiferencaEmDias(animal.dtUltimoParto!)
                      .toString()
                  : '';
          return [
            _tileInfo(context, 'DEL', del),
            _tileInfo(context, 'Último parto',
                animal.dtUltimoPartoContingencia ?? ''),
          ];
        case 'Inseminada':
        case 'Inseminada PP':
          return [
            _tileInfo(context, 'Inseminada', animal.dtUltimaInseminacao ?? '',
                alinhaInicio: true),
          ];
        case 'Prenha':
        case 'Seca':
          return [
            _tileInfo(context, 'Inseminada', animal.dtUltimaInseminacao ?? ''),
            _tileInfo(
                context, 'Pré parto prev.', animal.dtPrePartoPrevista ?? ''),
            _tileInfo(context, 'Parto previsto', animal.dtPartoPrevisto ?? '',
                destaque: true),
          ];
      }
    }
    return const [];
  }

  /// Faixa agrupando os tiles de informação, separados por divisores.
  Widget _faixaInfo(BuildContext context, List<Widget> tiles) {
    final filhos = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      if (i > 0) {
        filhos.add(VerticalDivider(
          width: 17.0,
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).alternate,
        ));
      }
      filhos.add(Expanded(child: tiles[i]));
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: filhos,
        ),
      ),
    );
  }

  /// Rótulo pequeno + valor destacado; vazio vira '—'. `FittedBox` faz a data
  /// encolher em vez de perder o ano.
  /// [alinhaInicio] alinha à esquerda — usado quando o cartão tem um único
  /// tile, em que centralizar na largura toda fica solto. NÃO derive isso de
  /// `_infoTiles`: é `_infoTiles` que constrói os tiles, então consultá-la aqui
  /// cria recursão infinita (stack overflow ao renderizar o cartão).
  Widget _tileInfo(BuildContext context, String rotulo, String valor,
      {bool destaque = false, bool alinhaInicio = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alinhaInicio ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          rotulo,
          maxLines: 1,
          textAlign: alinhaInicio ? TextAlign.start : TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: FlutterFlowTheme.of(context).labelSmall.override(
                font: GoogleFonts.readexPro(),
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 11.0,
                letterSpacing: 0.0,
              ),
        ),
        const SizedBox(height: 3.0),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            valor.isEmpty ? '—' : valor,
            maxLines: 1,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                  color: destaque
                      ? AppTokens.brand
                      : FlutterFlowTheme.of(context).primaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
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

  Widget _buildActionButtons(BuildContext context) {
    if (ehTouros(animal.grupoAnimal)) {
      return _linhaBotoes([
        _buildButton(context, 'Ação', Icons.add_alert, ActionButtonColors.acao,
            () => _showExameGinecologico(context)),
      ]);
    }
    if (ehBezerros(animal.grupoAnimal) || ehBezerras(animal.grupoAnimal)) {
      return _linhaBotoes([
        _buildButton(context, 'Desmamar', Icons.pause,
            ActionButtonColors.desmamar, () => _showDesmame(context)),
        _buildButton(context, 'Ação', Icons.add_alert, ActionButtonColors.acao,
            () => _showExameGinecologico(context)),
      ]);
    }
    if (ehNovilha(animal.grupoAnimal)) {
      switch (animal.status) {
        case 'Vazia':
          return _linhaBotoes([
            _buildButton(context, 'Inseminar', Icons.playlist_add,
                ActionButtonColors.inseminar, () => _showInseminacao(context)),
            _buildButton(context, 'Ação', Icons.add_alert,
                ActionButtonColors.acao, () => _showExameGinecologico(context)),
          ]);
        case 'Inseminada':
        case 'Inseminada PP':
          return _linhaBotoes([
            _buildButton(context, 'DG +', Icons.check_circle,
                ActionButtonColors.dgMais, () => _showDgMais(context)),
            _buildButton(context, 'DG -', Icons.cancel_rounded,
                ActionButtonColors.dgMenos, () => _showDgMenos(context)),
            _buildButton(context, 'Ação', Icons.add_alert,
                ActionButtonColors.acao, () => _showExameGinecologico(context)),
          ]);
        case 'Prenha':
          return _linhaBotoes([
            _buildButton(context, 'Aborto', Icons.cancel_sharp,
                ActionButtonColors.aborto, () => _showAborto(context)),
            _buildButton(context, 'Parto', Icons.add_alert,
                ActionButtonColors.parto, () => _showParto(context)),
            _buildButton(context, 'Pré-parto', Icons.check,
                ActionButtonColors.preParto, () => _showPreParto(context)),
          ]);
        case 'Seca':
          return _linhaBotoes([
            _buildButton(context, 'Parto', Icons.add_alert,
                ActionButtonColors.parto, () => _showParto(context)),
            _buildButton(context, 'Pré-parto', Icons.check,
                ActionButtonColors.preParto, () => _showPreParto(context)),
            _buildButton(context, 'Aborto', Icons.cancel_sharp,
                ActionButtonColors.aborto, () => _showAborto(context)),
          ]);
      }
    }
    return _linhaBotoes([
      _buildButton(context, 'Ação', Icons.add_alert, ActionButtonColors.acao,
          () => _showExameGinecologico(context)),
    ]);
  }

  /// Botões dividindo a largura igualmente, com 8px de respiro.
  Widget _linhaBotoes(List<Widget> botoes) {
    final filhos = <Widget>[];
    for (var i = 0; i < botoes.length; i++) {
      if (i > 0) filhos.add(const SizedBox(width: 8.0));
      filhos.add(Expanded(child: botoes[i]));
    }
    return Row(children: filhos);
  }

  /// Estilo padrão dos botões (altura 40, texto branco 12, cantos
  /// `radiusSmall`) — antes tinham 25px de altura e largura fixa de 100px.
  Widget _buildButton(BuildContext context, String text, IconData icon,
      Color color, VoidCallback onPressed) {
    return FFButtonWidget(
      onPressed: onPressed,
      text: text,
      icon: Icon(icon, size: 15.0),
      options: FFButtonOptions(
        height: 40.0,
        padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
        iconPadding: EdgeInsets.zero,
        color: color,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
            font: GoogleFonts.readexPro(),
            color: Colors.white,
            fontSize: 12.0,
            letterSpacing: 0.0),
        elevation: 0.0,
        borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
        borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
      ),
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
