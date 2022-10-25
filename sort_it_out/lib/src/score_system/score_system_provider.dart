import 'package:flutter/cupertino.dart';
import 'package:sort_it_out/src/save_data/save_data_provider.dart';

class ScoreSystemProvider extends ChangeNotifier {
  late int score;
  final SaveDataProvider? _saveDataProvider;
  ScoreSystemProvider(this._saveDataProvider) {
    if (_saveDataProvider != null) {
      int savedScore = _saveDataProvider!.getSavedScore();
      score = savedScore;
    }
  }

  _addPoints(int amount) {
    score += amount;
    _updateScoreOnSaveFile();
    notifyListeners();
  }

  _subtractPoints(int amount) {
    if (score != 0) {
      score -= amount;
      _updateScoreOnSaveFile();
    }
    notifyListeners();
  }

  resetScore() {
    score = 0;
    _updateScoreOnSaveFile();
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

  void _updateScoreOnSaveFile() {
    _saveDataProvider!.saveScore(score);
  }
}
