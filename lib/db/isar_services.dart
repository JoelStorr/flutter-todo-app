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

  //NOTE:-----------------------------------------------------------------------
  //NOTE: Initialize DB for Start

  Future<TodoProject> dbSetup() async {
    final TodoProject baseProject = TodoProject()
      ..title = 'Todo'
      ..fullyAdded = true;

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

  //NOTE:-----------------------------------------------------------------------
  //NOTE: Add Elements

  //You pase in the TodoProject modle when you call the Function you use the Collectiosn for that
  Future<int> saveTodoProject(TodoProject newProject) async {
    final isar = await db;

    return isar.writeTxnSync(() {
      return isar.todoProjects.putSync(newProject);
    });
  }

  Future<void> saveTodoItem(TodoItem newItem) async {
    final isar = await db;

    isar.writeTxnSync(() => isar.todoItems.putSync(newItem));
  }

  //NOTE: Edit Elements
  Future<void> editTodoProject({required int id, required String title}) async {
    final isar = await db;
    TodoProject? modifyTodo = await isar.todoProjects.get(id);
    isar.writeTxnSync(() async {
      if (modifyTodo == null) {
        return;
      }
      modifyTodo.title = title;
      modifyTodo.fullyAdded = true;

      isar.todoProjects.putSync(modifyTodo);
    });
  }

  Future<void> editTodoItem(
      {required int id, required String todo, required bool status}) async {
    final isar = await db;
    TodoItem? modifyTodo = await isar.todoItems.get(id);
    isar.writeTxnSync(() async {
      if (modifyTodo == null) {
        return;
      }
      modifyTodo.todo = todo;
      modifyTodo.done = status;

      isar.todoItems.putSync(modifyTodo);
    });
  }

  //NOTE: Edit Todo State
  Future<void> editTodoState({required int id, required bool status}) async {
    final isar = await db;
    TodoItem? modifyTodo = await isar.todoItems.get(id);
    isar.writeTxnSync(() async {
      if (modifyTodo == null) {
        return;
      }

      modifyTodo.done = status;

      isar.todoItems.putSync(modifyTodo);
    });
  }

  // NOTE: Delete Elements
  Future<void> deleteElement(int id, {bool project = false}) async {
    final isar = await db;
    isar.writeTxnSync(
      () async {
        if (project) {
          isar.todoProjects.deleteSync(id);
        } else {
          isar.todoItems.deleteSync(id);
        }
      },
    );
  }

  //NOTE:-----------------------------------------------------------------------
  //NOTE: Getters

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

//NOTE:-----------------------------------------------------------------------
// NOTE: Listeners

  //Listens to changes inside the Todo Project db
  Stream<List<TodoProject>> listenToProjects() async* {
    final isar = await db;
    yield* isar.todoProjects.where().watch(fireImmediately: true);
  }

  Stream<List<TodoItem>> listenActiveTodoItemsFor(
      TodoProject curProject) async* {
    final isar = await db;
    yield* isar.todoItems
        .where()
        .filter()
        .todoProject((q) => q.idEqualTo(curProject.id))
        .and()
        .not()
        .doneEqualTo(true)
        .watch(fireImmediately: true);
  }

  Stream<List<TodoItem>> listenDoneTodoItemsFor(TodoProject curProject) async* {
    final isar = await db;
    yield* isar.todoItems
        .filter()
        .todoProject((q) => q.idEqualTo(curProject.id))
        .and()
        .doneEqualTo(true)
        .watch(fireImmediately: true);
  }

//NOTE:-----------------------------------------------------------------------
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
