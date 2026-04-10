

import '../../global/models/api_request_response.dart';

class CopyLadderResponse implements ApiRequestResponse {
  String? msg;
  bool? status;

  CopyLadderResponse({this.msg, this.status});

  @override
  CopyLadderResponse fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}
