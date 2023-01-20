// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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
}
