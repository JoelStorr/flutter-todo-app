import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

import 'package:todo_app/models/todo_item_model.dart';

class TodoItemsNotifire extends StateNotifier<List<TodoItem>> {
  TodoItemsNotifire() : super([]);

  bool addTodoItem({required String todoItemName, required String parentId}) {
    final currentListLength = state.length;
    final tempTodoProject = TodoItem(
      name: todoItemName,
      parentId: parentId,
      postion: currentListLength,
    );

    state = [...state, tempTodoProject];
    return true;
  }
}

final todoProjectsProvider =
    StateNotifierProvider<TodoItemsNotifire, List<TodoItem>>(
        (ref) => TodoItemsNotifire());
