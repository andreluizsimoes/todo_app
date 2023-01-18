import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/app/core/database/sqlite_adm_connection.dart';
import 'package:todo_list_app/app/core/ui/todo_list_ui_config.dart';
import 'package:todo_list_app/app/modules/auth/auth_module.dart';
import 'package:todo_list_app/app/modules/splash/splash_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  var sqliteAdmConnection = SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    WidgetsBinding.instance.addObserver(sqliteAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(sqliteAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List Provider',
      initialRoute: '/login',
      theme: TodoListUiConfig.theme,
      routes: {...AuthModule().routers},
      home: SplashPage(),
    );
  }
}
