import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/modes/arcade/arcade_menu.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/bubble_sort_message_provider.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/stage_1/bubble_sort_provider_1.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/stage_2/bubble_sort_provider_2.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/stage_3/bubble_sort_provider_3.dart';
import 'package:sort_it_out/src/save_data/save_data_provider.dart';
import 'package:sort_it_out/src/score_system/score_system_provider.dart';
import 'theme.dart';

void main() async {
  SaveDataProvider saveProvider = await SaveDataProvider.init();
  runApp(MainMenu(saveProvider));
}

class MainMenu extends StatelessWidget {
  const MainMenu(this.saveProvider, {Key? key}) : super(key: key);
  final SaveDataProvider saveProvider;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SaveDataProvider>(create: (_) => saveProvider),
        ChangeNotifierProvider<BubbleSortProvider1>(
            create: (_) => BubbleSortProvider1()),
        ChangeNotifierProvider<BubbleSortProvider2>(
            create: (_) => BubbleSortProvider2()),
        ChangeNotifierProvider<BubbleSortProvider3>(
            create: (_) => BubbleSortProvider3()),
        ChangeNotifierProxyProvider<SaveDataProvider, ScoreSystemProvider>(
            create: (BuildContext context) => ScoreSystemProvider(saveProvider),
            update: (context, saveProvider, scoreProvider) =>
                ScoreSystemProvider(saveProvider)),
        ChangeNotifierProvider<BubbleSortMessageProvider>(
            create: (_) => BubbleSortMessageProvider()),
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
                child: const Text('Jogar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ArcadeMenu(
                            title: 'Sort It Out - Arcade mode')),
                  );
                },
                style: Theme.of(context).textButtonTheme.style),
            TextButton(
                child: const Text('Modo Livre'),
                onPressed: () {},
                style: Theme.of(context).textButtonTheme.style),
            TextButton(
                child: const Text('Opções'),
                onPressed: () => {},
                style: Theme.of(context).textButtonTheme.style),
          ],
        ),
      ),
    );
  }
}
