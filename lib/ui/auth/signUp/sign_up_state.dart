part of 'sign_up_bloc.dart';

/// Classe base para os estados do SignUp.
abstract class SignUpState {}

/// Estado inicial do SignUp.
class SignUpInitial extends SignUpState {}

/// Estado quando uma imagem é selecionada com sucesso.
class PictureSelectedState extends SignUpState {
  final Uint8List imageData;

  PictureSelectedState({required this.imageData});
}

/// Estado para campos validados com sucesso.
class ValidFields extends SignUpState {}

/// Estado para quando há falha no cadastro.
class SignUpFailureState extends SignUpState {
  final String errorMessage;

  SignUpFailureState({required this.errorMessage});
}

/// Estado para alternar o status do EULA (termos de uso).
class EulaToggleState extends SignUpState {
  final bool eulaAccepted;

  EulaToggleState(this.eulaAccepted);
}
