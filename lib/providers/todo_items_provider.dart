import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

import 'package:todo_app/models/todo_item_model.dart';

/* 
  Structure Idea for State
  {
    parentProjectId : [TodoItems, TodoItems],
    parentProjectId : [TodoItems, TodoItems],
  }
 */

class TodoItemsNotifire extends StateNotifier<List<TodoItem>> {
  TodoItemsNotifire()
      : super([TodoItem(name: 'Default Todo', projectId: '0000', postion: 0)]);

  bool addTodoItem({required String todoItemName, required String projectId}) {
    final currentListLength = state.length;
    final tempTodoProject = TodoItem(
      name: todoItemName,
      projectId: projectId,
      postion: currentListLength,
    );

    state = [...state, tempTodoProject];
    return true;
  }
}

final TodoItemsProvider =
    StateNotifierProvider<TodoItemsNotifire, List<TodoItem>>(
        (ref) => TodoItemsNotifire());
