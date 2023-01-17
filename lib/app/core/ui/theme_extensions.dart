// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorLight => Theme.of(this).primaryColorLight;
  Color get buttonColor => Theme.of(this).buttonColor;
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle get titleStyle =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey);
}
