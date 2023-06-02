import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/todo_lists_provider.dart';

class MySideDrawer extends ConsumerStatefulWidget {
  const MySideDrawer({super.key, required this.listTitle});

  final void Function(String) listTitle;

  @override
  ConsumerState<MySideDrawer> createState() => _MySideDrawerState();
}

class _MySideDrawerState extends ConsumerState<MySideDrawer> {
  final List todoList = ['Work', 'Shopping', 'Sport'];

  late List myTodoLists;

  @override
  void initState() {
    myTodoLists = ref.watch(todoListsProvider);

    super.initState();
  }

  final _listTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(myTodoLists);

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
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                if (todoList[index] != null) {
                  return GestureDetector(
                    onTap: () {
                      widget.listTitle(todoList[index]);
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.list,
                        size: 26,
                        color: Colors.white70,
                      ),
                      title: Text(todoList[index]),
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
                            todoList.remove(null);
                            _listTextController.clear();
                            return;
                          }
                          todoList[index] = value;
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
                  todoList.add(null);
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
