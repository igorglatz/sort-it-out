import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/draggable_list_provider.dart';

class BubbleSort extends StatefulWidget {
  const BubbleSort({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BubbleSortState();
}

class _BubbleSortState extends State<BubbleSort> {
  @override
  Widget build(BuildContext context) {
    DraggableListProvider draggableListProvider =
        Provider.of<DraggableListProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Stage 1 - Bubble Sort"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: () => {
                      if (draggableListProvider.checkCorrectMoveConditions())
                        {draggableListProvider.correctMovement()}
                      else
                        {draggableListProvider.wrongMovement()}
                    },
                child: const Text('Pass')),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 40,
              ),
              child: ReorderableListView(
                  padding: const EdgeInsets.only(bottom: 10),
                  scrollDirection: Axis.horizontal,
                  children: draggableListProvider.draggableList,
                  onReorder: (oldIndex, newIndex) {
                    _onReorder(oldIndex, newIndex, draggableListProvider);
                    if (draggableListProvider.isStageSolved) {
                      _onStageSolved(draggableListProvider);
                    }
                  }),
            ),
          ],
        ));
  }

  void _onReorder(
      int oldIndex, int newIndex, DraggableListProvider draggableListProvider) {
    setState(() {
      if (draggableListProvider.isMoveLegal(oldIndex, newIndex)) {
        newIndex = newIndex - 1;
        final element = draggableListProvider.draggableList.removeAt(oldIndex);
        draggableListProvider.draggableList.insert(newIndex, element);
        if (draggableListProvider.checkCorrectMoveConditions()) {
          draggableListProvider.correctMovement();
        }
      } else {
        draggableListProvider.wrongMovement();
      }
    });
  }

  _onStageSolved(DraggableListProvider draggableListProvider) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Sucess!'),
              content: const Text('Congratulations! You solved the stage!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    draggableListProvider.reset();
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
