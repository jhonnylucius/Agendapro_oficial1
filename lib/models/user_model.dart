import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl; // URL da foto armazenada no Firebase Storage
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

  // Converte o modelo para um mapa JSON
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

  // Cria o modelo a partir de um mapa JSON
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

  // Cria o modelo a partir de um usuário Firebase
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

  // Faz o upload da foto no Firebase Storage e retorna a URL gerada
  static Future<String?> uploadPhoto(String userId, String filePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('user_photos/$userId');
      final uploadTask = await ref.putFile(File(filePath));
      return await uploadTask.ref.getDownloadURL(); // Retorna a URL da imagem
    } catch (e) {
      print('Erro ao fazer upload da foto: $e');
      return null;
    }
  }

  // Atualiza as informações do usuário no Realtime Database
  Future<void> saveToRealtimeDatabase() async {
    try {
      final ref = FirebaseDatabase.instance.ref('users/$id');
      await ref.set(toJson()); // Salva os dados convertidos para JSON
    } catch (e) {
      print('Erro ao salvar usuário no Realtime Database: $e');
    }
  }

  // Atualiza a URL da foto no modelo e no Realtime Database
  static Future<void> updatePhotoUrl(String userId, String photoUrl) async {
    try {
      final ref = FirebaseDatabase.instance.ref('users/$userId');
      await ref.update({'photoUrl': photoUrl}); // Atualiza apenas a URL da foto
    } catch (e) {
      print('Erro ao atualizar a URL da foto no Realtime Database: $e');
    }
  }
}
