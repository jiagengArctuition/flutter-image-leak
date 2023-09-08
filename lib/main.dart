import 'package:flutter/material.dart';
import 'package:images/images_page.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Leak Demo',
      home: Scaffold(
        body: EntryPage(),
      ),
    );
  }
}

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const ImagesPage(),
        ),
        child: const Text('show images'),
      ),
    );
  }
}
