import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de view da tela de login do técnico.
///
/// Imutável; novas versões via [copyWith]. Substitui os campos de estado que
/// ficavam no antigo `LoginTechnicianModel` (FlutterFlowModel) — **exceto** os
/// controllers/focus de `TextField`, que pertencem ao ciclo de vida do widget
/// e continuam no `State` da page.
class LoginTechnicianState {
  const LoginTechnicianState({this.passwordVisibility = false});

  /// Se a senha está visível (olho aberto) no campo de senha.
  final bool passwordVisibility;

  LoginTechnicianState copyWith({bool? passwordVisibility}) =>
      LoginTechnicianState(
        passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      );
}

/// Controller (Riverpod [Notifier]) da tela de login.
///
/// **Padrão-referência** da migração FlutterFlow→Flutter (feature-first): a UI
/// lê o estado via `ref.watch(loginTechnicianControllerProvider)` e dispara
/// mutações via `ref.read(loginTechnicianControllerProvider.notifier)`. A
/// chamada de autenticação em si (`authManager.signInWithEmail`) permanece na
/// page por exigir `BuildContext` (snackbars/navegação).
class LoginTechnicianController extends Notifier<LoginTechnicianState> {
  @override
  LoginTechnicianState build() => const LoginTechnicianState();

  /// Alterna a visibilidade da senha (olho aberto/fechado).
  void togglePasswordVisibility() =>
      state = state.copyWith(passwordVisibility: !state.passwordVisibility);
}

final loginTechnicianControllerProvider =
    NotifierProvider<LoginTechnicianController, LoginTechnicianState>(
  LoginTechnicianController.new,
);
