import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/card_animal_lista.dart';
import '/core/ui/confirmar_acao.dart';
import '/core/ui/custom_functions.dart' as functions;
import '/core/ui/flutter_flow_drop_down.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import '/core/ui/painel_lista.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/domain/animais/classificacao_animal.dart';
import '/domain/animais/data_ultima_acao.dart';
import '/features/animais/application/touro_inseminacao.dart';
import '/features/inseminacoes/application/inseminacao_lote.dart';

/// Modal de inseminação, para um animal ou para vários de uma vez (seleção na
/// tela de Inseminações). Cada animal recebe exatamente a mesma gravação.
///
/// Com um animal só aparece também o campo Observações; no lote não, porque a
/// observação é de um animal específico.
class NovaInseminacaoWidget extends StatefulWidget {
  /// Um animal (botão "Inseminar" do card).
  NovaInseminacaoWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required DocumentReference? uidAnimaisProdutores,
    required String? grupoPredominante,
    required String? nomeAnimal,
    required this.visitaPresencial,
    required String? dtUltimaInseminacao,
    required String? brincoAnimal,
    required this.diasDg,
    String? uidAnimalOffline,
  }) : alvos = [
          AlvoInseminacao(
            nome: tituloNomeBrinco(
                nomeAnimal ?? '', int.tryParse(brincoAnimal ?? '')),
            referencia: uidAnimaisProdutores,
            uidAnimalOffline: uidAnimalOffline,
            dtUltimaInseminacao: dtUltimaInseminacao ?? '',
          ),
        ];

  /// Vários animais (seleção em lote).
  const NovaInseminacaoWidget.lote({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    required this.alvos,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final List<AlvoInseminacao> alvos;

  @override
  State<NovaInseminacaoWidget> createState() => _NovaInseminacaoWidgetState();
}

class _NovaInseminacaoWidgetState extends State<NovaInseminacaoWidget> {
  String? _touro;
  final _touroController = FormFieldController<String>(null);
  final _obsController = TextEditingController();
  DateTime _data = DateTime.now();
  bool _gravando = false;

  bool get _umAnimal => widget.alvos.length == 1;
  String get _dataTexto => dateTimeFormat('dd/MM/yyyy', _data);

  @override
  void dispose() {
    _obsController.dispose();
    super.dispose();
  }

  /// Touros e sêmens da propriedade liberados para inseminação.
  List<String> _opcoesTouro() => widget.uidPropriedade == null
      ? const []
      : opcoesTouroInseminacao(AnimalRepository()
          .getAnimaisByPropriedade(widget.uidPropriedade!.path)
          .where((a) => ehTouroOuSemem(a.grupoAnimal)));

  Future<void> _escolherData() async {
    var escolhida = _data;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height / 3,
        color: FlutterFlowTheme.of(context).secondaryBackground,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          minimumDate: DateTime(1900),
          initialDateTime: _data,
          maximumDate: DateTime.now(),
          onDateTimeChanged: (d) => escolhida = d,
        ),
      ),
    );
    safeSetState(() => _data = escolhida);
  }

  Future<void> _registrar() async {
    if ((_touro ?? '').isEmpty) {
      await _aviso(
          'Selecione um touro', 'Escolha um touro ou sêmen cadastrado.');
      return;
    }
    final mais = comInseminacaoMaisRecente(widget.alvos, _dataTexto);
    if (mais.isNotEmpty) {
      final nomes = mais.map((a) => '${a.nome} (${a.dtUltimaInseminacao})');
      final ok = await confirmarAcao(
        context,
        titulo: 'Data mais antiga que a atual',
        mensagem:
            '${mais.length == 1 ? 'Este animal já tem' : 'Estes animais já têm'}'
            ' inseminação depois de $_dataTexto:\n${nomes.join('\n')}\n\n'
            'Deseja substituir pela data mais antiga?',
        textoConfirmar: 'Substituir',
      );
      if (!ok) return;
    }

    safeSetState(() => _gravando = true);
    try {
      for (final alvo in widget.alvos) {
        await _inseminar(alvo);
      }
    } finally {
      safeSetState(() => _gravando = false);
    }
    if (!mounted) return;
    await _aviso(
      'Inseminação registrada!',
      _umAnimal
          ? 'Nova ação adicionada ao animal.'
          : '${widget.alvos.length} animais inseminados.',
    );
    if (mounted) Navigator.pop(context, true);
  }

  /// Gravação offline-first de UM animal: ação 'Inseminada' e o animal com
  /// status, datas previstas, touro e total de inseminações.
  Future<void> _inseminar(AlvoInseminacao alvo) async {
    final dtIns = _dataTexto;
    await AcaoRepository().add(AcaoEntity(
      parentPath: widget.uidTecnico!.path,
      uidAnimalAnimaisProdutoresPath: alvo.referencia?.path,
      uidAnimalOffline: alvo.referencia == null ? alvo.uidAnimalOffline : null,
      uidPropriedadePath: widget.uidPropriedade?.path,
      nomeAnimal: alvo.nome,
      acao: 'Inseminada',
      dataVisita: dtIns,
      obsVisita: _umAnimal ? _obsController.text : '',
      touroInseminacao: _touro,
      dataPartoPrevisto: functions.somarDataParto(dtIns),
      dataSecPrevista: functions.somarDataSecagem(dtIns),
      dataPrePartoPrevista: functions.somarDataPreParto(dtIns),
      dataDaAcao: getCurrentTimestamp,
    ));

    final dadosAnimal = <String, dynamic>{
      'dtUltimaInseminacao': dtIns,
      'status': 'Inseminada',
      'dtPartoPrevisto': functions.somarDataParto(dtIns),
      'dtSecPrevista': functions.somarDataSecagem(dtIns),
      'dtPrePartoPrevista': functions.somarDataPreParto(dtIns),
      'dtPP': '',
      'nomeTouroUltimaInseminacao': _touro,
      'compararDtUltimaInseminacao':
          functions.converterDataUltimaInseminacao(dtIns),
      'idStatusAnimal': 3,
    };
    final repo = AnimalRepository();
    final entity = alvo.referencia != null
        ? repo.getByFirestoreId(alvo.referencia!.id)
        : ((alvo.uidAnimalOffline ?? '').isNotEmpty
            ? repo.getByUidAnimalOffline(alvo.uidAnimalOffline!)
            : null);
    if (entity != null) {
      unawaited(repo.update(
          entity,
          comDataDaAcao({
            ...dadosAnimal,
            'totalInseminacoes': entity.totalInseminacoes + 1,
            // Vaca inseminada voltou ao ciclo: a inducao de lactacao acabou.
            // Novilha mantem a marca, que e o que libera a Secagem dela nas
            // Prenhas (novilha induzida lacta).
            if (ehVaca(entity.grupoAnimal) && entity.dtInducaoLactacao != null)
              'dtInducaoLactacao': null,
          }, quando: DateTime.now())));
    } else if (alvo.referencia != null) {
      // Animal fora do cache local: grava direto (persistência offline).
      unawaited(alvo.referencia!.update({
        ...createAnimaisProdutoresRecordData(
          dtUltimaInseminacao: dtIns,
          status: 'Inseminada',
          dtPartoPrevisto: functions.somarDataParto(dtIns),
          dtSecPrevista: functions.somarDataSecagem(dtIns),
          dtPrePartoPrevista: functions.somarDataPreParto(dtIns),
          dtPP: '',
          nomeTouroUltimaInseminacao: _touro,
          compararDtUltimaInseminacao:
              functions.converterDataUltimaInseminacao(dtIns),
          idStatusAnimal: 3,
        ),
        ...mapToFirestore({'totalInseminacoes': FieldValue.increment(1)}),
      }));
    }
  }

  Future<void> _aviso(String titulo, String mensagem) => showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c), child: const Text('Ok')),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: tema.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      padding: EdgeInsets.fromLTRB(
          20.0, 10.0, 20.0, 16.0 + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: tema.alternate,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          const SizedBox(height: 14.0),
          Row(
            children: [
              const Icon(Icons.playlist_add_rounded,
                  color: AppTokens.brand, size: 24.0),
              const SizedBox(width: 8.0),
              Text('Inseminar',
                  style: GoogleFonts.outfit(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: tema.primaryText)),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(resumoAlvos(widget.alvos),
              style: GoogleFonts.readexPro(
                  fontSize: 13.0, color: tema.secondaryText)),
          const SizedBox(height: 16.0),
          _rotulo(context, 'Data da inseminação'),
          InkWell(
            onTap: _escolherData,
            borderRadius: BorderRadius.circular(LayoutLista.raio),
            child: Container(
              height: LayoutLista.alturaControle + 4,
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              decoration: BoxDecoration(
                color: tema.primaryBackground,
                borderRadius: BorderRadius.circular(LayoutLista.raio),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(_dataTexto,
                        style: GoogleFonts.readexPro(
                            fontSize: 15.0, color: tema.primaryText)),
                  ),
                  Icon(Icons.calendar_month_rounded,
                      color: tema.secondaryText, size: 22.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          _rotulo(context, 'Touro/sêmen'),
          FlutterFlowDropDown<String>(
            controller: _touroController,
            options: _opcoesTouro(),
            onChanged: (v) => safeSetState(() => _touro = v),
            width: double.infinity,
            height: LayoutLista.alturaControle + 4,
            textStyle:
                GoogleFonts.readexPro(fontSize: 15.0, color: tema.primaryText),
            searchTextStyle:
                GoogleFonts.readexPro(fontSize: 14.0, color: tema.primaryText),
            searchHintTextStyle: GoogleFonts.readexPro(
                fontSize: 14.0, color: tema.secondaryText),
            hintText: 'Selecione um touro ou sêmen',
            searchHintText: 'Pesquise um touro ou sêmen...',
            icon: Icon(Icons.keyboard_arrow_down_rounded,
                color: tema.secondaryText, size: 24.0),
            fillColor: tema.primaryBackground,
            elevation: 2.0,
            borderColor: Colors.transparent,
            borderWidth: 1.0,
            borderRadius: LayoutLista.raio,
            margin: const EdgeInsetsDirectional.fromSTEB(14.0, 4.0, 12.0, 4.0),
            hidesUnderline: true,
            isOverButton: true,
            isSearchable: true,
            isMultiSelect: false,
          ),
          if (_umAnimal) ...[
            const SizedBox(height: 12.0),
            _rotulo(context, 'Observações'),
            TextField(
              controller: _obsController,
              minLines: 2,
              maxLines: 4,
              style: GoogleFonts.readexPro(
                  fontSize: 14.0, color: tema.primaryText),
              decoration: InputDecoration(
                hintText: 'Opcional',
                hintStyle: GoogleFonts.readexPro(
                    fontSize: 14.0, color: tema.secondaryText),
                filled: true,
                fillColor: tema.primaryBackground,
                contentPadding: const EdgeInsets.all(14.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(LayoutLista.raio),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppTokens.secondary, width: 1.5),
                  borderRadius: BorderRadius.circular(LayoutLista.raio),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: FFButtonWidget(
                  onPressed: _gravando ? null : () => Navigator.pop(context),
                  text: 'Cancelar',
                  options: FFButtonOptions(
                    height: 48.0,
                    color: tema.primaryBackground,
                    textStyle: GoogleFonts.readexPro(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: tema.primaryText),
                    elevation: 0.0,
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(LayoutLista.raio),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                flex: 2,
                child: FFButtonWidget(
                  onPressed: _gravando ? null : _registrar,
                  text: _gravando
                      ? 'Registrando...'
                      : _umAnimal
                          ? 'Registrar'
                          : 'Inseminar ${widget.alvos.length}',
                  icon: _gravando
                      ? const SizedBox(
                          width: 16.0,
                          height: 16.0,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.0, color: Colors.white),
                        )
                      : const Icon(Icons.check_rounded, size: 18.0),
                  options: FFButtonOptions(
                    height: 48.0,
                    color: AppTokens.brand,
                    textStyle: GoogleFonts.readexPro(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    elevation: 0.0,
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(LayoutLista.raio),
                    // ignore: deprecated_member_use
                    disabledColor: AppTokens.brand.withOpacity(0.7),
                    disabledTextColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rotulo(BuildContext context, String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 6.0, left: 2.0),
        child: Text(texto,
            style: GoogleFonts.readexPro(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: FlutterFlowTheme.of(context).secondaryText)),
      );
}
