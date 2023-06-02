import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TodoItem {
  TodoItem({
    required this.name,
    required this.parentId,
    time,
    this.done = false,
  })  : id = uuid.v1(),
        time = time ?? DateTime.now();

  final String id;
  final String parentId;
  String name;
  DateTime time;
  bool done;
}
