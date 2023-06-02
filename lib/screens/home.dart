import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/todo_project_model.dart';
import 'package:todo_app/providers/todo_projects_provider.dart';
import 'package:todo_app/widgets/done_todes.dart';
import 'package:todo_app/widgets/side_drawer.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  bool isEdit = false;
  final _todoTextController = TextEditingController();
  final List<String?> todos = ['Hello World', 'Second Element'];
  final List<Map<String, dynamic>> doneTodos = [];

  String? _title = null;

  void onChnageTitle(TodoProject project) {
    setState(() {
      _title = project.name;
    });
  }

  @override
  void dispose() {
    _todoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<TodoProject> defaultTodo = ref.read(todoProjectsProvider);
    _title ??= defaultTodo[0].name;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title!),
        actions: [
          IconButton(
              onPressed: () {
                if (todos.isNotEmpty && todos.last == null) {
                  return;
                }

                setState(() {
                  todos.add(null);
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: MySideDrawer(
        listTitle: onChnageTitle,
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
                      ? ListTile(
                          key: Key(index.toString()),
                          leading: IconButton(
                            icon: const Icon(Icons.square),
                            onPressed: () {
                              setState(() {
                                doneTodos.add({
                                  'todo': todos[index],
                                  'time': DateTime.now()
                                });
                                todos.removeAt(index);
                              });
                            },
                          ),
                          title: Text(todos[index]!),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                todos.removeAt(index);
                              });
                            },
                          ),
                        )
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
                                todos[index] = value;
                                _todoTextController.clear();
                              });
                            },
                            autofocus: true,
                          ),
                        );
                },
              ),
            ),
            DoneTodos(
              doneTodos: doneTodos,
            ),
          ],
        ),
      ),
    );
  }
}
