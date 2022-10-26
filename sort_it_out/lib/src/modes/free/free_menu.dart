import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/modes/free/free_bubble_sort/free_bubble_sort.dart';
import 'package:sort_it_out/src/save_data/save_data_provider.dart';

class FreeMenu extends StatefulWidget {
  const FreeMenu({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FreeMenu> createState() => _FreeMenuState();
}

class _FreeMenuState extends State<FreeMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<SaveDataProvider>(
        builder: ((context, saveProvider, child) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!saveProvider
                      .saveData!.bubbleSortSaveData.isStage3Complete)
                    const Text(
                        'Complete a última fase do algoritmo para poder jogá-lo no modo livre.'),
                  if (saveProvider
                      .saveData!.bubbleSortSaveData.isStage3Complete)
                    TextButton(
                        child: const Text('Bubble Sort'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FreeBubbleSort()),
                          );
                        },
                        style: Theme.of(context).textButtonTheme.style),
                ],
              ),
            )),
      ),
    );
  }
}
