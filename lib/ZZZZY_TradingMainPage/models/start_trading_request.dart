import 'package:dozen_diamond/global/models/api_request_response.dart';

class StartTradingRequest implements ApiRequestResponse {
  bool? actTradingStatus;

  StartTradingRequest({this.actTradingStatus});

  @override
  StartTradingRequest fromJson(Map<String, dynamic> json) {
    actTradingStatus = json['reg_trading_status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reg_trading_status'] = actTradingStatus;
    return data;
  }
}
