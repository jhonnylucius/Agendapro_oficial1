import 'package:bloc/bloc.dart';

part 'welcome_event.dart';
part 'welcome_state.dart';

/// Gerencia os eventos e estados para a tela de boas-vindas.
class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeInitial> {
  /// Construtor que define o estado inicial como [WelcomeInitial].
  WelcomeBloc() : super(WelcomeInitial()) {
    // Manipula o evento quando o botão de login é pressionado.
    on<LoginPressed>((event, emit) {
      emit(WelcomeInitial(pressTarget: WelcomePressTarget.login));
    });

    // Manipula o evento quando o botão de cadastro é pressionado.
    on<SignupPressed>((event, emit) {
      emit(WelcomeInitial(pressTarget: WelcomePressTarget.signup));
    });
  }
}
