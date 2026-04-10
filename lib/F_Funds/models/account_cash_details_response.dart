import 'package:dozen_diamond/global/models/api_request_response.dart';

class AccountCashDetailsResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Data? data;

  AccountCashDetailsResponse({this.status, this.message, this.data});

  AccountCashDetailsResponse fromJson(Map<String, dynamic> json) {
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

class Data implements ApiRequestResponse {
  String? accountUnallocatedCash;
  String? accountCashLeftInLadders;
  String? accountCashNeededForActiveLadders;
  String? accountExtraCashLeft;
  String? accountExtraCashGenerated;
  String? accountCashForNewLadders;
  String? accountFundsInPlay;
  String? accountCashLeft;

  Data(
      {this.accountUnallocatedCash,
      this.accountCashLeftInLadders,
      this.accountCashNeededForActiveLadders,
      this.accountExtraCashLeft,
      this.accountExtraCashGenerated,
      this.accountCashForNewLadders,
      this.accountFundsInPlay,
      this.accountCashLeft});

  Data fromJson(Map<String, dynamic> json) {
    accountUnallocatedCash = json['account_unallocated_cash'];
    accountCashLeftInLadders = json['account_cash_left_in_ladders'];
    accountCashNeededForActiveLadders =
        json['account_cash_needed_for_active_ladders'];
    accountExtraCashLeft = json['account_extra_cash_left'];
    accountExtraCashGenerated = json['account_extra_cash_generated'];
    accountCashForNewLadders = json['account_cash_for_new_ladders'];
    accountFundsInPlay = json['account_funds_in_play'];
    accountCashLeft = json['account_cash_left'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_unallocated_cash'] = this.accountUnallocatedCash;
    data['account_cash_left_in_ladders'] = this.accountCashLeftInLadders;
    data['account_cash_needed_for_ladders'] =
        this.accountCashNeededForActiveLadders;
    data['account_extra_cash_left'] = this.accountExtraCashLeft;
    data['account_extra_cash_generated'] = this.accountExtraCashGenerated;
    data['account_cash_for_new_ladders'] = this.accountCashForNewLadders;
    data['account_funds_in_play'] = this.accountFundsInPlay;
    data['account_cash_left'] = this.accountCashLeft;
    return data;
  }
}
