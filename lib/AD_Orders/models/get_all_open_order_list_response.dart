import '../../global/models/api_request_response.dart';

class GetAllOpenOrderListResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  List<Data>? data;

  GetAllOpenOrderListResponse({this.status, this.message, this.data});
  @override
  GetAllOpenOrderListResponse fromJson(Map<String, dynamic> json) {
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
  String? orderLadName;
  int? orderId;
  String? orderType;
  String? orderStatus;
  int? orderUserId;
  int? orderPositionId;
  int? orderLadderId;
  int? orderAutomated;
  double orderOpenPrice;
  String? orderTradingMode;
  int orderUnits;
  int? orderClosedUnits;
  double orderCashGain;
  double orderExecutionPrice;
  double orderExtraCashGenerated;
  double orderRealizedProfit;
  String? orderExchange;
  int? orderTickerId;
  String? orderStockName;
  String? createdAt;
  double? currentPrice;
  String? updatedAt;
  bool? noFollowup = false;

  double? estimatedBrokerageCost = 0.0;
  double? estimatedTotalTax = 0.0;
  String? orderFollowUp = "";

  Data({
    this.orderLadName,
    this.orderId,
    this.orderType,
    this.orderStatus,
    this.orderUserId,
    this.orderPositionId,
    this.orderLadderId,
    this.orderAutomated,
    this.orderOpenPrice = 0.0,
    this.orderTradingMode,
    this.orderUnits = 0,
    this.orderClosedUnits,
    this.orderCashGain = 0.0,
    this.orderExecutionPrice = 0.0,
    this.orderExtraCashGenerated = 0.0,
    this.orderRealizedProfit = 0.0,
    this.orderExchange,
    this.orderTickerId,
    this.orderStockName,
    this.currentPrice,
    this.createdAt,
    this.updatedAt,
    this.noFollowup = false,
    this.estimatedBrokerageCost = 0.0,
    this.estimatedTotalTax = 0.0,
    this.orderFollowUp = "",
  });
  @override
  Data fromJson(Map<String, dynamic> json) {
    orderLadName = json['order_ladder_name'] ?? "N/A";
    orderId = json['order_id'];
    orderType = json['order_type'];
    orderStatus = json['order_status'];
    orderUserId = json['order_user_id'];
    orderPositionId = json['order_position_id'];
    orderLadderId = json['order_ladder_id'];
    orderAutomated = json['order_automated'];
    orderOpenPrice = double.tryParse(json['order_open_price'] ?? "0.0") ?? 0.0;
    orderTradingMode = json['order_trading_mode'];
    orderUnits = json['order_units'] ?? 0;
    orderClosedUnits = json['order_closed_units'];
    orderCashGain = double.tryParse(json['order_cash_gain'] ?? "0.0") ?? 0.0;
    orderExecutionPrice =
        double.tryParse(json['order_execution_price'] ?? "0.0") ?? 0.0;
    orderExtraCashGenerated =
        double.tryParse(json['order_extra_cash_generated'] ?? "0.0") ?? 0.0;
    orderRealizedProfit =
        double.tryParse(json['order_realized_profit'] ?? "0.0") ?? 0.0;
    orderExchange = json['order_exchange'];
    orderTickerId = json['order_ticker_id'];
    orderStockName = json['order_stock_name'];
    currentPrice = double.tryParse(json['current_price'] ?? "0.0") ?? 0.0;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderFollowUp = json['order_follow_up'];
    // noFollowup = json['no_followup'] ?? false;
    noFollowup = (json['order_follow_up'] == "NO_FOLLOW_UP") ? true : false;

    estimatedBrokerageCost = (json['estimated_brokerage_cost'] == null)
        ? 0.0
        : double.tryParse(json['estimated_brokerage_cost'].toString()) ?? 0.0;
    estimatedTotalTax = (json['estimated_total_tax_cost'] == null)
        ? 0.0
        : double.tryParse(json['estimated_total_tax_cost'].toString()) ?? 0.0;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_ladder_name'] = this.orderLadName;
    data['order_id'] = this.orderId;
    data['order_type'] = this.orderType;
    data['order_status'] = this.orderStatus;
    data['order_user_id'] = this.orderUserId;
    data['order_position_id'] = this.orderPositionId;
    data['order_ladder_id'] = this.orderLadderId;
    data['order_automated'] = this.orderAutomated;
    data['order_open_price'] = this.orderOpenPrice;
    data['order_trading_mode'] = this.orderTradingMode;
    data['order_units'] = this.orderUnits;
    data['order_closed_units'] = this.orderClosedUnits;
    data['order_cash_gain'] = this.orderCashGain;
    data['order_execution_price'] = this.orderExecutionPrice;
    data['order_extra_cash_generated'] = this.orderExtraCashGenerated;
    data['order_realized_profit'] = this.orderRealizedProfit;
    data['order_exchange'] = this.orderExchange;
    data['order_ticker_id'] = this.orderTickerId;
    data['order_stock_name'] = this.orderStockName;
    data['current_price'] = this.currentPrice;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['no_followup'] = this.noFollowup;

    data['estimated_brokerage_cost'] = this.estimatedBrokerageCost;
    data['estimated_total_tax_cost'] = this.estimatedTotalTax;
    return data;
  }
}

//intervention
