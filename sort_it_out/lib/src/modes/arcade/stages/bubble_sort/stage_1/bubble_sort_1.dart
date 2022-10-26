import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/bubble_sort_message_provider.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/stage_1/bubble_sort_provider_1.dart';
import 'package:sort_it_out/src/save_data/save_data_provider.dart';
import 'package:sort_it_out/src/score_system/score_system_provider.dart';

class BubbleSort1 extends StatefulWidget {
  const BubbleSort1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BubbleSort1State();
}

class _BubbleSort1State extends State<BubbleSort1> {
  @override
  Widget build(BuildContext context) {
    BubbleSortProvider1 _bubbleSortProvider =
        Provider.of<BubbleSortProvider1>(context);
    ScoreSystemProvider _scoreSystemProvider =
        Provider.of<ScoreSystemProvider>(context);
    BubbleSortMessageProvider _messageProvider =
        Provider.of<BubbleSortMessageProvider>(context);
    SaveDataProvider _saveProvider = Provider.of<SaveDataProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fase 1 - Bubble Sort'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () {
                        {
                          Future.delayed(const Duration(seconds: 1));
                          _hintAsked(_scoreSystemProvider, _messageProvider);
                        }
                      },
                      child: const Text('Pedir dica (-20 pontos)')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () {
                        {
                          if (_bubbleSortProvider
                              .checkCorrectMoveConditions()) {
                            _correctMove(_bubbleSortProvider,
                                _scoreSystemProvider, _messageProvider);
                          } else {
                            _wrongMove(false, _bubbleSortProvider,
                                _scoreSystemProvider, _messageProvider);
                          }
                        }
                      },
                      child: const Text('Passar')),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Score: ' + _scoreSystemProvider.score.toString()),
                )
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 60,
                minWidth: 300,
              ),
              child: ReorderableListView(
                  padding: const EdgeInsets.only(bottom: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _bubbleSortProvider.draggableList,
                  onReorder: (oldIndex, newIndex) {
                    _onReorder(oldIndex, newIndex, _bubbleSortProvider,
                        _scoreSystemProvider, _messageProvider);
                    if (_bubbleSortProvider.isStageSolved) {
                      _onStageSolved(_bubbleSortProvider, _saveProvider);
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(_messageProvider.currentMessage),
            ),
            const SizedBox(
              height: 60,
            )
          ],
        ));
  }

  void _onReorder(
      int oldIndex,
      int newIndex,
      BubbleSortProvider1 bubbleSortProvider,
      ScoreSystemProvider scoreSystemProvider,
      BubbleSortMessageProvider messageProvider) {
    setState(() {
      if (bubbleSortProvider.isPos0to1Move(oldIndex, newIndex)) {
        newIndex = newIndex - 1;
        final element = bubbleSortProvider.draggableList.removeAt(oldIndex);
        bubbleSortProvider.draggableList.insert(newIndex, element);
        if (bubbleSortProvider.checkCorrectMoveConditions()) {
          _correctMove(
              bubbleSortProvider, scoreSystemProvider, messageProvider);
        }
      } else if (bubbleSortProvider.isPos1to0Move(oldIndex, newIndex)) {
        final element = bubbleSortProvider.draggableList.removeAt(oldIndex);
        bubbleSortProvider.draggableList.insert(newIndex, element);
        if (bubbleSortProvider.checkCorrectMoveConditions()) {
          _correctMove(
              bubbleSortProvider, scoreSystemProvider, messageProvider);
        }
      } else {
        _wrongMove(
            false, bubbleSortProvider, scoreSystemProvider, messageProvider);
      }
    });
  }

  _onStageSolved(
      BubbleSortProvider1 bubbleSortProvider, SaveDataProvider saveProvider) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Sucesso!'),
              content: const Text('Parabéns! Você resolveu o desafio!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    saveProvider.saveData!.bubbleSortSaveData.isStage1Complete =
                        true;
                    saveProvider.saveStageCompletion();
                    bubbleSortProvider.reset();
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  _hintAsked(ScoreSystemProvider scoreSystemProvider,
      BubbleSortMessageProvider messageProvider) {
    scoreSystemProvider.hintAsked();
    messageProvider.hintAsked();
  }

  _correctMove(
      BubbleSortProvider1 bubbleSortProvider,
      ScoreSystemProvider scoreSystemProvider,
      BubbleSortMessageProvider messageProvider) {
    bubbleSortProvider.correctMove();
    scoreSystemProvider.correctMove();
    messageProvider.correctMoveMessage();
  }

  _wrongMove(
      bool notHighlitedElementMoved,
      BubbleSortProvider1 bubbleSortProvider,
      ScoreSystemProvider scoreSystemProvider,
      BubbleSortMessageProvider messageProvider) {
    bubbleSortProvider.wrongMove();
    scoreSystemProvider.wrongMove();
    messageProvider.wrongMoveMessage(false);
  }
}
