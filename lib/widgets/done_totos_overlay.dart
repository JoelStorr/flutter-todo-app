import 'package:flutter/material.dart';

class DoneTodosOverlay extends StatelessWidget {
  const DoneTodosOverlay({super.key, required this.doneTodos});
  final List<String?> doneTodos;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      color: Colors.amber,
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('See what you accomplished'),
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
                  icon: const Icon(Icons.check),
                  onPressed: () {},
                ),
                title: Text(doneTodos[index]!),
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