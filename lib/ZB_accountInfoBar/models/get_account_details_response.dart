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
  String? accountCashDeposit;
  String? accountCashGain;
  String? createdAt;
  String? updatedAt;
  String? accountFundsInPlay;
  String? accountUnallocatedCashLeftForTrading;
  String? accountCashLeftInActiveLadders;
  String? accountCashNeededForActiveLadders;
  String? accountExtraCashLeft;
  String? accountExtraCashGenerated;
  String? accountCashLeftForNewLadders;
  String? accountUnsoldStocksCashGain;

  Data(
      {this.accountId,
      this.accountRealizedProfit,
      this.accountUserId,
      this.accountCashLeft,
      this.accountCashDeposit,
      this.accountCashGain,
      this.createdAt,
      this.updatedAt,
      this.accountFundsInPlay,
      this.accountUnallocatedCashLeftForTrading,
      this.accountCashLeftInActiveLadders,
      this.accountCashNeededForActiveLadders,
      this.accountExtraCashLeft,
      this.accountExtraCashGenerated,
      this.accountCashLeftForNewLadders,
      this.accountUnsoldStocksCashGain});

  Data fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    accountRealizedProfit = json['account_realized_profit'];
    accountUserId = json['account_user_id'];
    accountCashLeft = json['account_cash_left'];
    accountCashDeposit = json['account_cash_deposit'];
    accountCashGain = json['account_cash_gain'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accountFundsInPlay = json['account_funds_in_play'];
    accountUnallocatedCashLeftForTrading =
        json['account_unallocated_cash_left_for_trading'];
    accountCashLeftInActiveLadders =
        json['account_cash_left_in_active_ladders'];
    accountCashNeededForActiveLadders =
        json['account_cash_needed_for_active_ladders'];
    accountExtraCashLeft = json['account_extra_cash_left'];
    accountExtraCashGenerated = json['account_extra_cash_generated'];
    accountCashLeftForNewLadders = json['account_cash_left_for_new_ladders'];
    accountUnsoldStocksCashGain = json['account_unsold_stocks_cash_gain'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_id'] = this.accountId;
    data['account_realized_profit'] = this.accountRealizedProfit;
    data['account_user_id'] = this.accountUserId;
    data['account_cash_left'] = this.accountCashLeft;
    data['account_cash_deposit'] = this.accountCashDeposit;
    data['account_cash_gain'] = this.accountCashGain;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['account_funds_in_play'] = this.accountFundsInPlay;
    data['account_unallocated_cash_left_for_trading'] =
        this.accountUnallocatedCashLeftForTrading;
    data['account_cash_left_in_active_ladders'] =
        this.accountCashLeftInActiveLadders;
    data['account_cash_needed_for_active_ladders'] =
        this.accountCashNeededForActiveLadders;
    data['account_extra_cash_left'] = this.accountExtraCashLeft;
    data['account_extra_cash_generated'] = this.accountExtraCashGenerated;
    data['account_cash_left_for_new_ladders'] =
        this.accountCashLeftForNewLadders;
    data['account_unsold_stocks_cash_gain'] = this.accountUnsoldStocksCashGain;
    return data;
  }
}
