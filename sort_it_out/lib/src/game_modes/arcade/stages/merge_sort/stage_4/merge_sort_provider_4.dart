import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sort_it_out/src/model/input_item.dart';
import 'package:sort_it_out/src/model/sortable_item.dart';
import 'package:collection/collection.dart';

class MergeSortProvider4 extends ChangeNotifier {
  late List<SortableItem> _initialList;
  late List<List<List<SortableItem>>> _steps;
  late List<SortableItem> _finalList;
  bool isStageSolved = false;
  final int _numberOfElementsToSort = 7;
  late List<int> _correctOrderOfInputs;
  late List<List<List<InputItem>>> inputs;
  late List<String> _currentInputValues;

  MergeSortProvider4() {
    _steps = [];
    _correctOrderOfInputs = [];
    inputs = [];
    _currentInputValues = [];
    _createChallengeList(_numberOfElementsToSort);
    _generateSteps();
    _generateMergeSteps();
    _generateCorrectOrderOfInputs();
    _stepsToInputs();
    _assignOnChangeFunctionToInputs(true);
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

  highlightWrongInputs() {
    int index = 0;
    List<int> wrongInputPositions = [];
    for (String element in _currentInputValues) {
      if (int.parse(element) != _correctOrderOfInputs[index]) {
        wrongInputPositions.add(index);
      }
      index++;
    }

    print('Correct inputs in order: ${_correctOrderOfInputs.toString()}');
    print('These elements are wrong: ${wrongInputPositions.toString()}');

    _selectWrongInputs(wrongInputPositions);
  }

  bool areThereEmptyInputs() {
    List<int> emptyInputsPositions = [];
    int index = 0;
    for (String inputValue in _currentInputValues) {
      if (inputValue.isEmpty) {
        emptyInputsPositions.add(index);
      }
      index++;
    }

    if (emptyInputsPositions.isEmpty) {
      return false;
    } else {
      _selectWrongInputs(emptyInputsPositions);
      return true;
    }
  }

  bool checkInputs() {
    List<int> currentValuesToIntList = [];
    for (String inputValue in _currentInputValues) {
      currentValuesToIntList.add(int.tryParse(inputValue) ?? -1);
    }
    bool isCurrentSubmissionCorrect =
        listEquals(currentValuesToIntList, _correctOrderOfInputs);
    print('Submitted solution: ' + _currentInputValues.toString());
    return isCurrentSubmissionCorrect;
  }

  _createChallengeList(int numberOfElements) {
    _initialList =
        _buildDraggableItemList(_generateListOfElements(numberOfElements));
    log("Lista inicial: $_initialList");
  }

  _generateSteps() {
    _splitSortableItemList([_initialList]);

    while (!_isEveryInternalListOneElement(_steps.last)) {
      _splitSortableItemList(_steps.last);
    }

    log("steps: " + _steps.toString());
  }

  _generateMergeSteps() {
    List<List<List<SortableItem>>> splitSteps = _steps;

    while (_steps.last.length > 1) {
      List<List<SortableItem>> newStep = [];
      int mergeTimes = (splitSteps.last.length / 2).floor();
      int index = 0;

      while (mergeTimes > 0) {
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
      }

      _steps.add(newStep);
    }
    print('Steps after generating Merge steps: ' + _steps.toString());
  }

  List<SortableItem> getInitialList() => _initialList;

  List<SortableItem> getFinalList() => _finalList;

  List<List<List<SortableItem>>> getSteps() => _steps;

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
    _steps.add(newList);
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

  _generateCorrectOrderOfInputs() {
    for (List<List<SortableItem>> step in _steps) {
      for (List<SortableItem> internalList in step) {
        for (SortableItem item in internalList) {
          _correctOrderOfInputs.add(int.parse(item.title));
        }
      }
    }

    print("correct order of inputs " + _correctOrderOfInputs.toString());
  }

  bool isInputCorrect(int number, int position) {
    if (_correctOrderOfInputs[position] == number) {
      return true;
    }
    return false;
  }

  void _stepsToInputs() {
    List<List<List<InputItem>>> newInputs = [];
    int index = 0;
    for (List<List<SortableItem>> step in _steps) {
      List<List<InputItem>> stepInputs = [];
      for (List<SortableItem> internalList in step) {
        List<InputItem> internalListInputs = [];
        for (SortableItem item in internalList) {
          internalListInputs.add(InputItem(
            position: index,
            color: Colors.white,
          ));
          _currentInputValues.add('');
          index++;
        }
        stepInputs.add(internalListInputs);
      }
      newInputs.add(stepInputs);
    }
    index = 0;
    inputs = newInputs;
    notifyListeners();
  }

  _assignOnChangeFunctionToInputs(bool clean) {
    List<List<List<InputItem>>> newInputs = [];
    for (List<List<InputItem>> inputStep in inputs) {
      List<List<InputItem>> stepInputs = [];
      for (List<InputItem> internalInputList in inputStep) {
        List<InputItem> internalListInputs = [];
        for (InputItem item in internalInputList) {
          internalListInputs.add(InputItem(
            key: item.key,
            position: item.position,
            clean: clean,
            onChangedValue: (String value) {
              _currentInputValues[item.position] = value;
            },
            color: Colors.white,
          ));
        }
        stepInputs.add(internalListInputs);
      }
      newInputs.add(stepInputs);
    }
    inputs = newInputs;
    notifyListeners();
  }

  _selectWrongInputs(List<int> wrongInputPositions) {
    List<List<List<InputItem>>> newInputs = [];
    for (List<List<InputItem>> inputStep in inputs) {
      List<List<InputItem>> stepInputs = [];
      for (List<InputItem> internalInputList in inputStep) {
        List<InputItem> internalListInputs = [];
        for (InputItem item in internalInputList) {
          Color color = wrongInputPositions.contains(item.position)
              ? Colors.red
              : Colors.white;
          internalListInputs.add(InputItem(
            key: item.key,
            position: item.position,
            onChangedValue: (String value) {
              _currentInputValues[item.position] = value;
            },
            color: color,
          ));
        }
        stepInputs.add(internalListInputs);
      }
      newInputs.add(stepInputs);
    }
    inputs = newInputs;
    notifyListeners();
  }

  reset() {
    _steps = [];
    _correctOrderOfInputs = [];
    inputs = [];
    _currentInputValues = [];
    _createChallengeList(_numberOfElementsToSort);
    _generateSteps();
    _generateMergeSteps();
    _generateCorrectOrderOfInputs();
    _stepsToInputs();
    _assignOnChangeFunctionToInputs(true);
  }
}
