import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Stream para ouvir mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Método para fazer login com Facebook
  Future<UserModel?> signInWithFacebook() async {
    try {
      // Login no Facebook
      final LoginResult loginResult = await _facebookAuth.login();

      if (loginResult.status == LoginStatus.success) {
        // Obter credencial do Facebook
        final OAuthCredential credential = FacebookAuthProvider.credential(
          loginResult.accessToken!.token,
        );

        // Fazer login no Firebase
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Criar ou atualizar usuário no Realtime Database
        final userModel = UserModel.fromFirebaseUser(
          userCredential.user!,
          'facebook',
        );

        await _updateUserData(userModel);
        return userModel;
      }
      return null;
    } catch (e) {
      print('Erro no login com Facebook: $e');
      rethrow;
    }
  }

  // Método para atualizar ou criar dados do usuário no Realtime Database
  Future<void> _updateUserData(UserModel user) async {
    try {
      final userRef = _database.child('users/${user.id}');

      // Verifica se o usuário já existe
      final snapshot = await userRef.get();

      if (snapshot.exists) {
        // Atualiza apenas o lastLogin se o usuário já existe
        await userRef.update({
          'lastLogin': DateTime.now().toIso8601String(),
        });
      } else {
        // Cria um novo registro se o usuário não existe
        await userRef.set(user.toJson());
      }
    } catch (e) {
      print('Erro ao atualizar dados do usuário: $e');
      rethrow;
    }
  }

  // Método para verificar se o perfil está completo
  Future<bool> isProfileComplete(String userId) async {
    try {
      final snapshot = await _database.child('users/$userId').get();
      final data = snapshot.value as Map?;
      if (data == null) return false;

      return data['userType'] != null &&
          data['city'] != null &&
          data['phone'] != null;
    } catch (e) {
      print('Erro ao verificar perfil completo: $e');
      return false;
    }
  }

  // Método para obter dados do usuário atual
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final snapshot =
            await _database.child('users/${currentUser.uid}').get();

        if (snapshot.exists) {
          return UserModel.fromJson(
              Map<String, dynamic>.from(snapshot.value as Map));
        }
      }
      return null;
    } catch (e) {
      print('Erro ao obter usuário atual: $e');
      return null;
    }
  }

  // Stream para ouvir mudanças nos dados do usuário
  Stream<UserModel?> getUserStream(String userId) {
    return _database.child('users/$userId').onValue.map((event) {
      final data = event.snapshot.value;
      if (data != null) {
        return UserModel.fromJson(Map<String, dynamic>.from(data as Map));
      }
      return null;
    });
  }

  // Método para fazer logout
  Future<void> signOut() async {
    try {
      await _facebookAuth.logOut();
      await _auth.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
      rethrow;
    }
  }
}

extension on AccessToken {
  String get token => token;
}
