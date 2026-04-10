class SubmitAnswerData {
  int? correctAnswers;
  int? incorrectAnswers;
  String? status;

  SubmitAnswerData({this.correctAnswers, this.incorrectAnswers, this.status});

  SubmitAnswerData.fromJson(Map<String, dynamic> json) {
    correctAnswers = json['correctAnswers'];
    incorrectAnswers = json['incorrect_answers'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correctAnswers'] = this.correctAnswers;
    data['incorrect_answers'] = this.incorrectAnswers;
    data['status'] = this.status;
    return data;
  }
}