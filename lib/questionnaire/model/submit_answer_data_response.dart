import 'package:dozen_diamond/questionnaire/model/submit_answer_data.dart';

class SubmitAnswerDataResponse {
  bool? status;
  String? message;
  SubmitAnswerData? data;

  SubmitAnswerDataResponse({this.status, this.message, this.data});

  SubmitAnswerDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SubmitAnswerData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
