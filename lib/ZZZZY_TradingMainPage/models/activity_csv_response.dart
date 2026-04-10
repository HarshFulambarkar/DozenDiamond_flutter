import 'package:dozen_diamond/global/models/api_request_response.dart';

class ActivityCsvResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;

  ActivityCsvResponse({this.status, this.message, this.success});
  @override
  ActivityCsvResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    return data;
  }
}

class Success implements ApiRequestResponse {
  String? suggestion;
  String? description;

  Success({this.suggestion, this.description});
  @override
  Success fromJson(Map<String, dynamic> json) {
    suggestion = json['suggestion'];
    description = json['description'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suggestion'] = this.suggestion;
    data['description'] = this.description;
    return data;
  }
}
