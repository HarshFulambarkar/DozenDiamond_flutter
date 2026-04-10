import '../../global/models/api_request_response.dart';

class AccountDetailResponse implements ApiRequestResponse {
  String? message;
  bool? status;
  Data? data;

  AccountDetailResponse({this.message, this.status, this.data});
  @override
  AccountDetailResponse fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data implements ApiRequestResponse {
  String? totalCash;
  String? totalCashNeededForActiveLadders;
  String? totalAvailableCashForNewLadder;
  String? totalCashDeposite;

  Data(
      {this.totalCash,
      this.totalCashNeededForActiveLadders,
      this.totalAvailableCashForNewLadder,
      this.totalCashDeposite});
  @override
  Data fromJson(Map<String, dynamic> json) {
    totalCash = json['total_cash'];
    totalCashNeededForActiveLadders =
        json['total_cash_needed_for_active_ladders'];
    totalAvailableCashForNewLadder =
        json['total_available_cash_for_new_ladder'];
    totalCashDeposite = json['total_cash_deposite'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_cash'] = this.totalCash;
    data['total_cash_needed_for_active_ladders'] =
        this.totalCashNeededForActiveLadders;
    data['total_available_cash_for_new_ladder'] =
        this.totalAvailableCashForNewLadder;
    data['total_cash_deposite'] = this.totalCashDeposite;
    return data;
  }
}
