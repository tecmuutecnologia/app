import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/tecnico/propriedade/propriedades/confirmar_senha/confirmar_senha_widget.dart';
import '/features/onboarding/presentation/pages/welcome_page.dart';
import '/features/propriedades/presentation/pages/lista_propriedade_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarPropriedadePage extends StatefulWidget {
  const EditarPropriedadePage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.emailTecnico,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? emailTecnico;

  static String routeName = 'editarPropriedade';
  static String routePath = '/editarPropriedade';

  @override
  State<EditarPropriedadePage> createState() => _EditarPropriedadePageState();
}

class _EditarPropriedadePageState extends State<EditarPropriedadePage> {
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
  FocusNode? _senhaFocusNode;
  TextEditingController? _senhaTextController;
  bool _senhaVisibility = false;
  final String? Function(BuildContext, String?)? _senhaTextControllerValidator =
      null;
  FocusNode? _confirmaSenhaFocusNode;
  TextEditingController? _confirmaSenhaTextController;
  bool _confirmaSenhaVisibility = false;

  // Output de criação (antes no FlutterFlowModel).
  PersonRecord? _uidPersonProdutor;

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

  String? _confirmaSenhaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Confirmar Senha is required';
    }
    if (!RegExp('').hasMatch(val)) {
      return 'Invalid text';
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

    _senhaTextController ??= TextEditingController();
    _senhaFocusNode ??= FocusNode();

    _confirmaSenhaTextController ??= TextEditingController();
    _confirmaSenhaFocusNode ??= FocusNode();

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
    _senhaFocusNode?.dispose();
    _senhaTextController?.dispose();
    _confirmaSenhaFocusNode?.dispose();
    _confirmaSenhaTextController?.dispose();

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
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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

            await editarPropriedadePropriedadesRecord.reference
                .update(createPropriedadesRecordData(
              isDeleted: true,
              deletedAt: DateTime.now(),
            ));

            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Sucesso!'),
                  content: Text('Propriedade movida para a lixeira.'),
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

            await editarPropriedadePropriedadesRecord.reference
                .update(createPropriedadesRecordData(
              cpf: _cpfTextController.text,
              endereco: _enderecoTextController.text,
              displayName: _yourNameTextController.text,
              phoneNumber: _celularTextController.text,
              diasParaDg: _diasdgValue,
            ));
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
    return StreamBuilder<List<PropriedadesRecord>>(
      stream: queryPropriedadesRecord(
        parent: widget.uidTecnico,
        queryBuilder: (propriedadesRecord) => propriedadesRecord.where(
          'email',
          isEqualTo: widget.emailPropriedade,
        ),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF75E38),
                  ),
                ),
              ),
            ),
          );
        }
        List<PropriedadesRecord> editarPropriedadePropriedadesRecordList =
            snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final editarPropriedadePropriedadesRecord =
            editarPropriedadePropriedadesRecordList.isNotEmpty
                ? editarPropriedadePropriedadesRecordList.first
                : null;

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              backgroundColor: Color(0xFFF75E38),
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
            ),
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
                    if (!editarPropriedadePropriedadesRecord!
                        .hasUidPersonProdutor())
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _senhaTextController,
                            focusNode: _senhaFocusNode,
                            autofocus: false,
                            obscureText: !_senhaVisibility,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Senha Temporária',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 24.0, 0.0, 24.0),
                              suffixIcon: InkWell(
                                onTap: () => safeSetState(
                                  () => _senhaVisibility = !_senhaVisibility,
                                ),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _senhaVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22,
                                ),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            validator: _senhaTextControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    if (!editarPropriedadePropriedadesRecord
                        .hasUidPersonProdutor())
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _confirmaSenhaTextController,
                            focusNode: _confirmaSenhaFocusNode,
                            autofocus: false,
                            obscureText: !_confirmaSenhaVisibility,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Confirmar Senha',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 24.0, 0.0, 24.0),
                              suffixIcon: InkWell(
                                onTap: () => safeSetState(
                                  () => _confirmaSenhaVisibility =
                                      !_confirmaSenhaVisibility,
                                ),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _confirmaSenhaVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22,
                                ),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            validator: _confirmaSenhaTextControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    _p8(context, editarPropriedadePropriedadesRecord),
                    _p9(context, editarPropriedadePropriedadesRecord),
                    if (!editarPropriedadePropriedadesRecord
                        .hasUidPersonProdutor())
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
                              GoRouter.of(context).prepareAuthEvent();
                              if (_senhaTextController.text !=
                                  _confirmaSenhaTextController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'A confirmação da senha não corresponde à senha inicial. Por favor, verifique se as senhas digitadas são iguais e tente novamente. Se precisar de ajuda, estamos aqui para auxiliá-lo. Obrigado!',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final user =
                                  await authManager.createAccountWithEmail(
                                context,
                                _emailProdutorTextController.text,
                                _senhaTextController.text,
                              );
                              if (user == null) {
                                return;
                              }

                              var personRecordReference =
                                  PersonRecord.collection.doc(currentUserUid);
                              await personRecordReference.set({
                                ...createPersonRecordData(
                                  cpf: editarPropriedadePropriedadesRecord.cpf,
                                  uid: currentUserUid,
                                  endereco: editarPropriedadePropriedadesRecord
                                      .endereco,
                                  cidade: editarPropriedadePropriedadesRecord
                                      .cidade,
                                  email: widget.emailPropriedade,
                                  displayName:
                                      editarPropriedadePropriedadesRecord
                                          .displayName,
                                  phoneNumber:
                                      editarPropriedadePropriedadesRecord
                                          .phoneNumber,
                                  tipo: 'produtor',
                                ),
                                ...mapToFirestore(
                                  {
                                    'created_time':
                                        FieldValue.serverTimestamp(),
                                  },
                                ),
                              });
                              _uidPersonProdutor =
                                  PersonRecord.getDocumentFromData({
                                ...createPersonRecordData(
                                  cpf: editarPropriedadePropriedadesRecord.cpf,
                                  uid: currentUserUid,
                                  endereco: editarPropriedadePropriedadesRecord
                                      .endereco,
                                  cidade: editarPropriedadePropriedadesRecord
                                      .cidade,
                                  email: widget.emailPropriedade,
                                  displayName:
                                      editarPropriedadePropriedadesRecord
                                          .displayName,
                                  phoneNumber:
                                      editarPropriedadePropriedadesRecord
                                          .phoneNumber,
                                  tipo: 'produtor',
                                ),
                                ...mapToFirestore(
                                  {
                                    'created_time': DateTime.now(),
                                  },
                                ),
                              }, personRecordReference);
                              GoRouter.of(context).prepareAuthEvent();
                              await authManager.signOut();
                              GoRouter.of(context).clearRedirectLocation();

                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: ConfirmarSenhaWidget(
                                      email: widget.emailTecnico!,
                                      visitaPresencial:
                                          widget.visitaPresencial!,
                                      uidPersonProdutor:
                                          _uidPersonProdutor!.reference,
                                      emailProdutor: widget.emailPropriedade!,
                                      telefoneProdutor:
                                          editarPropriedadePropriedadesRecord
                                              .phoneNumber,
                                      enderecoProdutor:
                                          editarPropriedadePropriedadesRecord
                                              .endereco,
                                      nomeProdutor:
                                          editarPropriedadePropriedadesRecord
                                              .displayName,
                                      cpfProdutor:
                                          editarPropriedadePropriedadesRecord
                                              .cpf,
                                      diasparaDg:
                                          editarPropriedadePropriedadesRecord
                                              .diasParaDg,
                                      cidadeProdutor:
                                          editarPropriedadePropriedadesRecord
                                              .cidade,
                                      isEdit: true,
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));

                              safeSetState(() {});
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
