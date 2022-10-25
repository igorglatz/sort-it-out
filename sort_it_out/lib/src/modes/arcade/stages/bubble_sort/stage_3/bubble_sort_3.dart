import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/bubble_sort_message_provider.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/stage_3/bubble_sort_provider_3.dart';
import 'package:sort_it_out/src/score_system/score_system_provider.dart';

class BubbleSort3 extends StatefulWidget {
  const BubbleSort3({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BubbleSort3State();
}

class _BubbleSort3State extends State<BubbleSort3> {
  @override
  Widget build(BuildContext context) {
    BubbleSortProvider3 _bubbleSortProvider =
        Provider.of<BubbleSortProvider3>(context);
    ScoreSystemProvider _scoreSystemProvider =
        Provider.of<ScoreSystemProvider>(context);
    BubbleSortMessageProvider _messageProvider =
        Provider.of<BubbleSortMessageProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Fase 3 - Bubble Sort'),
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
                      _onStageSolved(_bubbleSortProvider);
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
      BubbleSortProvider3 bubbleSortProvider,
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

  _onStageSolved(BubbleSortProvider3 bubbleSortProvider) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Sucesso!'),
              content: const Text('Parabéns! Você resolveu o desafio!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    bubbleSortProvider.reset();
                    Navigator.pop(context, 'OK');
                    //save progress here
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  _correctMove(
      BubbleSortProvider3 bubbleSortProvider,
      ScoreSystemProvider scoreSystemProvider,
      BubbleSortMessageProvider messageProvider) {
    bubbleSortProvider.correctMove();
    scoreSystemProvider.correctMove();
    messageProvider.correctMoveMessage();
  }

  _wrongMove(
      bool notHighlitedElementMoved,
      BubbleSortProvider3 bubbleSortProvider,
      ScoreSystemProvider scoreSystemProvider,
      BubbleSortMessageProvider messageProvider) {
    bubbleSortProvider.wrongMove();
    scoreSystemProvider.wrongMove();
    messageProvider.wrongMoveMessage(false);
  }
}
