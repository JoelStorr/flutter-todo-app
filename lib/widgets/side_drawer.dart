import 'package:flutter/material.dart';

class MySideDrawer extends StatefulWidget {
  const MySideDrawer({super.key});

  @override
  State<MySideDrawer> createState() => _MySideDrawerState();
}

class _MySideDrawerState extends State<MySideDrawer> {
  final List todoList = ['Work', 'Shopping', 'Sport'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Expanded(
          flex: 1,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black12,
                    const Color.fromARGB(255, 167, 167, 167).withOpacity(0.3)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Text(
                'Flutter Do',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(
                  Icons.list,
                  size: 26,
                  color: Colors.white70,
                ),
                title: Text(todoList[index]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
