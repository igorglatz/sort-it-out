import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/merge_sort/merge_sort_message_provider.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/merge_sort/stage_1/merge_sort_provider_1.dart';
import 'package:sort_it_out/src/model/sortable_item.dart';
import 'package:sort_it_out/src/save_data/save_data_provider.dart';
import 'package:sort_it_out/src/score_system/score_system_provider.dart';

class MergeSort1 extends StatefulWidget {
  const MergeSort1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MergeSort1State();
}

class _MergeSort1State extends State<MergeSort1> {
  @override
  Widget build(BuildContext context) {
    MergeSortProvider1 _mergeSortProvider =
        Provider.of<MergeSortProvider1>(context);
    ScoreSystemProvider _scoreSystemProvider =
        Provider.of<ScoreSystemProvider>(context);
    MergeSortMessageProvider _messageProvider =
        Provider.of<MergeSortMessageProvider>(context);
    SaveDataProvider _saveProvider = Provider.of<SaveDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algoritmo 1 - Merge Sort'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 270,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Score: ' + _scoreSystemProvider.score.toString()),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                        onPressed: () {
                          {
                            Future.delayed(const Duration(seconds: 1));
                            _hintAsked(_scoreSystemProvider, _messageProvider);
                          }
                        },
                        child: const Text('Pedir dica (-20 pontos)')),
                  ),
                  SizedBox(
                    width: 270,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        _messageProvider.currentMessage,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 60,
                        minWidth: 150,
                      ),
                      child: ListView(
                          padding: const EdgeInsets.only(bottom: 10),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: _mergeSortProvider.getInitialList()),
                    ),
                    for (List<List<SortableItem>> step
                        in _mergeSortProvider.steps)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (List<SortableItem> internalList
                                        in step)
                                      IconButton(
                                          onPressed: () => _selectInternalList(
                                              internalList,
                                              _mergeSortProvider,
                                              _messageProvider,
                                              _saveProvider,
                                              _scoreSystemProvider),
                                          icon: const Icon(
                                              Icons.arrow_downward_sharp)),
                                    const SizedBox(
                                      width: 36,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _buildWholeStep(step),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 150,
            )
          ],
        ),
      ),
    );
  }

  _buildWholeStep(List<List<SortableItem>> step) {
    List<Widget> list = [];
    for (int i = 0; i < step.length; i++) {
      list.add(Padding(
        padding: i == step.length - 1
            ? const EdgeInsets.only(right: 20)
            : EdgeInsets.zero,
        child: SizedBox(
          width: step[i].length * 40,
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: step[i],
          ),
        ),
      ));
    }
    return list;
  }

  _hintAsked(ScoreSystemProvider scoreSystemProvider,
      MergeSortMessageProvider messageProvider) {
    scoreSystemProvider.hintAsked();
    messageProvider.hintAsked();
  }

  _selectInternalList(
    List<SortableItem> internalList,
    MergeSortProvider1 mergeSortProvider,
    MergeSortMessageProvider messageProvider,
    SaveDataProvider saveDataProvider,
    ScoreSystemProvider scoreProvider,
  ) {
    bool result = mergeSortProvider.checkInternalListSelection(internalList);

    result
        ? _correctSelection(internalList, messageProvider, mergeSortProvider,
            saveDataProvider, scoreProvider)
        : _incorrectSelection(
            messageProvider, mergeSortProvider, scoreProvider);
    log('selected internalList: ${internalList.toString()} is it correct? [$result]');
  }

  _correctSelection(
    List<SortableItem> internalList,
    MergeSortMessageProvider messageProvider,
    MergeSortProvider1 mergeSortProvider,
    SaveDataProvider saveDataProvider,
    ScoreSystemProvider scoreProvider,
  ) {
    messageProvider.correctMoveMessage();
    scoreProvider.correctMove();
    mergeSortProvider.select(internalList);
    if (mergeSortProvider.isStageSolved(internalList)) {
      _onStageSolved(mergeSortProvider, saveDataProvider);
    }
  }

  _incorrectSelection(MergeSortMessageProvider messageProvider,
      MergeSortProvider1 mergeSortProvider, ScoreSystemProvider scoreProvider) {
    scoreProvider.wrongMove();
    messageProvider.wrongMoveMessage();
  }

  _onStageSolved(
      MergeSortProvider1 mergeSortProvider, SaveDataProvider saveProvider) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Sucesso!'),
              content: const Text('Parabéns! Você resolveu o desafio!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    saveProvider.saveData!.mergeSortSaveData.isStage1Complete =
                        true;
                    saveProvider.saveStageCompletion();
                    mergeSortProvider.reset();
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
