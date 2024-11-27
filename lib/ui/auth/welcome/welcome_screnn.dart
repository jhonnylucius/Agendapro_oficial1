import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_screen/constants.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:flutter_login_screen/ui/auth/login/login_screen.dart';
import 'package:flutter_login_screen/ui/auth/signUp/sign_up_screen.dart';
import 'package:flutter_login_screen/ui/auth/welcome/welcome_bloc.dart';

/// Tela de boas-vindas do aplicativo.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WelcomeBloc>(
      create: (context) => WelcomeBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: BlocListener<WelcomeBloc, WelcomeInitial>(
              listener: (context, state) {
                switch (state.pressTarget) {
                  case WelcomePressTarget.login:
                    // Navega para a tela de login.
                    push(context, const LoginScreen());
                    break;
                  case WelcomePressTarget.signup:
                    // Navega para a tela de cadastro.
                    push(context, const SignUpScreen());
                    break;
                  default:
                    break;
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/images/welcome_image.png',
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 16, top: 32, right: 16, bottom: 8),
                    child: Text(
                      'Diga Olá ao Seu Novo App!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(colorPrimary),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: Text(
                      'Você acabou de economizar uma semana de desenvolvimento e dores de cabeça.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(
                            MediaQuery.of(context).size.width / 1.5),
                        backgroundColor: const Color(colorPrimary),
                        textStyle: const TextStyle(color: Colors.white),
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: const BorderSide(color: Color(colorPrimary))),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // Adiciona o evento de login ao Bloc.
                        context.read<WelcomeBloc>().add(LoginPressed());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, top: 20, bottom: 20),
                    child: TextButton(
                      onPressed: () {
                        // Adiciona o evento de cadastro ao Bloc.
                        context.read<WelcomeBloc>().add(SignupPressed());
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        fixedSize: Size.fromWidth(
                            MediaQuery.of(context).size.width / 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(
                            color: Color(colorPrimary),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cadastrar-se',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(colorPrimary)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
