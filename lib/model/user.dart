import 'dart:io';

import 'package:flutter/foundation.dart';

/// Classe que representa um usuário no sistema.
class User {
  String email; // Email do usuário
  String firstName; // Primeiro nome do usuário
  String lastName; // Sobrenome do usuário
  String userID; // Identificador único do usuário
  String profilePictureURL; // URL da foto de perfil do usuário
  final String appIdentifier; // Identificador do aplicativo e plataforma

  /// Construtor para inicializar os campos do usuário.
  User({
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.userID = '',
    this.profilePictureURL = '',
  }) : appIdentifier = 'AgendaPro ${kIsWeb ? 'Web' : Platform.operatingSystem}';

  /// Retorna o nome completo do usuário.
  String fullName() => '$firstName $lastName';

  /// Cria um objeto `User` a partir de um JSON recebido da API ou banco de dados.
  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      email: parsedJson['email'] ?? '', // Email do usuário ou valor padrão
      firstName: parsedJson['firstName'] ?? '', // Primeiro nome
      lastName: parsedJson['lastName'] ?? '', // Último nome
      userID: parsedJson['id'] ?? parsedJson['userID'] ?? '', // ID do usuário
      profilePictureURL:
          parsedJson['profilePictureURL'] ?? '', // Foto de perfil
    );
  }

  /// Converte o objeto `User` para um mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'email': email, // Email do usuário
      'firstName': firstName, // Primeiro nome
      'lastName': lastName, // Sobrenome
      'id': userID, // Identificador único
      'profilePictureURL': profilePictureURL, // URL da foto de perfil
      'appIdentifier': appIdentifier, // Identificador do app e plataforma
    };
  }
}
