import '../../global/models/api_request_response.dart';

class LadderCreationTickerResponse extends ApiRequestResponse {
  bool? status;
  String? message;
  Data? data;

  LadderCreationTickerResponse({this.status, this.message, this.data});

  LadderCreationTickerResponse fromJson(Map<String, dynamic> json) {
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
  List<LadderCreationTickerList>? ladderCreationTickerList;
  String? accountCashForNewLadders;
  String? accountUnallocatedCash;
  String? accountExtraCashLeft;
  String? accountExtraCashGenerated;

  Data(
      {this.ladderCreationTickerList,
      this.accountCashForNewLadders,
      this.accountUnallocatedCash,
      this.accountExtraCashLeft,
      this.accountExtraCashGenerated});

  Data fromJson(Map<String, dynamic> json) {
    if (json['ladder_creation_ticker_list'] != null) {
      ladderCreationTickerList = <LadderCreationTickerList>[];
      json['ladder_creation_ticker_list'].forEach((v) {
        ladderCreationTickerList!
            .add(new LadderCreationTickerList().fromJson(v));
      });
    }
    accountCashForNewLadders = json['account_cash_for_new_ladders'];
    accountUnallocatedCash = json['account_unallocated_cash'];
    accountExtraCashLeft = json['account_extra_cash_left'];
    accountExtraCashGenerated = json['account_extra_cash_generated'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ladderCreationTickerList != null) {
      data['ladder_creation_ticker_list'] =
          this.ladderCreationTickerList!.map((v) => v.toJson()).toList();
    }
    data['account_cash_for_new_ladders'] = this.accountCashForNewLadders;
    data['account_unallocated_cash'] = this.accountUnallocatedCash;
    data['account_extra_cash_left'] = this.accountExtraCashLeft;
    data['account_extra_cash_generated'] = this.accountExtraCashGenerated;
    return data;
  }
}

class LadderCreationTickerList extends ApiRequestResponse {
  int? ssId;
  int? ssRegId;
  int? ssTickerId;
  String? ssTicker;
  String? ssCurrentPrice;
  String? ssExchange;
  String? ssCashAllocated;
  List<LadderDetails>? ladderDetails;

  LadderCreationTickerList(
      {this.ssId,
      this.ssRegId,
      this.ssTickerId,
      this.ssTicker,
      this.ssCurrentPrice,
      this.ssExchange,
      this.ladderDetails,
      this.ssCashAllocated});

  LadderCreationTickerList fromJson(Map<String, dynamic> json) {
    ssId = json['ss_id'];
    ssRegId = json['ss_reg_id'];
    ssTickerId = json['ss_ticker_id'];
    ssTicker = json['ss_ticker'];
    ssCurrentPrice = json['ss_current_price'];
    ssExchange = json['ss_exchange'];
    if (json['ladder_details'] != null) {
      ladderDetails = <LadderDetails>[];
      json['ladder_details'].forEach((v) {
        ladderDetails!.add(new LadderDetails().fromJson(v));
      });
    }
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ss_id'] = this.ssId;
    data['ss_reg_id'] = this.ssRegId;
    data['ss_ticker_id'] = this.ssTickerId;
    data['ss_ticker'] = this.ssTicker;
    data['ss_current_price'] = this.ssCurrentPrice;
    data['ss_exchange'] = this.ssExchange;
    if (this.ladderDetails != null) {
      data['ladder_details'] =
          this.ladderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LadderDetails extends ApiRequestResponse {
  int? ladId;
  int? ladUserId;
  String? ladTicker;
  String? ladName;
  String? ladStatus;
  int? ladTickerId;
  String? ladExchange;
  String? ladCashAllocated;
  String? ladMinimumPrice;
  String? ladExtraCashGenerated;
  String? ladExtraCashLeft;
  int? ladInitialBuyQuantity;
  int? ladDefaultBuySellQuantity;
  String? ladTargetPrice;
  String? ladInitialBuyPrice;
  int? ladDefinitionId;
  int? ladNumOfStepsAbove;

  LadderDetails(
      {this.ladId,
      this.ladUserId,
      this.ladTicker,
      this.ladName,
      this.ladStatus,
      this.ladTickerId,
      this.ladExchange,
      this.ladCashAllocated,
      this.ladMinimumPrice,
      this.ladExtraCashGenerated,
      this.ladExtraCashLeft,
      this.ladInitialBuyQuantity,
      this.ladDefaultBuySellQuantity,
      this.ladTargetPrice,
      this.ladInitialBuyPrice,
      this.ladDefinitionId,
      this.ladNumOfStepsAbove});

  LadderDetails fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    ladUserId = json['lad_user_id'];
    ladTicker = json['lad_ticker'];
    ladName = json['lad_name'];
    ladStatus = json['lad_status'];
    ladTickerId = json['lad_ticker_id'];
    ladExchange = json['lad_exchange'];
    ladCashAllocated = json['lad_cash_allocated'];
    ladMinimumPrice = json['lad_minimum_price'];
    ladExtraCashGenerated = json['lad_extra_cash_generated'];
    ladExtraCashLeft = json['lad_extra_cash_left'];
    ladInitialBuyQuantity = json['lad_initial_buy_quantity'];
    ladDefaultBuySellQuantity = json['lad_default_buy_sell_quantity'];
    ladTargetPrice = json['lad_target_price'];
    ladInitialBuyPrice = json['lad_initial_buy_price'];
    ladDefinitionId = json['lad_definition_id'];
    ladNumOfStepsAbove = json['lad_num_of_steps_above'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    data['lad_user_id'] = this.ladUserId;
    data['lad_ticker'] = this.ladTicker;
    data['lad_name'] = this.ladName;
    data['lad_status'] = this.ladStatus;
    data['lad_ticker_id'] = this.ladTickerId;
    data['lad_exchange'] = this.ladExchange;
    data['lad_cash_allocated'] = this.ladCashAllocated;
    data['lad_minimum_price'] = this.ladMinimumPrice;
    data['lad_extra_cash_generated'] = this.ladExtraCashGenerated;
    data['lad_extra_cash_left'] = this.ladExtraCashLeft;
    data['lad_initial_buy_quantity'] = this.ladInitialBuyQuantity;
    data['lad_default_buy_sell_quantity'] = this.ladDefaultBuySellQuantity;
    data['lad_target_price'] = this.ladTargetPrice;
    data['lad_initial_buy_price'] = this.ladInitialBuyPrice;
    data['lad_definition_id'] = this.ladDefinitionId;
    data['lad_num_of_steps_above'] = this.ladNumOfStepsAbove;
    return data;
  }
}
