import 'package:flutter/material.dart';
import 'package:todo_list_app/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_app/app/core/ui/theme_extensions.dart';
import 'package:todo_list_app/app/core/ui/to_do_list_icons.dart';
import 'package:todo_list_app/app/models/task_filter_enum.dart';
import 'package:todo_list_app/app/modules/home/home_controller.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_drawer.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_filters.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_header.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_tasks.dart';
import 'package:todo_list_app/app/modules/home/widgets/home_week_filter.dart';
import 'package:todo_list_app/app/modules/tasks/tasks_module.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;
  const HomePage({Key? key, required HomeController homeController})
      : _homeController = homeController,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
      context: context,
      successCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._homeController.loadTotalTasks();
      widget._homeController.findTasks(filter: TaskFilterEnum.today);
    });
  }

  Future<void> _goToCreateTask(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
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
      ),
    );
    widget._homeController.refreshPage();
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
            onSelected: (value) {
              widget._homeController.showOrHideFinishedTasks();
            },
            itemBuilder: (_) => [
              PopupMenuItem<bool>(
                value: true,
                child: Text(
                    '${widget._homeController.showFinishedTasks ? 'Esconder' : 'Mostrar'} Tarefas concluídas'),
              )
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
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeHeader(),
                          HomeFilters(),
                          HomeWeekFilter(),              
                        ],
                      ),
                    ),
                  ),Container(
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeTasks(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
