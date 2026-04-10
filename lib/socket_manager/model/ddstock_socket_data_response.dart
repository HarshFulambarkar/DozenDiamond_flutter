import 'package:dozen_diamond/global/models/api_request_response.dart';

extension DdStockSocketDataResponseExt on DdStockSocketDataResponse {
  void updatePrices(DdStockSocketDataResponse newData) {
    if (ddStock == null || newData.ddStock == null) return;

    for (var newItem in newData.ddStock!) {
      final index = ddStock!.indexWhere((e) => e.tickerId == newItem.tickerId);

      if (index != -1) {
        ddStock![index].tickerPrice = newItem.tickerPrice;
        ddStock![index].upDownPrice = newItem.upDownPrice;
        ddStock![index].upDownPercentage = newItem.upDownPercentage;
        ddStock![index].updatedAt = newItem.updatedAt;
      }
    }
  }
}

class DdStockSocketDataResponse implements ApiRequestResponse {
  List<DdStock>? ddStock;

  DdStockSocketDataResponse({this.ddStock});

  DdStockSocketDataResponse fromJson(Map<String, dynamic> json) {
    if (json['ddStock'] != null) {
      ddStock = <DdStock>[];
      json['ddStock'].forEach((v) {
        ddStock!.add(new DdStock().fromJson(v));
      });
    }
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ddStock != null) {
      data['ddStock'] = this.ddStock!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



class DdStock implements ApiRequestResponse {
  String? updatedAt;
  // String? createdAt;
  // int? ddStockId;
  int? tickerId;
  String? tickerName;
  String? tickerPrice;
  String? tickerExchange;
  String? issuerName;
  bool? isPositive = true;
  String? previousClose;
  String? upDownPrice = "0";
  String? upDownPercentage = "0";
  bool? isPriceUp = true;
  String? ticker;
  DdStock(
      {this.updatedAt,
        // this.createdAt,
        // this.ddStockId,
        this.tickerId,   this.ticker,
        this.tickerName,
        this.tickerPrice,
        this.tickerExchange,
        this.issuerName,
        this.isPositive = true,
        this.previousClose,
        this.upDownPrice,
        this.upDownPercentage,
        this.isPriceUp = true,
      });

  DdStock fromJson(Map<String, dynamic> json) {
    // createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // ddStockId = json['dd_stock_id'];
    ticker = json['ticker_name']; // json['ticker'];
    tickerId = json['ticker_id'];
    tickerName = json['ticker_name'];
    tickerPrice = json['ticker_price'];
    tickerExchange = json['ticker_exchange'];
    issuerName = json['ticker_issuer_name'];
    previousClose = (json['previous_close'] != null) ? json['previous_close'].toString() : 'null';
    upDownPrice = (json['previous_close'] != null) ? (double.parse(json['ticker_price'].toString()) - double.parse(json['previous_close'].toString())).toStringAsFixed(2) : '0';
    isPositive = (double.parse(upDownPrice ?? '0.0') > 0) ? true : false;
    upDownPercentage = (json['previous_close'] != null) ? (json['previous_close'] == 0) ? "0" :(((double.parse(json['ticker_price'].toString()) - double.parse(json['previous_close'].toString())) / double.parse(json['previous_close'].toString())) * 100).toStringAsFixed(2) : '0';
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['ticker'] = this.ticker;
    // data['dd_stock_id'] = this.ddStockId;
    data['ticker_id'] = this.tickerId;
    data['ticker_name'] = this.tickerName;
    data['ticker_price'] = this.tickerPrice;
    data['ticker_exchange'] = this.tickerExchange;
    data['ticker_issuer_name'] = this.issuerName;
    return data;
  }
}