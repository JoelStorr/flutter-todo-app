import 'package:flutter/material.dart';
import 'package:todo_app/widgets/done_totos_overlay.dart';

class DoneTodos extends StatelessWidget {
  const DoneTodos({super.key, required this.doneTodos});

  final List<String?> doneTodos;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(
          context: context,
          builder: ((context) {
            return DoneTodosOverlay(
              doneTodos: doneTodos,
            );
          }),
        );
      },
      child: const Column(
        children: [
          Icon(Icons.arrow_upward),
          Text('See what you acomplished'),
        ],
      ),
    );
  }
}
