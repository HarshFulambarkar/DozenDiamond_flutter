import '../../global/models/api_request_response.dart';

class CloseTradeResponse implements ApiRequestResponse {
  String? msg;
  bool? status;

  CloseTradeResponse({this.msg, this.status});

  @override
  CloseTradeResponse fromJson(Map<String, dynamic> json) {
    return CloseTradeResponse(
      msg: json['msg'],
      status: json['status'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}
