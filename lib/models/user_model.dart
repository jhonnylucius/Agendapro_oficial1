import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String provider;
  final String lastLogin;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.provider,
    required this.lastLogin,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'provider': provider,
      'lastLogin': lastLogin,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      provider: json['provider'] ?? '',
      lastLogin: json['lastLogin'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  factory UserModel.fromFirebaseUser(User firebaseUser, String provider) {
    final now = DateTime.now().toIso8601String();
    return UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
      provider: provider,
      lastLogin: now,
      createdAt: now,
    );
  }
}
