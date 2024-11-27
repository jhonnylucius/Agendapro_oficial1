import 'dart:io';

import 'package:agendapro/constants.dart';
import 'package:agendapro/services/helper.dart';
import 'package:agendapro/ui/auth/authentication_bloc.dart';
import 'package:agendapro/ui/auth/signUp/sign_up_bloc.dart';
import 'package:agendapro/ui/home/home_screen.dart';
import 'package:agendapro/ui/loading_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  Uint8List? _imageData;
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  String? firstName, lastName, email, password, confirmPassword;
  AutovalidateMode _validate = AutovalidateMode.disabled;
  bool acceptEULA = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(),
      child: Builder(
        builder: (context) {
          // Recupera dados de imagem perdidos no Android
          if (!kIsWeb && Platform.isAndroid) {
            context.read<SignUpBloc>().add(RetrieveLostDataEvent());
          }
          return MultiBlocListener(
            listeners: [
              // Listener para autenticação
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  context.read<LoadingCubit>().hideLoading();
                  if (state.authState == AuthState.authenticated) {
                    pushAndRemoveUntil(
                        context, HomeScreen(user: state.user!), false);
                  } else {
                    showSnackBar(
                        context,
                        state?.message ??
                            'Erro ao criar conta. Por favor, tente novamente.');
                  }
                },
              ),
              // Listener para validações e estados do formulário
              BlocListener<SignUpBloc, SignUpState>(
                listener: (context, state) async {
                  if (state is ValidFields) {
                    await context.read<LoadingCubit>().showLoading(
                        context, 'Criando nova conta, aguarde...', false);
                    if (!mounted) return;
                    context.read<AuthenticationBloc>().add(
                        SignupWithEmailAndPasswordEvent(
                            emailAddress: email!,
                            password: password!,
                            imageData: _imageData,
                            lastName: lastName,
                            firstName: firstName));
                  } else if (state is SignUpFailureState) {
                    showSnackBar(context, state.errorMessage);
                  }
                },
              ),
            ],
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                    color: isDarkMode(context) ? Colors.white : Colors.black),
              ),
              body: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: BlocBuilder<SignUpBloc, SignUpState>(
                  buildWhen: (old, current) =>
                      current is SignUpFailureState && old != current,
                  builder: (context, state) {
                    if (state is SignUpFailureState) {
                      _validate = AutovalidateMode.onUserInteraction;
                    }
                    return Form(
                      key: _key,
                      autovalidateMode: _validate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Criar nova conta',
                              style: TextStyle(
                                  color: Color(colorPrimary),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
                            ),
                          ),
                          // Imagem de perfil
                          _buildProfilePicture(context),
                          // Campos de formulário
                          _buildFormFields(context),
                          // Botão de cadastro
                          _buildSignUpButton(context),
                          const SizedBox(height: 24),
                          // Checkbox de EULA
                          _buildEulaCheckbox(context),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Constrói o componente de imagem de perfil.
  Widget _buildProfilePicture(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlocBuilder<SignUpBloc, SignUpState>(
            buildWhen: (old, current) =>
                current is PictureSelectedState && old != current,
            builder: (context, state) {
              if (state is PictureSelectedState) {
                _imageData = state.imageData;
              }
              return state is PictureSelectedState
                  ? _buildProfileImage(state.imageData)
                  : _buildPlaceholderImage();
            },
          ),
          Positioned(
            right: 0,
            child: FloatingActionButton(
              backgroundColor: const Color(colorPrimary),
              mini: true,
              onPressed: () => _onCameraClick(context),
              child: Icon(
                Icons.camera_alt,
                color: isDarkMode(context) ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(Uint8List? imageData) {
    return SizedBox(
      height: 130,
      width: 130,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(65),
        child: Image.memory(
          imageData!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return SizedBox(
      height: 130,
      width: 130,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(65),
        child: Image.asset(
          'assets/images/placeholder.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Constrói os campos do formulário de cadastro.
  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          hint: 'Nome',
          onSaved: (val) => firstName = val,
          validator: validateName,
        ),
        _buildTextField(
          hint: 'Sobrenome',
          onSaved: (val) => lastName = val,
          validator: validateName,
        ),
        _buildTextField(
          hint: 'Email',
          onSaved: (val) => email = val,
          validator: validateEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildTextField(
          hint: 'Senha',
          onSaved: (val) => password = val,
          validator: validatePassword,
          obscureText: true,
          controller: _passwordController,
        ),
        _buildTextField(
          hint: 'Confirmar senha',
          onSaved: (val) => confirmPassword = val,
          validator: (val) =>
              validateConfirmPassword(_passwordController.text, val),
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
        decoration: getInputDecoration(
          hint: hint,
          darkMode: isDarkMode(context),
          errorColor: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  /// Constrói o botão de cadastro.
  Widget _buildSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: ElevatedButton(
        onPressed: () => context.read<SignUpBloc>().add(
              ValidateFieldsEvent(_key, acceptEula: acceptEULA),
            ),
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width / 1.5),
          backgroundColor: const Color(colorPrimary),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: const BorderSide(color: Color(colorPrimary)),
          ),
        ),
        child: const Text(
          'Cadastrar',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Constrói o checkbox de aceitação do EULA.
  Widget _buildEulaCheckbox(BuildContext context) {
    return ListTile(
      trailing: BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (old, current) =>
            current is EulaToggleState && old != current,
        builder: (context, state) {
          if (state is EulaToggleState) {
            acceptEULA = state.eulaAccepted;
          }
          return Checkbox(
            value: acceptEULA,
            onChanged: (value) => context.read<SignUpBloc>().add(
                  ToggleEulaCheckboxEvent(eulaAccepted: value!),
                ),
          );
        },
      ),
      title: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Ao criar uma conta, você concorda com os nossos ',
              style: TextStyle(color: Colors.grey),
            ),
            TextSpan(
              text: 'Termos de Uso',
              style: const TextStyle(color: Colors.blueAccent),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (await canLaunchUrl(Uri.parse(eula))) {
                    await launchUrl(Uri.parse(eula));
                  }
                },
            ),
          ],
        ),
      ),
    );
  }

  /// Mostra o modal para selecionar imagem via câmera ou galeria.
  void _onCameraClick(BuildContext context) {
    if (kIsWeb || Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      context.read<SignUpBloc>().add(ChooseImageFromGalleryEvent());
    } else {
      final action = CupertinoActionSheet(
        title: const Text(
          'Adicionar foto de perfil',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Escolher da galeria'),
            onPressed: () {
              Navigator.pop(context);
              context.read<SignUpBloc>().add(ChooseImageFromGalleryEvent());
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Tirar uma foto'),
            onPressed: () {
              Navigator.pop(context);
              context.read<SignUpBloc>().add(CaptureImageByCameraEvent());
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
      );
      showCupertinoModalPopup(context: context, builder: (context) => action);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _imageData = null;
    super.dispose();
  }
}
