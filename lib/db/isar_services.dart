import 'package:isar/isar.dart';
import 'package:todo_app/db/todo_item_db.dart';
import 'package:todo_app/db/todo_project_db.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  //You pase in the TodoProject modle when you call the Function you use the Collectiosn for that
  Future<void> saveTodoProject(TodoProject newProject) async {
    final isar = await db;

    isar.writeTxnSync(() => isar.todoProjects.putSync(newProject));
  }

  //NOTE: Sets up the DB at the beginning of the App
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TodoItemSchema, TodoProjectSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
