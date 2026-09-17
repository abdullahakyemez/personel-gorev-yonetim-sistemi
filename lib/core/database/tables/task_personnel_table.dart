import 'package:drift/drift.dart';

import 'personnel_table.dart';
import 'task_table.dart';

class TaskPersonnelTable extends Table {
  TextColumn get taskId =>
      text().references(TaskTable, #id, onDelete: KeyAction.cascade)();

  IntColumn get personnelId =>
      integer().references(PersonnelTable, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {taskId, personnelId};
}
