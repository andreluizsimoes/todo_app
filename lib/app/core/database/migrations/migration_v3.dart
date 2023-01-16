import 'package:sqflite_common/sqlite_api.dart';
import 'package:todo_list_app/app/core/database/migrations/migration.dart';

class MigrationV3 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
      create table nova(
        id Integer
      )
    ''');
  }

  @override
  void update(Batch batch) {
    batch.execute('''
      create table nova(
        id Integer
      )
    ''');
  }
}
