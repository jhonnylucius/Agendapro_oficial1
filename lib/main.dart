import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'screens/complete_profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<Widget> _getInitialScreen() async {
  try {
    // Verifica o usuário atual autenticado no Firebase
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    // Verifica se o perfil do usuário está completo no Realtime Database
    final userId = user.uid;
    final ref = FirebaseDatabase.instance.ref('users/$userId');
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      return CompleteProfileScreen(user: user);
    }

    final data = snapshot.value as Map<String, dynamic>?;
    if (data == null ||
        data['userType'] == null ||
        data['city'] == null ||
        data['phone'] == null) {
      return CompleteProfileScreen(user: user);
    }

    // Se tudo estiver configurado, redireciona para a HomeScreen
    return HomeScreen(user: user);
  } catch (e) {
    // Retorna LoginScreen em caso de erro
    return const LoginScreen();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Exibe um indicador de progresso enquanto aguarda o resultado
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          // Em caso de erro, exibe uma mensagem amigável
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Ocorreu um erro. Tente novamente mais tarde.'),
              ),
            ),
          );
        }

        return MaterialApp(
          title: 'AgendaPRO',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: snapshot.data ?? const LoginScreen(),
        );
      },
    );
  }
}
