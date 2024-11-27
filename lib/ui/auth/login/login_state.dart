part of 'login_bloc.dart';

/// Classe base para representar os diferentes estados do processo de login.
abstract class LoginState {}

/// Estado inicial do processo de login.
class LoginInitial extends LoginState {}

/// Estado que indica que os campos do formulário de login foram validados corretamente.
class ValidLoginFields extends LoginState {}

/// Estado que representa uma falha durante o processo de login.
/// Contém uma mensagem de erro para exibir ao usuário.
class LoginFailureState extends LoginState {
  /// Mensagem de erro que descreve o motivo da falha no login.
  final String errorMessage;

  /// Construtor que exige a mensagem de erro como parâmetro.
  LoginFailureState({required this.errorMessage});
}
