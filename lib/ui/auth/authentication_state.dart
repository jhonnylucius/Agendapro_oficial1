part of 'authentication_bloc.dart';

/// Enumeração para representar os estados de autenticação.
enum AuthState {
  firstRun, // Estado indicando a primeira execução do aplicativo.
  authenticated, // Estado indicando que o usuário está autenticado.
  unauthenticated, // Estado indicando que o usuário não está autenticado.
}

/// Classe que representa o estado atual da autenticação.
class AuthenticationState {
  final AuthState authState; // Estado de autenticação atual.
  final User? user; // Usuário autenticado (caso esteja autenticado).
  final String? message; // Mensagem adicional (ex.: erros ou avisos).

  /// Construtor privado para inicializar o estado de forma controlada.
  const AuthenticationState._(this.authState, {this.user, this.message});

  /// Construtor para o estado autenticado.
  /// Define o estado como [authenticated] e atribui o usuário autenticado.
  const AuthenticationState.authenticated(User user)
      : this._(AuthState.authenticated, user: user);

  /// Construtor para o estado não autenticado.
  /// Define o estado como [unauthenticated] e pode incluir uma mensagem explicativa.
  const AuthenticationState.unauthenticated({String? message})
      : this._(AuthState.unauthenticated,
            message: message ?? 'Usuário não autenticado.');

  /// Construtor para o estado de primeira execução do aplicativo (onboarding).
  const AuthenticationState.onboarding() : this._(AuthState.firstRun);
}
