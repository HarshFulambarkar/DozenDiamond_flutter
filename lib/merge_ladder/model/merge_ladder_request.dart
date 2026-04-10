import 'package:dozen_diamond/global/models/api_request_response.dart';

class MergeLadderRequest implements ApiRequestResponse {
  List<int>? ladderIds;
  MergeLadderData? mergeLadderData;

  MergeLadderRequest({this.ladderIds, this.mergeLadderData});

  MergeLadderRequest fromJson(Map<String, dynamic> json) {
    ladderIds = json['ladder_ids'].cast<String>();
    mergeLadderData = json['merge_ladder_data'] != null
        ? new MergeLadderData().fromJson(json['merge_ladder_data'])
        : null;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ladder_ids'] = this.ladderIds;
    if (this.mergeLadderData != null) {
      data['merge_ladder_data'] = this.mergeLadderData!.toJson();
    }
    return data;
  }
}

class MergeLadderData implements ApiRequestResponse {
  int? ladPositionId;
  String? ladTicker;
  String? ladStatus;
  int? ladTickerId;
  String? ladExchange;
  String? ladTradingMode;
  double? ladCashAllocated;
  double? ladCashGain;
  double? ladCashLeft;
  double? ladLastTradePrice;
  double? ladLastTradeOrderPrice;
  double? ladMinimumPrice;
  double? ladExtraCashGenerated;
  int? ladRealizedProfit;
  int? ladInitialBuyQuantity;
  int? ladDefaultBuySellQuantity;
  double? ladTargetPrice;
  double? ladNumOfStepsAbove;
  int? ladNumOfStepsBelow;
  double? ladCashNeeded;
  double? ladInitialBuyPrice;
  int? ladCurrentQuantity;
  double? ladStepSize;
  double? ladExtraCashLeft;
  int? ladReinvestExtraCash;
  int? ladUnsoldStockCashGain;
  double? targetPriceMultiplier;
  int? continueTradingAfterHittingTargetPrice;
  String? ladCashAssigned;

  MergeLadderData(
      {this.ladPositionId,
      this.ladTicker,
      this.ladStatus,
      this.ladTickerId,
      this.ladExchange,
      this.ladTradingMode,
      this.ladCashAllocated,
      this.ladCashGain,
      this.ladCashLeft,
      this.ladLastTradePrice,
      this.ladLastTradeOrderPrice,
      this.ladMinimumPrice,
      this.ladExtraCashGenerated,
      this.ladRealizedProfit,
      this.ladInitialBuyQuantity,
      this.ladDefaultBuySellQuantity,
      this.ladTargetPrice,
      this.ladNumOfStepsAbove,
      this.ladNumOfStepsBelow,
      this.ladCashNeeded,
      this.ladInitialBuyPrice,
      this.ladCurrentQuantity,
      this.ladStepSize,
      this.ladExtraCashLeft,
      this.ladReinvestExtraCash,
      this.ladUnsoldStockCashGain,
      this.targetPriceMultiplier,
      this.continueTradingAfterHittingTargetPrice,
        this.ladCashAssigned
      });

  MergeLadderData fromJson(Map<String, dynamic> json) {
    ladPositionId = json['lad_position_id'];
    ladTicker = json['lad_ticker'];
    ladStatus = json['lad_status'];
    ladTickerId = json['lad_ticker_id'];
    ladExchange = json['lad_exchange'];
    ladTradingMode = json['lad_trading_mode'];
    ladCashAllocated = json['lad_cash_allocated'];
    ladCashGain = json['lad_cash_gain'];
    ladCashLeft = json['lad_cash_left'];
    ladLastTradePrice = json['lad_last_trade_price'];
    ladLastTradeOrderPrice = json['lad_last_trade_order_price'];
    ladMinimumPrice = json['lad_minimum_price'];
    ladExtraCashGenerated = json['lad_extra_cash_generated'];
    ladRealizedProfit = json['lad_realized_profit'];
    ladInitialBuyQuantity = json['lad_initial_buy_quantity'];
    ladDefaultBuySellQuantity = json['lad_default_buy_sell_quantity'];
    ladTargetPrice = json['lad_target_price'];
    ladNumOfStepsAbove = json['lad_num_of_steps_above'];
    ladNumOfStepsBelow = json['lad_num_of_steps_below'];
    ladCashNeeded = json['lad_cash_needed'];
    ladInitialBuyPrice = json['lad_initial_buy_price'];
    ladCurrentQuantity = json['lad_current_quantity'];
    ladStepSize = json['lad_step_size'];
    ladExtraCashLeft = json['lad_extra_cash_left'];
    ladReinvestExtraCash = json['lad_reinvest_extra_cash'];
    ladUnsoldStockCashGain = json['lad_unsold_stock_cash_gain'];
    targetPriceMultiplier = json['target_price_multiplier'];
    continueTradingAfterHittingTargetPrice = json['continue_trading_after_hitting_target_price'];
    ladCashAssigned = json['lad_cash_assigned'].toString();
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_position_id'] = this.ladPositionId;
    data['lad_ticker'] = this.ladTicker;
    data['lad_status'] = this.ladStatus;
    data['lad_ticker_id'] = this.ladTickerId;
    data['lad_exchange'] = this.ladExchange;
    data['lad_trading_mode'] = this.ladTradingMode;
    data['lad_cash_allocated'] = this.ladCashAllocated;
    data['lad_cash_gain'] = this.ladCashGain;
    data['lad_cash_left'] = this.ladCashLeft;
    data['lad_last_trade_price'] = this.ladLastTradePrice;
    data['lad_last_trade_order_price'] = this.ladLastTradeOrderPrice;
    data['lad_minimum_price'] = this.ladMinimumPrice;
    data['lad_extra_cash_generated'] = this.ladExtraCashGenerated;
    data['lad_realized_profit'] = this.ladRealizedProfit;
    data['lad_initial_buy_quantity'] = this.ladInitialBuyQuantity;
    data['lad_default_buy_sell_quantity'] = this.ladDefaultBuySellQuantity;
    data['lad_target_price'] = this.ladTargetPrice;
    data['lad_num_of_steps_above'] = this.ladNumOfStepsAbove;
    data['lad_num_of_steps_below'] = this.ladNumOfStepsBelow;
    data['lad_cash_needed'] = this.ladCashNeeded;
    data['lad_initial_buy_price'] = this.ladInitialBuyPrice;
    data['lad_current_quantity'] = this.ladCurrentQuantity;
    data['lad_step_size'] = this.ladStepSize;
    data['lad_extra_cash_left'] = this.ladExtraCashLeft;
    data['lad_reinvest_extra_cash'] = this.ladReinvestExtraCash;
    data['lad_unsold_stock_cash_gain'] = this.ladUnsoldStockCashGain;
    data['target_price_multiplier'] = this.targetPriceMultiplier;
    data['continue_trading_after_hitting_target_price'] = this.continueTradingAfterHittingTargetPrice;
    data['lad_cash_assigned'] = this.ladCashAssigned;
    return data;
  }
}
