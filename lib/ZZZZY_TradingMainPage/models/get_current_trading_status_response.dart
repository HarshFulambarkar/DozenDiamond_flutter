import 'package:dozen_diamond/global/models/api_request_response.dart';

class GetCurrentTradingStatusResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Data? data;

  GetCurrentTradingStatusResponse({this.status, this.message, this.data});
  @override
  GetCurrentTradingStatusResponse fromJson(Map<String, dynamic> json) {
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
  bool? regTradingStatus;

  Data({this.regTradingStatus});
  @override
  Data fromJson(Map<String, dynamic> json) {
    regTradingStatus = json['reg_trading_status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reg_trading_status'] = this.regTradingStatus;
    return data;
  }
}
