import 'package:todo_list_app/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list_app/app/models/task_model.dart';

import './tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final SqliteConnectionFactory _sqliteConnectionFactory;

  TasksRepositoryImpl(
      {required SqliteConnectionFactory sqliteConnectionFactory})
      : _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<void> save(DateTime date, String description) async {
    final conn = await _sqliteConnectionFactory.opennConnection();
    await conn.insert('todo', {
      'id': null,
      'descricao': description,
      'data_hora': date.toIso8601String(),
      'finalizado': 0
    });
  }

  @override
  Future<List<TaskModel>> findByPeriod(DateTime start, DateTime end) async {
    final startFilter = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endFilter = DateTime(end.year, end.month, end.day, 23, 59, 59);

    final conn = await _sqliteConnectionFactory.opennConnection();
    final result = await conn.rawQuery(
        '''
        select * 
        from todo 
        where data_hora between ? and ? 
        order by data_hora
        ''',
        [
          startFilter.toIso8601String(),
          endFilter.toIso8601String(),
        ]);

    return result.map((task) => TaskModel.loadFromDB(task)).toList();
  }

  @override
  Future<void> chekOrUncheckTask(TaskModel task) async {
    final conn = await _sqliteConnectionFactory.opennConnection();
    final finished = task.finished ? 1 : 0;

    await conn.rawUpdate(
        'update todo set finalizado = ? where id = ?', [finished, task.id]);
  }

  @override
  Future<void> deleteTask(int id) async {
    final conn = await _sqliteConnectionFactory.opennConnection();

    await conn.rawDelete('delete from todo where id = ?', [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _sqliteConnectionFactory.deleteDB();
  }
}
