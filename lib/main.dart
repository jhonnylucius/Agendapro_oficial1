import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_screen/constants.dart';
import 'package:flutter_login_screen/firebase_options.dart';
import 'package:flutter_login_screen/ui/auth/authentication_bloc.dart';
import 'package:flutter_login_screen/ui/auth/launcherScreen/launcher_screen.dart';
import 'package:flutter_login_screen/ui/loading_cubit.dart';

void main() async {
  // Garante que os widgets do Flutter são inicializados antes do código principal
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a autenticação do Facebook
  await _initializeFacebookAuth();

  // Inicializa o aplicativo principal
  runApp(const MyApp());
}

// Função para inicializar o Facebook Auth
Future<void> _initializeFacebookAuth() async {
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.macOS) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: facebookAppID, // ID do app registrado no Facebook
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
}

// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provedores para gerenciar o estado do aplicativo
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (_) => AuthenticationBloc()), // Gerencia autenticação
        RepositoryProvider(
            create: (_) => LoadingCubit()), // Gerencia estado de carregamento
      ],
      child:
          const AppInitializer(), // Inicializa o Firebase e outras dependências
    );
  }
}

// Classe que inicializa o Firebase e verifica erros durante o processo
class AppInitializer extends StatefulWidget {
  const AppInitializer({Key? key}) : super(key: key);

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false; // Estado inicial do Firebase
  bool _hasError = false; // Indica se ocorreu um erro na inicialização

  @override
  void initState() {
    super.initState();
    _initializeFirebase(); // Inicializa o Firebase ao iniciar o app
  }

  // Função para inicializar o Firebase
  Future<void> _initializeFirebase() async {
    try {
      if (kIsWeb) {
        // Configuração específica para a web
        await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
      } else {
        // Configuração para outras plataformas
        await Firebase.initializeApp();
      }
      setState(() {
        _isInitialized = true; // Define como inicializado com sucesso
      });
    } catch (_) {
      setState(() {
        _hasError = true; // Define como erro caso ocorra falha na inicialização
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      // Exibe a tela de erro caso ocorra falha na inicialização
      return const _ErrorScreen();
    }

    if (!_isInitialized) {
      // Exibe a tela de carregamento enquanto o Firebase não estiver pronto
      return const _LoadingScreen();
    }

    // Configuração principal do app quando o Firebase estiver inicializado
    return MaterialApp(
      theme: _buildLightTheme(), // Tema claro
      darkTheme: _buildDarkTheme(), // Tema escuro
      debugShowCheckedModeBanner: false,
      home: const LauncherScreen(), // Tela inicial do aplicativo
    );
  }

  // Método para criar o tema claro do aplicativo
  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
      snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(color: Colors.white)),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(colorPrimary),
        brightness: Brightness.light,
      ),
    );
  }

  // Método para criar o tema escuro do aplicativo
  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade800,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
      snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(color: Colors.white)),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(colorPrimary),
        brightness: Brightness.dark,
      ),
    );
  }
}

// Tela exibida quando ocorre um erro
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 16),
                Text(
                  'Falha ao inicializar o Firebase!',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Tela exibida durante o carregamento
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
