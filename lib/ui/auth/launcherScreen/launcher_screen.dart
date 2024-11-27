import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_screen/constants.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:flutter_login_screen/ui/auth/authentication_bloc.dart';
import 'package:flutter_login_screen/ui/auth/onBoarding/data.dart';
import 'package:flutter_login_screen/ui/auth/onBoarding/on_boarding_screen.dart';
import 'package:flutter_login_screen/ui/auth/welcome/welcome_screen.dart';
import 'package:flutter_login_screen/ui/home/home_screen.dart';

/// Tela inicial que redireciona o usuário para a tela apropriada
/// com base no estado de autenticação ou se é a primeira execução.
class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key? key}) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();
    // Verifica se é a primeira execução do aplicativo.
    context.read<AuthenticationBloc>().add(CheckFirstRunEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorPrimary),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          // Define o fluxo de navegação com base no estado da autenticação.
          switch (state.authState) {
            case AuthState.firstRun:
              // Caso seja a primeira execução, exibe a tela de onboarding.
              pushReplacement(
                context,
                OnBoardingScreen(
                  images: imageList,
                  titles: titlesList,
                  subtitles: subtitlesList,
                ),
              );
              break;
            case AuthState.authenticated:
              // Caso o usuário esteja autenticado, vai para a tela inicial.
              pushReplacement(context, HomeScreen(user: state.user!));
              break;
            case AuthState.unauthenticated:
              // Caso o usuário não esteja autenticado, vai para a tela de boas-vindas.
              pushReplacement(context, const WelcomeScreen());
              break;
          }
        },
        // Mostra um indicador de carregamento enquanto o estado é avaliado.
        child: const Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(Color(colorPrimary)),
          ),
        ),
      ),
    );
  }
}
