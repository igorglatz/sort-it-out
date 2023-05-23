import 'package:sort_it_out/src/save_data/bubble_sort/bubble_sort_save_data.dart';
import 'package:sort_it_out/src/save_data/merge-sort/merge_sort_save_data.dart';

class SaveData {
  int score;
  BubbleSortSaveData bubbleSortSaveData;
  MergeSortSaveData mergeSortSaveData;

  SaveData(this.score, this.bubbleSortSaveData, this.mergeSortSaveData);

  SaveData.fromJson(Map<String, dynamic> json)
      : score = json['score'],
        bubbleSortSaveData =
            BubbleSortSaveData.fromJson(json['bubbleSortSaveData']),
        mergeSortSaveData =
            MergeSortSaveData.fromJson(json['bubbleSortSaveData']);

  Map<String, dynamic> toJson() => {
        'score': score,
        'bubbleSortSaveData': bubbleSortSaveData.toJson(),
        'mergeSortSaveData': mergeSortSaveData.toJson()
      };
}
