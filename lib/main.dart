/* NOTE: Package Imports */
import 'package:flutter/material.dart';

/* NOTE: Project Imports */
import 'package:todo_app/screens/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 38, 37, 37),
        ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: const MyHomePage(),
    );
  }
}
