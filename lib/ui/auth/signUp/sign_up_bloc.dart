import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

/// Gerencia os eventos e estados relacionados ao processo de cadastro de usuários.
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  /// Instância para manipulação de seleção de imagens.
  final ImagePicker imagePicker = ImagePicker();

  /// Construtor do `SignUpBloc`, inicializando o estado inicial e mapeando os eventos.
  SignUpBloc() : super(SignUpInitial()) {
    // Gerencia a recuperação de dados de imagem perdidos (iOS/Android)
    on<RetrieveLostDataEvent>((event, emit) async {
      final LostDataResponse response = await imagePicker.retrieveLostData();
      if (response.file != null) {
        emit(PictureSelectedState(
            imageData: await response.file!.readAsBytes()));
      }
    });

    // Gerencia a seleção de imagem a partir da galeria.
    on<ChooseImageFromGalleryEvent>((event, emit) async {
      // Caso não seja um ambiente web e esteja rodando em desktop (Windows/MacOS/Linux)
      if (!kIsWeb &&
          (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          emit(PictureSelectedState(
              imageData: await File(result.files.single.path!).readAsBytes()));
        }
      } else {
        // Para ambientes móveis e web
        XFile? xImage =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (xImage != null) {
          emit(PictureSelectedState(imageData: await xImage.readAsBytes()));
        }
      }
    });

    // Gerencia a captura de imagem usando a câmera.
    on<CaptureImageByCameraEvent>((event, emit) async {
      XFile? xImage = await imagePicker.pickImage(source: ImageSource.camera);
      if (xImage != null) {
        emit(PictureSelectedState(imageData: await xImage.readAsBytes()));
      }
    });

    // Valida os campos do formulário de cadastro.
    on<ValidateFieldsEvent>((event, emit) async {
      if (event.key.currentState?.validate() ?? false) {
        if (event.acceptEula) {
          event.key.currentState!.save();
          emit(ValidFields());
        } else {
          emit(SignUpFailureState(
              errorMessage: 'Por favor, aceite os termos de uso.'));
        }
      } else {
        emit(SignUpFailureState(
            errorMessage: 'Por favor, preencha todos os campos obrigatórios.'));
      }
    });

    // Gerencia o estado da caixa de seleção de aceitação dos termos de uso (EULA).
    on<ToggleEulaCheckboxEvent>(
        (event, emit) => emit(EulaToggleState(event.eulaAccepted)));
  }
}
