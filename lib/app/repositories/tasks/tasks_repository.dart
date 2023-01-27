import 'package:todo_list_app/app/models/task_model.dart';

abstract class TasksRepository {
  Future<void> save(DateTime date, String description);
  Future<List<TaskModel>> findByPeriod(DateTime start, DateTime end);
  Future<void> chekOrUncheckTask(TaskModel task);
  Future<void> deleteTask(int id);
  Future<void> deleteAll();
}
