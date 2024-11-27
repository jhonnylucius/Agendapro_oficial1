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
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do FacebookAuth para Web e macOS
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.macOS) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: facebookAppID,
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (_) => AuthenticationBloc()),
      RepositoryProvider(create: (_) => LoadingCubit()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _initializeFlutterFire();
  }

  /// Método para inicializar o Firebase
  Future<void> _initializeFlutterFire() async {
    try {
      if (kIsWeb) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
      } else {
        await Firebase.initializeApp();
      }
      _setInitialized(true);
    } catch (e) {
      debugPrint('Erro ao inicializar o Firebase: $e');
      _setError(true);
    }
  }

  /// Atualiza o estado para indicar inicialização bem-sucedida
  void _setInitialized(bool value) {
    if (mounted) {
      setState(() {
        _initialized = value;
      });
    }
  }

  /// Atualiza o estado para indicar erro na inicialização
  void _setError(bool value) {
    if (mounted) {
      setState(() {
        _error = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Exibe mensagem de erro se a inicialização falhar
    if (_error) {
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
                    'Erro ao inicializar o Firebase!',
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

    // Exibe indicador de carregamento enquanto o Firebase não está inicializado
    if (!_initialized) {
      return MaterialApp(
        home: Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    }

    // Retorna a aplicação principal
    return MaterialApp(
      theme: _buildLightTheme(context),
      darkTheme: _buildDarkTheme(context),
      debugShowCheckedModeBanner: false,
      home: const LauncherScreen(),
    );
  }

  /// Tema claro da aplicação
  ThemeData _buildLightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(colorPrimary),
        brightness: Brightness.light,
      ),
    );
  }

  /// Tema escuro da aplicação
  ThemeData _buildDarkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade800,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(colorPrimary),
        brightness: Brightness.dark,
      ),
    );
  }
}
