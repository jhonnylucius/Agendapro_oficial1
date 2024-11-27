import 'dart:typed_data';

import 'package:agendapro/constants.dart';
import 'package:agendapro/model/user.dart';
import 'package:agendapro/services/authenticate.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// Gerencia os eventos de autenticação e seus respectivos estados.
/// Esta classe utiliza o padrão Bloc para gerenciar o fluxo de autenticação.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  User? user; // Usuário autenticado atual.
  late SharedPreferences
      prefs; // Preferências compartilhadas para armazenamento local.
  late bool finishedOnBoarding; // Indica se o onboarding foi concluído.

  /// Construtor que inicializa o estado não autenticado como padrão.
  AuthenticationBloc({this.user})
      : super(const AuthenticationState.unauthenticated()) {
    // Verifica se é a primeira execução do app.
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const AuthenticationState.onboarding());
      } else {
        user = await FireStoreUtils.getAuthUser();
        if (user == null) {
          emit(const AuthenticationState.unauthenticated());
        } else {
          emit(AuthenticationState.authenticated(user!));
        }
      }
    });

    // Evento para concluir o onboarding.
    on<FinishedOnBoardingEvent>((event, emit) async {
      await prefs.setBool(finishedOnBoardingConst, true);
      emit(const AuthenticationState.unauthenticated());
    });

    // Login com e-mail e senha.
    on<LoginWithEmailAndPasswordEvent>((event, emit) async {
      dynamic result = await FireStoreUtils.loginWithEmailAndPassword(
          event.email, event.password);
      if (result != null && result is User) {
        user = result;
        emit(AuthenticationState.authenticated(user!));
      } else if (result != null && result is String) {
        emit(AuthenticationState.unauthenticated(message: result));
      } else {
        emit(const AuthenticationState.unauthenticated(
            message: 'Falha no login. Tente novamente.'));
      }
    });

    // Login com o Facebook.
    on<LoginWithFacebookEvent>((event, emit) async {
      dynamic result = await FireStoreUtils.loginWithFacebook();
      if (result != null && result is User) {
        user = result;
        emit(AuthenticationState.authenticated(user!));
      } else if (result != null && result is String) {
        emit(AuthenticationState.unauthenticated(message: result));
      } else {
        emit(const AuthenticationState.unauthenticated(
            message: 'Falha no login pelo Facebook. Tente novamente.'));
      }
    });

    // Login com o Apple.
    on<LoginWithAppleEvent>((event, emit) async {
      dynamic result = await FireStoreUtils.loginWithApple();
      if (result != null && result is User) {
        user = result;
        emit(AuthenticationState.authenticated(user!));
      } else if (result != null && result is String) {
        emit(AuthenticationState.unauthenticated(message: result));
      } else {
        emit(const AuthenticationState.unauthenticated(
            message: 'Falha no login pela Apple. Tente novamente.'));
      }
    });

    // Login ou criação de usuário com número de telefone.
    on<LoginWithPhoneNumberEvent>((event, emit) async {
      dynamic result =
          await FireStoreUtils.loginOrCreateUserWithPhoneNumberCredential(
              credential: event.credential,
              phoneNumber: event.phoneNumber,
              firstName: event.firstName,
              lastName: event.lastName,
              imageData: event.imageData);
      if (result is User) {
        user = result;
        emit(AuthenticationState.authenticated(result));
      } else if (result is String) {
        emit(AuthenticationState.unauthenticated(message: result));
      }
    });

    // Criação de conta com e-mail e senha.
    on<SignupWithEmailAndPasswordEvent>((event, emit) async {
      dynamic result = await FireStoreUtils.signUpWithEmailAndPassword(
          emailAddress: event.emailAddress,
          password: event.password,
          imageData: event.imageData,
          firstName: event.firstName,
          lastName: event.lastName);
      if (result != null && result is User) {
        user = result;
        emit(AuthenticationState.authenticated(user!));
      } else if (result != null && result is String) {
        emit(AuthenticationState.unauthenticated(message: result));
      } else {
        emit(const AuthenticationState.unauthenticated(
            message: 'Não foi possível criar a conta.'));
      }
    });

    // Logout.
    on<LogoutEvent>((event, emit) async {
      await FireStoreUtils.logout();
      user = null;
      emit(const AuthenticationState.unauthenticated());
    });
  }
}
