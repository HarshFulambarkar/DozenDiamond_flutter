// Content in this file will added once API for ladders fund info is readyimport '../../global/models/api_request_response.dart';

import 'package:dozen_diamond/global/models/api_request_response.dart';

class GetLadderResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  List<Data>? data;

  GetLadderResponse({this.status, this.message, this.success, this.data});
  @override
  GetLadderResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Success implements ApiRequestResponse {
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});
  @override
  Success fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}

class Data implements ApiRequestResponse {
  String? stockName;
  List<LadderData>? ladderData;

  Data({this.stockName, this.ladderData});
  @override
  Data fromJson(Map<String, dynamic> json) {
    stockName = json['stock_name'];
    if (json['ladder_data'] != null) {
      ladderData = <LadderData>[];
      json['ladder_data'].forEach((v) {
        ladderData!.add(new LadderData().fromJson(v));
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stock_name'] = this.stockName;
    if (this.ladderData != null) {
      data['ladder_data'] = this.ladderData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LadderData implements ApiRequestResponse {
  int? ladId;
  String? securityCode;
  String? ladCashInitialAllocated;
  int? userId;
  String? ladLadderName;
  String? initialPurchasePrice;
  int? ladInitialBuyQuantity;
  int? ladNumOfStepsAboveInitial;
  String? ladMinimumPrice;
  String? ladStatus;
  String? ladTargetPrice;
  int? ladDefaultBuySellQuantity;
  String? ladCashNeeded;
  String? ladMaxPurchaseCashGain;
  String? ladAvailableCash;
  int? ladStocksBoughtAfterInitalPurchase;
  String? ladCashGainForNewStock;
  String? ladCashGainForAllStock;
  String? ladCreatedAt;
  String? ladStepSize;
  bool? ladMarketOrder;
  bool? ladReinvestProfit;
  bool? ladTradingStatus;
  String? ladStockName;
  String? updatedAt;
  String? ladCashAllocated;
  int? ladCurrentQuantity;
  String? currentPrice;
  String? ladCashGain;
  String? ladExtraCash;
  String? ladCashGainForInitialPurchase;
  String? ladLastTradePrice;
  String? ladLastStepPrice;

  LadderData(
      {this.ladId,
      this.securityCode,
      this.ladCashInitialAllocated,
      this.userId,
      this.ladLadderName,
      this.initialPurchasePrice,
      this.ladInitialBuyQuantity,
      this.ladMinimumPrice,
      this.ladStatus,
      this.ladTargetPrice,
      this.ladDefaultBuySellQuantity,
      this.ladCashNeeded,
      this.ladMaxPurchaseCashGain,
      this.ladAvailableCash,
      this.ladStocksBoughtAfterInitalPurchase,
      this.ladCashGainForNewStock,
      this.ladCashGainForAllStock,
      this.ladCreatedAt,
      this.ladStepSize,
      this.ladMarketOrder,
      this.ladReinvestProfit,
      this.ladTradingStatus,
      this.ladStockName,
      this.updatedAt,
      this.ladCashAllocated,
      this.ladCurrentQuantity,
      this.currentPrice,
      this.ladCashGain,
      this.ladExtraCash,
      this.ladCashGainForInitialPurchase,
      this.ladLastStepPrice,
      this.ladNumOfStepsAboveInitial,
      this.ladLastTradePrice});
  @override
  LadderData fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    securityCode = json['security_code'];
    ladCashInitialAllocated = json['lad_cash_initial_allocated'];
    userId = json['user_id'];
    ladLadderName = json['lad_ladder_name'];
    initialPurchasePrice = json['Initial_purchase_price'];
    ladInitialBuyQuantity = json['lad_initial_buy_quantity'];
    ladMinimumPrice = json['lad_minimum_price'];
    ladStatus = json['lad_status'];
    ladTargetPrice = json['lad_target_price'];
    ladDefaultBuySellQuantity = json['lad_default_buy_sell_quantity'];
    ladCashNeeded = json['lad_cash_needed'];
    ladMaxPurchaseCashGain = json['lad_max_purchase_cash_gain'];
    ladAvailableCash = json['lad_available_cash'];
    ladStocksBoughtAfterInitalPurchase =
        json['lad_stocks_bought_after_inital_purchase'];
    ladCashGainForNewStock = json['lad_cash_gain_for_new_stock'];
    ladCashGainForAllStock = json['lad_cash_gain_for_all_stock'];
    ladCreatedAt = json['lad_created_at'];
    ladStepSize = json['lad_step_size'];
    ladMarketOrder = json['lad_market_order'];
    ladReinvestProfit = json['lad_reinvest_profit'];
    ladTradingStatus = json['lad_trading_status'];
    ladStockName = json['lad_stock_name'];
    updatedAt = json['updatedAt'];
    ladCashAllocated = json['lad_cash_allocated'];
    ladCurrentQuantity = json['lad_current_quantity'];
    currentPrice = json['current_price'];
    ladCashGain = json['lad_cash_gain'];
    ladExtraCash = json['lad_extra_cash'];
    ladCashGainForInitialPurchase = json['lad_cash_gain_for_initial_purchase'];
    ladLastTradePrice = json['lad_last_trade_price'];
    ladLastStepPrice = json['lad_last_step_price'];
    ladNumOfStepsAboveInitial = json['lad_num_of_steps_above_initial'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    data['security_code'] = this.securityCode;
    data['lad_cash_initial_allocated'] = this.ladCashInitialAllocated;
    data['user_id'] = this.userId;
    data['lad_ladder_name'] = this.ladLadderName;
    data['Initial_purchase_price'] = this.initialPurchasePrice;
    data['lad_initial_buy_quantity'] = this.ladInitialBuyQuantity;
    data['lad_minimum_price'] = this.ladMinimumPrice;
    data['lad_status'] = this.ladStatus;
    data['lad_target_price'] = this.ladTargetPrice;
    data['lad_default_buy_sell_quantity'] = this.ladDefaultBuySellQuantity;
    data['lad_cash_needed'] = this.ladCashNeeded;
    data['lad_max_purchase_cash_gain'] = this.ladMaxPurchaseCashGain;
    data['lad_available_cash'] = this.ladAvailableCash;
    data['lad_stocks_bought_after_inital_purchase'] =
        this.ladStocksBoughtAfterInitalPurchase;
    data['lad_cash_gain_for_new_stock'] = this.ladCashGainForNewStock;
    data['lad_cash_gain_for_all_stock'] = this.ladCashGainForAllStock;
    data['lad_created_at'] = this.ladCreatedAt;
    data['lad_step_size'] = this.ladStepSize;
    data['lad_market_order'] = this.ladMarketOrder;
    data['lad_reinvest_profit'] = this.ladReinvestProfit;
    data['lad_trading_status'] = this.ladTradingStatus;
    data['lad_stock_name'] = this.ladStockName;
    data['updatedAt'] = this.updatedAt;
    data['lad_cash_allocated'] = this.ladCashAllocated;
    data['lad_current_quantity'] = this.ladCurrentQuantity;
    data['current_price'] = this.currentPrice;
    data['lad_cash_gain'] = this.ladCashGain;
    data['lad_extra_cash'] = this.ladExtraCash;
    data['lad_last_trade_price'] = this.ladLastTradePrice;
    data['lad_last_step_price'] = this.ladLastStepPrice;
    data['lad_cash_gain_for_initial_purchase'] =
        this.ladCashGainForInitialPurchase;
    data['lad_num_of_steps_above_initial'] = this.ladNumOfStepsAboveInitial;
    return data;
  }
}
