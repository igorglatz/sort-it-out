import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/merge_sort/merge_sort_message_provider.dart';
import 'package:sort_it_out/src/game_modes/arcade/stages/merge_sort/stage_2/merge_sort_provider_2.dart';
import 'package:sort_it_out/src/model/input_item.dart';
import 'package:sort_it_out/src/model/sortable_item.dart';
import 'package:sort_it_out/src/save_data/save_data_provider.dart';
import 'package:sort_it_out/src/score_system/score_system_provider.dart';

class MergeSort2 extends StatefulWidget {
  const MergeSort2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MergeSort1State();
}

class _MergeSort1State extends State<MergeSort2> {
  @override
  Widget build(BuildContext context) {
    MergeSortProvider2 _mergeSortProvider =
        Provider.of<MergeSortProvider2>(context);
    ScoreSystemProvider _scoreSystemProvider =
        Provider.of<ScoreSystemProvider>(context);
    MergeSortMessageProvider _messageProvider =
        Provider.of<MergeSortMessageProvider>(context);
    SaveDataProvider _saveProvider = Provider.of<SaveDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algoritmo 2 - Merge Sort'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                  child: Text(
                    _messageProvider.currentMessage,
                    softWrap: true,
                  ),
                ),
              ],
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
                    for (List<List<InputItem>> step
                        in _mergeSortProvider.inputs)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Row(children: [
                                  for (List<InputItem> internalList in step)
                                    step.last != internalList
                                        ? Row(
                                            children: const [
                                              Icon(Icons.arrow_downward_sharp),
                                              SizedBox(
                                                width: 36,
                                              )
                                            ],
                                          )
                                        : const Icon(
                                            Icons.arrow_downward_sharp),
                                  const SizedBox(
                                    width: 30,
                                  )
                                ]),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                      onPressed: () {
                        {
                          Future.delayed(const Duration(seconds: 1));
                          _submitInputValues(_mergeSortProvider, _saveProvider,
                              _scoreSystemProvider, _messageProvider);
                        }
                      },
                      child: const Text('Submeter')),
                ),
              ],
            ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
      ),
    );
  }

  _buildWholeStep(List<List<InputItem>> step) {
    List<Widget> list = [];

    for (int i = 0; i < step.length; i++) {
      list.add(Padding(
        padding: i == step.length - 1
            ? const EdgeInsets.only(right: 20)
            : EdgeInsets.zero,
        child: Row(
          children: [
            SizedBox(
              width: step[i].length * 40,
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: step[i],
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
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

  _submitInputValues(
    MergeSortProvider2 mergeSortProvider,
    SaveDataProvider saveDataProvider,
    ScoreSystemProvider scoreProvider,
    MergeSortMessageProvider messageProvider,
  ) {
    bool isSubmissionCorrect = mergeSortProvider.checkInputs();
    if (isSubmissionCorrect) {
      _correctInputs(
          messageProvider, mergeSortProvider, saveDataProvider, scoreProvider);
    } else {
      if (_areThereEmptyInputs(mergeSortProvider)) {
        _emptyInputs(messageProvider, mergeSortProvider);
      } else {
        _incorrectInputs(messageProvider, mergeSortProvider, scoreProvider);
      }
    }
  }

  _areThereEmptyInputs(MergeSortProvider2 mergeSortProvider) {
    return mergeSortProvider.areThereEmptyInputs();
  }

  _correctInputs(
      MergeSortMessageProvider messageProvider,
      MergeSortProvider2 mergeSortProvider,
      SaveDataProvider saveDataProvider,
      ScoreSystemProvider scoreProvider) {
    messageProvider.correctMoveMessage();
    scoreProvider.correctMove();
    _onStageSolved(mergeSortProvider, saveDataProvider);
  }

  _incorrectInputs(MergeSortMessageProvider messageProvider,
      MergeSortProvider2 mergeSortProvider, ScoreSystemProvider scoreProvider) {
    scoreProvider.wrongMove();
    messageProvider.wrongMoveMessageInputs();
    mergeSortProvider.highlightWrongInputs();
  }

  _emptyInputs(MergeSortMessageProvider messageProvider,
      MergeSortProvider2 mergeSortProvider) {
    // --- perguntar se deve fazer o usuario perder pontos
    messageProvider.emptyInputsErrorMessage();
  }

  _onStageSolved(
      MergeSortProvider2 mergeSortProvider, SaveDataProvider saveProvider) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Sucesso!'),
              content: const Text('Parabéns! Você resolveu o desafio!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    saveProvider.saveData!.mergeSortSaveData.isStage2Complete =
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
