import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/bubble_sort/stage_1/bubble_sort_1.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/bubble_sort/stage_2/bubble_sort_2.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/bubble_sort/stage_3/bubble_sort_3.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/merge_sort/stage_1/merge_sort_1.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/merge_sort/stage_2/merge_sort_2.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/merge_sort/stage_3/merge_sort_3.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/merge_sort/stage_4/merge_sort_4.dart';
import 'package:sort_it_out/src/save_data/save_data_provider.dart';

class ArcadeMenu extends StatefulWidget {
  const ArcadeMenu({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ArcadeMenu> createState() => _ArcadeMenuState();
}

class _ArcadeMenuState extends State<ArcadeMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Consumer<SaveDataProvider>(
          builder: ((context, saveProvider, child) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Bubble Sort'),
                    TextButton(
                        child: const Text('Fase 1'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BubbleSort1()),
                          );
                        },
                        style: Theme.of(context).textButtonTheme.style),
                    if (saveProvider
                        .saveData!.bubbleSortSaveData.isStage1Complete)
                      TextButton(
                          child: const Text('Fase 2'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BubbleSort2()),
                            );
                          },
                          style: Theme.of(context).textButtonTheme.style),
                    if (saveProvider
                        .saveData!.bubbleSortSaveData.isStage2Complete)
                      TextButton(
                          child: const Text('Fase 3'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BubbleSort3()),
                            );
                          },
                          style: Theme.of(context).textButtonTheme.style),
                    if (saveProvider.bubbleSortSaveData.isStage3Complete)
                      const Text('Merge Sort'),
                    TextButton(
                        child: const Text('Fase 1'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MergeSort1()),
                          );
                        },
                        style: Theme.of(context).textButtonTheme.style),
                    if (saveProvider.mergeSortSaveData.isStage1Complete)
                      TextButton(
                          child: const Text('Fase 2'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MergeSort2()),
                            );
                          },
                          style: Theme.of(context).textButtonTheme.style),
                    if (saveProvider.mergeSortSaveData.isStage2Complete)
                      TextButton(
                          child: const Text('Fase 3'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MergeSort3()),
                            );
                          },
                          style: Theme.of(context).textButtonTheme.style),
                    if (saveProvider.mergeSortSaveData.isStage3Complete)
                      TextButton(
                          child: const Text('Fase 4'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MergeSort4()),
                            );
                          },
                          style: Theme.of(context).textButtonTheme.style),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
