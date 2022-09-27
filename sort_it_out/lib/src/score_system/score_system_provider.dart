import 'package:flutter/cupertino.dart';

class ScoreSystemProvider extends ChangeNotifier {
  late int score;

  ScoreSystemProvider() {
    //Check here if there is persistant data.
    //if (player does not have points from previous game sessions)
    score = 0;
  }

  _addPoints(int amount) {
    score += amount;
    notifyListeners();
  }

  _subtractPoints(int amount) {
    if (score != 0) {
      score -= amount;
    }
    notifyListeners();
  }

  resetScore() {
    score = 0;
    notifyListeners();
  }

  wrongMove() {
    _subtractPoints(50);
  }

  correctMove() {
    _addPoints(100);
  }

  hintAsked() {
    _subtractPoints(20);
  }
}
