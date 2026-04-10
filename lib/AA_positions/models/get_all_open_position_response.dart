import '../../global/models/api_request_response.dart';

class GetAllOpenPositionsResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  List<Data>? data;

  GetAllOpenPositionsResponse({this.status, this.message, this.data});
  @override
  GetAllOpenPositionsResponse fromJson(Map<String, dynamic> json) {
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
  int? postnId;
  int postnTotalQuantity;
  String? postnTicker;
  int? postnUserId;
  String? postnPositionStatus;
  String? postnExchange;
  String? postnTradingMode;
  double postnCashAllocated;
  double postnAveragePurchasePrice;
  double postnCashLeft;
  int? postnAutomated;
  double postnCashGain;
  double postnRealizedProfit;
  double postnUnsoldStockCashGain;
  double postnCashNeeded;
  double postnExtraCashGenerated;
  int? postnNumberOfLadders;
  int? postnTickerId;
  String? createdAt;
  String? updatedAt;
  double currentPrice;
  bool? noFollowup = false;

  double? actualBrokerageCost = 0.0;
  double? otherBrokerageCharges = 0.0;

  Data({
    this.postnId,
    this.postnTotalQuantity = 0,
    this.postnTicker,
    this.postnUserId,
    this.postnPositionStatus,
    this.postnExchange,
    this.postnTradingMode,
    this.postnCashAllocated = 0.0,
    this.postnAveragePurchasePrice = 0.0,
    this.postnCashLeft = 0.0,
    this.postnAutomated,
    this.postnCashGain = 0.0,
    this.postnRealizedProfit = 0.0,
    this.postnUnsoldStockCashGain = 0.0,
    this.postnCashNeeded = 0.0,
    this.postnExtraCashGenerated = 0.0,
    this.postnNumberOfLadders,
    this.postnTickerId,
    this.createdAt,
    this.currentPrice = 0.0,
    this.updatedAt,
    this.noFollowup = false,
    this.actualBrokerageCost = 0.0,
    this.otherBrokerageCharges = 0.0,
  });
  @override
  Data fromJson(Map<String, dynamic> json) {
    postnId = json['postn_id'];
    postnTotalQuantity = json['postn_total_quantity'] ?? 0;
    postnTicker = json['postn_ticker'];
    postnUserId = json['postn_user_id'];
    postnPositionStatus = json['postn_position_status'];
    postnExchange = json['postn_exchange'];
    postnTradingMode = json['postn_trading_mode'];
    postnCashAllocated =
        double.tryParse(json['postn_cash_allocated'] ?? "0.0") ?? 0.0;
    postnAveragePurchasePrice =
        double.tryParse(json['postn_average_purchase_price'] ?? "0.0") ?? 0.0;
    postnCashLeft = double.tryParse(json['postn_cash_left'] ?? "0.0") ?? 0.0;
    postnUnsoldStockCashGain =
        double.tryParse(json['postn_unsold_stock_cash_gain'] ?? "0.0") ?? 0.0;
    postnAutomated = json['postn_automated'];
    postnCashGain = double.tryParse(json['postn_cash_gain'] ?? "0.0") ?? 0.0;
    postnRealizedProfit =
        double.tryParse(json['postn_realized_profit'] ?? "0.0") ?? 0.0;
    postnCashNeeded =
        double.tryParse(json['postn_cash_needed'] ?? "0.0") ?? 0.0;
    postnExtraCashGenerated =
        double.tryParse(json['postn_extra_cash_generated'] ?? "0.0") ?? 0.0;
    postnNumberOfLadders = json['postn_number_of_ladders'];
    postnTickerId = json['postn_ticker_id'];
    currentPrice = (json['current_price'] == null || json['current_price'] == "null")?0.0:double.tryParse(json['current_price'].toString()) ?? 0.0;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

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
    data['postn_id'] = this.postnId;
    data['postn_total_quantity'] = this.postnTotalQuantity;
    data['postn_ticker'] = this.postnTicker;
    data['postn_user_id'] = this.postnUserId;
    data['postn_position_status'] = this.postnPositionStatus;
    data['postn_exchange'] = this.postnExchange;
    data['postn_trading_mode'] = this.postnTradingMode;
    data['postn_cash_allocated'] = this.postnCashAllocated;
    data['postn_average_purchase_price'] = this.postnAveragePurchasePrice;
    data['postn_cash_left'] = this.postnCashLeft;
    data['postn_automated'] = this.postnAutomated;
    data['postn_cash_gain'] = this.postnCashGain;
    data['postn_realized_profit'] = this.postnRealizedProfit;
    data['postn_cash_needed'] = this.postnCashNeeded;
    data['postn_extra_cash_generated'] = this.postnExtraCashGenerated;
    data['postn_number_of_ladders'] = this.postnNumberOfLadders;
    data['postn_unsold_stock_cash_gain'] = this.postnUnsoldStockCashGain;
    data['postn_ticker_id'] = this.postnTickerId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['current_price'] = this.currentPrice;
    data['no_followup'] = this.noFollowup;

    data['actual_brokerage_cost'] = this.actualBrokerageCost;
    data['total_tax_cost'] = this.otherBrokerageCharges;
    return data;
  }
}
