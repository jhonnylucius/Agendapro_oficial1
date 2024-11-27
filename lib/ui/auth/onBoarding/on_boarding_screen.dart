import 'package:agendapro/constants.dart';
import 'package:agendapro/services/helper.dart';
import 'package:agendapro/ui/auth/authentication_bloc.dart';
import 'package:agendapro/ui/auth/onBoarding/on_boarding_cubit.dart';
import 'package:agendapro/ui/auth/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Tela de Onboarding que apresenta informações iniciais para o usuário.
/// Mostra imagens, títulos e subtítulos em um formato deslizável.
class OnBoardingScreen extends StatefulWidget {
  final List<dynamic> images; // Lista de imagens ou ícones para cada página.
  final List<String> titles,
      subtitles; // Títulos e subtítulos para cada página.

  const OnBoardingScreen({
    super.key,
    required this.images,
    required this.titles,
    required this.subtitles,
  });

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // Controlador para o PageView.
  final PageController pageController = PageController();

  @override
  void dispose() {
    // Liberar o controlador ao descartar a tela.
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: Scaffold(
        backgroundColor: const Color(colorPrimary), // Cor de fundo da tela.
        body: BlocBuilder<OnBoardingCubit, OnBoardingInitial>(
          builder: (context, state) {
            return Stack(
              children: [
                // PageView para exibir as páginas de onboarding.
                PageView.builder(
                  itemBuilder: (context, index) => OnBoardingPage(
                    image: widget.images[index],
                    title: widget.titles[index],
                    subtitle: widget.subtitles[index],
                  ),
                  controller: pageController,
                  itemCount: widget.titles.length,
                  onPageChanged: (int index) {
                    context.read<OnBoardingCubit>().onPageChanged(index);
                  },
                ),
                // Botão "Continue" que aparece na última página.
                Visibility(
                  visible: state.currentPageCount + 1 == widget.titles.length,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Directionality.of(context) == TextDirection.ltr
                          ? Alignment.bottomRight
                          : Alignment.bottomLeft,
                      child:
                          BlocListener<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) {
                          if (state.authState == AuthState.unauthenticated) {
                            pushAndRemoveUntil(context, const WelcomeScreen(),
                                (Route<dynamic> route) => false);
                          }
                        },
                        child: OutlinedButton(
                          onPressed: () {
                            context
                                .read<AuthenticationBloc>()
                                .add(FinishedOnBoardingEvent());
                          },
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: const StadiumBorder()),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Indicador de páginas na parte inferior.
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: widget.titles.length,
                      effect: ScrollingDotsEffect(
                        activeDotColor: Colors.white,
                        dotColor: Colors.grey.shade400,
                        dotWidth: 8,
                        dotHeight: 8,
                        fixedCenter: true,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Página individual do Onboarding que exibe uma imagem, título e subtítulo.
class OnBoardingPage extends StatelessWidget {
  final dynamic image; // Pode ser uma String (caminho) ou um ícone.
  final String title, subtitle; // Título e subtítulo da página.

  const OnBoardingPage({
    super.key,
    this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Exibe a imagem ou o ícone.
        image is String
            ? Image.asset(
                image,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : Icon(
                image as IconData,
                color: Colors.white,
                size: 150,
              ),
        const SizedBox(height: 40),
        // Exibe o título da página.
        Text(
          title.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        // Exibe o subtítulo da página.
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
