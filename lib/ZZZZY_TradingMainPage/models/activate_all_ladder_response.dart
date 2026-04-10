import 'package:dozen_diamond/global/models/api_request_response.dart';

class ActivateAllLadderResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Data? data;

  ActivateAllLadderResponse({this.status, this.message, this.data});
  @override
  ActivateAllLadderResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    return this;
  }

  @override
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

class Data implements ApiRequestResponse {
  String? description;
  String? suggestion;

  Data({this.description, this.suggestion});
  @override
  Data fromJson(Map<String, dynamic> json) {
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
