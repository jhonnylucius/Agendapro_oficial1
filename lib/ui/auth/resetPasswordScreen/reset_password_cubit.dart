import 'package:agendapro/services/authenticate.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'reset_password_state.dart';

/// Gerencia o estado do processo de redefinição de senha.
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  /// Estado inicial do cubit.
  ResetPasswordCubit() : super(ResetPasswordInitial());

  /// Método para solicitar a redefinição de senha.
  /// Envia um e-mail para o endereço fornecido, se válido.
  ///
  /// @param email Endereço de e-mail do usuário que deseja redefinir a senha.
  resetPassword(String email) async {
    await FireStoreUtils.resetPassword(email);
    emit(ResetPasswordDone());
  }

  /// Verifica se o campo de entrada é válido antes de enviar a solicitação.
  ///
  /// @param key Chave global do formulário para validação.
  checkValidField(GlobalKey<FormState> key) {
    if (key.currentState?.validate() ?? false) {
      key.currentState!.save();
      emit(ValidResetPasswordField());
    } else {
      emit(ResetPasswordFailureState(
          errorMessage: 'Endereço de e-mail inválido.'));
    }
  }
}
