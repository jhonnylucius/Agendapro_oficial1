import 'package:agendapro/constants.dart';
import 'package:agendapro/services/helper.dart';
import 'package:agendapro/ui/auth/resetPasswordScreen/reset_password_cubit.dart';
import 'package:agendapro/ui/loading_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tela para redefinição de senha.
/// Permite ao usuário solicitar a redefinição de senha por e-mail.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String _emailAddress = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordCubit>(
      create: (context) => ResetPasswordCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                  color: isDarkMode(context) ? Colors.white : Colors.black),
              elevation: 0.0,
            ),
            body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
              listenWhen: (old, current) => old != current,
              listener: (context, state) async {
                if (state is ResetPasswordDone) {
                  // Mostra mensagem de sucesso e volta à tela anterior
                  context.read<LoadingCubit>().hideLoading();
                  showSnackBar(context,
                      'E-mail para redefinição de senha enviado! Verifique sua caixa de entrada.');
                  Navigator.pop(context);
                } else if (state is ValidResetPasswordField) {
                  // Exibe loading enquanto processa o envio
                  await context
                      .read<LoadingCubit>()
                      .showLoading(context, 'Enviando e-mail...', false);
                  if (!mounted) return;
                  context
                      .read<ResetPasswordCubit>()
                      .resetPassword(_emailAddress);
                } else if (state is ResetPasswordFailureState) {
                  // Exibe mensagem de erro caso haja falha
                  showSnackBar(context, state.errorMessage);
                }
              },
              buildWhen: (old, current) =>
                  current is ResetPasswordFailureState && old != current,
              builder: (context, state) {
                if (state is ResetPasswordFailureState) {
                  _validate = AutovalidateMode.onUserInteraction;
                }
                return Form(
                  autovalidateMode: _validate,
                  key: _key,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 32.0, right: 16.0, left: 16.0),
                          child: Text(
                            'Redefinir Senha',
                            style: TextStyle(
                                color: Color(colorPrimary),
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, right: 24.0, left: 24.0),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.done,
                            validator: validateEmail,
                            onFieldSubmitted: (_) => context
                                .read<ResetPasswordCubit>()
                                .checkValidField(_key),
                            onSaved: (val) => _emailAddress = val!,
                            style: const TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: const Color(colorPrimary),
                            decoration: getInputDecoration(
                                hint: 'E-mail',
                                darkMode: isDarkMode(context),
                                errorColor:
                                    Theme.of(context).colorScheme.error),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 40.0, left: 40.0, top: 40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width / 1.5),
                              backgroundColor: const Color(colorPrimary),
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: const BorderSide(
                                  color: Color(colorPrimary),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Enviar E-mail',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => context
                                .read<ResetPasswordCubit>()
                                .checkValidField(_key),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
