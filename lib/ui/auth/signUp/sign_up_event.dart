part of 'sign_up_bloc.dart';

/// Classe base para todos os eventos relacionados ao processo de cadastro.
abstract class SignUpEvent {}

/// Evento para recuperar dados de imagem perdidos, geralmente usado em dispositivos móveis.
class RetrieveLostDataEvent extends SignUpEvent {}

/// Evento para selecionar uma imagem da galeria.
class ChooseImageFromGalleryEvent extends SignUpEvent {
  ChooseImageFromGalleryEvent();
}

/// Evento para capturar uma imagem usando a câmera.
class CaptureImageByCameraEvent extends SignUpEvent {
  CaptureImageByCameraEvent();
}

/// Evento para validar os campos do formulário de cadastro.
///
/// - `key`: chave do formulário que será validado.
/// - `acceptEula`: indica se os termos de uso (EULA) foram aceitos.
class ValidateFieldsEvent extends SignUpEvent {
  final GlobalKey<FormState> key;
  final bool acceptEula;

  ValidateFieldsEvent(this.key, {required this.acceptEula});
}

/// Evento para alterar o estado do checkbox de aceitação dos termos de uso (EULA).
///
/// - `eulaAccepted`: indica se o EULA foi aceito ou não.
class ToggleEulaCheckboxEvent extends SignUpEvent {
  final bool eulaAccepted;

  ToggleEulaCheckboxEvent({required this.eulaAccepted});
}
