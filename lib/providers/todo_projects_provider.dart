import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/db/todo_project_db.dart';

class TodoProjectsNotifire extends StateNotifier<TodoProject?> {
  TodoProjectsNotifire() : super(null);

  bool setCurrentTodoProject({required TodoProject currProject}) {
    state = currProject;
    return true;
  }
}

final todoProjectsProvider =
    StateNotifierProvider<TodoProjectsNotifire, TodoProject?>(
        (ref) => TodoProjectsNotifire());
