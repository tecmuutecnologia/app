import '/core/auth/firebase_auth/auth_util.dart';
import '/core/ui/app_card.dart';
import '/data/backend.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import '/core/auth/produtor_account_service.dart';
import '/core/di/providers.dart';
import '/data/objectbox/entities/index.dart';
import '/features/propriedades/application/firestore_refs.dart';
import '/features/propriedades/application/propriedades_providers.dart';
import '/features/onboarding/presentation/pages/welcome_page.dart';
import '/features/propriedades/presentation/pages/lista_propriedade_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class EditarPropriedadePage extends ConsumerStatefulWidget {
  const EditarPropriedadePage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.emailTecnico,
    this.propriedadePendenteId,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? emailTecnico;

  /// Id LOCAL (ObjectBox) de uma propriedade PENDENTE de ativação. Quando
  /// presente, a tela edita a propriedade criada offline (que ainda não tem
  /// firestoreId) — usado para corrigir dados, como o e-mail, antes de reativar.
  final int? propriedadePendenteId;

  static String routeName = 'editarPropriedade';
  static String routePath = '/editarPropriedade';

  @override
  ConsumerState<EditarPropriedadePage> createState() =>
      _EditarPropriedadePageState();
}

class _EditarPropriedadePageState extends ConsumerState<EditarPropriedadePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  FocusNode? _yourNameFocusNode;
  TextEditingController? _yourNameTextController;
  FocusNode? _cpfFocusNode;
  TextEditingController? _cpfTextController;
  late MaskTextInputFormatter _cpfMask;
  FocusNode? _celularFocusNode;
  TextEditingController? _celularTextController;
  late MaskTextInputFormatter _celularMask;
  FocusNode? _enderecoFocusNode;
  TextEditingController? _enderecoTextController;
  String? _diasdgValue;
  FormFieldController<String>? _diasdgValueController;
  FocusNode? _emailProdutorFocusNode;
  TextEditingController? _emailProdutorTextController;

  String? _yourNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 5) {
      return 'Mínimo 5 caracteres.';
    }
    if (val.length > 150) {
      return 'Máximo 150 caracteres.';
    }
    return null;
  }

  String? _cpfTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 14) {
      return 'Mínimo 14 caracteres.';
    }
    if (val.length > 14) {
      return 'Máximo 14 caracteres.';
    }
    return null;
  }

  String? _celularTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 15) {
      return 'Mínimo 15 caracteres.';
    }
    if (val.length > 15) {
      return 'Máximo 15 caracteres.';
    }
    return null;
  }

  String? _enderecoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 2) {
      return 'Mínimo 15 caracteres.';
    }
    if (val.length > 50) {
      return 'Máximo 50 caracteres.';
    }
    return null;
  }

  String? _emailProdutorTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'emailPropriedade is required';
    }
    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    _yourNameFocusNode ??= FocusNode();

    _cpfFocusNode ??= FocusNode();
    _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');

    _celularFocusNode ??= FocusNode();
    _celularMask = MaskTextInputFormatter(mask: '(##) #####-####');

    _enderecoFocusNode ??= FocusNode();

    _emailProdutorTextController ??=
        TextEditingController(text: widget.emailPropriedade);
    _emailProdutorFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _yourNameFocusNode?.dispose();
    _yourNameTextController?.dispose();
    _cpfFocusNode?.dispose();
    _cpfTextController?.dispose();
    _celularFocusNode?.dispose();
    _celularTextController?.dispose();
    _enderecoFocusNode?.dispose();
    _enderecoTextController?.dispose();
    _emailProdutorFocusNode?.dispose();
    _emailProdutorTextController?.dispose();

    super.dispose();
  }

  Widget _p1(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 50.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
        ),
        Text(
          'Editar  propriedade',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.outfit(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
                color: Colors.white,
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight:
                    FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle:
                    FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
        ),
      ],
    );
  }

  Widget _p2(
      BuildContext context, dynamic editarPropriedadePropriedadesRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 16.0),
      child: TextFormField(
        controller: _yourNameTextController ??= TextEditingController(
          text: editarPropriedadePropriedadesRecord?.displayName,
        ),
        focusNode: _yourNameFocusNode,
        textCapitalization: TextCapitalization.words,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Seu nome',
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
              color: Colors.transparent,
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
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
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
        validator: _yourNameTextControllerValidator.asValidator(context),
        inputFormatters: [
          if (!isAndroid && !isiOS)
            TextInputFormatter.withFunction((oldValue, newValue) {
              return TextEditingValue(
                selection: newValue.selection,
                text: newValue.text.toCapitalization(TextCapitalization.words),
              );
            }),
        ],
      ),
    );
  }

  Widget _p3(
      BuildContext context, dynamic editarPropriedadePropriedadesRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
      child: TextFormField(
        controller: _cpfTextController ??= TextEditingController(
          text: editarPropriedadePropriedadesRecord?.cpf,
        ),
        focusNode: _cpfFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'CPF',
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
              color: Colors.transparent,
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
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
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
        validator: _cpfTextControllerValidator.asValidator(context),
        inputFormatters: [_cpfMask],
      ),
    );
  }

  Widget _p4(
      BuildContext context, dynamic editarPropriedadePropriedadesRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
      child: TextFormField(
        controller: _celularTextController ??= TextEditingController(
          text: editarPropriedadePropriedadesRecord?.phoneNumber,
        ),
        focusNode: _celularFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Celular',
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
              color: Colors.transparent,
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
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
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
        validator: _celularTextControllerValidator.asValidator(context),
        inputFormatters: [_celularMask],
      ),
    );
  }

  Widget _p5(
      BuildContext context, dynamic editarPropriedadePropriedadesRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
      child: TextFormField(
        controller: _enderecoTextController ??= TextEditingController(
          text: editarPropriedadePropriedadesRecord?.endereco,
        ),
        focusNode: _enderecoFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Endereço',
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
              color: Colors.transparent,
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
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
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
        validator: _enderecoTextControllerValidator.asValidator(context),
        inputFormatters: [
          if (!isAndroid && !isiOS)
            TextInputFormatter.withFunction((oldValue, newValue) {
              return TextEditingValue(
                selection: newValue.selection,
                text: newValue.text.toCapitalization(TextCapitalization.none),
              );
            }),
        ],
      ),
    );
  }

  Widget _p6(
      BuildContext context, dynamic editarPropriedadePropriedadesRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
      child: FlutterFlowDropDown<String>(
        controller: _diasdgValueController ??= FormFieldController<String>(
          _diasdgValue ??= editarPropriedadePropriedadesRecord?.diasParaDg,
        ),
        options: List<String>.from(['28', '30', '40', '21']),
        optionLabels: ['28 Dias', '30 Dias', '40 Dias', '21 Dias'],
        onChanged: (val) => safeSetState(() => _diasdgValue = val),
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: 50.0,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        hintText: 'Dias para Diagnóstico Gestação (DG)',
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 24.0,
        ),
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 2.0,
        borderColor: FlutterFlowTheme.of(context).alternate,
        borderWidth: 2.0,
        borderRadius: 8.0,
        margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
        hidesUnderline: true,
        isOverButton: true,
        isSearchable: false,
        isMultiSelect: false,
      ),
    );
  }

  Widget _p7(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _emailProdutorTextController,
          focusNode: _emailProdutorFocusNode,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'E-mail',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
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
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
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
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
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
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 0.0, 24.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          keyboardType: TextInputType.emailAddress,
          validator: _emailProdutorTextControllerValidator.asValidator(context),
        ),
      ),
    );
  }

  Widget _p8(
      BuildContext context, dynamic editarPropriedadePropriedadesRecord) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.05),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
        child: FFButtonWidget(
          onPressed: () async {
            var confirmDialogResponse = await showDialog<bool>(
                  context: context,
                  builder: (alertDialogContext) {
                    return AlertDialog(
                      title: Text('Excluir Propriedade'),
                      content: Text(
                          'Tem certeza que deseja excluir essa propriedade? Ela será movida para a lixeira e poderá ser restaurada posteriormente.'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(alertDialogContext, false),
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(alertDialogContext, true),
                          child: Text('Excluir'),
                        ),
                      ],
                    );
                  },
                ) ??
                false;
            if (!confirmDialogResponse) {
              return;
            }

            final entity = editarPropriedadePropriedadesRecord;
            final repo = ref.read(propriedadeRepositoryProvider);
            if (!entity.contaCriada) {
              // Pendente: existe só localmente (sem doc no Firestore) → remove
              // do ObjectBox. Não há lixeira porque nada foi sincronizado.
              repo.box.remove(entity.id);
            } else {
              // Offline-first: soft-delete via ObjectBox (sincroniza como UPDATE,
              // preservando a semântica de lixeira).
              entity.isDeleted = true;
              entity.deletedAt = DateTime.now();
              await repo.save(entity);
            }

            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Sucesso!'),
                  content: Text(entity.contaCriada
                      ? 'Propriedade movida para a lixeira.'
                      : 'Propriedade removida.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );

            context.goNamed(
              ListaPropriedadePage.routeName,
              queryParameters: {
                'visitaPresencial': serializeParam(
                  widget.visitaPresencial,
                  ParamType.bool,
                ),
              }.withoutNulls,
            );
          },
          text: 'Excluir Propriedade',
          icon: Icon(
            Icons.delete_outline,
            size: 15.0,
          ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 50.0,
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: Color(0xFFEF4444),
            textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: Colors.white,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
            elevation: 2.0,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _p9(
      BuildContext context, dynamic editarPropriedadePropriedadesRecord) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.05),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 15.0),
        child: FFButtonWidget(
          onPressed: () async {
            if (_formKey.currentState == null ||
                !_formKey.currentState!.validate()) {
              return;
            }
            if (_diasdgValue == null) {
              return;
            }
            if ((editarPropriedadePropriedadesRecord.displayName != '') &&
                (editarPropriedadePropriedadesRecord.email != '') &&
                (editarPropriedadePropriedadesRecord.cpf != '') &&
                (editarPropriedadePropriedadesRecord.phoneNumber != '')) {
              if (editarPropriedadePropriedadesRecord.diasParaDg !=
                  _diasdgValue) {
                var confirmDialogResponse = await showDialog<bool>(
                      context: context,
                      builder: (alertDialogContext) {
                        return AlertDialog(
                          title: Text('Importante!'),
                          content: Text(
                              'A nova quantidade de dias para DG, será válido apenas para novas ações.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(alertDialogContext, false),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(alertDialogContext, true),
                              child: Text('Confirmar'),
                            ),
                          ],
                        );
                      },
                    ) ??
                    false;
                if (!confirmDialogResponse) {
                  return;
                }
              }
            } else {
              await showDialog(
                context: context,
                builder: (alertDialogContext) {
                  return AlertDialog(
                    title: Text('Campos obrigatórios não preenchidos.'),
                    content: Text('Preencha todos os campos obrigatórios.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(alertDialogContext),
                        child: Text('Ok'),
                      ),
                    ],
                  );
                },
              );
              return;
            }

            // Offline-first: atualiza via ObjectBox.
            final entity = editarPropriedadePropriedadesRecord;
            entity.cpf = _cpfTextController.text;
            entity.endereco = _enderecoTextController.text;
            entity.displayName = _yourNameTextController.text;
            entity.phoneNumber = _celularTextController.text;
            entity.diasParaDg = _diasdgValue;
            final repo = ref.read(propriedadeRepositoryProvider);
            if (!entity.contaCriada) {
              // Propriedade PENDENTE: o e-mail é editável (é o que se corrige
              // antes de reativar) e a gravação é só local — a fila de sync não
              // deve enviar uma propriedade cujo produtor ainda não existe.
              entity.email = _emailProdutorTextController.text;
              repo.saveLocalPending(entity);
            } else {
              // Propriedade ativa: sincroniza como UPDATE parcial (ou enfileira).
              await repo.save(entity);
            }
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Sucesso!'),
                  content: Text('Atualização realizada com sucesso.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );

            context.goNamed(
              ListaPropriedadePage.routeName,
              queryParameters: {
                'visitaPresencial': serializeParam(
                  widget.visitaPresencial,
                  ParamType.bool,
                ),
              }.withoutNulls,
            );
          },
          text: 'Salvar e editar',
          icon: Icon(
            Icons.save,
            size: 15.0,
          ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 50.0,
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: Color(0xFFEC3B5B),
            textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: Colors.white,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
            elevation: 2.0,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _p10(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.05),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 15.0, 20.0, 0.0),
        child: FFButtonWidget(
          onPressed: () async {
            GoRouter.of(context).prepareAuthEvent();
            await authManager.signOut();
            GoRouter.of(context).clearRedirectLocation();

            context.goNamedAuth(WelcomePage.routeName, context.mounted);
          },
          text: 'Logout',
          icon: Icon(
            Icons.logout,
            size: 15.0,
          ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 50.0,
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: Color(0xFF473BEC),
            textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: Colors.white,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
            elevation: 2.0,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Propriedade lida do ObjectBox (offline-first). Antes, a página inteira
    // ficava atrás de uma query do Firestore por e-mail.
    //
    // Dois modos: propriedade PENDENTE (criada offline, sem firestoreId) é
    // carregada pelo id local; propriedade já ativa é carregada pelo firestoreId.
    final AsyncValue<PropriedadeEntity?> propriedadeAsync;
    if (widget.propriedadePendenteId != null) {
      propriedadeAsync =
          ref.watch(propriedadeByLocalIdProvider(widget.propriedadePendenteId!));
    } else {
      final firestoreId = widget.uidPropriedade?.id;
      if (firestoreId == null) {
        return Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          body: Center(child: Text('Propriedade não informada.')),
        );
      }
      propriedadeAsync = ref.watch(propriedadeByIdProvider(firestoreId));
    }

    return propriedadeAsync.when(
      loading: () => Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Center(child: Text('Erro ao carregar a propriedade.')),
      ),
      data: (editarPropriedadePropriedadesRecord) {
        if (editarPropriedadePropriedadesRecord == null) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
                child: Text('Propriedade não encontrada no dispositivo.')),
          );
        }

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
                    begin: AlignmentDirectional(-1.0, -1.0),
                    end: AlignmentDirectional(1.0, 1.0),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.0),
                    bottomRight: Radius.circular(24.0),
                  ),
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  actions: [],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _p1(context),
                      ],
                    ),
                    centerTitle: true,
                    expandedTitleScale: 1.0,
                  ),
                  elevation: 0.0,
                )),
          ),
          body: SafeArea(
            top: true,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _p2(context, editarPropriedadePropriedadesRecord),
                    _p3(context, editarPropriedadePropriedadesRecord),
                    _p4(context, editarPropriedadePropriedadesRecord),
                    _p5(context, editarPropriedadePropriedadesRecord),
                    _p6(context, editarPropriedadePropriedadesRecord),
                    _p7(context),
                    _p8(context, editarPropriedadePropriedadesRecord),
                    _p9(context, editarPropriedadePropriedadesRecord),
                    // "Liberar Acesso" só para propriedade JÁ ativa sem produtor
                    // vinculado. Pendente é ativada pela lista ("Ativar conta"),
                    // e o fluxo aqui usa docRef (nulo enquanto pendente).
                    if (editarPropriedadePropriedadesRecord.contaCriada &&
                        editarPropriedadePropriedadesRecord
                                .uidPersonProdutorPath ==
                            null)
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.05),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 20.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              // Valida Formulário
                              if (_formKey.currentState == null ||
                                  !_formKey.currentState!.validate()) {
                                return;
                              }
                              if (_diasdgValue == null) {
                                return;
                              }

                              final record =
                                  editarPropriedadePropriedadesRecord;

                              // Liberar acesso cria a conta do produtor (online).
                              final connectivity =
                                  ref.read(connectivityServiceProvider);
                              if (!connectivity.isOnline) {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) => AlertDialog(
                                    title: const Text('Sem conexão'),
                                    content: const Text(
                                        'É necessário estar conectado à internet para liberar o acesso do produtor.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }

                              // Loading bloqueante.
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFFF75E38)),
                                    ),
                                  ),
                                ),
                              );

                              try {
                                // Senha padrão do produtor = CPF só dígitos.
                                final senhaProdutor = (record.cpf ?? '')
                                    .replaceAll(RegExp(r'[^0-9]'), '');

                                // Cria a conta numa instância secundária do
                                // Firebase — o técnico NÃO é deslogado.
                                final produtorUid = await ProdutorAccountService
                                    .criarContaProdutor(
                                  email: _emailProdutorTextController.text,
                                  password: senhaProdutor,
                                  buildPersonData: (uid) =>
                                      createPersonRecordData(
                                    cpf: record.cpf,
                                    uid: uid,
                                    endereco: record.endereco,
                                    cidade: record.cidade,
                                    email: widget.emailPropriedade,
                                    createdTime: getCurrentTimestamp,
                                    displayName: record.displayName,
                                    phoneNumber: record.phoneNumber,
                                    tipo: 'produtor',
                                  ),
                                );

                                final produtorPersonRef =
                                    PersonRecord.collection.doc(produtorUid);

                                // Vincula o produtor à propriedade existente.
                                await record.docRef!
                                    .update(createPropriedadesRecordData(
                                  uidPersonProdutor: produtorPersonRef,
                                ));

                                // Espelha o vínculo no ObjectBox para o botão
                                // "Liberar Acesso" sumir na hora. `put` direto:
                                // o Firestore já foi atualizado acima.
                                record.uidPersonProdutorPath =
                                    produtorPersonRef.path;
                                ref
                                    .read(propriedadeRepositoryProvider)
                                    .box
                                    .put(record);

                                // Atualiza contadores do técnico.
                                await widget.uidTecnico!.update({
                                  ...createTecnicoRecordData(
                                    uidPerson: currentUserUid,
                                  ),
                                  ...mapToFirestore({
                                    'quantidadeProdutoresCadastrados':
                                        FieldValue.increment(1),
                                    'restanteLimiteProdutores':
                                        FieldValue.increment(-(1)),
                                  }),
                                });

                                // E-mail de boas-vindas (senha = CPF).
                                await launchUrl(Uri(
                                    scheme: 'mailto',
                                    path: widget.emailPropriedade!,
                                    query: {
                                      'subject': 'Bem-vindo(a) Tecmuu!',
                                      'body':
                                          'Olá, produtor! Seja muito bem-vindo à plataforma TecMuu! Para começar sua jornada conosco, baixe nosso aplicativo na Play Store ou na App Store e faça login utilizando seu e-mail e, como senha padrão, o seu CPF (apenas os números). No primeiro acesso, recomendamos que você troque a senha. Estamos ansiosos para ter você conosco! 🚀',
                                    }
                                        .entries
                                        .map((MapEntry<String, String> e) =>
                                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                        .join('&')));

                                if (!mounted) return;
                                Navigator.of(context).pop(); // fecha o loading
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) => AlertDialog(
                                    title: const Text('Acesso liberado!'),
                                    content: const Text(
                                        'O produtor recebeu o e-mail de boas-vindas com as instruções de acesso.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );

                                if (!mounted) return;
                                context.goNamed(
                                  ListaPropriedadePage.routeName,
                                  queryParameters: {
                                    'visitaPresencial': serializeParam(
                                      widget.visitaPresencial,
                                      ParamType.bool,
                                    ),
                                  }.withoutNulls,
                                );
                              } catch (e) {
                                if (!mounted) return;
                                Navigator.of(context).pop(); // fecha o loading
                                final jaExiste = e is FirebaseAuthException &&
                                    e.code == 'email-already-in-use';
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) => AlertDialog(
                                    title: Text(jaExiste
                                        ? 'E-mail já cadastrado'
                                        : 'Não foi possível liberar o acesso'),
                                    content: Text(jaExiste
                                        ? 'Já existe uma conta com este e-mail.'
                                        : 'Ocorreu um erro. Verifique sua conexão e tente novamente.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            text: 'Liberar Acesso',
                            icon: Icon(
                              Icons.key_sharp,
                              size: 15.0,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).tertiary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                              elevation: 2.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    _p10(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
