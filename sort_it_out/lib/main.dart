import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/bubble_sort.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/draggable_list_provider.dart';
import 'theme.dart';

void main() {
  runApp(const MainMenu());
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DraggableListProvider>(
            create: (_) => DraggableListProvider())
      ],
      child: MaterialApp(
        title: 'Sort it out',
        theme: AppTheme().themeData,
        home: const MyHomePage(title: 'Sort It Out'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                child: const Text("Jogar"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BubbleSort()),
                  );
                },
                style: Theme.of(context).textButtonTheme.style),
            TextButton(
                child: const Text("Modo Livre"),
                onPressed: () {},
                style: Theme.of(context).textButtonTheme.style),
            TextButton(
                child: const Text("Opções"),
                onPressed: () => {},
                style: Theme.of(context).textButtonTheme.style),
          ],
        ),
      ),
    );
  }
}
