import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String provider;
  final String lastLogin;
  final String createdAt;
  final String? userType; // Cliente, Prestador de Serviços ou Ambos
  final String? category; // Autônomo, MEI, etc.
  final String? areaOfExpertise; // Área de atuação
  final List<String>? servicesOffered; // Serviços prestados
  final String? city;
  final String? phone;
  final String? cpf;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.provider,
    required this.lastLogin,
    required this.createdAt,
    this.userType,
    this.category,
    this.areaOfExpertise,
    this.servicesOffered,
    this.city,
    this.phone,
    this.cpf,
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
      'userType': userType,
      'category': category,
      'areaOfExpertise': areaOfExpertise,
      'servicesOffered': servicesOffered,
      'city': city,
      'phone': phone,
      'cpf': cpf,
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
      userType: json['userType'],
      category: json['category'],
      areaOfExpertise: json['areaOfExpertise'],
      servicesOffered: List<String>.from(json['servicesOffered'] ?? []),
      city: json['city'],
      phone: json['phone'],
      cpf: json['cpf'],
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
