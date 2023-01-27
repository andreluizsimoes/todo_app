import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/app/core/ui/theme_extensions.dart';
import 'package:todo_list_app/app/models/task_filter_enum.dart';
import 'package:todo_list_app/app/models/task_model.dart';
import 'package:todo_list_app/app/modules/home/home_controller.dart';
import 'package:todo_list_app/app/modules/home/widgets/task.dart';

class HomeTasks extends StatelessWidget {
  const HomeTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Selector<HomeController, String>(
          selector: (context, controller) {
            return controller.filterSelected.description;
          },
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'TASK\'S $value',
                style: context.titleStyle,
              ),
            );
          },
        ),
        Column(
          children: context
              .select<HomeController, List<TaskModel>>(
                  (controller) => controller.filteredTasks)
              .map((task) => Task(
                    task: task,
                  ))
              .toList(),
        )
      ],
    ));
  }
}
