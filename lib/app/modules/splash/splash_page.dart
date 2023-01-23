import 'package:flutter/material.dart';
import 'package:todo_list_app/app/core/widget/todo_list_logo.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TodoListLogo(),
      ),
    );
  }
}
