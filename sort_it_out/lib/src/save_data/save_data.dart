import 'package:sort_it_out/src/save_data/bubble_sort/bubble_sort_save_data.dart';

class SaveData {
  int score;
  BubbleSortSaveData bubbleSortSaveData;

  SaveData(this.score, this.bubbleSortSaveData);

  SaveData.fromJson(Map<String, dynamic> json)
      : score = json['score'],
        bubbleSortSaveData =
            BubbleSortSaveData.fromJson(json['bubbleSortSaveData']);

  Map<String, dynamic> toJson() =>
      {'score': score, 'bubbleSortSaveData': bubbleSortSaveData.toJson()};
}
