import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/* import 'package:todo_app/models/todo_item_model.dart'; */
/* import 'package:todo_app/models/todo_project_model.dart'; */
/* import 'package:todo_app/providers/todo_items_provider.dart'; */
/* import 'package:todo_app/providers/todo_projects_provider.dart'; */
import 'package:todo_app/widgets/done_todes.dart';
import 'package:todo_app/widgets/side_drawer.dart';
import 'package:todo_app/db/isar_services.dart';
import 'package:todo_app/db/todo_item_db.dart';
import 'package:todo_app/db/todo_project_db.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  bool isEdit = false;
  final _todoTextController = TextEditingController();

  TodoProject? _curProject;
  final service = IsarService();
  void onChnageTitle(TodoProject project) {
    setState(() {
      _curProject = project;
    });
  }

  //NOTE: Default Isa TodoPRoject entrie

  @override
  void dispose() {
    _todoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* NOTE: Setup Base PRoject */
    if (_curProject == null) {
      service.dbSetup().then((value) {
        setState(() {
          _curProject = value;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_curProject != null ? _curProject!.title : 'demo'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
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
                child: _curProject != null
                    ? StreamBuilder<List<TodoItem>>(
                        stream: service.listenActiveTodoItemsFor(_curProject!),
                        builder: (context, snapshot) => ListView.builder(
                            itemCount:
                                snapshot.hasData ? snapshot.data!.length : 0,
                            itemBuilder: (ctx, index) {}),
                      )
                    : const Text('No data found')

                /* ListView.builder(
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

                                service.saveTodoItem(item_db.TodoItem()
                                  ..todo = value
                                  ..todoProject.value = _curProject);

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
                }, */
                ),

            /* NOTE: Shows Popup to display Todo History */
            const DoneTodos(),
          ],
        ),
      ),
    );
  }
}
