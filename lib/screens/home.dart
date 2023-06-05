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
                setState(() {
                  service.saveTodoItem(TodoItem()
                    ..todo = ''
                    ..todoProject.value = _curProject);
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
                child: _curProject != null
                    ? StreamBuilder<List<TodoItem>>(
                        stream: service.listenActiveTodoItemsFor(_curProject!),
                        builder: (context, snapshot) => ListView.builder(
                            itemCount:
                                snapshot.hasData ? snapshot.data!.length : 0,
                            itemBuilder: (ctx, index) {
                              return snapshot.data![index].done == null
                                  ? ListTile(
                                      key: Key(
                                          snapshot.data![index].id.toString()),
                                      leading: IconButton(
                                        icon: const Icon(Icons.square),
                                        onPressed: () {
                                          setState(() {
                                            //TODO: Chnage State from active to done
                                          });
                                        },
                                      ),
                                      title: TextField(
                                        controller: _todoTextController,
                                        onSubmitted: (String value) {
                                          setState(() {
                                            if (value.trim().isEmpty) {
                                              _todoTextController.clear();
                                              return;
                                            }

                                            service.editTodoItem(
                                                id: snapshot.data![index].id,
                                                todo: value,
                                                status: false);

                                            _todoTextController.clear();
                                          });
                                        },
                                        autofocus: true,
                                      ),
                                    )
                                  : ListTile(
                                      key: Key(index.toString()),
                                      leading: IconButton(
                                        icon: const Icon(Icons.square),
                                        onPressed: () {
                                          setState(() {
                                            //TODO: Set Todo Status
                                          });
                                        },
                                      ),
                                      title: Text(snapshot.data![index].todo),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            //TODO: Remove element form DB
                                          });
                                        },
                                      ),
                                    );
                            }),
                      )
                    : const Text('No data found')),

            /* NOTE: Shows Popup to display Todo History */
            const DoneTodos(),
          ],
        ),
      ),
    );
  }
}
