import 'package:sqflite_common/sqlite_api.dart';
import 'package:todo_list_app/app/core/database/migrations/migration.dart';

class MigrationV1 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
      create table todo(
        iid Integer primary key autoincremente,
        descricao varchar(500) not null,
        data_hora datetime,
        finalizado integer
      )
    ''');
  }

  @override
  void update(Batch batch) {
    // TODO: implement update
  }
}
