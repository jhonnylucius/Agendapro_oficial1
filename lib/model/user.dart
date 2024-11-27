import 'dart:io';

import 'package:flutter/foundation.dart';

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String userID;
  final String profilePictureURL;
  final String platform;

  /// Construtor para criar um usuário, inicializando os campos.
  User({
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.userID = '',
    this.profilePictureURL = '',
  }) : platform =
            'Flutter Login Screen for ${kIsWeb ? 'Web' : Platform.isAndroid ? 'Android' : 'Unsupported'}';

  /// Retorna o nome completo do usuário, formatado.
  String get fullName => '$firstName $lastName';

  /// Cria um objeto `User` a partir de um JSON recebido da API.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      userID: json['id'] ?? json['userID'] ?? '',
      profilePictureURL: json['profilePictureURL'] ?? '',
    );
  }

  /// Converte o objeto `User` para um JSON que será enviado ou armazenado.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'id': userID,
      'profilePictureURL': profilePictureURL,
      'platform': platform,
    };
  }
}
