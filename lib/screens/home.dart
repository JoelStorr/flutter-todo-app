import 'package:flutter/material.dart';
import 'package:todo_app/widgets/done_todes.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isEdit = false;
  final List<String?> todos = ['Hello World', 'Second Element'];
  final List<Map<String, dynamic>> doneTodos = [
    {'todo': 'Demo Done', 'time': DateTime.now()}
  ];
  final _todoTextController = TextEditingController();

  @override
  void dispose() {
    _todoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Do'),
        actions: [
          IconButton(
              onPressed: () {
                if (todos.last == null) {
                  return;
                }

                setState(() {
                  todos.add(null);
                });
              },
              icon: const Icon(Icons.add))
        ],
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
                                /* doneTodos.add(todos[index]); */
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
