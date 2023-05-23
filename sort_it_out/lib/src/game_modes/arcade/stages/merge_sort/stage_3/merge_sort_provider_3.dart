import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sort_it_out/src/model/sortable_item.dart';
import 'package:collection/collection.dart';

class MergeSortProvider3 extends ChangeNotifier {
  late List<SortableItem> _initialList;
  late List<List<List<SortableItem>>> steps;
  late List<SortableItem> _finalList;
  final int _numberOfElementsToSort = 7;
  late List<List<SortableItem>> _selectedInternalLists;
  late List<List<SortableItem>> _correctOrderOfInternalListsSelection;

  MergeSortProvider3() {
    steps = [];
    _selectedInternalLists = [];
    _correctOrderOfInternalListsSelection = [];
    _createChallengeList(_numberOfElementsToSort);
    _generateSteps();
    _generateMergeSteps();
    _generateCorrectOrderOfInternalListsSelection();
  }

  List<int> _generateListOfElements(int listSize) {
    List<int> listOfRandomNumbers =
        List.generate(listSize * 2, (index) => index);
    listOfRandomNumbers.shuffle();
    List<int> returnList = listOfRandomNumbers.sublist(0, listSize);

    while (_isListOrdered(returnList)) {
      listOfRandomNumbers.shuffle();
      returnList = listOfRandomNumbers.sublist(0, listSize);
    }

    return returnList;
  }

  List<SortableItem> _buildDraggableItemList(List<int> randomNumbers) {
    List<SortableItem> draggableItemList = [];
    for (int number in randomNumbers) {
      SortableItem item = SortableItem(
        key: ValueKey(number),
        color: Colors.white,
        title: number.toString(),
        height: 20.0,
        width: 30.0,
        fontSize: 15,
      );
      draggableItemList.add(item);
    }
    return draggableItemList;
  }

  bool checkInternalListSelection(List<SortableItem> internalList) {
    bool isCorrect = isCorrectlySelected(internalList);
    if (isCorrect) {
      _selectedInternalLists.add(internalList);
    }
    return isCorrect;
  }

  _createChallengeList(int numberOfElements) {
    _initialList =
        _buildDraggableItemList(_generateListOfElements(numberOfElements));
    log("Lista inicial: $_initialList");
  }

  _generateSteps() {
    _splitSortableItemList([_initialList]);

    while (!_isEveryInternalListOneElement(steps.last)) {
      _splitSortableItemList(steps.last);
    }

    log("steps: " + steps.toString());
  }

  _generateMergeSteps() {
    List<List<List<SortableItem>>> splitSteps = steps;

    while (steps.last.length > 1) {
      List<List<SortableItem>> newStep = [];
      int mergeTimes = (splitSteps.last.length / 2).floor();
      int index = 0;

      while (mergeTimes > 0) {
        // if (index + 1 <= splitSteps.last.length) {
        List<SortableItem> list = List.from(splitSteps.last[index])
          ..addAll(splitSteps.last[index + 1]);
        list.sort((a, b) {
          if (int.parse(a.title) > int.parse(b.title)) {
            return 1;
          } else {
            if (int.parse(a.title) < int.parse(b.title)) {
              return -1;
            }
            return 0;
          }
        });
        newStep.add(list);
        mergeTimes--;
        if (index + 1 != _numberOfElementsToSort - 2) {
          index += 2;
        } else {
          newStep.add(splitSteps.last[index + 2]);
        }
        // } else {
        //   newStep.add(splitSteps.last[index]);
        // }
      }

      steps.add(newStep);
    }
    print('Steps after generating Merge steps: ' + steps.toString());
  }

  List<SortableItem> getInitialList() => _initialList;

  List<SortableItem> getFinalList() => _finalList;

  List<List<List<SortableItem>>> getSteps() => steps;

  void _splitSortableItemList(List<List<SortableItem>> sortableItemList) {
    List<List<SortableItem>> newList = [];
    for (List<SortableItem> oldList in sortableItemList) {
      int listSize = oldList.length;
      if (listSize > 1) {
        if (listSize.isEven) {
          newList.add(oldList.sublist(0, (listSize / 2).floor()));
          newList.add(oldList.sublist((listSize / 2).floor()));
        } else {
          newList.add(oldList.sublist(0, (listSize / 2).floor() + 1));
          newList.add(oldList.sublist((listSize / 2).floor() + 1));
        }
      } else if (listSize == 1) {
        newList.add(oldList);
      }
    }
    steps.add(newList);
  }

  _isEveryInternalListOneElement(List<List<SortableItem>> externalList) {
    int result = 0;
    for (List<SortableItem> internalList in externalList) {
      if (internalList.length == 1) {
        result++;
      }
    }
    return result == externalList.length;
  }

  bool _isListOrdered(List<int> list) {
    return list.isSorted((a, b) => a.compareTo(b));
  }

  void _generateCorrectOrderOfInternalListsSelection() {
    _correctOrderOfInternalListsSelection.addAll([
      steps[0][0],
      steps[1][0],
      steps[2][0],
      steps[2][1],
      steps[3][0],
      steps[1][1],
      steps[2][2],
      steps[2][3],
      steps[3][1],
      steps[4][0],
      steps[0][1],
      steps[1][2],
      steps[2][4],
      steps[2][5],
      steps[3][2],
      steps[1][3],
      steps[2][6],
      steps[3][3],
      steps[4][1],
      steps[5][0]
    ]);

    print('correct order of internal lists: ' +
        _correctOrderOfInternalListsSelection.toString());
  }

  bool isCorrectlySelected(List<SortableItem> internalList) {
    if (_correctOrderOfInternalListsSelection.contains(internalList)) {
      if (_correctOrderOfInternalListsSelection[
              _selectedInternalLists.length] ==
          internalList) {
        return true;
      }
    }
    return false;
  }

  reset() {
    steps = [];
    _selectedInternalLists = [];
    _correctOrderOfInternalListsSelection = [];
    _createChallengeList(_numberOfElementsToSort);
    _generateSteps();
    _generateMergeSteps();
    _generateCorrectOrderOfInternalListsSelection();
  }

  bool isStageSolved(List<SortableItem> currentInternalList) {
    if (currentInternalList.length != steps.last.last.length) {
      return false;
    }
    int index = 0;
    for (SortableItem item in steps.last.last) {
      if (item.title != currentInternalList[index].title) {
        return false;
      }
      index++;
    }
    return true;
  }

  int _getLevelOfInternalList(List<SortableItem> selectedInternalList) {
    int outerIndex = 0;
    for (List<List<SortableItem>> step in steps) {
      for (List<SortableItem> internalList in step) {
        if (listEquals(internalList, selectedInternalList)) {
          return outerIndex;
        }
      }
      outerIndex++;
    }

    return -1;
  }

  void select(List<SortableItem> selectedInternalList) {
    int level = _getLevelOfInternalList(selectedInternalList);

    int index = 0;
    List<SortableItem> newInternalList = [];
    for (List<SortableItem> internalList in steps[level]) {
      if (listEquals(internalList, selectedInternalList)) {
        List<SortableItem> newInternalList = [];
        for (SortableItem item in steps[level][index]) {
          newInternalList.add(SortableItem(
              title: item.title,
              color: Colors.green,
              key: item.key,
              height: 20.0,
              width: 30.0,
              fontSize: 15));
        }

        steps[level][index] = newInternalList;
      }

      index++;
    }

    notifyListeners();
  }
}
