import 'package:flutter/cupertino.dart';

class MergeSortMessageProvider extends ChangeNotifier {
  late String currentMessage;

  late List<String> _hints;

  MergeSortMessageProvider() {
    currentMessage = '';
    _hints = [
      'Lembre-se que não há duas fases distintas nesse algoritmo',
      'A lista inicial é dividida em duas partes, tente organizar uma das partes antes de seguir para a outra'
    ];
  }

  void wrongMoveMessage() {
    currentMessage = 'Seleção incorreta!';
    notifyListeners();
  }

  void wrongMoveMessageInputs() {
    currentMessage = 'Alguns elementos estão errados!';
    notifyListeners();
  }

  void emptyInputsErrorMessage() {
    currentMessage = 'Alguns campos estão vazios!';
    notifyListeners();
  }

  void correctMoveMessage() {
    currentMessage = 'Bom trabalho!';
    notifyListeners();
  }

  void hintAsked() {
    currentMessage = getRandomHint();
    notifyListeners();
  }

  String getRandomHint() {
    List<int> listOfRandomNumbers =
        List.generate(_hints.length, (index) => index);
    listOfRandomNumbers.shuffle();
    return _hints[listOfRandomNumbers.first];
  }
}
