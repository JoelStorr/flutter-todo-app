import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class TodoProjects {
  TodoProjects({required this.position, required this.name}) : id = uuid.v1();

  final String id;
  final int position;
  final String name;
}
