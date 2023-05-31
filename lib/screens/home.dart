import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isEdit = false;
  List<String?> todos = ['Hello World', 'Second Element'];

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
        title: const Text('Hello World'),
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
                  return Expanded(
                    child: todos[index] != null
                        ? ListTile(
                            key: Key(index.toString()),
                            leading: IconButton(
                              icon: const Icon(Icons.square),
                              onPressed: () {},
                            ),
                            title: Text(todos[index]!),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {},
                            ),
                          )
                        : ListTile(
                            key: Key(index.toString()),
                            leading: IconButton(
                              icon: const Icon(Icons.square),
                              onPressed: () {},
                            ),
                            title: TextField(
                              controller: _todoTextController,
                              onSubmitted: (String value) {
                                setState(() {
                                  todos[index] = value;
                                  _todoTextController.clear();
                                });
                              },
                            ),
                          ),
                  );
                },
              ),
            ),
            const Text('Demo Text'),
          ],
        ),
      ),
    );
  }
}
