import 'package:todo_list_app/app/models/task_model.dart';
import 'package:todo_list_app/app/repositories/tasks/tasks_repository.dart';

import '../../models/week_task_model.dart';
import './tasks_service.dart';

class TasksServiceImpl implements TasksService {
  final TasksRepository _tasksRepository;

  TasksServiceImpl({required TasksRepository repository})
      : _tasksRepository = repository;

  @override
  Future<void> save(DateTime date, String description) async =>
      _tasksRepository.save(date, description);

  // @override
  // Future<List<TaskModel>> findByPeriod(DateTime start, DateTime end) =>
  //     _tasksRepository.findByPeriod(start, end);

  @override
  Future<List<TaskModel>> getToday() {
    return _tasksRepository.findByPeriod(DateTime.now(), DateTime.now());
  }

  @override
  Future<List<TaskModel>> getTomorrow() {
    var tomorrow = DateTime.now().add(Duration(days: 1));
    return _tasksRepository.findByPeriod(tomorrow, tomorrow);
  }

  @override
  Future<WeekTaskModel> getWeek() async {
    final today = DateTime.now();
    var startFilter = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endFilter;

    if (startFilter.weekday != DateTime.monday) {
      startFilter =
          startFilter.subtract(Duration(days: startFilter.weekday - 1));
    }

    endFilter = startFilter.add(Duration(days: 7));

    final tasks = await _tasksRepository.findByPeriod(startFilter, endFilter);

    return WeekTaskModel(
      startDate: startFilter,
      endDate: endFilter,
      tasks: tasks,
    );
  }

  @override
  Future<void> chekOrUncheckTask(TaskModel task) =>
      _tasksRepository.chekOrUncheckTask(task);

  @override
  Future<void> deleteTask(int id) => _tasksRepository.deleteTask(id);

  @override
  Future<void> deleteAll() => _tasksRepository.deleteAll();
}
