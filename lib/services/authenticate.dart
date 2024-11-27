import 'package:agendapr/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_screen/model/user.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

/// Classe responsável pela integração com Firebase, autenticação e armazenamento.
class FireStoreUtils {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final Reference storage = FirebaseStorage.instance.ref();

  /// Obtém o usuário atual pelo UID do Firebase.
  static Future<User?> getCurrentUser(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await firestore.collection(usersCollection).doc(uid).get();

      if (userDocument.exists && userDocument.data() != null) {
        return User.fromJson(userDocument.data()!);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Erro ao buscar o usuário: $e");
      return null;
    }
  }

  /// Atualiza o usuário atual no Firestore.
  static Future<User> updateCurrentUser(User user) async {
    try {
      await firestore
          .collection(usersCollection)
          .doc(user.userID)
          .set(user.toJson());
      return user;
    } catch (e) {
      debugPrint("Erro ao atualizar o usuário: $e");
      rethrow;
    }
  }

  /// Faz o upload da imagem de perfil do usuário para o Firebase Storage.
  static Future<String> uploadUserImageToServer(
      Uint8List imageData, String userID) async {
    try {
      Reference upload = storage.child("images/$userID.png");
      UploadTask uploadTask = upload.putData(
          imageData, SettableMetadata(contentType: 'image/jpeg'));
      String downloadUrl =
          await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("Erro ao fazer upload da imagem: $e");
      rethrow;
    }
  }

  /// Realiza login com e-mail e senha no Firebase.
  static Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
          .collection(usersCollection)
          .doc(result.user?.uid ?? '')
          .get();

      if (documentSnapshot.exists) {
        return User.fromJson(documentSnapshot.data() ?? {});
      }
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return _handleFirebaseAuthError(e);
    } catch (e) {
      debugPrint("Erro ao fazer login: $e");
      return 'Erro inesperado ao fazer login. Tente novamente.';
    }
  }

  /// Realiza login com o Facebook.
  static Future<dynamic> loginWithFacebook() async {
    try {
      LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        AccessToken? token = result.accessToken;
        return await handleFacebookLogin(
            await FacebookAuth.instance.getUserData(), token!);
      }
      return 'Falha ao realizar login com o Facebook.';
    } catch (e) {
      debugPrint("Erro ao fazer login com o Facebook: $e");
      return 'Erro ao conectar com o Facebook.';
    }
  }

  /// Trata o login com dados retornados do Facebook.
  static Future<dynamic> handleFacebookLogin(
      Map<String, dynamic> userData, AccessToken token) async {
    try {
      auth.UserCredential authResult = await auth.FirebaseAuth.instance
          .signInWithCredential(
              auth.FacebookAuthProvider.credential(token.token));

      User? user = await getCurrentUser(authResult.user?.uid ?? '');

      if (user != null) {
        user
          ..profilePictureURL = userData['picture']['data']['url'] ?? ''
          ..firstName = userData['name'].split(' ').first
          ..lastName = userData['name'].split(' ').last
          ..email = userData['email'] ?? '';
        return await updateCurrentUser(user);
      } else {
        User newUser = User(
          email: userData['email'] ?? '',
          firstName: userData['name'].split(' ').first,
          lastName: userData['name'].split(' ').last,
          profilePictureURL: userData['picture']['data']['url'] ?? '',
          userID: authResult.user?.uid ?? '',
        );
        return await createNewUser(newUser);
      }
    } catch (e) {
      debugPrint("Erro ao tratar login com Facebook: $e");
      return 'Erro ao processar login do Facebook.';
    }
  }

  /// Cria um novo usuário no Firestore.
  static Future<String?> createNewUser(User user) async {
    try {
      await firestore
          .collection(usersCollection)
          .doc(user.userID)
          .set(user.toJson());
      return null;
    } catch (e) {
      debugPrint("Erro ao criar novo usuário: $e");
      return 'Erro ao salvar novo usuário no Firestore.';
    }
  }

  /// Realiza logout do usuário atual.
  static Future<void> logout() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint("Erro ao deslogar: $e");
    }
  }

  /// Realiza login com número de telefone e cria o usuário, se necessário.
  static Future<dynamic> loginOrCreateUserWithPhoneNumberCredential({
    required auth.PhoneAuthCredential credential,
    required String phoneNumber,
    String? firstName = 'Anônimo',
    String? lastName = '',
    Uint8List? imageData,
  }) async {
    try {
      auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.signInWithCredential(credential);

      User? user = await getCurrentUser(userCredential.user?.uid ?? '');

      if (user == null) {
        String profileImageUrl = '';
        if (imageData != null) {
          profileImageUrl = await uploadUserImageToServer(
              imageData, userCredential.user?.uid ?? '');
        }

        User newUser = User(
          firstName: firstName!,
          lastName: lastName!,
          email: '',
          profilePictureURL: profileImageUrl,
          userID: userCredential.user?.uid ?? '',
        );
        return await createNewUser(newUser);
      }
      return user;
    } catch (e) {
      debugPrint("Erro ao fazer login com número de telefone: $e");
      return 'Erro ao realizar login.';
    }
  }

  /// Realiza o reset da senha do usuário.
  static Future<void> resetPassword(String emailAddress) async {
    try {
      await auth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailAddress);
    } catch (e) {
      debugPrint("Erro ao enviar email de redefinição de senha: $e");
    }
  }

  /// Trata erros do Firebase Authentication.
  static String _handleFirebaseAuthError(auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'user-disabled':
        return 'Usuário desativado.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      default:
        return 'Erro ao autenticar. Tente novamente.';
    }
  }
}
