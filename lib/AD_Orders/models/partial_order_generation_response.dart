import '../../global/models/api_request_response.dart';

class PartialOrderGenerationResponse implements ApiRequestResponse {
  bool? status;
  String? message;

  PartialOrderGenerationResponse({this.status, this.message});

  PartialOrderGenerationResponse fromJson(Map<String, dynamic> json) {
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
