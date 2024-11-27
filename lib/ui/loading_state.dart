part of 'loading_cubit.dart';

/// Classe base abstrata para os estados do `LoadingCubit`.
///
/// Todos os estados relacionados ao carregamento devem estender esta classe.
@immutable
abstract class LoadingState {}

/// Estado inicial do carregamento.
///
/// Representa o estado em que nenhuma ação de carregamento está em andamento.
class LoadingInitial extends LoadingState {}
