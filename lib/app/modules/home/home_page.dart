import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/app/core/auth/auth_provider.dart';
import 'package:todo_list_app/app/core/ui/theme_extensions.dart';
import 'package:todo_list_app/app/core/ui/to_do_list_icons.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_drawer.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_filters.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_header.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_tasks.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_week_filter.dart';
import 'package:todo_list_app/app/modules/tasks/task_create_page.dart';
import 'package:todo_list_app/app/modules/tasks/tasks_module.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _goToCreateTask(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.easeInQuad);
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.bottomRight,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return TasksModule().getPage('/task/create', context);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        iconTheme: IconThemeData(color: context.primaryColor),
        actions: [
          PopupMenuButton(
            icon: Icon(ToDoListIcons.filter),
            itemBuilder: (_) => [
              PopupMenuItem<bool>(child: Text('Mostrar Tarefas concluídas'))
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        onPressed: () => _goToCreateTask(context),
        child: Icon(Icons.add),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      drawer: HomeDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(),
                      HomeFilters(),
                      HomeWeekFilter(),
                      HomeTasks(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
