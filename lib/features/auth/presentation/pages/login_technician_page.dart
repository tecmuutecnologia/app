import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/auth/firebase_auth/auth_util.dart';
import '/data/objectbox/offline_auth_service.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/app_card.dart';
import '/features/auth/presentation/pages/create_account_technician_page.dart';
import '/features/auth/presentation/pages/sync_technician_page.dart';
import '../controllers/login_technician_controller.dart';

/// Tela de login do técnico.
///
/// **Receita-ouro** da migração FlutterFlow→Flutter (feature-first):
/// - `ConsumerStatefulWidget` (acesso a `ref` para o Riverpod);
/// - controllers/focus de `TextField` vivem no `State` (ciclo de vida de UI);
/// - estado de view (visibilidade da senha) no
///   [LoginTechnicianController]/[LoginTechnicianState];
/// - sem `createModel`/`FlutterFlowModel` e sem `import '/index.dart'`.
class LoginTechnicianPage extends ConsumerStatefulWidget {
  const LoginTechnicianPage({super.key});

  static String routeName = 'loginTechnician';
  static String routePath = '/loginTechnician';

  @override
  ConsumerState<LoginTechnicianPage> createState() =>
      _LoginTechnicianPageState();
}

class _LoginTechnicianPageState extends ConsumerState<LoginTechnicianPage>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  late final TextEditingController _emailController;
  late final FocusNode _emailFocusNode;
  late final TextEditingController _passwordController;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 140.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.9, 0.9),
            end: Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(-0.349, 0),
            end: Offset(0, 0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Widget _p1(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
        width: 100.0,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: AlignmentDirectional(0.7, 0.0),
            image: Image.asset(
              'assets/images/veterinary-farm-walking-cowshed-checking-cows.jpg',
            ).image,
          ),
          gradient: LinearGradient(
            colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
            stops: [0.0, 1.0],
            begin: AlignmentDirectional(0.87, -1.0),
            end: AlignmentDirectional(-0.87, 1.0),
          ),
        ),
        alignment: AlignmentDirectional(0.0, -1.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _p2(context),
              _p3(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _p2(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 70.0, 0.0, 32.0),
      child: Container(
        width: 200.0,
        height: 140.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/logo-2.png',
            width: 130.0,
            height: 130.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _p3(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
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
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _p4(context),
                _p5(context),
                _p6(context),
                _p7(context),
                _p8(context),
                _p9(context),
                _p10(context),
              ],
            ),
          ),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }

  Widget _p4(BuildContext context) {
    return Text(
      'Login',
      textAlign: TextAlign.center,
      style: FlutterFlowTheme.of(context).displaySmall.override(
            font: GoogleFonts.outfit(
              fontWeight: FlutterFlowTheme.of(context).displaySmall.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
            ),
            letterSpacing: 0.0,
            fontWeight: FlutterFlowTheme.of(context).displaySmall.fontWeight,
            fontStyle: FlutterFlowTheme.of(context).displaySmall.fontStyle,
          ),
    );
  }

  Widget _p5(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 24.0),
      child: Text(
        'Preencha os campos\nabaixo para entrar',
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

  Widget _p6(BuildContext context) {
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
                color: FlutterFlowTheme.of(context).primaryBackground,
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
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
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

  Widget _p7(BuildContext context) {
    final passwordVisibility =
        ref.watch(loginTechnicianControllerProvider).passwordVisibility;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          autofocus: true,
          autofillHints: [AutofillHints.password],
          obscureText: !passwordVisibility,
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
                color: FlutterFlowTheme.of(context).primaryBackground,
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
            suffixIcon: InkWell(
              onTap: () => ref
                  .read(loginTechnicianControllerProvider.notifier)
                  .togglePasswordVisibility(),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                passwordVisibility
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
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: FFButtonWidget(
        onPressed: () async {
          GoRouter.of(context).prepareAuthEvent();

          final user = await authManager.signInWithEmail(
            context,
            _emailController.text,
            _passwordController.text,
          );
          if (user == null) {
            return;
          }

          context.pushNamedAuth(SyncTechnicianPage.routeName, context.mounted);
        },
        text: 'Entrar',
        options: FFButtonOptions(
          width: double.infinity,
          height: 44.0,
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: Color(0xFFF75E38),
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
          elevation: 3.0,
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _p9(BuildContext context) {
    return // Login offline por biometria/PIN: só aparece se
        // há sessão salva no cofre e o aparelho suporta.
        FutureBuilder<bool>(
      future: OfflineAuthService.instance.then((s) => s.podeUsarBiometria()),
      builder: (context, snapBio) {
        if (snapBio.data != true) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
          child: FFButtonWidget(
            onPressed: () async {
              final service = await OfflineAuthService.instance;
              final session = await service.loginOfflineComBiometria();
              if (session != null && context.mounted) {
                context.pushNamedAuth(
                    SyncTechnicianPage.routeName, context.mounted);
              }
            },
            text: 'Entrar com biometria',
            icon: const Icon(Icons.fingerprint, size: 22.0),
            options: FFButtonOptions(
              width: double.infinity,
              height: 44.0,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.readexPro(),
                    color: const Color(0xFFF75E38),
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderSide: const BorderSide(
                color: Color(0xFFF75E38),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );
      },
    );
  }

  Widget _p10(BuildContext context) {
    return // You will have to add an action on this rich text to go to your login page.
        Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(CreateAccountTechnicianPage.routeName);
        },
        child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Não tem uma conta? ',
                style: TextStyle(),
              ),
              TextSpan(
                text: 'Assine aqui',
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
                    context.pushNamed(CreateAccountTechnicianPage.routeName);
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
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _p1(context),
          ],
        ),
      ),
    );
  }
}
