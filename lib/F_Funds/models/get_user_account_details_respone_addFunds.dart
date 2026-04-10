import 'package:dozen_diamond/global/models/api_request_response.dart';

class GetUserAccountDetailsResponse extends ApiRequestResponse {
  bool? status;
  String? message;
  Data? data;

  GetUserAccountDetailsResponse({this.status, this.message, this.data});

  GetUserAccountDetailsResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    return this;
  }

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

class Data extends ApiRequestResponse {
  int? accountId;
  String? accountRealizedProfit;
  int? accountUserId;
  String? accountCashLeft;
  String? accountCashDeposite;
  String? accountCashGain;
  String? createdAt;
  String? updatedAt;
  String? accountFundsInPlay;

  Data(
      {this.accountId,
      this.accountRealizedProfit,
      this.accountUserId,
      this.accountCashLeft,
      this.accountCashDeposite,
      this.accountCashGain,
      this.createdAt,
      this.updatedAt,
      this.accountFundsInPlay});

  Data fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    accountRealizedProfit = json['account_realized_profit'];
    accountUserId = json['account_user_id'];
    accountCashLeft = json['account_cash_left'];
    accountCashDeposite = json['account_cash_deposite'];
    accountCashGain = json['account_cash_gain'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accountFundsInPlay = json['account_funds_in_play'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_id'] = this.accountId;
    data['account_realized_profit'] = this.accountRealizedProfit;
    data['account_user_id'] = this.accountUserId;
    data['account_cash_left'] = this.accountCashLeft;
    data['account_cash_deposite'] = this.accountCashDeposite;
    data['account_cash_gain'] = this.accountCashGain;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['account_funds_in_play'] = this.accountFundsInPlay;
    return data;
  }
}
