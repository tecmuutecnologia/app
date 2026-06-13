// ignore_for_file: dead_code, unused_field
import '/core/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import 'dart:ui';
import '/features/propriedades/presentation/pages/lista_propriedade_page.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmarSenhaWidget extends StatefulWidget {
  const ConfirmarSenhaWidget({
    super.key,
    required this.email,
    required this.visitaPresencial,
    required this.uidPersonProdutor,
    required this.emailProdutor,
    required this.telefoneProdutor,
    required this.enderecoProdutor,
    required this.nomeProdutor,
    required this.cpfProdutor,
    required this.diasparaDg,
    required this.cidadeProdutor,
    required this.isEdit,
  });

  final String? email;
  final bool? visitaPresencial;
  final DocumentReference? uidPersonProdutor;
  final String? emailProdutor;
  final String? telefoneProdutor;
  final String? enderecoProdutor;
  final String? nomeProdutor;
  final String? cpfProdutor;
  final String? diasparaDg;
  final String? cidadeProdutor;
  final bool? isEdit;

  @override
  State<ConfirmarSenhaWidget> createState() => _ConfirmarSenhaWidgetState();
}

class _ConfirmarSenhaWidgetState extends State<ConfirmarSenhaWidget>
    with TickerProviderStateMixin {
  final animationsMap = <String, AnimationInfo>{};

  final _formKey = GlobalKey<FormState>();

  FocusNode? _senhaTemporariaFocusNode;
  TextEditingController? _senhaTemporariaTextController;
  bool _senhaTemporariaVisibility = false;

  // Outputs de query/criação (antes no FlutterFlowModel).
  TecnicoRecord? _outUidTecnicoLogged;
  PropriedadesRecord? _propriedadeTecnico;
  PropriedadesRecord? _outUidPropriedadeNewCadaster;

  String? _senhaTemporariaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Senha Temporária is required';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    _senhaTemporariaTextController ??= TextEditingController();
    _senhaTemporariaFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 250.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 250.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 70.0),
            end: Offset(0.0, 0.0),
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

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _senhaTemporariaFocusNode?.dispose();
    _senhaTemporariaTextController?.dispose();

    super.dispose();
  }

  Widget _p1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 670.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 3.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _p2(context),
            ],
          ),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!),
    );
  }

  Widget _p2(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        _p3(context),
      ],
    );
  }

  Widget _p3(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _p4(context),
            _p5(context),
            _p6(context),
          ],
        ),
      ),
    );
  }

  Widget _p4(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                  child: Text(
                    'Por favor, confirme sua senha!',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.outfit(
                            fontWeight: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _p5(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: TextFormField(
        controller: _senhaTemporariaTextController,
        focusNode: _senhaTemporariaFocusNode,
        autofocus: true,
        obscureText: !_senhaTemporariaVisibility,
        decoration: InputDecoration(
          labelText: 'Senha',
          labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelLarge.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
              ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          suffixIcon: InkWell(
            onTap: () => safeSetState(
              () => _senhaTemporariaVisibility = !_senhaTemporariaVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              _senhaTemporariaVisibility
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Color(0xFF757575),
              size: 22.0,
            ),
          ),
        ),
        style: FlutterFlowTheme.of(context).bodyLarge.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
            ),
        validator: _senhaTemporariaTextControllerValidator.asValidator(context),
      ),
    );
  }

  Widget _p6(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
            child: FFButtonWidget(
              onPressed: () async {
                var _shouldSetState = false;
                GoRouter.of(context).prepareAuthEvent();

                final user = await authManager.signInWithEmail(
                  context,
                  widget.email!,
                  _senhaTemporariaTextController.text,
                );
                if (user == null) {
                  return;
                }

                if (loggedIn == true) {
                  _outUidTecnicoLogged = await queryTecnicoRecordOnce(
                    queryBuilder: (tecnicoRecord) => tecnicoRecord.where(
                      'uidPerson',
                      isEqualTo: currentUserUid,
                    ),
                    singleRecord: true,
                  ).then((s) => s.firstOrNull);
                  _shouldSetState = true;
                  _propriedadeTecnico = await queryPropriedadesRecordOnce(
                    parent: _outUidTecnicoLogged?.reference,
                    queryBuilder: (propriedadesRecord) =>
                        propriedadesRecord.where(
                      'email',
                      isEqualTo: widget.emailProdutor,
                    ),
                    singleRecord: true,
                  ).then((s) => s.firstOrNull);
                  _shouldSetState = true;
                  if (widget.isEdit!) {
                    await _propriedadeTecnico!.reference
                        .update(createPropriedadesRecordData(
                      uidPersonProdutor: widget.uidPersonProdutor,
                    ));
                  } else {
                    var propriedadesRecordReference =
                        PropriedadesRecord.createDoc(
                            _outUidTecnicoLogged!.reference);
                    await propriedadesRecordReference
                        .set(createPropriedadesRecordData(
                      email: widget.emailProdutor,
                      displayName: widget.nomeProdutor,
                      cpf: widget.cpfProdutor,
                      endereco: widget.enderecoProdutor,
                      cidade: widget.cidadeProdutor,
                      phoneNumber: widget.telefoneProdutor,
                      diasParaDg: widget.diasparaDg,
                      uidPersonProdutor: widget.uidPersonProdutor,
                    ));
                    _outUidPropriedadeNewCadaster =
                        PropriedadesRecord.getDocumentFromData(
                            createPropriedadesRecordData(
                              email: widget.emailProdutor,
                              displayName: widget.nomeProdutor,
                              cpf: widget.cpfProdutor,
                              endereco: widget.enderecoProdutor,
                              cidade: widget.cidadeProdutor,
                              phoneNumber: widget.telefoneProdutor,
                              diasParaDg: widget.diasparaDg,
                              uidPersonProdutor: widget.uidPersonProdutor,
                            ),
                            propriedadesRecordReference);
                    _shouldSetState = true;
                  }

                  await _outUidTecnicoLogged!.reference.update({
                    ...createTecnicoRecordData(
                      uidPerson: currentUserUid,
                    ),
                    ...mapToFirestore(
                      {
                        'quantidadeProdutoresCadastrados':
                            FieldValue.increment(1),
                        'restanteLimiteProdutores': FieldValue.increment(-(1)),
                      },
                    ),
                  });
                  await launchUrl(Uri(
                      scheme: 'mailto',
                      path: widget.emailProdutor!,
                      query: {
                        'subject': 'Bem-vindo(a) Tecmuu!',
                        'body':
                            'Olá, produtor! Seja muito bem-vindo à plataforma TecMuu! Para começar sua jornada conosco, baixe nosso aplicativo na Play Store ou na App Store e faça login utilizando seu e-mail e a senha padrão: 1234. Estamos ansiosos para ter você conosco! 🚀',
                      }
                          .entries
                          .map((MapEntry<String, String> e) =>
                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                          .join('&')));
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text('Cadastro realizado com sucesso!'),
                        content: Text(
                            'Produtor recebeu e-mail notificando seu cadastro.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(alertDialogContext),
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );

                  context.goNamedAuth(
                    ListaPropriedadePage.routeName,
                    context.mounted,
                    queryParameters: {
                      'visitaPresencial': serializeParam(
                        false,
                        ParamType.bool,
                      ),
                    }.withoutNulls,
                  );

                  if (_shouldSetState) safeSetState(() {});
                  return;
                } else {
                  if (_shouldSetState) safeSetState(() {});
                  return;
                }
              },
              text: 'Confirmar',
              icon: Icon(
                Icons.check_sharp,
                size: 15.0,
              ),
              options: FFButtonOptions(
                height: 50.0,
                padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).secondary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.black,
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                elevation: 2.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 4.0,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).accent4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _p1(context),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
    );
  }
}
