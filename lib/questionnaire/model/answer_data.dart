class Answer {
  final int questionId;
  // final dynamic response;
  final int selectedOptionIndex;

  Answer({
    required this.questionId,
    // required this.response,
    required this.selectedOptionIndex,
  });

  Map<String, dynamic> toJson() => {
    'quesId': questionId,
    // 'response': response,
    'selectedOptionIndex': selectedOptionIndex,
  };
}
