part of 'reset_password_cubit.dart';

/// Classe base para representar os estados da redefinição de senha.
abstract class ResetPasswordState {}

/// Estado inicial, representando o momento antes de qualquer interação do usuário.
class ResetPasswordInitial extends ResetPasswordState {}

/// Estado que indica que o campo de e-mail é válido.
class ValidResetPasswordField extends ResetPasswordState {}

/// Estado que representa uma falha ao tentar redefinir a senha.
class ResetPasswordFailureState extends ResetPasswordState {
  /// Mensagem de erro detalhando o motivo da falha.
  final String errorMessage;

  ResetPasswordFailureState({required this.errorMessage});
}

/// Estado que indica que o e-mail de redefinição de senha foi enviado com sucesso.
class ResetPasswordDone extends ResetPasswordState {}
