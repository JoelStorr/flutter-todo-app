import 'package:flutter/material.dart';

class DoneTodosOverlay extends StatelessWidget {
  const DoneTodosOverlay({super.key, required this.doneTodos});
  final List<String?> doneTodos;

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
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
                size: 15,
              ),
              label: const Text(
                'Swipe down to close',
                style: TextStyle(color: Colors.white, fontSize: 12),
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
                  doneTodos[index]!,
                  style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.lineThrough),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

//TODO: Add Button to Close Overlay 
//TODO: Dispaly a List of the Accomplished Todos