import 'package:flutter/material.dart';
import 'package:sort_it_out/src/modes/arcade/stages/bubble_sort/model/draggable_list_item.dart';

class DraggableListProvider extends ChangeNotifier {
  late List<DraggableListItem> draggableList;
  late int index1;
  late int index2;
  bool isStageSolved = false;

  DraggableListProvider() {
    draggableList = buildDraggableItemList(generateListOfElements(6));
    index1 = 0;
    index2 = 1;
    isStageSolved = isListFullyOrdered();
    select(index1, index2);
  }

  List<int> generateListOfElements(int listSize) {
    List<int> listOfRandomNumbers =
        List.generate(listSize * 2, (index) => index);
    listOfRandomNumbers.shuffle();
    return listOfRandomNumbers.sublist(0, listSize);
  }

  List<DraggableListItem> buildDraggableItemList(List<int> randomNumbers) {
    List<DraggableListItem> draggableItemList = [];
    for (int number in randomNumbers) {
      DraggableListItem item = DraggableListItem(
          key: ValueKey(number), color: Colors.white, title: number.toString());
      draggableItemList.add(item);
    }
    return draggableItemList;
  }

  void correctMovement() {
    //Change colors of old selected numbers.
    unselect(index1, index2);
    incrementIndexes();

    if (!isStageSolved) {
      if (isSelectionOutOfBounds(index2)) {
        select(0, 1);
        resetIndexes();
      } else {
        select(index1, index2);
      }
      print("index1: $index1 e index2 $index2");
      notifyListeners();
    }
  }

  void unselect(int index1, int index2) {
    draggableList[index1] = DraggableListItem(
        title: draggableList[index1].title,
        color: Colors.white,
        key: draggableList[index1].key);
    draggableList[index2] = DraggableListItem(
        title: draggableList[index2].title,
        color: Colors.white,
        key: draggableList[index2].key);
  }

  void incrementIndexes() {
    index1++;
    index2++;
    if (isListFullyOrdered()) {
      isStageSolved = true;
      print('Stage solved!');
      notifyListeners();
    }
  }

  void select(int index1, int index2) {
    draggableList[index1] = DraggableListItem(
        title: draggableList[index1].title,
        color: Colors.green,
        key: draggableList[index1].key);
    draggableList[index2] = DraggableListItem(
        title: draggableList[index2].title,
        color: Colors.green,
        key: draggableList[index2].key);
  }

  void wrongMovement() {
    //Show error message
    draggableList[index1] = DraggableListItem(
        title: draggableList[index1].title,
        color: Colors.red,
        key: draggableList[index1].key);
    draggableList[index2] = DraggableListItem(
        title: draggableList[index2].title,
        color: Colors.red,
        key: draggableList[index2].key);
    notifyListeners();
  }

  bool checkCorrectMoveConditions() {
    return isSelectionOrdered();
  }

  bool isSelectionOrdered() =>
      int.parse(draggableList[index1].title) <
      int.parse(draggableList[index2].title);

  bool isListFullyOrdered() {
    List<DraggableListItem> tempList = draggableList.toList();
    tempList.sort((a, b) => int.parse(a.title).compareTo(int.parse(b.title)));
    for (int i = 0; i < draggableList.length; i++) {
      int compareResult = int.parse(draggableList[i].title)
          .compareTo(int.parse(tempList[i].title));
      if (compareResult != 0) {
        print('Not ordered yet!');
        return false;
      }
    }
    return true;
  }

  bool isSelectionOutOfBounds(int index) => index2 == draggableList.length;

  void resetIndexes() {
    index1 = 0;
    index2 = 1;
  }
}
