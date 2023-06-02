import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

import 'package:todo_app/models/todo_project_model.dart';

class TodoProjectsNotifire extends StateNotifier<List<TodoProjects>> {
  TodoProjectsNotifire() : super([]);

  void addTodoList(TodoProjects todoList) {
    state = [...state, todoList];
  }
}

final todoProjectsProvider =
    StateNotifierProvider<TodoProjectsNotifire, List<TodoProjects>>(
        (ref) => TodoProjectsNotifire());
