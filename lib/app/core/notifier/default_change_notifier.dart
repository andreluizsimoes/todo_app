import 'package:flutter/material.dart';

class DefaultChangeNotifier extends ChangeNotifier {
  bool _loading = false;
  bool _success = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isSuccess => _success;

  void showLoading() => _loading = true;
  void hideLoading() => _loading = false;

  void success() => _success = true;
  void setError(String? error) => _error = error;

  void resetState() {
    setError(null);
    _success = false;
  }

  void showLoadingAndResetState() {
    showLoading();
    resetState();
  }
}
