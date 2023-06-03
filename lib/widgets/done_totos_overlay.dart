import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo_item_model.dart';

class DoneTodosOverlay extends StatelessWidget {
  const DoneTodosOverlay({super.key, required this.doneTodos});
  final List<TodoItem> doneTodos;

  @override
  Widget build(BuildContext context) {
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
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: doneTodos.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                key: Key(index.toString()),
                leading: IconButton(
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  onPressed: () {},
                ),
                title: Text(
                  doneTodos[index].name,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 173, 173, 173),
                      decoration: TextDecoration.lineThrough),
                ),
                trailing: Text(
                  DateFormat('dd-MM-yyyy – kk:mm')
                      .format(doneTodos[index].time),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 173, 173, 173)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
