import 'package:flutter_riverpod/flutter_riverpod.dart';

/* import 'dart:io'; */

import 'package:todo_app/models/todo_item_model.dart';

/* 
  Structure Idea for State
  {
    parentProjectId : [TodoItems, TodoItems],
    parentProjectId : [TodoItems, TodoItems],
  }
 */
// TodoItem(name: 'Default Todo', projectId: '0000', postion: 0)
class TodoItemsNotifire extends StateNotifier<Map<String, List>> {
  TodoItemsNotifire()
      : super({
          'active': [
            TodoItem(name: 'Default Todo', projectId: '0000', postion: 0)
          ],
          'done': []
        });

  bool addTodoItem({required String todoItemName, required String projectId}) {
    final currentListLength = state.length;
    final tempTodoProject = TodoItem(
      name: todoItemName,
      projectId: projectId,
      postion: currentListLength,
    );

    final Map<String, List> tempState = {...state};
    tempState['active']!.add(tempTodoProject);

    state = {...tempState};
    return true;
  }

  //NOTE: Sets Todo to done
  bool setTodoToDone({required String todoId}) {
    print(todoId);
    final tempState = {...state};

    tempState['done']!.add(
      tempState['active']!.firstWhere((element) => element.id == todoId),
    );
    tempState['done']!.last.time = DateTime.now();

    tempState['active']!.removeWhere((element) => element.id == todoId);
    state = {...tempState};
    return true;
  }

  //NOTE: Sets Todo to active
  bool setTodoToActive({required String todoId}) {
    print(todoId);
    final tempState = {...state};

    tempState['active']!.add(
      tempState['done']!.firstWhere((element) => element.id == todoId),
    );

    tempState['done']!.removeWhere((element) => element.id == todoId);
    state = {...tempState};
    return true;
  }
}

final todoItemsProvider =
    StateNotifierProvider<TodoItemsNotifire, Map<String, List>>(
        (ref) => TodoItemsNotifire());
