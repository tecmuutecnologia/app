import '/core/auth/firebase_auth/auth_util.dart';
import '/data/backend.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/app_card.dart';
import '/features/auth/presentation/pages/login_technician_page.dart';
import '/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountTechnicianPage extends StatefulWidget {
  const CreateAccountTechnicianPage({super.key});

  static String routeName = 'createAccountTechnician';
  static String routePath = '/createAccountTechnician';

  @override
  State<CreateAccountTechnicianPage> createState() =>
      _CreateAccountTechnicianPageState();
}

class _CreateAccountTechnicianPageState
    extends State<CreateAccountTechnicianPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late final TextEditingController _emailController;
  late final FocusNode _emailFocusNode;
  late final TextEditingController _passwordController;
  late final FocusNode _passwordFocusNode;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _confirmPasswordFocusNode;
  bool _passwordVisibility = false;
  bool _confirmPasswordVisibility = false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _confirmPasswordController = TextEditingController();
    _confirmPasswordFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _emailController.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    _confirmPasswordFocusNode.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Widget _p1(BuildContext context) {
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

  Widget _p2(BuildContext context) {
    return Padding(
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
                _p3(context),
                _p4(context),
                _p5(context),
                _p6(context),
                _p7(context),
                _p8(context),
                _p9(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _p3(BuildContext context) {
    return Text(
      'Cadastro Técnico',
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

  Widget _p4(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 24.0),
      child: Text(
        'Vamos começar preenchendo o formulário abaixo.',
        textAlign: TextAlign.center,
        style: FlutterFlowTheme.of(context).labelLarge.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
            ),
      ),
    );
  }

  Widget _p5(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          autofocus: true,
          autofillHints: [AutofillHints.email],
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'E-mail',
            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
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
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            contentPadding: EdgeInsets.all(24.0),
            prefixIcon: Icon(
              Icons.email,
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
          keyboardType: TextInputType.emailAddress,
        ),
      ),
    );
  }

  Widget _p6(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          autofocus: true,
          autofillHints: [AutofillHints.password],
          obscureText: !_passwordVisibility,
          decoration: InputDecoration(
            labelText: 'Senha',
            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
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
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            contentPadding: EdgeInsets.all(24.0),
            suffixIcon: InkWell(
              onTap: () => safeSetState(
                () => _passwordVisibility = !_passwordVisibility,
              ),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                _passwordVisibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
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
        ),
      ),
    );
  }

  Widget _p7(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          autofocus: true,
          autofillHints: [AutofillHints.password],
          obscureText: !_confirmPasswordVisibility,
          decoration: InputDecoration(
            labelText: 'Confirme sua senha',
            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.readexPro(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
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
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            contentPadding: EdgeInsets.all(24.0),
            suffixIcon: InkWell(
              onTap: () => safeSetState(
                () => _confirmPasswordVisibility = !_confirmPasswordVisibility,
              ),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                _confirmPasswordVisibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
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
        ),
      ),
    );
  }

  Widget _p8(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
        child: FFButtonWidget(
          onPressed: () async {
            GoRouter.of(context).prepareAuthEvent();
            if (_passwordController.text != _confirmPasswordController.text) {
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
              _emailController.text,
              _passwordController.text,
            );
            if (user == null) {
              return;
            }

            await PersonRecord.collection
                .doc(currentUserUid)
                .set(createPersonRecordData(
                  uid: currentUserUid,
                ));

            context.goNamedAuth(
                CompletarPerfilTecnicoPage.routeName, context.mounted);
          },
          text: 'Criar conta',
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
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
            elevation: 3.0,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }

  Widget _p9(BuildContext context) {
    return // You will have to add an action on this rich text to go to your login page.
        Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.pushNamed(LoginTechnicianPage.routeName);
          },
          child: RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Já tem uma conta? ',
                  style: TextStyle(),
                ),
                TextSpan(
                  text: 'Entrar',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  mouseCursor: SystemMouseCursors.click,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      }
                      context.pushNamed(
                        LoginTechnicianPage.routeName,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                          ),
                        },
                      );
                    },
                )
              ],
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
            ),
          ),
        ),
      ),
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
                  _p1(context),
                  _p2(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
