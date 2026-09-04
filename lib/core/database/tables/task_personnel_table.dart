import 'package:drift/drift.dart';

import 'task_table.dart';

class TaskPersonnelTable extends Table {
  TextColumn get taskId =>
      text().references(TaskTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get personnelId => text()();

  @override
  Set<Column<Object>> get primaryKey => {taskId, personnelId};
}
