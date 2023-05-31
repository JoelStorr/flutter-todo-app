import 'package:flutter/material.dart';

class DoneTodosOverlay extends StatelessWidget {
  const DoneTodosOverlay({super.key, required this.doneTodos});
  final List<String?> doneTodos;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      color: Colors.amber,
    );
  }
}
