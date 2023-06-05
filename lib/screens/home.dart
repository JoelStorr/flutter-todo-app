import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/todo_item_model.dart';
import 'package:todo_app/models/todo_project_model.dart';
import 'package:todo_app/providers/todo_items_provider.dart';
import 'package:todo_app/providers/todo_projects_provider.dart';
import 'package:todo_app/widgets/done_todes.dart';
import 'package:todo_app/widgets/side_drawer.dart';
import 'package:todo_app/db/isar_services.dart';
import 'package:todo_app/db/todo_item_db.dart' as item_db;
import 'package:todo_app/db/todo_project_db.dart' as project_db;

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  bool isEdit = false;
  final _todoTextController = TextEditingController();
  List<TodoItem?> todos = [];
  List<TodoItem> doneTodos = [];

  project_db.TodoProject? _curProject;
  final service = IsarService();
  void onChnageTitle(project_db.TodoProject project) {
    setState(() {
      _curProject = project;
    });
  }

  @override
  void dispose() {
    _todoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List> myTodos = ref.watch(todoItemsProvider);
    if (todos.isNotEmpty && todos.last == null) {
      todos = [...myTodos['active']!, null];
      doneTodos = [...myTodos['done']!];
    } else {
      todos = [...myTodos['active']!];
      doneTodos = [...myTodos['done']!];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_curProject != null ? _curProject!.title : 'demo'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  todos.add(null);
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: MySideDrawer(
        service,
        currProject: onChnageTitle,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: todos.length,
                itemBuilder: (ctx, index) {
                  return todos[index] != null
                      /* NOTE: Dispaly Todos */
                      ? ListTile(
                          key: Key(index.toString()),
                          leading: IconButton(
                            icon: const Icon(Icons.square),
                            onPressed: () {
                              setState(() {
                                ref
                                    .read(todoItemsProvider.notifier)
                                    .setTodoToDone(todoId: todos[index]!.id);
                              });
                            },
                          ),
                          title: Text(todos[index]!.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                ref
                                    .read(todoItemsProvider.notifier)
                                    .deleteTodo(todoId: todos[index]!.id);
                              });
                            },
                          ),
                        )
                      /* NOTE: Display Input to add Todo */
                      : ListTile(
                          key: Key(index.toString()),
                          leading: IconButton(
                            icon: const Icon(Icons.square),
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                          title: TextField(
                            controller: _todoTextController,
                            onSubmitted: (String value) {
                              setState(() {
                                if (value.trim().isEmpty) {
                                  todos.remove(null);
                                  _todoTextController.clear();
                                  return;
                                }

                                service.saveTodoItem(
                                    item_db.TodoItem()..todo = value);

                                /* ref
                                    .read(todoItemsProvider.notifier)
                                    .addTodoItem(
                                        projectId: _projectId!,
                                        todoItemName: value); */
                                todos.remove(null);
                                _todoTextController.clear();
                              });
                            },
                            autofocus: true,
                          ),
                        );
                },
              ),
            ),
            /* NOTE: Shows Popup to display Todo History */
            const DoneTodos(),
          ],
        ),
      ),
    );
  }
}
