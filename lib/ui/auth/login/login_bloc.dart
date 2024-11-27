import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Gerenciador de estados (Bloc) para a tela de login.
///
/// Esse gerenciador é responsável por validar os campos do formulário
/// e emitir os estados correspondentes.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// Construtor inicializando o estado inicial como `LoginInitial`.
  LoginBloc() : super(LoginInitial()) {
    /// Mapeia o evento de validação dos campos de login para suas respectivas ações.
    on<ValidateLoginFieldsEvent>((event, emit) {
      // Valida os campos do formulário.
      if (event.key.currentState?.validate() ?? false) {
        // Salva os valores dos campos, caso válidos.
        event.key.currentState!.save();
        // Emite o estado de campos válidos.
        emit(ValidLoginFields());
      } else {
        // Emite o estado de erro com uma mensagem.
        emit(LoginFailureState(
            errorMessage: 'Por favor, preencha os campos obrigatórios.'));
      }
    });
  }
}
