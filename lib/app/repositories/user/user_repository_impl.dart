// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_app/app/exceptions/auth_exception.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'email-already-in-use') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthException(
              message: 'E-mail já utilizado, por favor escolha outro e-mail!');
        } else {
          throw AuthException(
              message:
                  'Você fez o cadastro com sua conta Google! Use-a para fazer Login!');
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuário!');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userData = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return userData.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: e.message ?? 'Erro ao realizar o Login!!!');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'wrong-password') {
        throw AuthException(message: 'Senha Inválida!');
      } else if (e.code == 'user-not-found') {
        throw AuthException(message: 'E-mail não cadastrado!');
      }
      throw AuthException(message: e.message ?? 'Erro ao realizar o Login!!!');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginTypes = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (loginTypes.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginTypes.contains('google')) {
        throw AuthException(
            message:
                'Cadastro feito com a Conta Google! Não podemos resetar a sua senha!');
      } else {
        throw AuthException(message: 'E-mail não cadastrado');
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: 'Erro ao resetar a senha.');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginTypes;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
        if (loginTypes.contains('password')) {
          throw AuthException(
              message:
                  'Você já usou esse e-mail para cadastro! Por favor use o link "Esqueci minha senha"');
        } else {
          final googleAuth = await googleUser.authentication;
          final googleCredential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

          var userCredential =
              await _firebaseAuth.signInWithCredential(googleCredential);

          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(
            message:
                '''
                Login Inválido! Você se registrou no ToDo List usando outro provedor:
                ${loginTypes?.join(',')}
                        ''');
      } else {
        throw AuthException(message: 'Erro ao realizar login!');
      }
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
