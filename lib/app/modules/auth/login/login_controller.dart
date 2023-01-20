import 'package:flutter/material.dart';

import 'package:todo_list_app/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_app/app/exceptions/auth_exception.dart';
import 'package:todo_list_app/app/services/user/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;

  LoginController({
    required UserService userService,
  }) : _userService = userService;

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      final user = await _userService.login(email, password);

      if (user != null) {
        success();
      } else {
        setError('Usuário ou Senha inválidos!');
      }
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
