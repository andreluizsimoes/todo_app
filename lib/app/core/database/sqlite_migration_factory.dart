import 'package:todo_list_app/app/core/database/migrations/migration.dart';
import 'package:todo_list_app/app/core/database/migrations/migration_v1.dart';

class SqliteMigrationFactory {
  List<Migration> getCreateMigration() => [
        MigrationV1(),
      ];

  List<Migration> getUpgradeMigration(int version) {
    var migrations = <Migration>[];
    // Versão ATUAL = 3
    // Version = 1, tem que atualizar 2 e 3
    if (version == 1) {}
    // Version = 2, tem que atualizar 3

    if (version == 2) {}

    return migrations;
  }
}
