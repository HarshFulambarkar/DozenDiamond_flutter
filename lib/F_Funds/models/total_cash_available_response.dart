import '../../global/models/api_request_response.dart';

class TotalCashAvailableResponse implements ApiRequestResponse {
  Data? data;
  bool? status;

  TotalCashAvailableResponse({this.data, this.status});

  @override
  TotalCashAvailableResponse fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data().fromJson(json['data']) : null;
    status = json['status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data implements ApiRequestResponse {
  String? usrAccuntCashAvailable;

  Data({this.usrAccuntCashAvailable});

  @override
  Data fromJson(Map<String, dynamic> json) {
    usrAccuntCashAvailable = json['usr_accunt_cash_available'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usr_accunt_cash_available'] = this.usrAccuntCashAvailable;
    return data;
  }
}
