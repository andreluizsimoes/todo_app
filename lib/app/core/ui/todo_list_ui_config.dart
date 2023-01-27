import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoListUiConfig {
  TodoListUiConfig._();
  static ThemeData get theme => ThemeData(
      textTheme: GoogleFonts.mandaliTextTheme(),
      primaryColor: Color(0xFF12a698),
      primaryColorLight: Color.fromARGB(255, 171, 247, 247),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF12a698),
      )));
}
