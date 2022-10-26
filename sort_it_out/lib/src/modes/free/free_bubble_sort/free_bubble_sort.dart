import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/bubble_sort_message_provider.dart';
import 'package:sort_it_out/src/modes/free/free_bubble_sort/free_bubble_sort_provider.dart';

class FreeBubbleSort extends StatefulWidget {
  const FreeBubbleSort({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FreeBubbleSortState();
}

class _FreeBubbleSortState extends State<FreeBubbleSort> {
  @override
  Widget build(BuildContext context) {
    FreeBubbleSortProvider _bubbleSortProvider =
        Provider.of<FreeBubbleSortProvider>(context);
    BubbleSortMessageProvider _messageProvider =
        Provider.of<BubbleSortMessageProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Modo Livre - Bubble Sort'),
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
                            _correctMove(_bubbleSortProvider, _messageProvider);
                          } else {
                            _wrongMove(
                                false, _bubbleSortProvider, _messageProvider);
                          }
                        }
                      },
                      child: const Text('Passar')),
                ),
                const SizedBox(height: 20),
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
                        _messageProvider);
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
      FreeBubbleSortProvider bubbleSortProvider,
      BubbleSortMessageProvider messageProvider) {
    setState(() {
      if (bubbleSortProvider.isPos0to1Move(oldIndex, newIndex)) {
        newIndex = newIndex - 1;
        final element = bubbleSortProvider.draggableList.removeAt(oldIndex);
        bubbleSortProvider.draggableList.insert(newIndex, element);
        if (bubbleSortProvider.checkCorrectMoveConditions()) {
          _correctMove(bubbleSortProvider, messageProvider);
        }
      } else if (bubbleSortProvider.isPos1to0Move(oldIndex, newIndex)) {
        final element = bubbleSortProvider.draggableList.removeAt(oldIndex);
        bubbleSortProvider.draggableList.insert(newIndex, element);
        if (bubbleSortProvider.checkCorrectMoveConditions()) {
          _correctMove(bubbleSortProvider, messageProvider);
        }
      } else {
        _wrongMove(false, bubbleSortProvider, messageProvider);
      }
    });
  }

  _onStageSolved(FreeBubbleSortProvider bubbleSortProvider) {
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

  _correctMove(FreeBubbleSortProvider bubbleSortProvider,
      BubbleSortMessageProvider messageProvider) {
    bubbleSortProvider.correctMove();
    messageProvider.correctMoveMessage();
  }

  _wrongMove(
      bool notHighlitedElementMoved,
      FreeBubbleSortProvider bubbleSortProvider,
      BubbleSortMessageProvider messageProvider) {
    bubbleSortProvider.wrongMove();
    messageProvider.wrongMoveMessage(false);
  }
}
