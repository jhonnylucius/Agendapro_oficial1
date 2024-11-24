import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _loginWithFacebook() async {
    setState(() => _isLoading = true);

    try {
      // Realizar login com Facebook
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Obter credencial do Facebook
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        // Fazer login no Firebase
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => HomeScreen(user: userCredential.user!)),
          );
        }
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AgendaPRO')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                icon: const Icon(Icons.facebook),
                label: const Text('Entrar com Facebook'),
                onPressed: _loginWithFacebook,
              ),
      ),
    );
  }
}

extension on AccessToken {
  String get token => token;
}
