import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list_app/app/core/database/sqlite_adm_connection.dart';
import 'package:todo_list_app/app/core/navigator/todo_list_navigator.dart';
import 'package:todo_list_app/app/core/ui/todo_list_ui_config.dart';
import 'package:todo_list_app/app/modules/auth/auth_module.dart';
import 'package:todo_list_app/app/modules/home/home_module.dart';
import 'package:todo_list_app/app/modules/splash/splash_page.dart';
import 'package:todo_list_app/app/modules/tasks/tasks_module.dart';

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
      theme: TodoListUiConfig.theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: TodoListNavigator.navigatorKey,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      routes: {
        ...AuthModule().routers,
        ...HomeModule().routers,
        ...TasksModule().routers
      },
      home: SplashPage(),
    );
  }
}
