import 'dart:ffi';

import 'package:isar/isar.dart';
import 'package:todo_app/db/todo_item_db.dart';
import 'package:todo_app/db/todo_project_db.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<TodoProject> dbSetup() async {
    final isar = await db;

    final TodoProject baseProject = TodoProject()..title = 'Todo';

    final temProject = await getAllProjects();

    if (temProject.isEmpty) {
      final id = await saveTodoProject(baseProject);
      final item = await getProject(id: id);
      if (item == null) {
        throw Error();
      }

      return item;
    }

    final baseItem = await getProject();
    if (baseItem == null) {
      throw Error();
    }

    return baseItem;
  }

  //You pase in the TodoProject modle when you call the Function you use the Collectiosn for that
  Future<int> saveTodoProject(TodoProject newProject) async {
    final isar = await db;

    return isar.writeTxnSync(() => isar.todoProjects.putSync(newProject));
  }

  Future<void> saveTodoItem(TodoItem newItem) async {
    final isar = await db;

    isar.writeTxnSync(() => isar.todoItems.putSync(newItem));
  }

  Future<TodoProject?> getProject({int? id}) async {
    final isar = await db;

    if (id == null) {
      return await isar.todoProjects.where().findFirst();
    } else {
      return await isar.todoProjects.where().idEqualTo(id).findFirst();
    }
  }

  Future<List<TodoProject>> getAllProjects() async {
    final isar = await db;
    return await isar.todoProjects.where().findAll();
  }

  Future<List<TodoItem>> getTodoItemsFor(TodoProject curProject) async {
    final isar = await db;
    return await isar.todoItems
        .filter()
        .todoProject((q) => q.idEqualTo(curProject.id))
        .findAll();
  }

/* NOTE: Listeners  */

  //Listens to changes inside the Todo Project db
  Stream<List<TodoProject>> listenToProjects() async* {
    final isar = await db;
    yield* isar.todoProjects.where().watch(fireImmediately: true);
  }

  Stream<List<TodoItem>>? listenActiveTodoItemsFor(
      TodoProject curProject) async* {
    final isar = await db;
    yield* isar.todoItems
        .where()
        .filter()
        .doneEqualTo(false)
        .todoProject((q) => q.idEqualTo(curProject.id))
        .watch();
  }

  Future<List<TodoItem>> getDoneTodoItemsFor(TodoProject curProject) async {
    final isar = await db;
    return await isar.todoItems
        .filter()
        .doneEqualTo(true)
        .todoProject((q) => q.idEqualTo(curProject.id))
        .findAll();
  }

/* NOTE: Drops Database */
  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
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
