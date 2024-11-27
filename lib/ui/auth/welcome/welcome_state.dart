part of 'welcome_bloc.dart';

/// Enum que define os possíveis alvos de interação na tela de boas-vindas.
/// - [login]: Indica que o usuário pressionou o botão "Entrar".
/// - [signup]: Indica que o usuário pressionou o botão "Cadastrar-se".
enum WelcomePressTarget { login, signup }

/// Representa o estado inicial da tela de boas-vindas.
///
/// Este estado é usado para capturar a interação do usuário com os botões
/// e definir qual ação deve ser realizada.
class WelcomeInitial {
  /// Alvo da interação do usuário, podendo ser login ou cadastro.
  WelcomePressTarget? pressTarget;

  /// Construtor que inicializa o estado com um alvo opcional.
  WelcomeInitial({this.pressTarget});
}
