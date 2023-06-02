import 'package:flutter/material.dart';
import 'package:todo_app/widgets/done_totos_overlay.dart';

class DoneTodos extends StatelessWidget {
  const DoneTodos({super.key, required this.doneTodos});

  final List<Map<String, dynamic>> doneTodos;

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
      onHorizontalDragStart: (details) {
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
          Icon(
            Icons.arrow_upward,
            color: Color.fromARGB(255, 134, 177, 198),
            size: 16,
          ),
          Text(
            'See what you acomplished',
            style: TextStyle(
                fontSize: 14, color: Color.fromARGB(255, 134, 177, 198)),
          ),
        ],
      ),
    );
  }
}
