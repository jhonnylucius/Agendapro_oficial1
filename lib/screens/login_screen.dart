import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _loginWithFacebook(BuildContext context) async {
    try {
      // Faz login com o Facebook
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Obtém o token de acesso
        final AccessToken accessToken = result.accessToken!;

        // Usa o token para criar uma credencial do Firebase
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token!);

        // Faz login no Firebase com a credencial
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Verifica se o widget ainda está montado antes de usar o BuildContext
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login realizado com sucesso!')),
          );
        }
      } else {
        // Verifica se o widget ainda está montado
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro no login: ${result.message}')),
          );
        }
      }
    } catch (e) {
      // Captura e exibe qualquer outro erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer login: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login com Facebook')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _loginWithFacebook(context),
          icon: const Icon(Icons.facebook),
          label: const Text('Entrar com Facebook'),
        ),
      ),
    );
  }
}

extension on AccessToken {
  get token => null;
}
