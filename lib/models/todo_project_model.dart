import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class TodoProject {
  TodoProject({required this.position, required this.name})
      : id = uuid.v1(),
        completed = false;

  final String id;
  final int position;
  final String name;
  bool completed;
}
