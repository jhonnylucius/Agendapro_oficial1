import 'package:agendapro/services/helper.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'loading_state.dart';

/// Cubit responsável por gerenciar o estado de carregamento da aplicação.
///
/// O `LoadingCubit` utiliza a abordagem de gerenciamento de estado baseada em eventos
/// para exibir e ocultar o indicador de carregamento (loading).
class LoadingCubit extends Cubit<LoadingState> {
  /// Inicializa o estado do cubit com o estado inicial.
  LoadingCubit() : super(LoadingInitial());

  /// Exibe o indicador de carregamento com uma mensagem customizada.
  ///
  /// [context]: Contexto atual da aplicação.
  /// [message]: Mensagem a ser exibida no indicador de carregamento.
  /// [isDismissible]: Define se o indicador pode ser fechado pelo usuário.
  Future<void> showLoading(
      BuildContext context, String message, bool isDismissible) async {
    await showProgress(context, message, isDismissible);
  }

  /// Oculta o indicador de carregamento.
  Future<void> hideLoading() async {
    await hideProgress();
  }
}
