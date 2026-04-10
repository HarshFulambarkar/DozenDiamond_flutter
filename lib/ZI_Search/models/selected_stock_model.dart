import '../../global/models/api_request_response.dart';

class SelectedTickerModel implements ApiRequestResponse {
  int ssId;
  int ssRegId;
  int ssTickerId;
  int ssSecurityCode;
  String ssTicker;
  String ssIsinNo;
  String ssSimulatedPrice;
  String ssExchange;

  SelectedTickerModel({
    this.ssId = 0,
    this.ssRegId = 0,
    this.ssTickerId = 0,
    this.ssSecurityCode = 0,
    this.ssTicker = "",
    this.ssIsinNo = "",
    this.ssSimulatedPrice = "",
    this.ssExchange = "",
  });

  @override
  SelectedTickerModel fromJson(Map<String, dynamic> json) {
    ssId = json['ss_id'];
    ssRegId = json['ss_reg_id'];
    ssTickerId = json['ss_ticker_id'];
    ssSecurityCode = json['ss_security_code'];
    ssTicker = json['ss_ticker'];
    ssIsinNo = json['ss_isin_no'];
    ssSimulatedPrice = json['ss_simulated_price'];
    ssExchange = json['ss_exchange'];

    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ss_id'] = ssId;
    data['ss_reg_id'] = ssRegId;
    data['ss_ticker_id'] = ssTickerId;
    data['ss_security_code'] = ssSecurityCode;
    data['ss_ticker'] = ssTicker;
    data['ss_isin_no'] = ssIsinNo;
    data['ss_simulated_price'] = ssSimulatedPrice;
    data['ss_exchange'] = ssExchange;

    return data;
  }
}
