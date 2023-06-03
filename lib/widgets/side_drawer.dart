import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/todo_project_model.dart';
import 'package:todo_app/providers/todo_projects_provider.dart';

//NOTE: For DB
import 'package:todo_app/db/todo_project_db.dart' as todo_project_db;
import 'package:todo_app/db/isar_services.dart';

class MySideDrawer extends ConsumerStatefulWidget {
  const MySideDrawer(this.services, {super.key, required this.currProject});
  final IsarService services;
  final void Function(TodoProject) currProject;

  @override
  ConsumerState<MySideDrawer> createState() => _MySideDrawerState();
}

class _MySideDrawerState extends ConsumerState<MySideDrawer> {
  List<TodoProject?> _todoList = [];

  final _listTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final List<TodoProject> myTodoLists = ref.watch(todoProjectsProvider);

    /* NOTE: Null List State should be handled in Component */
    if (_todoList.isNotEmpty && _todoList.last == null) {
      _todoList = [...myTodoLists, null];
    } else {
      _todoList = [...myTodoLists];
    }

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: DrawerHeader(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black12,
                      const Color.fromARGB(255, 167, 167, 167).withOpacity(0.3)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Text(
                  'Flutter Do',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                if (_todoList[index] != null) {
                  return GestureDetector(
                    onTap: () {
                      widget.currProject(_todoList[index]!);
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.list,
                        size: 26,
                        color: Colors.white70,
                      ),
                      title: Text(_todoList[index]!.name),
                    ),
                  );
                } else {
                  return ListTile(
                    leading: const Icon(Icons.edit),
                    title: TextField(
                      controller: _listTextController,
                      onSubmitted: (String value) {
                        setState(() {
                          if (value.trim().isEmpty) {
                            _todoList.remove(null);
                            _listTextController.clear();
                            return;
                          }

                          widget.services.saveTodoProject(
                              todo_project_db.TodoProject()..title = value);

                          /* ref
                              .read(todoProjectsProvider.notifier)
                              .addTodoProject(todoProjectName: value); */
                          _todoList.remove(null);
                          _listTextController.clear();
                        });
                      },
                      autofocus: true,
                    ),
                  );
                }
              },
            ),
          ),
          SafeArea(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _todoList.add(null);
                });
              },
              icon: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 134, 177, 198),
              ),
              label: const Text(
                'Add new List',
                style: TextStyle(
                  color: Color.fromARGB(255, 134, 177, 198),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
