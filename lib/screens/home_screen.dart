import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'complete_profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  Future<bool> _isProfileComplete() async {
    final ref = FirebaseDatabase.instance.ref('users/${user.uid}');
    final snapshot = await ref.get();
    final data = snapshot.value as Map<dynamic, dynamic>?;

    return data != null &&
        data['userType'] != null &&
        data['city'] != null &&
        data['phone'] != null;
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isProfileComplete(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && !snapshot.data!) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CompleteProfileScreen(user: user),
              ),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bem-vindo'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _signOut(context),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    user.photoURL ?? 'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(height: 16),
                Text('Olá, ${user.displayName}!'),
                const SizedBox(height: 16),
                const Image(
                  image: AssetImage('assets/welcome_image.png'),
                  width: 200,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
