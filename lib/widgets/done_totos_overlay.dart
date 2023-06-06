import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//NOTE: Local DB
import 'package:todo_app/db/todo_item_db.dart';
import 'package:todo_app/db/isar_services.dart';
import 'package:todo_app/db/todo_project_db.dart';
//NOTE: Global State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/todo_projects_provider.dart';

class DoneTodosOverlay extends ConsumerStatefulWidget {
  const DoneTodosOverlay({
    super.key,
  });

  @override
  ConsumerState<DoneTodosOverlay> createState() => _DoneTodosOverlayState();
}

class _DoneTodosOverlayState extends ConsumerState<DoneTodosOverlay> {
  final service = IsarService();

  @override
  Widget build(BuildContext context) {
    final TodoProject currentProject = ref.watch(todoProjectsProvider);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('See what you accomplished'),
          TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_downward,
                color: Color.fromARGB(255, 134, 177, 198),
                size: 15,
              ),
              label: const Text(
                'Swipe down to close',
                style: TextStyle(
                    color: Color.fromARGB(255, 134, 177, 198), fontSize: 12),
              )),
          const SizedBox(
            height: 30,
          ),
          StreamBuilder<List<TodoItem>>(
            stream: service.listenDoneTodoItemsFor(currentProject),
            builder: (ctx, snapshot) => ListView.builder(
              itemCount: snapshot.data != null ? snapshot.data!.length : 0,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onDoubleTap: () {
                    //TODO: Add DB
                  },
                  child: ListTile(
                    key: Key(index.toString()),
                    leading: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      onPressed: () {},
                    ),
                    title: Text(
                      snapshot.data![index].todo,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 173, 173, 173),
                          decoration: TextDecoration.lineThrough),
                    ),
                    trailing: Text(
                      DateFormat('dd-MM-yyyy – kk:mm')
                          .format(snapshot.data![index].finishedAt),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 173, 173, 173)),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
