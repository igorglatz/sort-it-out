import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sort_it_out/src/model/sortable_item.dart';

class BubbleSortProvider3 extends ChangeNotifier {
  late List<SortableItem> draggableList;
  late int _index1;
  late int _index2;
  bool isStageSolved = false;

  BubbleSortProvider3() {
    draggableList = _buildDraggableItemList(_generateListOfElements(10));
    _index1 = 0;
    _index2 = 1;
    isStageSolved = _isListFullyOrdered();
    select(_index1, _index2);
  }

  List<int> _generateListOfElements(int listSize) {
    List<int> listOfRandomNumbers =
        List.generate(listSize * 2, (index) => index);
    listOfRandomNumbers.shuffle();
    return listOfRandomNumbers.sublist(0, listSize);
  }

  List<SortableItem> _buildDraggableItemList(List<int> randomNumbers) {
    List<SortableItem> draggableItemList = [];
    for (int number in randomNumbers) {
      SortableItem item = SortableItem(
          key: ValueKey(number), color: Colors.white, title: number.toString());
      draggableItemList.add(item);
    }
    return draggableItemList;
  }

  void correctMove() {
    //Change colors of old selected numbers.
    _unselect(_index1, _index2);
    _incrementIndexes();

    if (!isStageSolved) {
      if (_isSelectionOutOfBounds(_index2)) {
        select(0, 1);
        resetIndexes();
      } else {
        select(_index1, _index2);
      }
      log("index1: $_index1 e index2 $_index2");
      notifyListeners();
    }
  }

  void _unselect(int index1, int index2) {
    draggableList[index1] = SortableItem(
        title: draggableList[index1].title,
        color: Colors.white,
        key: draggableList[index1].key);
    draggableList[index2] = SortableItem(
        title: draggableList[index2].title,
        color: Colors.white,
        key: draggableList[index2].key);
  }

  void _incrementIndexes() {
    _index1++;
    _index2++;
    if (_isListFullyOrdered()) {
      isStageSolved = true;
      log('Stage solved!');
      notifyListeners();
    }
  }

  void select(int index1, int index2) {
    draggableList[index1] = SortableItem(
        title: draggableList[index1].title,
        color: Colors.green,
        key: draggableList[index1].key);
    draggableList[index2] = SortableItem(
        title: draggableList[index2].title,
        color: Colors.green,
        key: draggableList[index2].key);
  }

  void wrongMove() {
    draggableList[_index1] = SortableItem(
        title: draggableList[_index1].title,
        color: Colors.red,
        key: draggableList[_index1].key);
    draggableList[_index2] = SortableItem(
        title: draggableList[_index2].title,
        color: Colors.red,
        key: draggableList[_index2].key);
    notifyListeners();
  }

  bool checkCorrectMoveConditions() {
    return _isSelectionOrdered();
  }

  bool isPos0to1Move(int oldIndex, int newIndex) =>
      newIndex == oldIndex + 2 &&
      (oldIndex == _index1 && newIndex == _index2 + 1);

  bool isPos1to0Move(int oldIndex, int newIndex) =>
      newIndex == oldIndex - 1 && (oldIndex == _index2 && newIndex == _index1);

  bool _isSelectionOrdered() =>
      int.parse(draggableList[_index1].title) <
      int.parse(draggableList[_index2].title);

  bool _isListFullyOrdered() {
    List<SortableItem> tempList = draggableList.toList();
    tempList.sort((a, b) => int.parse(a.title).compareTo(int.parse(b.title)));
    for (int i = 0; i < draggableList.length; i++) {
      int compareResult = int.parse(draggableList[i].title)
          .compareTo(int.parse(tempList[i].title));
      if (compareResult != 0) {
        log('Not ordered yet!');
        return false;
      }
    }
    return true;
  }

  bool _isSelectionOutOfBounds(int index) => _index2 == draggableList.length;

  void resetIndexes() {
    _index1 = 0;
    _index2 = 1;
  }

  void reset() {
    draggableList = _buildDraggableItemList(_generateListOfElements(10));
    _index1 = 0;
    _index2 = 1;
    isStageSolved = _isListFullyOrdered();
    select(_index1, _index2);
    notifyListeners();
  }
}
