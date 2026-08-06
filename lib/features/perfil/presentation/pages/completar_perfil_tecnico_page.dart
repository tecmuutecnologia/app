import '/core/auth/firebase_auth/auth_util.dart';
import '/data/backend.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/app_card.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/features/sincronizacao/presentation/pages/sync_page.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CompletarPerfilTecnicoPage extends StatefulWidget {
  const CompletarPerfilTecnicoPage({super.key});

  static String routeName = 'completarPerfilTecnico';
  static String routePath = '/completarPerfilTecnico';

  @override
  State<CompletarPerfilTecnicoPage> createState() =>
      _CompletarPerfilTecnicoPageState();
}

class _CompletarPerfilTecnicoPageState
    extends State<CompletarPerfilTecnicoPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  FocusNode? _nomeFocusNode;
  TextEditingController? _nomeTextController;
  FocusNode? _empresaFocusNode;
  TextEditingController? _empresaTextController;
  final String? Function(BuildContext, String?)?
      _empresaTextControllerValidator = null;
  FocusNode? _cpfFocusNode;
  TextEditingController? _cpfTextController;
  late MaskTextInputFormatter _cpfMask;
  FocusNode? _dtnascimentoFocusNode;
  TextEditingController? _dtnascimentoTextController;
  late MaskTextInputFormatter _dtnascimentoMask;
  FocusNode? _celularFocusNode;
  TextEditingController? _celularTextController;
  late MaskTextInputFormatter _celularMask;
  FocusNode? _cidadeufFocusNode;
  TextEditingController? _cidadeufTextController;
  FocusNode? _enderecoFocusNode;
  TextEditingController? _enderecoTextController;
  FocusNode? _bairroFocusNode;
  TextEditingController? _bairroTextController;

  // Outputs de query/criação (antes no FlutterFlowModel).
  PersonRecord? _outUidPersonExists;
  TecnicoRecord? _outUidTecnico;
  AssinaturaTecnicoRecord? _outAssinaturaTecnico;

  String? _nomeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 5) {
      return 'Mínimo 5 caracteres.';
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
    return null;
  }

  String? _dtnascimentoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 10) {
      return 'Mínimo 10 caracteres.';
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
    return null;
  }

  String? _cidadeufTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 10) {
      return 'Mínimo 10 caracteres.';
    }
    return null;
  }

  String? _enderecoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 3) {
      return 'Mínimo 3 caracteres.';
    }
    return null;
  }

  String? _bairroTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 3) {
      return 'Mínimo 3 caracteres.';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    _nomeTextController ??= TextEditingController();
    _nomeFocusNode ??= FocusNode();

    _empresaTextController ??= TextEditingController();
    _empresaFocusNode ??= FocusNode();

    _cpfTextController ??= TextEditingController();
    _cpfFocusNode ??= FocusNode();
    _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');

    _dtnascimentoTextController ??= TextEditingController();
    _dtnascimentoFocusNode ??= FocusNode();
    _dtnascimentoMask = MaskTextInputFormatter(mask: '##/##/####');

    _celularTextController ??= TextEditingController();
    _celularFocusNode ??= FocusNode();
    _celularMask = MaskTextInputFormatter(mask: '(##) #####-####');

    _cidadeufTextController ??= TextEditingController();
    _cidadeufFocusNode ??= FocusNode();

    _enderecoTextController ??= TextEditingController();
    _enderecoFocusNode ??= FocusNode();

    _bairroTextController ??= TextEditingController();
    _bairroFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _nomeFocusNode?.dispose();
    _nomeTextController?.dispose();
    _empresaFocusNode?.dispose();
    _empresaTextController?.dispose();
    _cpfFocusNode?.dispose();
    _cpfTextController?.dispose();
    _dtnascimentoFocusNode?.dispose();
    _dtnascimentoTextController?.dispose();
    _celularFocusNode?.dispose();
    _celularTextController?.dispose();
    _cidadeufFocusNode?.dispose();
    _cidadeufTextController?.dispose();
    _enderecoFocusNode?.dispose();
    _enderecoTextController?.dispose();
    _bairroFocusNode?.dispose();
    _bairroTextController?.dispose();

    super.dispose();
  }

  Widget _conteudo(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 32.0),
      child: Container(
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/logo-2.png',
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _formulario(
      BuildContext context, dynamic completarPerfilTecnicoPersonRecord) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 570.0,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: AppTokens.softShadow(context),
            borderRadius: BorderRadius.circular(AppTokens.radius),
          ),
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _titulo(context),
                  _campoNome(context),
                  _campoEmpresa(context),
                  _campoCpf(context),
                  _campoDataNascimento(context),
                  _campoCelular(context),
                  _campoCidadeUf(context),
                  _campoEndereco(context),
                  _campoBairro(context),
                  _secaoPlano(context, completarPerfilTecnicoPersonRecord),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titulo(BuildContext context) {
    return Text(
      'Complete seu cadastro Técnico',
      textAlign: TextAlign.center,
      style: FlutterFlowTheme.of(context).displaySmall.override(
            font: GoogleFonts.outfit(
              fontWeight: FlutterFlowTheme.of(context).displaySmall.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
            ),
            fontSize: 30.0,
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).displaySmall.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
          ),
    );
  }

  Widget _campoNome(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _nomeTextController,
          focusNode: _nomeFocusNode,
          autofocus: true,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Nome completo*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 16.0,
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
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTokens.secondary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            contentPadding: EdgeInsets.all(24.0),
            prefixIcon: Icon(
              Icons.person,
            ),
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
          maxLength: 100,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          validator: _nomeTextControllerValidator.asValidator(context),
        ),
      ),
    );
  }

  Widget _campoEmpresa(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _empresaTextController,
          focusNode: _empresaFocusNode,
          autofocus: true,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Empresa',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 16.0,
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
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTokens.secondary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            contentPadding: EdgeInsets.all(24.0),
            prefixIcon: Icon(
              Icons.person,
            ),
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
          maxLength: 100,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          validator: _empresaTextControllerValidator.asValidator(context),
        ),
      ),
    );
  }

  Widget _campoCpf(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _cpfTextController,
          focusNode: _cpfFocusNode,
          autofocus: true,
          textCapitalization: TextCapitalization.none,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'CPF*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 16.0,
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
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTokens.secondary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(24.0),
            prefixIcon: Icon(
              Icons.content_copy,
            ),
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
          maxLength: 14,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          keyboardType: TextInputType.number,
          validator: _cpfTextControllerValidator.asValidator(context),
          inputFormatters: [_cpfMask],
        ),
      ),
    );
  }

  Widget _campoDataNascimento(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _dtnascimentoTextController,
          focusNode: _dtnascimentoFocusNode,
          autofocus: true,
          textCapitalization: TextCapitalization.none,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Data nascimento*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 16.0,
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
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTokens.secondary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(24.0),
            prefixIcon: Icon(
              Icons.calendar_today,
            ),
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
          maxLength: 10,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          keyboardType: TextInputType.number,
          validator: _dtnascimentoTextControllerValidator.asValidator(context),
          inputFormatters: [_dtnascimentoMask],
        ),
      ),
    );
  }

  Widget _campoCelular(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _celularTextController,
          focusNode: _celularFocusNode,
          autofocus: true,
          textCapitalization: TextCapitalization.none,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Celular*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 16.0,
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
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTokens.secondary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(24.0),
            prefixIcon: Icon(
              Icons.call,
            ),
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
          maxLength: 15,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          keyboardType: TextInputType.number,
          validator: _celularTextControllerValidator.asValidator(context),
          inputFormatters: [_celularMask],
        ),
      ),
    );
  }

  Widget _campoCidadeUf(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _cidadeufTextController,
          focusNode: _cidadeufFocusNode,
          autofocus: true,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Cidade/UF*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 16.0,
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
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTokens.secondary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            contentPadding: EdgeInsets.all(24.0),
            prefixIcon: Icon(
              Icons.location_pin,
            ),
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
          maxLength: 100,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          validator: _cidadeufTextControllerValidator.asValidator(context),
        ),
      ),
    );
  }

  Widget _campoEndereco(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _enderecoTextController,
          focusNode: _enderecoFocusNode,
          autofocus: true,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Endereço*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 16.0,
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
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTokens.secondary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            contentPadding: EdgeInsets.all(24.0),
            prefixIcon: Icon(
              Icons.location_pin,
            ),
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
          maxLength: 100,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          validator: _enderecoTextControllerValidator.asValidator(context),
        ),
      ),
    );
  }

  Widget _campoBairro(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _bairroTextController,
          focusNode: _bairroFocusNode,
          autofocus: true,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Bairro*',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
                  fontSize: 16.0,
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
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTokens.secondary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            contentPadding: EdgeInsets.all(24.0),
            prefixIcon: Icon(
              Icons.location_pin,
            ),
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
          maxLength: 50,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          validator: _bairroTextControllerValidator.asValidator(context),
        ),
      ),
    );
  }

  Widget _secaoPlano(
      BuildContext context, dynamic completarPerfilTecnicoPersonRecord) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
        child: StreamBuilder<List<PlanosTecnicosRecord>>(
          stream: queryPlanosTecnicosRecord(
            queryBuilder: (planosTecnicosRecord) => planosTecnicosRecord.where(
              'nome',
              isEqualTo: 'Start',
            ),
            singleRecord: true,
          ),
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
            List<PlanosTecnicosRecord> btnAvancarPlanosTecnicosRecordList =
                snapshot.data!;
            // Return an empty Container when the item does not exist.
            if (snapshot.data!.isEmpty) {
              return Container();
            }
            final btnAvancarPlanosTecnicosRecord =
                btnAvancarPlanosTecnicosRecordList.isNotEmpty
                    ? btnAvancarPlanosTecnicosRecordList.first
                    : null;

            return FFButtonWidget(
              onPressed: () async {
                var _shouldSetState = false;
                if (_formKey.currentState == null ||
                    !_formKey.currentState!.validate()) {
                  return;
                }
                _outUidPersonExists = await queryPersonRecordOnce(
                  queryBuilder: (personRecord) => personRecord.where(
                    'cpf',
                    isEqualTo: _cpfTextController.text,
                  ),
                  singleRecord: true,
                ).then((s) => s.firstOrNull);
                _shouldSetState = true;
                if (_outUidPersonExists != null) {
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text('CPF informado já possui um cadastro.'),
                        content: Text('Informe outro CPF para continuar.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(alertDialogContext),
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                  if (_shouldSetState) safeSetState(() {});
                  return;
                }

                await completarPerfilTecnicoPersonRecord!.reference
                    .update(createPersonRecordData(
                  dtNascimento: _dtnascimentoTextController.text,
                  cpf: _cpfTextController.text,
                  endereco: _enderecoTextController.text,
                  cidade: _cidadeufTextController.text,
                  bairro: _bairroTextController.text,
                  displayName: _nomeTextController.text,
                  phoneNumber: _celularTextController.text,
                  empresa: _empresaTextController.text,
                ));

                var tecnicoRecordReference = TecnicoRecord.collection.doc();
                await tecnicoRecordReference.set(createTecnicoRecordData(
                  uidPerson: completarPerfilTecnicoPersonRecord.reference.id,
                  liberado: true,
                  limiteProdutoresContratado: 3,
                  quantidadeProdutoresCadastrados: 0,
                  restanteLimiteProdutores: 3,
                  limiteAnimaisContratado: 50,
                  quantidadeAnimaisCadastrados: 0,
                  restanteLimiteAnimais: 50,
                ));
                _outUidTecnico = TecnicoRecord.getDocumentFromData(
                    createTecnicoRecordData(
                      uidPerson:
                          completarPerfilTecnicoPersonRecord.reference.id,
                      liberado: true,
                      limiteProdutoresContratado: 3,
                      quantidadeProdutoresCadastrados: 0,
                      restanteLimiteProdutores: 3,
                      limiteAnimaisContratado: 50,
                      quantidadeAnimaisCadastrados: 0,
                      restanteLimiteAnimais: 50,
                    ),
                    tecnicoRecordReference);
                _shouldSetState = true;

                var assinaturaTecnicoRecordReference =
                    AssinaturaTecnicoRecord.collection.doc();
                await assinaturaTecnicoRecordReference
                    .set(createAssinaturaTecnicoRecordData(
                  idTecnico: _outUidTecnico?.reference,
                  idPlano: btnAvancarPlanosTecnicosRecord?.reference,
                  dtAssinatura: getCurrentTimestamp,
                  dtExpiracao: getCurrentTimestamp,
                ));
                _outAssinaturaTecnico =
                    AssinaturaTecnicoRecord.getDocumentFromData(
                        createAssinaturaTecnicoRecordData(
                          idTecnico: _outUidTecnico?.reference,
                          idPlano: btnAvancarPlanosTecnicosRecord?.reference,
                          dtAssinatura: getCurrentTimestamp,
                          dtExpiracao: getCurrentTimestamp,
                        ),
                        assinaturaTecnicoRecordReference);
                _shouldSetState = true;

                await AssinaturaAtivaTecnicoRecord.collection
                    .doc()
                    .set(createAssinaturaAtivaTecnicoRecordData(
                      tipoPlano: '30',
                      dtAssinatura: getCurrentTimestamp,
                      dtExpiracao: getCurrentTimestamp,
                      idAssinaturaTecnico: _outAssinaturaTecnico?.reference,
                      nomePlano: 'Plano Start',
                    ));

                context.pushNamed(
                  SyncPage.routeName,
                  queryParameters: {'papel': 'tecnico'},
                );

                if (_shouldSetState) safeSetState(() {});
              },
              text: 'Completar e avançar',
              options: FFButtonOptions(
                width: double.infinity,
                height: 52.0,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: Color(0xFFF75E38),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
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
                borderRadius: BorderRadius.circular(40.0),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PersonRecord>>(
      stream: queryPersonRecord(
        queryBuilder: (personRecord) => personRecord.where(
          'uid',
          isEqualTo: currentUserUid,
        ),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFFEC3B5B),
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
        List<PersonRecord> completarPerfilTecnicoPersonRecordList =
            snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final completarPerfilTecnicoPersonRecord =
            completarPerfilTecnicoPersonRecordList.isNotEmpty
                ? completarPerfilTecnicoPersonRecordList.first
                : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFFEC3B5B),
            body: SafeArea(
              top: true,
              child: Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _conteudo(context),
                      _formulario(context, completarPerfilTecnicoPersonRecord),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
