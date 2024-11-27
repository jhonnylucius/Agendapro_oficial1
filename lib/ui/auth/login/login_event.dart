part of 'login_bloc.dart';

/// Classe base para eventos relacionados à tela de login.
abstract class LoginEvent {}

/// Evento responsável por validar os campos do formulário de login.
///
/// Contém a [GlobalKey] associada ao formulário que será validado.
class ValidateLoginFieldsEvent extends LoginEvent {
  /// Chave global que identifica e acessa o estado do formulário.
  final GlobalKey<FormState> key;

  /// Construtor para inicializar o evento com a [key] do formulário.
  ValidateLoginFieldsEvent(this.key);
}
