import 'package:dozen_diamond/global/models/api_request_response.dart';

class IsAnyLadderActiveResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Data? data;

  IsAnyLadderActiveResponse({this.status, this.message, this.data});

  @override
  IsAnyLadderActiveResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    return this;
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

class Data implements ApiRequestResponse {
  bool? anyLadderActive;

  Data({this.anyLadderActive});

  @override
  Data fromJson(Map<String, dynamic> json) {
    anyLadderActive = json['anyLadderActive'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['anyLadderActive'] = this.anyLadderActive;
    return data;
  }
}
