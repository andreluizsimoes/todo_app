import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/app/core/ui/theme_extensions.dart';
import 'package:todo_list_app/app/models/task_model.dart';
import 'package:todo_list_app/app/modules/home/home_controller.dart';

class Task extends StatelessWidget {
  final TaskModel task;
  final dateFormat = DateFormat('dd/MM/y');

  Task({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeController>();
    return Dismissible(
      key: ValueKey<int>(task.id),
      onDismissed: (direction) {
        controller.deleteTask(task.id);
      },
      background: swipeToDelete(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: context.primaryColor),
            top: BorderSide(color: context.primaryColor),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: IntrinsicHeight(
          child: ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: Checkbox(
                value: task.finished,
                onChanged: (value) =>
                    context.read<HomeController>().chekOrUncheckTask(task),
                activeColor: context.primaryColor,
              ),
              title: Text(
                task.description,
                style: TextStyle(
                  height: 1.5,
                  decoration: task.finished ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                dateFormat.format(task.dateTime),
                style: TextStyle(
                  decoration: task.finished ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: Icon(
                Icons.delete_sweep_rounded,
              )),
        ),
      ),
    );
  }
}

Widget swipeToDelete() => Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete_sweep_rounded,
        color: Colors.white,
      ),
    );
