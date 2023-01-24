import 'package:todo_list_app/app/repositories/tasks/tasks_repository.dart';

import './tasks_service.dart';

class TasksServiceImpl implements TasksService {
  final TasksRepository _tasksRepository;

  TasksServiceImpl({required TasksRepository repository})
      : _tasksRepository = repository;

  @override
  Future<void> save(DateTime date, String description) async =>
      _tasksRepository.save(date, description);
}
