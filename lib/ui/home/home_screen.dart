import 'dart:math';

import 'package:agendapro/constants.dart';
import 'package:agendapro/model/user.dart';
import 'package:agendapro/services/helper.dart';
import 'package:agendapro/ui/auth/authentication_bloc.dart';
import 'package:agendapro/ui/auth/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tela inicial do aplicativo, exibindo as informações do usuário logado.
/// Permite logout através do menu lateral.
class HomeScreen extends StatefulWidget {
  final User user;

  /// Recebe o usuário autenticado como parâmetro.
  const HomeScreen({super.key, required this.user});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    // Inicializa o usuário com os dados recebidos.
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        // Redireciona o usuário para a tela de boas-vindas caso não esteja autenticado.
        if (state.authState == AuthState.unauthenticated) {
          pushAndRemoveUntil(
              context, const WelcomeScreen(), (Route<dynamic> route) => false);
        }
      },
      child: Scaffold(
        // Menu lateral (Drawer) com opções.
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(colorPrimary),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              ListTile(
                title: Text(
                  'Sair',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.grey.shade50
                          : Colors.grey.shade900),
                ),
                leading: Transform.rotate(
                  angle: pi, // Ícone de logout invertido.
                  child: Icon(
                    Icons.exit_to_app,
                    color: isDarkMode(context)
                        ? Colors.grey.shade50
                        : Colors.grey.shade900,
                  ),
                ),
                onTap: () {
                  // Envia o evento de logout ao bloco de autenticação.
                  context.read<AuthenticationBloc>().add(LogoutEvent());
                },
              ),
            ],
          ),
        ),
        // Barra superior (AppBar) da tela.
        appBar: AppBar(
          title: Text(
            'Início',
            style: TextStyle(
                color: isDarkMode(context)
                    ? Colors.grey.shade50
                    : Colors.grey.shade900),
          ),
          iconTheme: IconThemeData(
              color: isDarkMode(context)
                  ? Colors.grey.shade50
                  : Colors.grey.shade900),
          backgroundColor:
              isDarkMode(context) ? Colors.grey.shade900 : Colors.grey.shade50,
          centerTitle: true,
        ),
        // Corpo da tela, mostrando informações do usuário.
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Exibe a foto do perfil do usuário ou uma imagem padrão.
              user.profilePictureURL == ''
                  ? CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey.shade400,
                      child: ClipOval(
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Image.asset(
                            'assets/images/placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : displayCircleImage(user.profilePictureURL, 80, false),
              // Exibe o nome completo do usuário.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user.fullName(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              // Exibe o e-mail do usuário.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user.email,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              // Exibe o ID do usuário.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user.userID,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
