import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/app/core/ui/theme_extensions.dart';
import 'package:todo_list_app/app/models/task_filter_enum.dart';
import 'package:todo_list_app/app/models/total_tasks_model.dart';
import 'package:todo_list_app/app/modules/home/home_controller.dart';

class TodoCardFilter extends StatelessWidget {
  final String label;
  final TaskFilterEnum taskFilter;
  final TotalTasksModel? totalTasksModel;
  final bool selected;

  const TodoCardFilter(
      {Key? key,
      required this.label,
      required this.taskFilter,
      required this.selected,
      this.totalTasksModel})
      : super(key: key);

  double _getPercentFinished() {
    final total = totalTasksModel?.totalTasks ?? 0.1;
    final finished = totalTasksModel?.totalTasksFinished ?? 0.0;

    if (total == 0) {
      return 0.0;
    } else {
      return finished / total;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = totalTasksModel?.totalTasks ?? 0;
    final finished = totalTasksModel?.totalTasksFinished ?? 0;
    final toDo = total - finished;
    final controller = context.read<HomeController>();
    return InkWell(
      onTap: () => context.read<HomeController>().findTasks(filter: taskFilter),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 120,
          maxWidth: 150,
        ),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            color: selected ? context.primaryColor : Colors.white,
            border: Border.all(width: 1, color: Colors.grey.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${controller.showFinishedTasks ? total : toDo} TASKS',
              style: context.titleStyle.copyWith(
                fontSize: 10,
                color: selected ? Colors.white : Colors.grey,
              ),
            ),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.0,
                end: _getPercentFinished(),
              ),
              duration: Duration(seconds: 1),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  backgroundColor: selected
                      ? context.primaryColorLight
                      : Colors.grey.shade400,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      selected ? Colors.white : context.primaryColor),
                  value: value,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
