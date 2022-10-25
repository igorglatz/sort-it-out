class BubbleSortSaveData {
  bool isStage1Complete;
  bool isStage2Complete;
  bool isStage3Complete;

  BubbleSortSaveData(
      this.isStage1Complete, this.isStage2Complete, this.isStage3Complete);

  BubbleSortSaveData.fromJson(Map<String, dynamic> json)
      : isStage1Complete = json['isStage1Complete'],
        isStage2Complete = json['isStage2Complete'],
        isStage3Complete = json['isStage3Complete'];

  Map<String, dynamic> toJson() => {
        'isStage1Complete': isStage1Complete,
        'isStage2Complete': isStage2Complete,
        'isStage3Complete': isStage3Complete
      };
}
