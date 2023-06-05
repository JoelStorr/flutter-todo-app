import 'package:isar/isar.dart';
import 'todo_item_db.dart';
part 'todo_project_db.g.dart';

@Collection()
class TodoProject {
  Id id = Isar.autoIncrement;
  late String title;
  bool fullyAdded = false;
  @Backlink(to: 'todoProject')
  final todoItem = IsarLink<TodoItem>();
}
