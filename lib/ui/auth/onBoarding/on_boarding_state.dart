part of 'on_boarding_cubit.dart';

/// Classe base abstrata para representar os estados do OnBoarding.
abstract class OnBoardingState {}

/// Estado inicial do OnBoarding, que mantém o índice da página atual.
class OnBoardingInitial extends OnBoardingState {
  /// Contador da página atual no OnBoarding.
  final int currentPageCount;

  /// Construtor para inicializar o estado com o índice da página.
  ///
  /// [currentPageCount] representa a página atual no fluxo de OnBoarding.
  OnBoardingInitial(this.currentPageCount);
}
