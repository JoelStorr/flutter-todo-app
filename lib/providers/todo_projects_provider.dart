import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

import 'package:todo_app/models/todo_project_model.dart';

class TodoProjectsNotifire extends StateNotifier<List<TodoProject>> {
  TodoProjectsNotifire() : super([TodoProject(position: 0, name: 'Todos')]);

  bool addTodoProject({required String todoProjectName}) {
    final currentListLength = state.length;
    final tempTodoProject =
        TodoProject(position: currentListLength, name: todoProjectName);

    state = [...state, tempTodoProject];
    return true;
  }
}

final todoProjectsProvider =
    StateNotifierProvider<TodoProjectsNotifire, List<TodoProject>>(
        (ref) => TodoProjectsNotifire());
