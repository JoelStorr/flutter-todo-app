import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TodoItem {
  TodoItem({required this.name, time, this.done = false})
      : id = uuid.v1(),
        time = time ?? DateTime.now();

  final String id;

  String name;
  DateTime time;
  bool done;
}
