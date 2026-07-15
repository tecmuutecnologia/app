import '/core/ui/app_card.dart';
import '/data/backend.dart';
import '/core/ui/flutter_flow_drop_down.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/form_field_controller.dart';
import '/core/di/providers.dart';
import '/data/objectbox/entities/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Offline-first: o Salvar grava a propriedade apenas na base local (ObjectBox)
/// marcada como conta NÃO criada. A criação da conta do produtor (Firebase Auth)
/// + escrita no Firestore fica para a "ativação" online, disparada na lista.

class NovaPropriedadePage extends ConsumerStatefulWidget {
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
  ConsumerState<NovaPropriedadePage> createState() =>
      _NovaPropriedadePageState();
}

class _NovaPropriedadePageState extends ConsumerState<NovaPropriedadePage> {
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

    super.dispose();
  }

  Widget navBar(BuildContext context) {
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
            icon: const Icon(
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

  Widget formulario(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            inputNome(context),
            inputCPF(context),
            inputEmail(context),
            inputCelular(context),
            inputCidade(context),
            inputEndereco(context),
            inputCEP(context),
            inputComplemento(context),
            inputDiasDG(context),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }

  Widget btnSalvar(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 12.0),
      child: FFButtonWidget(
        onPressed: () async {
          if (_formKey.currentState == null ||
              !_formKey.currentState!.validate()) {
            return;
          }
          if (_diasdgValue == null) {
            return;
          }

          final cpf = _cpfTextController.text;
          final email = _emailTextController.text;

          final propriedadeRepo = ref.read(propriedadeRepositoryProvider);
          final personRepo = ref.read(personRepositoryProvider);
          final connectivity = ref.read(connectivityServiceProvider);

          // --- Checagem de duplicidade (offline-first, híbrida) ---------------
          // Sempre checa a base local; quando há internet, também o Firestore.
          final localPersonDup =
              personRepo.getByCpf(cpf) ?? personRepo.getByEmail(email);
          final localPropriedadeDup = propriedadeRepo.getByCpf(cpf) ??
              propriedadeRepo.getByEmail(email);

          var personDupOnline = false;
          var propriedadeDupCpfOnline = false;
          if (connectivity.isOnline) {
            personDupOnline = await queryPersonRecordOnce(
              queryBuilder: (personRecord) => personRecord.where(Filter.or(
                Filter('cpf', isEqualTo: cpf),
                Filter('email', isEqualTo: email),
              )),
              singleRecord: true,
            ).then((s) => s.firstOrNull != null);
            propriedadeDupCpfOnline = await queryPropriedadesRecordOnce(
              parent: widget.uidTecnico,
              queryBuilder: (propriedadesRecord) =>
                  propriedadesRecord.where('cpf', isEqualTo: cpf),
              singleRecord: true,
            ).then((s) => s.firstOrNull != null);
          }

          if (!mounted) return;

          if (localPersonDup != null || personDupOnline) {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: const Text('Usuário já possui cadastro!'),
                  content: const Text(
                      'E-mail e/ou cpf informado já possui um cadastro.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: const Text('Ok'),
                    ),
                  ],
                );
              },
            );
            return;
          }

          if (localPropriedadeDup != null || propriedadeDupCpfOnline) {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: const Text('CPF informado já cadastrado.'),
                  content: const Text('Produtor já cadastrado.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: const Text('Ok'),
                    ),
                  ],
                );
              },
            );
            return;
          }

          // --- Salva apenas localmente, como PENDENTE de ativação -------------
          propriedadeRepo.saveLocalPending(PropriedadeEntity(
            parentPath: widget.uidTecnico?.path,
            email: email,
            displayName: _nomeTextController.text,
            cpf: cpf,
            endereco: _enderecoTextController.text,
            cidade: _cidadeTextController.text,
            phoneNumber: _celularTextController.text,
            diasParaDg: _diasdgValue,
          ));

          if (!mounted) return;

          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: const Text('Propriedade salva!'),
                content: const Text(
                    'A propriedade foi salva no dispositivo. Ative a conta do '
                    'produtor pelo botão "Ativar conta" na lista quando houver '
                    'conexão com a internet.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );

          if (!mounted) return;
          Navigator.of(context).pop();
        },
        text: 'Salvar',
        icon: const Icon(
          Icons.save,
          size: 15.0,
        ),
        options: FFButtonOptions(
          width: double.infinity,
          height: 48.0,
          padding: const EdgeInsets.all(0.0),
          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).salvar,
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
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(60.0),
        ),
      ),
    );
  }

  Widget inputNome(BuildContext context) {
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
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
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

  Widget inputCPF(BuildContext context) {
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
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
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

  Widget inputEmail(BuildContext context) {
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
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
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

  Widget inputCelular(BuildContext context) {
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
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
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

  Widget inputCidade(BuildContext context) {
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
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
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

  Widget inputEndereco(BuildContext context) {
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
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
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

  Widget inputCEP(BuildContext context) {
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
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
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

  Widget inputComplemento(BuildContext context) {
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
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
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

  Widget inputDiasDG(BuildContext context) {
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
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
              decoration: const BoxDecoration(
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
                actions: const [],
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      navBar(context),
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
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formulario(context),
                  btnSalvar(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
