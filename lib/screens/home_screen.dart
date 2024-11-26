import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'complete_profile_screen.dart'; // Tela de completar perfil do usuário.
import 'login_screen.dart'; // Tela de login.

class HomeScreen extends StatelessWidget {
  final User user; // Objeto do Firebase que representa o usuário logado.

  // Construtor que recebe o usuário como parâmetro.
  const HomeScreen({super.key, required this.user});

  // Método assíncrono para verificar se o perfil do usuário está completo.
  Future<bool> _isProfileComplete() async {
    // Referência ao nó do usuário no banco de dados Firebase Realtime Database.
    final ref = FirebaseDatabase.instance.ref('users/${user.uid}');
    // Obtém os dados do nó do usuário.
    final snapshot = await ref.get();
    // Converte os dados obtidos em um mapa.
    final data = snapshot.value as Map<dynamic, dynamic>?;

    // Verifica se os campos necessários do perfil estão preenchidos.
    return data != null &&
        data['userType'] != null && // Tipo de usuário.
        data['city'] != null && // Cidade.
        data['phone'] != null; // Telefone.
  }

  // Método para realizar o logout do usuário.
  Future<void> _signOut(BuildContext context) async {
    // Faz o logout pelo Firebase Auth.
    await FirebaseAuth.instance.signOut();

    // Verifica se o contexto ainda está montado antes de navegar.
    if (context.mounted) {
      // Redireciona para a tela de login após o logout.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      // Inicia o Future para verificar se o perfil está completo.
      future: _isProfileComplete(),
      builder: (context, snapshot) {
        // Exibe um indicador de carregamento enquanto o Future não é concluído.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Verifica se o perfil não está completo.
        if (snapshot.hasData && !snapshot.data!) {
          // Navega para a tela de completar perfil assim que o widget é renderizado.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CompleteProfileScreen(user: user),
              ),
            );
          });
        }

        // Retorna a interface principal se o perfil estiver completo.
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bem-vindo'), // Título no AppBar.
            actions: [
              IconButton(
                icon: const Icon(Icons.logout), // Ícone de logout.
                onPressed: () => _signOut(context), // Chama o método de logout.
              ),
            ],
          ),
          body: Center(
            // Corpo centralizado com as informações do usuário.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50, // Tamanho do avatar.
                  backgroundImage: NetworkImage(
                    user.photoURL ??
                        'https://via.placeholder.com/150', // Foto do usuário ou imagem padrão.
                  ),
                ),
                const SizedBox(height: 16), // Espaçamento vertical.
                Text('Olá, ${user.displayName}!'), // Exibe o nome do usuário.
                const SizedBox(height: 16),
                const Image(
                  image: AssetImage(
                      'assets/welcome_image.png'), // Imagem de boas-vindas.
                  width: 200, // Largura da imagem.
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
