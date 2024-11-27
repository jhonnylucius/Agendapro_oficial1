part of 'authentication_bloc.dart';

/// Classe base para todos os eventos relacionados à autenticação.
abstract class AuthenticationEvent {}

/// Evento para login utilizando e-mail e senha.
class LoginWithEmailAndPasswordEvent extends AuthenticationEvent {
  final String email; // E-mail do usuário.
  final String password; // Senha do usuário.

  /// Construtor para inicializar o evento com e-mail e senha.
  LoginWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });
}

/// Evento para login utilizando a conta do Facebook.
class LoginWithFacebookEvent extends AuthenticationEvent {}

/// Evento para login utilizando a conta da Apple.
class LoginWithAppleEvent extends AuthenticationEvent {}

/// Evento para login ou criação de conta utilizando número de telefone.
class LoginWithPhoneNumberEvent extends AuthenticationEvent {
  final auth.PhoneAuthCredential credential; // Credenciais do telefone.
  final String phoneNumber; // Número de telefone do usuário.
  final String? firstName; // Primeiro nome (opcional).
  final String? lastName; // Sobrenome (opcional).
  final Uint8List? imageData; // Imagem de perfil do usuário (opcional).

  /// Construtor para inicializar o evento com as credenciais do telefone e informações do usuário.
  LoginWithPhoneNumberEvent({
    required this.credential,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.imageData,
  });
}

/// Evento para criar uma nova conta utilizando e-mail e senha.
class SignupWithEmailAndPasswordEvent extends AuthenticationEvent {
  final String emailAddress; // E-mail do usuário.
  final String password; // Senha do usuário.
  final Uint8List? imageData; // Imagem de perfil do usuário (opcional).
  final String? firstName; // Primeiro nome do usuário (opcional).
  final String? lastName; // Sobrenome do usuário (opcional).

  /// Construtor para inicializar o evento com as informações necessárias para cadastro.
  SignupWithEmailAndPasswordEvent({
    required this.emailAddress,
    required this.password,
    this.imageData,
    this.firstName = 'Anonymous', // Nome padrão.
    this.lastName = 'User', // Sobrenome padrão.
  });
}

/// Evento para desconectar o usuário da sessão.
class LogoutEvent extends AuthenticationEvent {}

/// Evento que indica que o usuário finalizou o processo de onboarding.
class FinishedOnBoardingEvent extends AuthenticationEvent {}

/// Evento para verificar se é a primeira execução do aplicativo.
class CheckFirstRunEvent extends AuthenticationEvent {}
