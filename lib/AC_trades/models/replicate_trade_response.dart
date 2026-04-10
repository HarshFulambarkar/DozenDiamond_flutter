import '../../global/models/api_request_response.dart';

class ReplicateTradeResponse implements ApiRequestResponse {
  String? msg;
  bool? status;

  ReplicateTradeResponse({this.msg, this.status});

  @override
  ReplicateTradeResponse fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}
