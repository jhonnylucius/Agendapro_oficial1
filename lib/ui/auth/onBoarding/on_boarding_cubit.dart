import 'package:bloc/bloc.dart';

part 'on_boarding_state.dart';

/// Gerenciador de estado para o fluxo de onboarding.
/// Este Cubit é responsável por rastrear a página atual no fluxo de onboarding.
class OnBoardingCubit extends Cubit<OnBoardingInitial> {
  /// Inicializa o estado inicial do Cubit com a página 0.
  OnBoardingCubit() : super(OnBoardingInitial(0));

  /// Atualiza o estado quando a página de onboarding muda.
  ///
  /// [count] é o índice da página atual.
  void onPageChanged(int count) {
    emit(OnBoardingInitial(count));
  }
}
