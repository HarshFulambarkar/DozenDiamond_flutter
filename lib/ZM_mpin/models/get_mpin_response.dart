import '../../global/models/api_request_response.dart';

class GetMpinResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;

  GetMpinResponse({this.status, this.message, this.success});
  @override
  GetMpinResponse fromJson(Map<String, dynamic> json) {
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
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});
  @override
  Success fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}
