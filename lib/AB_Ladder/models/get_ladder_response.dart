import 'package:dozen_diamond/global/models/api_request_response.dart';

class PaginationData implements ApiRequestResponse {
  bool? hasMore;
  int? nextCursor;
  PaginationData({this.hasMore, this.nextCursor});
  @override
  PaginationData fromJson(Map<String, dynamic> json) {
    hasMore = json['has_more'];
    nextCursor = json['next_cursor'] as int? ?? 0;

    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['has_more'] = this.hasMore;
    data['next_cursor'] = this.nextCursor;
    return data;
  }
}

class GetLadderResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  List<Data>? data;
  PaginationData? pagination;
  GetLadderResponse({this.status, this.message, this.data});
  @override
  GetLadderResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    pagination = PaginationData().fromJson(json['pagination']);

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
    data['pagination'] = this.pagination;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data implements ApiRequestResponse {
  String? stockName;
  double currentPrice;
  List<LadderData>? ladderData;

  Data({this.stockName, this.currentPrice = 0.0, this.ladderData});
  @override
  Data fromJson(Map<String, dynamic> json) {
    stockName = json['stock_name'];
    currentPrice = double.tryParse(json['current_price'] ?? "0.0") ?? 0.0;
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
    data['current_price'] = this.currentPrice;
    if (this.ladderData != null) {
      data['ladder_data'] = this.ladderData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LadderData implements ApiRequestResponse {
  int? ladId;
  int? ladUserId;
  int? ladDefinitionId;
  int? ladPositionId;
  String? ladTicker;
  String? ladName;
  String? ladStatus;
  int? ladTickerId;
  String? ladExchange;
  String? ladTradingMode;
  double ladCashAllocated;
  double ladStepSize;
  double ladCashGain;
  double ladCashLeft;
  double ladLastTradePrice;
  double ladLastTradeOrderPrice;
  double ladMinimumPrice;
  double ladExtraCashGenerated;
  double ladExtraCashPerOrder;
  double ladRealizedProfit;
  int ladInitialBuyQuantity;
  int ladDefaultBuySellQuantity;
  double ladTargetPrice;
  double ladNumOfStepsAbove;
  int ladNumOfStepsBelow;
  double ladCashNeeded;
  double ladInitialBuyPrice;
  int ladCurrentQuantity;
  int? ladInitialBuyExecuted;
  int? ladRecentTradeId;
  int? ladReinvestExtraCash;
  bool? noFollowup = false;

  // int? timeToRecoverInMonth = 0;
  double? timeToRecoverInvestmentInYears = 0.0;
  int? timeToRecoverLossesInDays = 0;
  int? noOfTradesPerMonth = 0;
  double? amountAlreadyRecovered = 0.0;
  int? ladExecutedOrders;
  int? ladOpenOrders;
  String? ladCashAssigned = "0";

  double? actualBrokerageCost = 0.0;
  double? otherBrokerageCharges = 0.0;
  DateTime? createdAt = DateTime.now();
  bool? isOneClick = false;

  LadderData({
    this.ladId,
    this.ladUserId,
    this.ladDefinitionId,
    this.ladPositionId,
    this.ladTicker,
    this.ladName,
    this.ladStatus,
    this.ladTickerId,
    this.ladExchange,
    this.ladTradingMode,
    this.ladCashAllocated = 0.0,
    this.ladStepSize = 0.0,
    this.ladCashGain = 0.0,
    this.ladCashLeft = 0.0,
    this.ladLastTradePrice = 0.0,
    this.ladLastTradeOrderPrice = 0.0,
    this.ladMinimumPrice = 0.0,
    this.ladExtraCashGenerated = 0.0,
    this.ladExtraCashPerOrder = 0.0,
    this.ladRealizedProfit = 0.0,
    this.ladInitialBuyQuantity = 0,
    this.ladDefaultBuySellQuantity = 0,
    this.ladTargetPrice = 0.0,
    this.ladNumOfStepsAbove = 0,
    this.ladNumOfStepsBelow = 0,
    this.ladCashNeeded = 0.0,
    this.ladInitialBuyPrice = 0.0,
    this.ladCurrentQuantity = 0,
    this.ladInitialBuyExecuted,
    this.ladRecentTradeId,
    this.ladReinvestExtraCash,
    this.noFollowup = false,
    // this.timeToRecoverInMonth = 0,
    this.timeToRecoverInvestmentInYears = 0,
    this.timeToRecoverLossesInDays = 0,
    this.noOfTradesPerMonth = 0,
    this.amountAlreadyRecovered = 0.0,
    this.ladExecutedOrders = 0,
    this.ladOpenOrders = 0,
    this.ladCashAssigned = "0",
    this.actualBrokerageCost = 0.0,
    this.otherBrokerageCharges = 0.0,
    this.createdAt,
    this.isOneClick = false,
  });
  @override
  LadderData fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    ladUserId = json['lad_user_id'];
    ladDefinitionId = json['lad_definition_id'];
    ladPositionId = json['lad_position_id'];
    ladTicker = json['lad_ticker'];
    ladName = json['lad_name'];
    ladStatus = json['lad_status'];
    ladTickerId = json['lad_ticker_id'];
    ladExchange = json['lad_exchange'];
    ladTradingMode = json['lad_trading_mode'];
    ladCashAllocated =
        double.tryParse(json['lad_cash_allocated'] ?? "0.0") ?? 0.0;
    ladStepSize = double.tryParse(json['lad_step_size'] ?? "0.0") ?? 0.0;
    ladCashGain = double.tryParse(json['lad_cash_gain'] ?? "0.0") ?? 0.0;
    ladCashLeft = double.tryParse(json['lad_cash_left'] ?? "0.0") ?? 0.0;
    ladLastTradePrice =
        double.tryParse(json['lad_last_trade_price'] ?? "0.0") ?? 0.0;
    ladLastTradeOrderPrice =
        double.tryParse(json['lad_last_trade_order_price'] ?? "0.0") ?? 0.0;
    ladMinimumPrice =
        double.tryParse(json['lad_minimum_price'] ?? "0.0") ?? 0.0;
    ladExtraCashGenerated =
        double.tryParse(json['lad_extra_cash_generated'] ?? "0.0") ?? 0.0;
    ladExtraCashPerOrder =
        // (((double.tryParse(json['lad_step_size'] ?? "0.0") ?? 0.0) * (double.tryParse(json['lad_default_buy_sell_quantity'] ?? "0.0") ?? 0.0)) / 2);
        double.tryParse(json['lad_extra_cash_per_order'] ?? "0.0") ?? 0.0;
    ladRealizedProfit =
        double.tryParse(json['lad_realized_profit'] ?? "0.0") ?? 0.0;
    ladInitialBuyQuantity = json['lad_initial_buy_quantity'];
    ladDefaultBuySellQuantity = json['lad_default_buy_sell_quantity'];
    ladTargetPrice = double.tryParse(json['lad_target_price'] ?? "0.0") ?? 0.0;
    ladNumOfStepsAbove =
        double.tryParse(json['lad_num_of_steps_above'].toString() ?? "0") ??
        0.0;
    ladNumOfStepsBelow = json['lad_num_of_steps_below'];
    ladCashNeeded = double.tryParse(json['lad_cash_needed'] ?? "0.0") ?? 0.0;
    ladInitialBuyPrice =
        double.tryParse(json['lad_initial_buy_price'] ?? "0.0") ?? 0.0;
    ladCurrentQuantity = json['lad_current_quantity'];
    ladInitialBuyExecuted = json['lad_initial_buy_executed'];
    ladRecentTradeId = json['lad_recent_trade_id'];
    ladReinvestExtraCash = json['lad_reinvest_extra_cash'];
    ladExecutedOrders = json['lad_executed_orders'];
    ladOpenOrders = json['lad_open_orders'];
    // noFollowup = json['no_followup'] ?? false;
    noFollowup = (json['order_follow_up'] == "NO_FOLLOW_UP") ? true : false;

    // timeToRecoverInMonth = json['time_to_recover_in_month'] != null
    //     ? json['time_to_recover_in_month']
    //     : 0;
    timeToRecoverLossesInDays = json['time_to_recover_losses_in_days'] != null
        ? int.parse(json['time_to_recover_losses_in_days'].toString())
        : 0;
    timeToRecoverInvestmentInYears =
        json['time_to_recover_investment_in_years'] != null
        ? double.parse(json['time_to_recover_investment_in_years'].toString())
        : 0.0;

    noOfTradesPerMonth = json['no_of_trades_per_month'] != null
        ? json['no_of_trades_per_month']
        : 0;
    amountAlreadyRecovered = json['amount_already_recovered'] != null
        ? double.parse(json['amount_already_recovered'].toString())
        : 0.0;
    ladCashAssigned = json['lad_cash_assigned'] ?? "0";

    actualBrokerageCost = (json['actual_brokerage_cost'] == null)
        ? 0.0
        : double.tryParse(json['actual_brokerage_cost'].toString()) ?? 0.0;
    otherBrokerageCharges = (json['total_tax_cost'] == null)
        ? 0.0
        : double.tryParse(json['total_tax_cost'].toString()) ?? 0.0;
    // final createdAtStr = json['createdAt']?.toString();
    // createdAtStr != null
    //     ? DateFormat('yyyy-MM-dd').parse(createdAtStr)
    //     : DateTime.now();
    createdAt = (json['createdAt'] == null)
        ? DateTime.now()
        // : DateFormat('yyyy-MM-dd').tryParse(json['createdAt'].toString()) ?? DateTime.now();
        : DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    // print("below is createdAt");
    // print(json['createdAt']);
    // print(createdAt);
    isOneClick = (json['is_one_click_ladder'] == true || json['is_one_click_ladder'] == "true" || json['is_one_click_ladder'] == "1" || json['is_one_click_ladder'] == 1) ? true : false;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    data['lad_user_id'] = this.ladUserId;
    data['lad_definition_id'] = this.ladDefinitionId;
    data['lad_position_id'] = this.ladPositionId;
    data['lad_ticker'] = this.ladTicker;
    data['lad_name'] = this.ladName;
    data['lad_status'] = this.ladStatus;
    data['lad_ticker_id'] = this.ladTickerId;
    data['lad_exchange'] = this.ladExchange;
    data['lad_trading_mode'] = this.ladTradingMode;
    data['lad_cash_allocated'] = this.ladCashAllocated;
    data['lad_step_size'] = this.ladStepSize;
    data['lad_cash_gain'] = this.ladCashGain;
    data['lad_cash_left'] = this.ladCashLeft;
    data['lad_last_trade_price'] = this.ladLastTradePrice;
    data['lad_last_trade_order_price'] = this.ladLastTradeOrderPrice;
    data['lad_minimum_price'] = this.ladMinimumPrice;
    data['lad_extra_cash_generated'] = this.ladExtraCashGenerated;
    data['lad_extra_cash_per_order'] = this.ladExtraCashPerOrder;
    data['lad_realized_profit'] = this.ladRealizedProfit;
    data['lad_initial_buy_quantity'] = this.ladInitialBuyQuantity;
    data['lad_default_buy_sell_quantity'] = this.ladDefaultBuySellQuantity;
    data['lad_target_price'] = this.ladTargetPrice;
    data['lad_num_of_steps_above'] = this.ladNumOfStepsAbove;
    data['lad_num_of_steps_below'] = this.ladNumOfStepsBelow;
    data['lad_cash_needed'] = this.ladCashNeeded;
    data['lad_initial_buy_price'] = this.ladInitialBuyPrice;
    data['lad_current_quantity'] = this.ladCurrentQuantity;
    data['lad_initial_buy_executed'] = this.ladInitialBuyExecuted;
    data['lad_recent_trade_id'] = this.ladRecentTradeId;
    data['lad_reinvest_extra_cash'] = this.ladReinvestExtraCash;
    data['no_followup'] = this.noFollowup;
    data['lad_open_orders'] = this.ladOpenOrders;
    data['lad_executed_orders'] = this.ladExecutedOrders;

    // data['time_to_recover_in_month'] = this.timeToRecoverInMonth;
    data['time_to_recover_losses_in_days'] = this.timeToRecoverLossesInDays;
    data['time_to_recover_investment_in_years'] =
        this.timeToRecoverInvestmentInYears;
    data['no_of_trades_per_month'] = this.noOfTradesPerMonth;
    data['amount_already_recovered'] = this.amountAlreadyRecovered;

    data['lad_cash_assigned'] = this.ladCashAssigned;

    data['actual_brokerage_cost'] = this.actualBrokerageCost;
    data['total_tax_cost'] = this.otherBrokerageCharges;
    data['is_one_click_ladder'] = this.isOneClick;

    return data;
  }
}
