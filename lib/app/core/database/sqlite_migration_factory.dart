import 'package:todo_list_app/app/core/database/migrations/migration.dart';
import 'package:todo_list_app/app/core/database/migrations/migration_v1.dart';
import 'package:todo_list_app/app/core/database/migrations/migration_v2.dart';

import 'migrations/migration_v3.dart';

class SqliteMigrationFactory {
  List<Migration> getCreateMigration() => [
        MigrationV1(),
        MigrationV2(),
        MigrationV3(),
      ];

  List<Migration> getUpgradeMigration(int version) {
    var migrations = <Migration>[];
    // Versão ATUAL = 3
    // Version = 1, tem que atualizar 2 e 3
    if (version == 1) {
      migrations.add(MigrationV2());
      migrations.add(MigrationV3());
    }
    // Version = 2, tem que atualizar 3

    if (version == 2) {
      migrations.add(MigrationV3());
    }

    return migrations;
  }
}
