import '../../global/models/api_request_response.dart';

class GetAllUnsettledTradeListResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  List<Data>? data;

  GetAllUnsettledTradeListResponse({this.status, this.message, this.data});
  @override
  GetAllUnsettledTradeListResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data implements ApiRequestResponse {
  String? tradeOrderTicketNumber;
  int? tradeId;
  int? prevTradeId;
  int? nextTradeId;
  String? tradeType;
  String? tradeStatus;
  int? tradePositionId;
  int? tradeUserId;
  int? tradeLadderId;
  int? tradeTotalUnits;
  double tradeExecutionPrice;
  int? tradeAutomated;
  String? tradeTradingMode;
  int? tradeUnsettledTradeUnits;
  double tradeCashGain;
  double tradeRealizedProfit;
  double tradeExtraCashGenerated;
  int? tradePreviousTradeId;
  String? tradeExchange;
  int? tradeTickerId;
  String? tradeTicker;
  String? createdAt;
  String? updatedAt;
  double currentPrice;
  String? tradeLadderName;
  bool? noFollowup = false;

  double? actualBrokerageCost = 0.0;
  double? otherBrokerageCharges = 0.0;

  Data({
    this.tradeOrderTicketNumber,
    this.tradeId,
    this.prevTradeId,
    this.nextTradeId,
    this.tradeType,
    this.tradeStatus,
    this.tradePositionId,
    this.tradeUserId,
    this.tradeLadderId,
    this.tradeTotalUnits,
    this.tradeExecutionPrice = 0.0,
    this.tradeAutomated,
    this.tradeTradingMode,
    this.tradeUnsettledTradeUnits,
    this.tradeCashGain = 0.0,
    this.tradeRealizedProfit = 0.0,
    this.tradeExtraCashGenerated = 0.0,
    this.tradePreviousTradeId,
    this.tradeExchange,
    this.tradeTickerId,
    this.tradeTicker,
    this.createdAt,
    this.updatedAt,
    this.tradeLadderName,
    this.currentPrice = 0.0,
    this.noFollowup = false,
    this.actualBrokerageCost = 0.0,
    this.otherBrokerageCharges = 0.0,
  });
  @override
  Data fromJson(Map<String, dynamic> json) {
    tradeOrderTicketNumber = json['trade_order_ticket_number'] ?? "N/A";
    tradeId = json['trade_id'];
    prevTradeId = json['prev_trade_id'];
    nextTradeId = json['next_trade_id'];
    tradeType = json['trade_type'];
    tradeStatus = json['trade_status'];
    tradePositionId = json['trade_position_id'];
    tradeUserId = json['trade_user_id'];
    tradeLadderId = json['trade_ladder_id'];
    tradeTotalUnits = json['trade_total_units'];
    tradeLadderName = json['trade_ladder_name'];
    tradeExecutionPrice =
        double.tryParse(json['trade_execution_price'] ?? "0.0") ?? 0.0;
    tradeAutomated = json['trade_automated'];
    tradeTradingMode = json['trade_trading_mode'];
    tradeUnsettledTradeUnits = json['trade_unsettled_trade_units'];
    tradeCashGain = double.tryParse(json['trade_cash_gain'] ?? "0.0") ?? 0.0;
    tradeRealizedProfit =
        double.tryParse(json['trade_realized_profit'] ?? "0.0") ?? 0.0;
    tradeExtraCashGenerated =
        double.tryParse(json['trade_extra_cash_generated'] ?? "0.0") ?? 0.0;
    tradePreviousTradeId = json['trade_previous_trade_id'];
    tradeExchange = json['trade_exchange'];
    tradeTickerId = json['trade_ticker_id'];
    tradeTicker = json['trade_ticker'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    currentPrice = double.tryParse(json['current_price'].toString() ?? "0.0") ?? 0.0;
    // noFollowup = json['no_followup'] ?? false;
    noFollowup = (json['order_follow_up'] == "NO_FOLLOW_UP") ? true : false;

    actualBrokerageCost = (json['actual_brokerage_cost'] == null)
        ? 0.0
        : double.tryParse(json['actual_brokerage_cost'].toString()) ?? 0.0;
    otherBrokerageCharges = (json['total_tax_cost'] == null)
        ? 0.0
        : double.tryParse(json['total_tax_cost'].toString()) ?? 0.0;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_order_ticket_number'] = this.tradeOrderTicketNumber;
    data['trade_id'] = this.tradeId;
    data['prev_trade_id'] = this.prevTradeId;
    data['next_trade_id'] = this.nextTradeId;
    data['trade_type'] = this.tradeType;
    data['trade_status'] = this.tradeStatus;
    data['trade_position_id'] = this.tradePositionId;
    data['trade_user_id'] = this.tradeUserId;
    data['trade_ladder_id'] = this.tradeLadderId;
    data['trade_total_units'] = this.tradeTotalUnits;
    data['trade_execution_price'] = this.tradeExecutionPrice;
    data['trade_automated'] = this.tradeAutomated;
    data['trade_trading_mode'] = this.tradeTradingMode;
    data['trade_unsettled_trade_units'] = this.tradeUnsettledTradeUnits;
    data['trade_cash_gain'] = this.tradeCashGain;
    data['trade_realized_profit'] = this.tradeRealizedProfit;
    data['trade_extra_cash_generated'] = this.tradeExtraCashGenerated;
    data['trade_previous_trade_id'] = this.tradePreviousTradeId;
    data['trade_ladder_name'] = this.tradeLadderName;
    data['trade_exchange'] = this.tradeExchange;
    data['trade_ticker_id'] = this.tradeTickerId;
    data['trade_ticker'] = this.tradeTicker;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['current_price'] = this.currentPrice;
    data['no_followup'] = this.noFollowup;

    data['actual_brokerage_cost'] = this.actualBrokerageCost;
    data['total_tax_cost'] = this.otherBrokerageCharges;

    return data;
  }
}
