import 'package:todo_list_app/app/models/week_task_model.dart';

import '../../models/task_model.dart';

abstract class TasksService {
  Future<void> save(DateTime date, String description);
  Future<List<TaskModel>> getToday();
  Future<List<TaskModel>> getTomorrow();
  Future<WeekTaskModel> getWeek();
  Future<void> chekOrUncheckTask(TaskModel task);
  Future<void> deleteTask(int id);



  // Future<List<TaskModel>> findByPeriod(DateTime start, DateTime end);

}
