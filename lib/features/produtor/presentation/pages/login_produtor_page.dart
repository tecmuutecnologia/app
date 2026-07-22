import '/core/auth/firebase_auth/auth_util.dart';
import '/data/backend.dart';
import '/data/objectbox/offline_auth_service.dart';
import '/core/ui/flutter_flow_animations.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/produtor/presentation/pages/inicio_propriedade_produtor_page.dart';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Importa os widgets refatorados
import '../widgets/widgets.dart';

/// Tela de login do produtor.
///
/// Esta versão utiliza componentes separados para melhor manutenção:
/// - [LoginBackground]: Fundo com gradiente e imagem
/// - [LoginLogo]: Logo do aplicativo
/// - [LoginFormCard]: Card container do formulário
/// - [LoginHeader]: Título e subtítulo
/// - [EmailTextField]: Campo de email
/// - [PasswordTextField]: Campo de senha com toggle
/// - [LoginButton]: Botão de login estilizado
class LoginProdutorPage extends StatefulWidget {
  const LoginProdutorPage({super.key});

  static String routeName = 'loginProdutor';
  static String routePath = '/loginProdutor';

  @override
  State<LoginProdutorPage> createState() => _LoginProdutorPageState();
}

class _LoginProdutorPageState extends State<LoginProdutorPage>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  late final TextEditingController _emailController;
  late final FocusNode _emailFocusNode;
  late final TextEditingController _passwordController;
  late final FocusNode _passwordFocusNode;
  bool _passwordVisibility = false;
  final String? Function(BuildContext, String?)? _emailValidator = null;
  final String? Function(BuildContext, String?)? _passwordValidator = null;

  @override
  void initState() {
    super.initState();

    _initializeTextControllers();
    _setupAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Inicializa os controladores de texto.
  void _initializeTextControllers() {
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
  }

  /// Configura as animações da página.
  void _setupAnimations() {
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
            begin: const Offset(0.0, 140.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(-0.349, 0),
            end: const Offset(0, 0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _emailController.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
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
            Expanded(
              flex: 6,
              child: LoginBackground(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LoginLogo(),
                      _buildLoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o formulário de login com animação.
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LoginFormCard(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const LoginHeader(),
            _buildEmailField(),
            _buildPasswordField(),
            _buildLoginButton(),
            _buildBiometricButton(),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
  }

  /// Constrói o campo de email.
  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: EmailTextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        validator: _emailValidator,
      ),
    );
  }

  /// Constrói o campo de senha.
  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: PasswordTextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        isVisible: _passwordVisibility,
        onToggleVisibility: () => safeSetState(
          () => _passwordVisibility = !_passwordVisibility,
        ),
        validator: _passwordValidator,
      ),
    );
  }

  /// Constrói o botão de login.
  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: LoginButton(
        onPressed: _handleLogin,
      ),
    );
  }

  /// Botão de login por biometria/PIN — só aparece se há sessão salva no cofre
  /// e o aparelho suporta biometria/PIN (offline-first).
  Widget _buildBiometricButton() {
    return FutureBuilder<bool>(
      future: OfflineAuthService.instance.then((s) => s.podeUsarBiometria()),
      builder: (context, snap) {
        if (snap.data != true) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
          child: OutlinedButton.icon(
            onPressed: _handleLoginBiometria,
            icon: const Icon(Icons.fingerprint, color: Color(0xFFF75E38)),
            label: const Text(
              'Entrar com biometria',
              style: TextStyle(color: Color(0xFFF75E38)),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              side: const BorderSide(color: Color(0xFFF75E38), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Processa o login do usuário.
  Future<void> _handleLogin() async {
    GoRouter.of(context).prepareAuthEvent();

    final user = await authManager.signInWithEmail(
      context,
      _emailController.text,
      _passwordController.text,
    );

    if (user == null) {
      return;
    }

    await _afterLogin();
  }

  /// Login offline por biometria/PIN: reabre a sessão sem digitar a senha.
  Future<void> _handleLoginBiometria() async {
    final service = await OfflineAuthService.instance;
    final session = await service.loginOfflineComBiometria();
    if (session == null || !mounted) return;
    await _afterLogin();
  }

  /// Carrega person/propriedade e navega — comum aos logins por senha e biometria.
  Future<void> _afterLogin() async {
    // Busca dados do usuário logado
    final uidPersonLogged = await queryPersonRecordOnce(
      queryBuilder: (personRecord) => personRecord.where(
        'uid',
        isEqualTo: currentUserUid,
      ),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    // Busca dados da propriedade
    final outUidPropriedade = await queryPropriedadesRecordOnce(
      queryBuilder: (propriedadesRecord) => propriedadesRecord.where(
        'uidPersonProdutor',
        isEqualTo: uidPersonLogged?.reference,
      ),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    // Navega para a tela principal
    _navigateToHome(outUidPropriedade);

    safeSetState(() {});
  }

  /// Navega para a tela inicial da propriedade.
  void _navigateToHome(PropriedadesRecord? outUidPropriedade) {
    context.goNamedAuth(
      InicioPropriedadeProdutorPage.routeName,
      context.mounted,
      queryParameters: {
        'nomePropriedade': serializeParam(
          outUidPropriedade?.displayName,
          ParamType.String,
        ),
        'uidPropriedade': serializeParam(
          outUidPropriedade?.reference,
          ParamType.DocumentReference,
        ),
        'uidTecnico': serializeParam(
          outUidPropriedade?.parentReference,
          ParamType.DocumentReference,
        ),
        'emailPropriedade': serializeParam(
          outUidPropriedade?.email,
          ParamType.String,
        ),
        'visitaPresencial': serializeParam(
          false,
          ParamType.bool,
        ),
        'diasDg': serializeParam(
          outUidPropriedade?.diasParaDg,
          ParamType.String,
        ),
      }.withoutNulls,
    );
  }
}
