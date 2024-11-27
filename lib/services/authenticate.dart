import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_screen/constants.dart';
import 'package:flutter_login_screen/model/user.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

class FireStoreUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Reference _storage = FirebaseStorage.instance.ref();

  /// Fetches the current user from Firestore using their UID.
  static Future<User?> getCurrentUser(String uid) async {
    try {
      final userDoc =
          await _firestore.collection(usersCollection).doc(uid).get();
      if (userDoc.exists) {
        return User.fromJson(userDoc.data()!);
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
    return null;
  }

  /// Updates the current user's details in Firestore.
  static Future<User> updateCurrentUser(User user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.userID)
          .set(user.toJson());
      return user;
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  /// Uploads a user's image to Firebase Storage and returns the URL.
  static Future<String> uploadUserImage(
      Uint8List imageData, String userID) async {
    try {
      final uploadRef = _storage.child("images/$userID.png");
      final uploadTask = uploadRef.putData(
          imageData, SettableMetadata(contentType: 'image/jpeg'));
      return await (await uploadTask).ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      rethrow;
    }
  }

  /// Handles login with email and password.
  static Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return await getCurrentUser(credential.user?.uid ?? '');
    } on auth.FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected login error: $e');
      return 'Login failed, please try again.';
    }
  }

  /// Handles Facebook login and returns the authenticated user.
  static Future<dynamic> loginWithFacebook() async {
    try {
      final facebookAuth = FacebookAuth.instance;
      final result = await facebookAuth.login();

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken!;
        final userData = await facebookAuth.getUserData();
        return await _handleSocialLogin(
          auth.FacebookAuthProvider.credential(accessToken.token),
          userData,
        );
      }
      return result.message ?? 'Facebook login failed.';
    } catch (e) {
      debugPrint('Facebook login error: $e');
      return 'Login failed, please try again.';
    }
  }

  /// Handles Apple login and returns the authenticated user.
  static Future<dynamic> loginWithApple() async {
    try {
      final appleCredential = await apple.TheAppleSignIn.performRequests([
        const apple.AppleIdRequest(
          requestedScopes: [apple.Scope.email, apple.Scope.fullName],
        ),
      ]);

      if (appleCredential.status == apple.AuthorizationStatus.authorized) {
        final credential = auth.OAuthProvider('apple.com').credential(
          accessToken: String.fromCharCodes(
              appleCredential.credential?.authorizationCode ?? []),
          idToken: String.fromCharCodes(
              appleCredential.credential?.identityToken ?? []),
        );

        final userData = {
          'name': '${appleCredential.credential?.fullName?.givenName ?? ''} '
              '${appleCredential.credential?.fullName?.familyName ?? ''}',
          'email': appleCredential.credential?.email ?? '',
        };

        return await _handleSocialLogin(credential, userData);
      }
      return 'Login falhou.';
    } catch (e) {
      debugPrint('Apple login error: $e');
      return 'Login failed, please try again.';
    }
  }

  /// Creates a new user in Firestore.
  static Future<String?> createNewUser(User user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.userID)
          .set(user.toJson());
      return null;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return 'Error creating user.';
    }
  }

  /// Logs out the current user.
  static Future<void> logout() async {
    await auth.FirebaseAuth.instance.signOut();
  }

  /// Resets the user's password.
  static Future<void> resetPassword(String email) async {
    await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  /// Common handler for social login (Facebook/Apple).
  static Future<dynamic> _handleSocialLogin(
      auth.AuthCredential credential, Map<String, dynamic> userData) async {
    try {
      final authResult =
          await auth.FirebaseAuth.instance.signInWithCredential(credential);
      User? user = await getCurrentUser(authResult.user?.uid ?? '');

      final fullName = (userData['name'] ?? '').split(' ');
      final firstName = fullName.isNotEmpty ? fullName.first : 'Anonymous';
      final lastName = fullName.length > 1 ? fullName.sublist(1).join(' ') : '';

      if (user != null) {
        user
          ..firstName = firstName
          ..lastName = lastName
          ..email = userData['email'] ?? ''
          ..profilePictureURL = userData['picture']['data']['url'] ?? '';
        return await updateCurrentUser(user);
      }

      user = User(
        email: userData['email'] ?? '',
        firstName: firstName,
        lastName: lastName,
        profilePictureURL: userData['picture']['data']['url'] ?? '',
        userID: authResult.user?.uid ?? '',
      );
      return await createNewUser(user) ?? user;
    } catch (e) {
      debugPrint('Social login error: $e');
      return 'Login failed, please try again.';
    }
  }

  /// Handles Firebase exceptions and returns error messages.
  static String _handleAuthException(auth.FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'wrong-password':
        return 'Wrong password.';
      case 'user-not-found':
        return 'User not found.';
      case 'user-disabled':
        return 'User has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      default:
        return 'Authentication error. Please try again.';
    }
  }
}
