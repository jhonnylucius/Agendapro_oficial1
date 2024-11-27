import 'package:flutter/material.dart';

/// Lista de títulos para as telas de onboarding.
final List<String> titlesList = [
  'Introdução ao Flutter',
  'Autenticação Firebase',
  'Login com Facebook',
  'Instaflutter.com',
  'Comece agora mesmo',
];

/// Lista de subtítulos para as telas de onboarding.
/// Estes textos são exibidos abaixo dos títulos para fornecer mais informações.
final List<String> subtitlesList = [
  'Crie seu fluxo de onboarding em segundos.',
  'Gerencie usuários facilmente com o Firebase.',
  'Simplifique o login dos usuários com o Facebook.',
  'Descubra mais templates incríveis.',
  'Dê o primeiro passo para começar.',
];

/// Lista de imagens ou ícones para cada página de onboarding.
/// As imagens podem ser caminhos para arquivos ou objetos `IconData`.
final List<dynamic> imageList = [
  Icons.developer_mode, // Ícone representando desenvolvimento.
  Icons.layers, // Ícone representando camadas.
  Icons.account_circle, // Ícone representando contas de usuário.
  'assets/images/ic_launcher_round.png', // Caminho para um arquivo de imagem.
  Icons.code, // Ícone representando código.
];
