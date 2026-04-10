// class Question {
//   final int id;
//   final String text;
//   final String type;
//   final List<String>? options;
//
//   Question({
//     required this.id,
//     required this.text,
//     required this.type,
//     this.options,
//   });
//
//   factory Question.fromJson(Map<String, dynamic> json) => Question(
//     id: json['id'] as int,
//     text: json['text'] as String,
//     type: json['type'] as String,
//     options: (json['options'] as List<dynamic>?)?.cast<String>(),
//   );
// }

class QuestionData {
  int? quesId;
  String? questionTest;
  List<String>? options;
  String? questionType;

  QuestionData({this.quesId, this.questionTest, this.options, this.questionType});

  QuestionData.fromJson(Map<String, dynamic> json) {
    quesId = json['ques_id'];
    questionTest = json['question_test'];
    options = json['options'].cast<String>();
    questionType = json['question_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ques_id'] = this.quesId;
    data['question_test'] = this.questionTest;
    data['options'] = this.options;
    data['question_type'] = this.questionType;
    return data;
  }
}

