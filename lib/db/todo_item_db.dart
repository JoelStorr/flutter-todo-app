import 'package:isar/isar.dart';

import 'todo_project_db.dart';

part 'todo_item_db.g.dart';

@Collection()
class TodoItem {
  Id id = Isar.autoIncrement;
  late String todo;
  bool? done;
  late DateTime finishedAt;
  final todoProject = IsarLink<TodoProject>();
}
