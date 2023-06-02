import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

import 'package:todo_app/models/todolist_model.dart';

class TodoListsNotifire extends StateNotifier<List<TodoList>> {
  TodoListsNotifire() : super([]);

  void addTodoList(TodoList todoList) {
    state = [...state, todoList];
  }
}

final todoListsProvider =
    StateNotifierProvider<TodoListsNotifire, List<TodoList>>(
        (ref) => TodoListsNotifire());
