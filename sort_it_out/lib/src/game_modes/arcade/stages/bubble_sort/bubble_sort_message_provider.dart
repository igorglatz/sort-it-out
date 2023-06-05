import 'package:flutter/cupertino.dart';

class BubbleSortMessageProvider extends ChangeNotifier {
  late String currentMessage;

  late List<String> _hints;

  BubbleSortMessageProvider() {
    currentMessage = '';
    _hints = [
      'Lembre-se que o elemento destacado à esquerda deve sempre ser menor que o elemento à direita'
    ];
  }

  void wrongMoveMessage(bool notHighlitedElementMoved) {
    if (notHighlitedElementMoved) {
      currentMessage = 'Elementos não destacados não devem ser movidos!';
      notifyListeners();
    } else {
      currentMessage = 'Movimento incorreto!';
      notifyListeners();
    }
  }

  void correctMoveMessage() {
    currentMessage = 'Bom trabalho!';
    notifyListeners();
  }

  void hintAsked() {
    currentMessage = _getRandomHint();
    notifyListeners();
  }

  String _getRandomHint() {
    List<int> listOfRandomNumbers =
        List.generate(_hints.length, (index) => index);
    listOfRandomNumbers.shuffle();
    return _hints[listOfRandomNumbers.first];
  }
}
