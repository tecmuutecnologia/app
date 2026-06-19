// ignore_for_file: dead_null_aware_expression, unused_field

import '/data/backend.dart';
import '/core/ui/app_card.dart';
import '/data/objectbox/repositories/animal_repository.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import 'dart:async';
import '/core/ui/flutter_flow_animations.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import 'dart:ui';
import '/core/ui/custom_functions.dart' as functions;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarPartoWidget extends StatefulWidget {
  const RegistrarPartoWidget({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    required this.uidAnimaisProdutores,
    required this.nomeVacaAtual,
    required this.nomeTourtoUltimaInseminacao,
    required this.brincoVacaAtual,
    this.uidAnimalOffline,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;
  final DocumentReference? uidAnimaisProdutores;

  /// Identidade local da MÃE criada OFFLINE (sem firestoreId). Para esses,
  /// [uidAnimaisProdutores] é null; o parto é localizado por getByUidAnimalOffline.
  final String? uidAnimalOffline;
  final String? nomeVacaAtual;
  final String? nomeTourtoUltimaInseminacao;
  final String? brincoVacaAtual;

  @override
  State<RegistrarPartoWidget> createState() => _RegistrarPartoWidgetState();
}

class _RegistrarPartoWidgetState extends State<RegistrarPartoWidget>
    with TickerProviderStateMixin {
  final animationsMap = <String, AnimationInfo>{};

  AnimaisProdutoresRecord? _outUidAnimaisAnimal;
  FocusNode? _nomeFocusNode;
  TextEditingController? _nomeTextController;
  final String? Function(BuildContext, String?)? _nomeTextControllerValidator =
      null;
  FocusNode? _brincoFocusNode;
  TextEditingController? _brincoTextController;
  final String? Function(BuildContext, String?)?
      _brincoTextControllerValidator = null;
  String? _sexoValue;
  FormFieldController<String>? _sexoValueController;
  String? _racaPreValue;
  FormFieldController<String>? _racaPreValueController;
  FocusNode? _dtPartoFocusNode;
  TextEditingController? _dtPartoTextController;
  late MaskTextInputFormatter _dtPartoMask;
  final String? Function(BuildContext, String?)?
      _dtPartoTextControllerValidator = null;
  DateTime? _datePicked;
  FocusNode? _pesoNascFocusNode;
  TextEditingController? _pesoNascTextController;
  final String? Function(BuildContext, String?)?
      _pesoNascTextControllerValidator = null;
  bool? _novoAnimalValue;

  @override
  void initState() {
    super.initState();

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Mãe criada offline não tem doc no Firestore: pula a leitura remota.
      if (widget.uidAnimaisProdutores != null) {
        _outUidAnimaisAnimal = await AnimaisProdutoresRecord.getDocumentOnce(
            widget.uidAnimaisProdutores!);
      }
    });

    _nomeTextController ??= TextEditingController();
    _nomeFocusNode ??= FocusNode();

    _brincoTextController ??= TextEditingController();
    _brincoFocusNode ??= FocusNode();

    _dtPartoTextController ??= TextEditingController();
    _dtPartoFocusNode ??= FocusNode();

    _dtPartoMask = MaskTextInputFormatter(mask: '##/##/####');
    _pesoNascTextController ??= TextEditingController();
    _pesoNascFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {
          _dtPartoTextController?.text = dateTimeFormat(
            "dd/MM/yyyy",
            getCurrentTimestamp,
            locale: FFLocalizations.of(context).languageCode,
          );
        }));
  }

  @override
  void dispose() {
    _nomeFocusNode?.dispose();
    _nomeTextController?.dispose();
    _brincoFocusNode?.dispose();
    _brincoTextController?.dispose();
    _dtPartoFocusNode?.dispose();
    _dtPartoTextController?.dispose();
    _pesoNascFocusNode?.dispose();
    _pesoNascTextController?.dispose();

    super.dispose();
  }

  /// Registra o parto da mãe de forma offline-first: atualiza o animal (parto,
  /// status 'Vazia', limpa datas de ciclo/inseminação e incrementa partos) direto
  /// no ObjectBox (fonte única), delegando o sync com o Firestore aos
  /// repositórios. Funciona sem conexão. O cadastro do bezerro (quando há) é
  /// tratado à parte, também offline-first, via `criarAnimalOffline`.
  Future<void> _registrarPartoMaeOfflineFirst(String dtParto) async {
    final dados = <String, dynamic>{
      'dtUltimoParto': dtParto,
      'dtPartoPrevisto': '',
      'dtPrePartoPrevista': '',
      'dtSecPrevista': '',
      'dtSecagem': '',
      'grupoAnimal': 'Vacas',
      'status': 'Vazia',
      'dtUltimoPartoContingencia': dtParto,
      'idStatusAnimal': 2,
      'dtUltimaInseminacao': '',
      'nomeTouroUltimaInseminacao': '',
    };
    final animalRepo = AnimalRepository();
    final entity = widget.uidAnimaisProdutores != null
        ? animalRepo.getByFirestoreId(widget.uidAnimaisProdutores!.id)
        : (widget.uidAnimalOffline != null &&
                widget.uidAnimalOffline!.isNotEmpty
            ? animalRepo.getByUidAnimalOffline(widget.uidAnimalOffline!)
            : null);
    if (entity != null) {
      dados['totalPartos'] = entity.totalPartos + 1;
      unawaited(animalRepo.update(entity, dados));
    } else if (widget.uidAnimaisProdutores != null) {
      unawaited(widget.uidAnimaisProdutores!.update({
        ...createAnimaisProdutoresRecordData(
          dtUltimoParto: dtParto,
          dtPartoPrevisto: '',
          dtPrePartoPrevista: '',
          dtSecPrevista: '',
          dtSecagem: '',
          grupoAnimal: 'Vacas',
          status: 'Vazia',
          dtUltimoPartoContingencia: dtParto,
          idStatusAnimal: 2,
          dtUltimaInseminacao: '',
          nomeTouroUltimaInseminacao: '',
        ),
        ...mapToFirestore(
          {
            'totalPartos': FieldValue.increment(1),
          },
        ),
      }));
    }
  }

  Widget _p1(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 16.0, 16.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 670.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 12.0,
              color: Color(0x1E000000),
              offset: Offset(
                0.0,
                5.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _p2(context),
              _p3(context),
              _p4(context),
            ],
          ),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }

  Widget _p2(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 0.0, 0.0),
      child: Text(
        valueOrDefault<String>(
          widget.nomeVacaAtual,
          'Animal',
        ),
        style: FlutterFlowTheme.of(context).headlineMedium.override(
              font: GoogleFonts.outfit(
                fontWeight:
                    FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle:
                    FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight:
                  FlutterFlowTheme.of(context).headlineMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _p3(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _p5(context),
        _p6(context),
        _p7(context),
        _p8(context),
        _p9(context),
        _p10(context),
        _p11(context),
      ],
    );
  }

  Widget _p4(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.05),
            child: FFButtonWidget(
              onPressed: () async {
                Navigator.pop(context);
              },
              text: 'Cancelar',
              options: FFButtonOptions(
                height: 44.0,
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).secondaryBackground,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                elevation: 0.0,
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
                hoverColor: FlutterFlowTheme.of(context).alternate,
                hoverBorderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 2.0,
                ),
                hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                hoverElevation: 3.0,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, 0.05),
            child: FFButtonWidget(
              onPressed: () async {
                if (_novoAnimalValue == true) {
                  if ((_nomeTextController.text != '') ||
                      (_brincoTextController.text != '')) {
                    if (_dtPartoTextController.text != '') {
                      // Offline-first: atualiza a mãe (parto)
                      // no ObjectBox; sync enfileirado.
                      await _registrarPartoMaeOfflineFirst(
                          _dtPartoTextController.text);

                      // Cadastro do bezerro offline-first: cria
                      // no ObjectBox (online empurra na hora;
                      // offline enfileira e a cascata liga as
                      // ações ao bezerro quando ele sincroniza).
                      await criarAnimalOffline(AnimaisProdutoresStruct(
                        uidTecnicoPropriedade: widget.uidPropriedade,
                        nomeAnimal: _nomeTextController.text,
                        brincoAnimal: (_brincoTextController.text != '') &&
                                (_brincoTextController.text != '-1')
                            ? int.tryParse(_brincoTextController.text)
                            : -1,
                        racaAnimal: _racaPreValue,
                        pesoAnimal: _pesoNascTextController.text,
                        dtNascimento: _dtPartoTextController.text,
                        grupoAnimal: _sexoValue,
                        vaca: () {
                          if ((widget.nomeVacaAtual != null &&
                                  widget.nomeVacaAtual != '') &&
                              (widget.brincoVacaAtual != null &&
                                  widget.brincoVacaAtual != '')) {
                            return '${widget.nomeVacaAtual} - ${widget.brincoVacaAtual}';
                          } else if (widget.brincoVacaAtual != null &&
                              widget.brincoVacaAtual != '') {
                            return widget.brincoVacaAtual;
                          } else {
                            return widget.nomeVacaAtual;
                          }
                        }(),
                        touro: widget.nomeTourtoUltimaInseminacao,
                        status: '',
                        nomeBrincoConcat: () {
                          if ((_nomeTextController.text != '') &&
                              (_brincoTextController.text != '') &&
                              (_brincoTextController.text != '-1')) {
                            return '${_nomeTextController.text} - ${_brincoTextController.text}';
                          } else if (_nomeTextController.text != '') {
                            return _nomeTextController.text;
                          } else {
                            return _brincoTextController.text;
                          }
                        }(),
                        brincoAnimalOrder: (_brincoTextController.text != '') &&
                                (_brincoTextController.text != '-1')
                            ? int.tryParse(_brincoTextController.text)
                            : 999999,
                        uidAnimalOffline: functions.criarUidRandom(),
                      ));
                      Navigator.pop(context);
                      return;
                    } else {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text('Data do parto é obrigatória.'),
                            content: Text('Preencha todos os campos.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext),
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                  } else {
                    await showDialog(
                      context: context,
                      builder: (alertDialogContext) {
                        return AlertDialog(
                          title: Text('Nome ou brinco obrigatório.'),
                          content: Text('Preencha os campos obrigatórios.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(alertDialogContext),
                              child: Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                } else {
                  // Offline-first: atualiza a mãe (parto) no
                  // ObjectBox; sync enfileirado.
                  await _registrarPartoMaeOfflineFirst(
                    _dtPartoTextController.text != ''
                        ? _dtPartoTextController.text
                        : dateTimeFormat(
                            "dd/MM/yyyy",
                            getCurrentTimestamp,
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                  );
                  Navigator.pop(context);
                  return;
                }
              },
              text: 'Salvar',
              icon: Icon(
                Icons.check_circle_outline_sharp,
                size: 15.0,
              ),
              options: FFButtonOptions(
                height: 44.0,
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: Color(0xFF048508),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                elevation: 3.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
                hoverColor: FlutterFlowTheme.of(context).accent1,
                hoverBorderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 1.0,
                ),
                hoverTextColor: FlutterFlowTheme.of(context).primaryText,
                hoverElevation: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _p5(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: _nomeTextController,
        focusNode: _nomeFocusNode,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Nome*',
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTokens.secondary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding:
              EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        keyboardType: TextInputType.name,
        cursorColor: FlutterFlowTheme.of(context).primary,
        validator: _nomeTextControllerValidator.asValidator(context),
      ),
    );
  }

  Widget _p6(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: _brincoTextController,
        focusNode: _brincoFocusNode,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Brinco*',
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTokens.secondary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding:
              EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        keyboardType: TextInputType.number,
        cursorColor: FlutterFlowTheme.of(context).primary,
        validator: _brincoTextControllerValidator.asValidator(context),
      ),
    );
  }

  Widget _p7(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: FlutterFlowDropDown<String>(
        controller: _sexoValueController ??= FormFieldController<String>(
          _sexoValue ??= 'Bezerras',
        ),
        options: List<String>.from(['Bezerras', 'Bezerros']),
        optionLabels: ['Feminino (Bezerra)', 'Masculino (Bezerro)'],
        onChanged: (val) => safeSetState(() => _sexoValue = val),
        width: double.infinity,
        height: 58.0,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        hintText: 'Sexo*',
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 24.0,
        ),
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 2.0,
        borderColor: FlutterFlowTheme.of(context).alternate,
        borderWidth: 2.0,
        borderRadius: 12.0,
        margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
        hidesUnderline: true,
        isSearchable: false,
        isMultiSelect: false,
      ),
    );
  }

  Widget _p8(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: StreamBuilder<List<RacasRecord>>(
        stream: queryRacasRecord(),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF75E38),
                  ),
                ),
              ),
            );
          }
          List<RacasRecord> racaPreRacasRecordList = snapshot.data!;

          return FlutterFlowDropDown<String>(
            controller: _racaPreValueController ??= FormFieldController<String>(
              _racaPreValue ??= 'Holandesa',
            ),
            options: racaPreRacasRecordList.map((e) => e.descricao).toList(),
            onChanged: (val) => safeSetState(() => _racaPreValue = val),
            width: double.infinity,
            height: 58.0,
            searchHintTextStyle: FlutterFlowTheme.of(context)
                .labelMedium
                .override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
            searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
            hintText: 'Raça predominante*',
            searchHintText: 'Pesquise uma raça...',
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2.0,
            borderRadius: 12.0,
            margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
            hidesUnderline: true,
            isSearchable: true,
            isMultiSelect: false,
          );
        },
      ),
    );
  }

  Widget _p9(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
              child: TextFormField(
                controller: _dtPartoTextController,
                focusNode: _dtPartoFocusNode,
                autofocus: false,
                readOnly: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Data parto*',
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTokens.secondary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                maxLength: 10,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    null,
                keyboardType: TextInputType.datetime,
                cursorColor: FlutterFlowTheme.of(context).primary,
                validator: _dtPartoTextControllerValidator.asValidator(context),
                inputFormatters: [_dtPartoMask],
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              // calendarNascimento
              await showModalBottomSheet<bool>(
                  context: context,
                  builder: (context) {
                    final _datePickedCupertinoTheme =
                        CupertinoTheme.of(context);
                    return ScrollConfiguration(
                      behavior: const MaterialScrollBehavior().copyWith(
                        dragDevices: {
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.touch,
                          PointerDeviceKind.stylus,
                          PointerDeviceKind.unknown
                        },
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        child: CupertinoTheme(
                          data: _datePickedCupertinoTheme.copyWith(
                            textTheme:
                                _datePickedCupertinoTheme.textTheme.copyWith(
                              dateTimePickerTextStyle:
                                  FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                      ),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            minimumDate: DateTime(1900),
                            initialDateTime: functions.obterDataAtualFormat(),
                            maximumDate: (functions.obterDataAtualFormat() ??
                                DateTime(2050)),
                            backgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            use24hFormat: false,
                            onDateTimeChanged: (newDateTime) =>
                                safeSetState(() {
                              _datePicked = newDateTime;
                            }),
                          ),
                        ),
                      ),
                    );
                  });
              safeSetState(() {
                _dtPartoTextController?.text = dateTimeFormat(
                  "dd/MM/yyyy",
                  _datePicked,
                  locale: FFLocalizations.of(context).languageCode,
                );
                _dtPartoMask.updateMask(
                  newValue: TextEditingValue(
                    text: _dtPartoTextController!.text,
                  ),
                );
              });
            },
            child: Icon(
              Icons.calendar_month,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _p10(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: TextFormField(
        controller: _pesoNascTextController,
        focusNode: _pesoNascFocusNode,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Peso nascimento',
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTokens.secondary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding:
              EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        keyboardType: TextInputType.number,
        cursorColor: FlutterFlowTheme.of(context).primary,
        validator: _pesoNascTextControllerValidator.asValidator(context),
      ),
    );
  }

  Widget _p11(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
      child: Material(
        color: Colors.transparent,
        child: SwitchListTile.adaptive(
          value: _novoAnimalValue ??= true,
          onChanged: (newValue) async {
            safeSetState(() => _novoAnimalValue = newValue);
          },
          title: Text(
            'Registrar novo animal ao salvar',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.outfit(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          tileColor: FlutterFlowTheme.of(context).secondaryBackground,
          activeColor: Color(0xFFFF6000),
          activeTrackColor: Color(0xFFBE5312),
          dense: false,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).accent4,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _p1(context),
          ],
        ),
      ),
    );
  }
}
