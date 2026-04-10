import 'package:dozen_diamond/global/models/api_request_response.dart';

class SwitchingTradingModeRequest implements ApiRequestResponse {
  String? tradingMode;

  SwitchingTradingModeRequest({this.tradingMode});

  @override
  SwitchingTradingModeRequest fromJson(Map<String, dynamic> json) {
    tradingMode = json['trading_mode'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trading_mode'] = this.tradingMode;
    return data;
  }
}
