class LadderModel {
  int? ladId;
  String? ladderName;
  String? ladderStatus;
  bool? copyCheckbox;
  LadderModel({
    required this.ladId,
    required this.ladderName,
    required this.ladderStatus,
    this.copyCheckbox = false,
  });
}
