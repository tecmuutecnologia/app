import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import '/features/propriedades/presentation/widgets/confirmar_senha_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
//TODO Esta pedidndo para o tecnico confirmar a senha após criar a propriedade,
//isso acontece pela criação dos dados da conta do produtor, não seria mais facil
//armazenar a senha em um local seguro e deopis somente utilizar?? Outra coisa é que pede para gerar uma senha e depois manda um e-mail para a pessoa com uma senha padrão, não seria melhor remover os campos de gerar senha, e utilizar o cpf como senha padrão e no primeiro acesso do produtor pedir pra trocar, e informar no email que a senha é o cpf??

class NovaPropriedadePage extends StatefulWidget {
  const NovaPropriedadePage({
    super.key,
    required this.visitaPresencial,
    required this.uidTecnico,
    required this.email,
  });

  final bool? visitaPresencial;
  final DocumentReference? uidTecnico;
  final String? email;

  static String routeName = 'novaPropriedade';
  static String routePath = '/novaPropriedade';

  @override
  State<NovaPropriedadePage> createState() => _NovaPropriedadePageState();
}

class _NovaPropriedadePageState extends State<NovaPropriedadePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  FocusNode? _nomeFocusNode;
  TextEditingController? _nomeTextController;
  FocusNode? _cpfFocusNode;
  TextEditingController? _cpfTextController;
  late MaskTextInputFormatter _cpfMask;
  FocusNode? _emailFocusNode;
  TextEditingController? _emailTextController;
  FocusNode? _celularFocusNode;
  TextEditingController? _celularTextController;
  late MaskTextInputFormatter _celularMask;
  FocusNode? _cidadeFocusNode;
  TextEditingController? _cidadeTextController;
  FocusNode? _enderecoFocusNode;
  TextEditingController? _enderecoTextController;
  FocusNode? _cepFocusNode;
  TextEditingController? _cepTextController;
  late MaskTextInputFormatter _cepMask;
  FocusNode? _complementoFocusNode;
  TextEditingController? _complementoTextController;
  final String? Function(BuildContext, String?)?
      _complementoTextControllerValidator = null;
  String? _diasdgValue;
  FormFieldController<String>? _diasdgValueController;
  FocusNode? _senhaFocusNode;
  TextEditingController? _senhaTextController;
  bool _senhaVisibility = false;
  FocusNode? _confirmaSenhaFocusNode;
  TextEditingController? _confirmaSenhaTextController;
  bool _confirmaSenhaVisibility = false;

  // Outputs de query/criação (antes no FlutterFlowModel).
  PersonRecord? _outRetornoPersonExist;
  PropriedadesRecord? _outUidPersonCpf;
  PersonRecord? _uidPersonProdutor;

  String? _nomeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 5) {
      return 'Digite no mínimo 5 caracteres.';
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
    if (val.length < 11) {
      return 'Digite no mínimo 11 caracteres.';
    }
    if (val.length > 50) {
      return 'Máximo 50 caracteres.';
    }
    return null;
  }

  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 5) {
      return 'Digite no mínimo 5 caracteres.';
    }
    if (val.length > 150) {
      return 'Máximo 150 caracteres.';
    }
    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  String? _celularTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 12) {
      return 'Digite no mínimo 11 caracteres.';
    }
    if (val.length > 50) {
      return 'Máximo 12 caracteres.';
    }
    return null;
  }

  String? _cidadeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 5) {
      return 'Digite no mínimo 5 caracteres.';
    }
    if (val.length > 50) {
      return 'Máximo 50 caracteres.';
    }
    return null;
  }

  String? _enderecoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 3) {
      return 'Digite no mínimo 3 caracteres.';
    }
    if (val.length > 150) {
      return 'Máximo 150 caracteres.';
    }
    return null;
  }

  String? _cepTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 8) {
      return 'Digite no mínimo 8 caracteres.';
    }
    if (val.length > 10) {
      return 'Máximo 10 caracteres.';
    }
    return null;
  }

  String? _senhaTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 6) {
      return 'Mínimo 6 caracteres.';
    }
    if (val.length > 100) {
      return 'Máximo 100 caracteres.';
    }
    return null;
  }

  String? _confirmaSenhaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo é obrigatório.';
    }
    if (val.length < 6) {
      return 'Mínimo 6 caracteres.';
    }
    if (val.length > 100) {
      return 'Máximo 100 caracteres.';
    }
    if (val != _senhaTextController?.text) {
      return 'As senhas não correspondem.';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    _nomeTextController ??= TextEditingController();
    _nomeFocusNode ??= FocusNode();

    _cpfTextController ??= TextEditingController();
    _cpfFocusNode ??= FocusNode();
    _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');

    _emailTextController ??= TextEditingController();
    _emailFocusNode ??= FocusNode();

    _celularTextController ??= TextEditingController();
    _celularFocusNode ??= FocusNode();
    _celularMask = MaskTextInputFormatter(mask: '(##) #####-####');

    _cidadeTextController ??= TextEditingController();
    _cidadeFocusNode ??= FocusNode();

    _enderecoTextController ??= TextEditingController();
    _enderecoFocusNode ??= FocusNode();

    _cepTextController ??= TextEditingController();
    _cepFocusNode ??= FocusNode();
    _cepMask = MaskTextInputFormatter(mask: '#####-###');

    _complementoTextController ??= TextEditingController();
    _complementoFocusNode ??= FocusNode();

    _senhaTextController ??= TextEditingController();
    _senhaFocusNode ??= FocusNode();

    _confirmaSenhaTextController ??= TextEditingController();
    _confirmaSenhaFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _nomeFocusNode?.dispose();
    _nomeTextController?.dispose();
    _cpfFocusNode?.dispose();
    _cpfTextController?.dispose();
    _emailFocusNode?.dispose();
    _emailTextController?.dispose();
    _celularFocusNode?.dispose();
    _celularTextController?.dispose();
    _cidadeFocusNode?.dispose();
    _cidadeTextController?.dispose();
    _enderecoFocusNode?.dispose();
    _enderecoTextController?.dispose();
    _cepFocusNode?.dispose();
    _cepTextController?.dispose();
    _complementoFocusNode?.dispose();
    _complementoTextController?.dispose();
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
          'Adicionar propriedade',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.outfit(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
                color: Colors.white,
                fontSize: 22.0,
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

  Widget _p2(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _p4(context),
            _p5(context),
            _p6(context),
            _p7(context),
            _p8(context),
            _p9(context),
            _p10(context),
            _p11(context),
            _p12(context),
            _p13(context),
            _p14(context),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }

  Widget _p3(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 12.0),
      child: FFButtonWidget(
        onPressed: () async {
          var _shouldSetState = false;
          if (_formKey.currentState == null ||
              !_formKey.currentState!.validate()) {
            return;
          }
          if (_diasdgValue == null) {
            return;
          }
          _outRetornoPersonExist = await queryPersonRecordOnce(
            queryBuilder: (personRecord) => personRecord.where(Filter.or(
              Filter(
                'cpf',
                isEqualTo: _cpfTextController.text,
              ),
              Filter(
                'email',
                isEqualTo: _emailTextController.text,
              ),
            )),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          _shouldSetState = true;
          if (_outRetornoPersonExist != null) {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Usuário já possui cadastro!'),
                  content:
                      Text('E-mail e/ou cpf informado já possui um cadastro.'),
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
          } else {
            _outUidPersonCpf = await queryPropriedadesRecordOnce(
              parent: widget.uidTecnico,
              queryBuilder: (propriedadesRecord) => propriedadesRecord.where(
                'cpf',
                isEqualTo: _cpfTextController.text,
              ),
              singleRecord: true,
            ).then((s) => s.firstOrNull);
            _shouldSetState = true;
            if (_outUidPersonCpf != null) {
              await showDialog(
                context: context,
                builder: (alertDialogContext) {
                  return AlertDialog(
                    title: Text('CPF informado já cadastrado.'),
                    content: Text('Produtor já cadastrado.'),
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
            GoRouter.of(context).prepareAuthEvent();
            if (_senhaTextController.text != _senhaTextController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'A confirmação da senha não corresponde à senha inicial. Por favor, verifique se as senhas digitadas são iguais e tente novamente. Se precisar de ajuda, estamos aqui para auxiliá-lo. Obrigado!',
                  ),
                ),
              );
              return;
            }

            final user = await authManager.createAccountWithEmail(
              context,
              _emailTextController.text,
              _senhaTextController.text,
            );
            if (user == null) {
              return;
            }

            var personRecordReference =
                PersonRecord.collection.doc(currentUserUid);
            await personRecordReference.set(createPersonRecordData(
              cpf: _cpfTextController.text,
              uid: currentUserUid,
              endereco: _enderecoTextController.text,
              cidade: _cidadeTextController.text,
              email: _emailTextController.text,
              createdTime: getCurrentTimestamp,
              displayName: _nomeTextController.text,
              phoneNumber: _celularTextController.text,
              tipo: 'produtor',
            ));
            _uidPersonProdutor = PersonRecord.getDocumentFromData(
                createPersonRecordData(
                  cpf: _cpfTextController.text,
                  uid: currentUserUid,
                  endereco: _enderecoTextController.text,
                  cidade: _cidadeTextController.text,
                  email: _emailTextController.text,
                  createdTime: getCurrentTimestamp,
                  displayName: _nomeTextController.text,
                  phoneNumber: _celularTextController.text,
                  tipo: 'produtor',
                ),
                personRecordReference);
            _shouldSetState = true;
            GoRouter.of(context).prepareAuthEvent();
            await authManager.signOut();
            GoRouter.of(context).clearRedirectLocation();

            await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enableDrag: false,
              context: context,
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Padding(
                    padding: MediaQuery.viewInsetsOf(context),
                    child: ConfirmarSenhaWidget(
                      email: widget.email!,
                      visitaPresencial: widget.visitaPresencial!,
                      uidPersonProdutor: _uidPersonProdutor!.reference,
                      emailProdutor: _emailTextController.text,
                      telefoneProdutor: _celularTextController.text,
                      enderecoProdutor: _enderecoTextController.text,
                      nomeProdutor: _nomeTextController.text,
                      cpfProdutor: _cpfTextController.text,
                      diasparaDg: _diasdgValue!,
                      cidadeProdutor: _cidadeTextController.text,
                      isEdit: false,
                    ),
                  ),
                );
              },
            ).then((value) => safeSetState(() {}));
          }

          if (_shouldSetState) safeSetState(() {});
        },
        text: 'Cadastrar nova',
        icon: Icon(
          Icons.save,
          size: 15.0,
        ),
        options: FFButtonOptions(
          width: double.infinity,
          height: 48.0,
          padding: EdgeInsets.all(0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: Color(0xFFEC3B5B),
          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
                color: Colors.white,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
              ),
          elevation: 4.0,
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(60.0),
        ),
      ),
    );
  }

  Widget _p4(BuildContext context) {
    return TextFormField(
      controller: _nomeTextController,
      focusNode: _nomeFocusNode,
      autofocus: true,
      textInputAction: TextInputAction.next,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Nome produtor',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
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
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _nomeTextControllerValidator.asValidator(context),
    );
  }

  Widget _p5(BuildContext context) {
    return TextFormField(
      controller: _cpfTextController,
      focusNode: _cpfFocusNode,
      autofocus: true,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'CPF',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
      maxLength: 14,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      keyboardType: TextInputType.number,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _cpfTextControllerValidator.asValidator(context),
      inputFormatters: [_cpfMask],
    );
  }

  Widget _p6(BuildContext context) {
    return TextFormField(
      controller: _emailTextController,
      focusNode: _emailFocusNode,
      autofocus: true,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'E-mail',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _emailTextControllerValidator.asValidator(context),
    );
  }

  Widget _p7(BuildContext context) {
    return TextFormField(
      controller: _celularTextController,
      focusNode: _celularFocusNode,
      autofocus: true,
      textCapitalization: TextCapitalization.none,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Celular',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
      maxLength: 15,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      keyboardType: TextInputType.number,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _celularTextControllerValidator.asValidator(context),
      inputFormatters: [_celularMask],
    );
  }

  Widget _p8(BuildContext context) {
    return TextFormField(
      controller: _cidadeTextController,
      focusNode: _cidadeFocusNode,
      autofocus: true,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Cidade/UF',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _cidadeTextControllerValidator.asValidator(context),
    );
  }

  Widget _p9(BuildContext context) {
    return TextFormField(
      controller: _enderecoTextController,
      focusNode: _enderecoFocusNode,
      autofocus: true,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Endereço',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _enderecoTextControllerValidator.asValidator(context),
    );
  }

  Widget _p10(BuildContext context) {
    return TextFormField(
      controller: _cepTextController,
      focusNode: _cepFocusNode,
      autofocus: true,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'CEP',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
      maxLength: 9,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      keyboardType: TextInputType.number,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _cepTextControllerValidator.asValidator(context),
      inputFormatters: [_cepMask],
    );
  }

  Widget _p11(BuildContext context) {
    return TextFormField(
      controller: _complementoTextController,
      focusNode: _complementoFocusNode,
      autofocus: true,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Complemento',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _complementoTextControllerValidator.asValidator(context),
    );
  }

  Widget _p12(BuildContext context) {
    return FlutterFlowDropDown<String>(
      controller: _diasdgValueController ??= FormFieldController<String>(
        _diasdgValue ??= '28',
      ),
      options: List<String>.from(['28', '30', '40', '21']),
      optionLabels: [
        '28 Dias para Diagnóstico Gestação (DG)',
        '30 Dias para Diagnóstico Gestação (DG)',
        '40 Dias para Diagnóstico Gestação (DG)',
        '21 Dias para Diagnóstico Gestação (DG)'
      ],
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
    );
  }

  Widget _p13(BuildContext context) {
    return TextFormField(
      controller: _senhaTextController,
      focusNode: _senhaFocusNode,
      autofocus: true,
      obscureText: !_senhaVisibility,
      decoration: InputDecoration(
        labelText: 'Senha temporária',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
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
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _senhaTextControllerValidator.asValidator(context),
    );
  }

  Widget _p14(BuildContext context) {
    return TextFormField(
      controller: _confirmaSenhaTextController,
      focusNode: _confirmaSenhaFocusNode,
      autofocus: true,
      obscureText: !_confirmaSenhaVisibility,
      decoration: InputDecoration(
        labelText: 'Repita a Senha temporária',
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
            ),
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
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
            color: FlutterFlowTheme.of(context).primary,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        suffixIcon: InkWell(
          onTap: () => safeSetState(
            () => _confirmaSenhaVisibility = !_confirmaSenhaVisibility,
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
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.readexPro(
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      cursorColor: FlutterFlowTheme.of(context).primary,
      validator: _confirmaSenhaTextControllerValidator.asValidator(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _p2(context),
                  _p3(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
