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

  Future<void> saveTodoItem(TodoItem newItem) async {
    final isar = await db;

    isar.writeTxnSync(() => isar.todoItems.putSync(newItem));
  }

  Future<List<TodoProject>> getAllProjects() async {
    final isar = await db;
    return await isar.todoProjects.where().findAll();
  }

  //Listens to changes inside the Todo Project db
  Stream<List<TodoProject>> listenToProjects() async* {
    final isar = await db;

    yield* isar.todoProjects.where().watch(fireImmediately: true);
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<List<TodoItem>> getTodoItemsFor(TodoProject curProject) async {
    final isar = await db;
    return await isar.todoItems
        .filter()
        .todoProject((q) => q.idEqualTo(curProject.id))
        .findAll();
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
