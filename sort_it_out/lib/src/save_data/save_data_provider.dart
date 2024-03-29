import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sort_it_out/src/save_data/bubble_sort/bubble_sort_save_data.dart';
import 'package:sort_it_out/src/save_data/merge-sort/merge_sort_save_data.dart';
import 'package:sort_it_out/src/save_data/save_data.dart';

class SaveDataProvider extends ChangeNotifier {
  SaveData? saveData;

  SaveDataProvider._create() {
    saveData = SaveData(0, BubbleSortSaveData(false, false, false),
        MergeSortSaveData(false, false, false));
  }

  static Future<SaveDataProvider> init() async {
    var saveDataProvider = SaveDataProvider._create();
    await saveDataProvider._init();
    return saveDataProvider;
  }

  _init() async {
    bool _saveFileExists = await _previousSaveFileExists();
    if (_saveFileExists) {
      _readFile();
    } else {
      _createFile();
    }
  }

  void _writeSaveFile() async {
    File file = File(await getFilePath());
    file.writeAsString(jsonEncode(saveData!.toJson()));
  }

  get bubbleSortSaveData => saveData!.bubbleSortSaveData;

  get mergeSortSaveData => saveData!.mergeSortSaveData;

  Future<String> getFilePath() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/saveFile.txt';

    return filePath;
  }

  void _readFile() async {
    File file = File(await getFilePath());
    String fileContent = await file.readAsString();

    try {
      saveData = SaveData.fromJson(jsonDecode(fileContent));
    } catch (e) {
      log('Error during int parsing in readFile process: $e');
    }
  }

  void _createFile() async {
    File file = await File(await getFilePath()).create(recursive: true);
    file.writeAsString(jsonEncode(saveData!.toJson()));
  }

  _previousSaveFileExists() async {
    File file = File(await getFilePath());
    return await file.exists();
  }

  int getSavedScore() {
    int score = saveData != null ? saveData!.score : 0;
    return score;
  }

  saveStageCompletion() {
    _writeSaveFile();
    notifyListeners();
  }

  saveScore(int score) {
    saveData!.score = score;
    _writeSaveFile();
    notifyListeners();
  }

  resetSaveData() {
    saveData = SaveData(0, BubbleSortSaveData(false, false, false),
        MergeSortSaveData(false, false, false));
    _writeSaveFile();
    notifyListeners();
  }
}
