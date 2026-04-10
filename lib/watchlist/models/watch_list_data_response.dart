class WatchListDataResponse {
  bool? status;
  String? message;
  List<WatchlistData>? data;

  WatchListDataResponse({this.status, this.message, this.data});

  WatchListDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WatchlistData>[];
      json['data'].forEach((v) {
        data!.add(new WatchlistData.fromJson(v));
      });
    }
  }

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

class WatchlistData {
  int? wlTickerId;
  int? wlId;
  int? wlSecurityCode;
  String? tickerPrice;
  String? wlTicker;
  String? wlExchange;
  String? wlIsinNo;
  String? wlLtpProvidedByBroker;
  String? issuerName;
  String? change;
  bool? isPositive = true;
  String? wlSimulatedPrice;
  String? tradingMode;
  String? previousClose;
  String? upDownPrice = "0";
  String? upDownPercentage = "0";

  WatchlistData({
    this.wlTickerId,
    this.wlId,
    this.tickerPrice,
    this.wlSecurityCode,
    this.wlTicker,
    this.wlExchange,
    this.wlIsinNo,
    this.wlLtpProvidedByBroker,
    this.issuerName,
    this.change,
    this.isPositive = true,
    this.wlSimulatedPrice,
    this.tradingMode,
    this.previousClose,
    this.upDownPrice,
    this.upDownPercentage,
  });

  WatchlistData.fromJson(Map<String, dynamic> json) {
    tickerPrice = json['ticker_price'];
    wlTickerId = json['wl_ticker_id'];
    wlId = json['wl_id'];
    wlSecurityCode = json['wl_security_code'];
    wlTicker = json['wl_ticker'];
    wlExchange = json['exchange'];
    wlIsinNo = json['wl_isin_no'];
    wlLtpProvidedByBroker = json['wl_ltp_provided_by_broker'];
    issuerName = json['issuer_name'];
    change = json['change'];
    
    wlSimulatedPrice = json['wl_simulated_price'];
    tradingMode = json['tradingMode'];
    previousClose = json['previous_close'];
    isPositive = true;
    // upDownPrice = (json['previous_close'] != null) ? (double.parse(json['previous_close'].toString()) - double.parse(json['ticker_price'].toString())).toStringAsFixed(2) : '0';
    // isPositive = (double.parse(upDownPrice ?? '0') > 0) ? true : false;
    // upDownPercentage = (((double.parse(tickerPrice ?? "0") - double.parse(previousClose ?? "0")) / double.parse(previousClose ?? "0")) / 100).toStringAsFixed(2);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticker_price'] = this.tickerPrice;
    data['wl_ticker_id'] = this.wlTickerId;
    data['wl_id'] = this.wlId;
    data['wl_security_code'] = this.wlSecurityCode;
    data['wl_ticker'] = this.wlTicker;
    data['exchange'] = this.wlExchange;
    data['wl_isin_no'] = this.wlIsinNo;
    data['wl_ltp_provided_by_broker'] = this.wlLtpProvidedByBroker;
    data['issuer_name'] = this.issuerName;
    data['change'] = this.change;
    data['is_positive'] = this.isPositive;
    data['wl_simulated_price'] = this.wlSimulatedPrice;
    data['tradingMode'] = this.tradingMode;
    data['previous_close'] = this.previousClose;
    return data;
  }
}
