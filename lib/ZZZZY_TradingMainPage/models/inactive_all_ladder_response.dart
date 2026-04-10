import 'package:dozen_diamond/global/models/api_request_response.dart';

class InActiveAllLadderResponse implements ApiRequestResponse {
  bool? status;
  String? message;

  InActiveAllLadderResponse({this.status, this.message});
  @override
  InActiveAllLadderResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
