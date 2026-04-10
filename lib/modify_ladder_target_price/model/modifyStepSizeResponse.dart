import 'package:dozen_diamond/global/models/api_request_response.dart';

class ModifyStepSizeResponse implements ApiRequestResponse {
  bool? status;
  String? message;

  ModifyStepSizeResponse({this.status, this.message});

  ModifyStepSizeResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
