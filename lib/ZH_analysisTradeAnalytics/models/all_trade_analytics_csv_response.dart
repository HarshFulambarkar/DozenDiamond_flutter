import 'package:dozen_diamond/global/models/api_request_response.dart';

class AllTradeAnalyticsCsvResponse implements ApiRequestResponse {
  String? msg;
  bool? status;

  AllTradeAnalyticsCsvResponse({this.msg, this.status});

  @override
  AllTradeAnalyticsCsvResponse fromJson(Map<String, dynamic> json) {
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
