part of 'welcome_bloc.dart';

/// Classe base para eventos da tela de boas-vindas.
abstract class WelcomeEvent {}

/// Evento disparado quando o botão de login é pressionado.
class LoginPressed extends WelcomeEvent {}

/// Evento disparado quando o botão de cadastro é pressionado.
class SignupPressed extends WelcomeEvent {}
