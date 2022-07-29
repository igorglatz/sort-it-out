import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/bubble_sort_provider.dart';

class BubbleSort extends StatefulWidget {
  const BubbleSort({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BubbleSortState();
}

class _BubbleSortState extends State<BubbleSort> {
  @override
  Widget build(BuildContext context) {
    BubbleSortProvider bubbleSortProvider =
        Provider.of<BubbleSortProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Stage 1 - Bubble Sort'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: () => {
                      if (bubbleSortProvider.checkCorrectMoveConditions())
                        {bubbleSortProvider.correctMovement()}
                      else
                        {bubbleSortProvider.wrongMovement()}
                    },
                child: const Text('Pass')),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 40,
              ),
              child: ReorderableListView(
                  padding: const EdgeInsets.only(bottom: 10),
                  scrollDirection: Axis.horizontal,
                  children: bubbleSortProvider.draggableList,
                  onReorder: (oldIndex, newIndex) {
                    _onReorder(oldIndex, newIndex, bubbleSortProvider);
                    if (bubbleSortProvider.isStageSolved) {
                      _onStageSolved(bubbleSortProvider);
                    }
                  }),
            ),
          ],
        ));
  }

  void _onReorder(
      int oldIndex, int newIndex, BubbleSortProvider bubbleSortProvider) {
    setState(() {
      if (bubbleSortProvider.isPos0to1Move(oldIndex, newIndex)) {
        newIndex = newIndex - 1;
        final element = bubbleSortProvider.draggableList.removeAt(oldIndex);
        bubbleSortProvider.draggableList.insert(newIndex, element);
        if (bubbleSortProvider.checkCorrectMoveConditions()) {
          bubbleSortProvider.correctMovement();
        }
      } else if (bubbleSortProvider.isPos1to0Move(oldIndex, newIndex)) {
        final element = bubbleSortProvider.draggableList.removeAt(oldIndex);
        bubbleSortProvider.draggableList.insert(newIndex, element);
        if (bubbleSortProvider.checkCorrectMoveConditions()) {
          bubbleSortProvider.correctMovement();
        }
      } else {
        bubbleSortProvider.wrongMovement();
      }
    });
  }

  _onStageSolved(BubbleSortProvider bubbleSortProvider) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Sucess!'),
              content: const Text('Congratulations! You solved the stage!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    bubbleSortProvider.reset();
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
