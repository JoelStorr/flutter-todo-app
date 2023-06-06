import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

import 'package:todo_app/db/todo_project_db.dart';

class TodoProjectsNotifire extends StateNotifier<TodoProject> {
  TodoProjectsNotifire() : super(TodoProject());

  bool setCurrentTodoProject({required TodoProject currProject}) {
    state = currProject;
    return true;
  }
}

final todoProjectsProvider =
    StateNotifierProvider<TodoProjectsNotifire, TodoProject>(
        (ref) => TodoProjectsNotifire());
