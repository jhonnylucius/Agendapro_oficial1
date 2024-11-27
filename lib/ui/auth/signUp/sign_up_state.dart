part of 'sign_up_bloc.dart';

/// Enum que define o estado atual da autenticação.
enum AuthState {
  /// Estado inicial (primeira vez que o app é executado).
  firstRun,

  /// Estado quando o usuário está autenticado.
  authenticated,

  /// Estado quando o usuário não está autenticado.
  unauthenticated,
}

/// Classe que representa os diferentes estados do processo de autenticação.
class AuthenticationState {
  /// Define o estado atual da autenticação.
  final AuthState authState;

  /// Usuário autenticado (opcional, apenas no estado autenticado).
  final User? user;

  /// Mensagem de erro ou status (opcional).
  final String? message;

  /// Construtor privado para instanciar diferentes estados.
  const AuthenticationState._(this.authState, {this.user, this.message});

  /// Estado autenticado com o usuário logado.
  const AuthenticationState.authenticated(User user)
      : this._(AuthState.authenticated, user: user);

  /// Estado não autenticado com uma mensagem opcional.
  const AuthenticationState.unauthenticated({String? message})
      : this._(AuthState.unauthenticated,
            message: message ?? 'Usuário não autenticado.');

  /// Estado inicial, representando a primeira vez que o app é executado.
  const AuthenticationState.onboarding() : this._(AuthState.firstRun);
}
