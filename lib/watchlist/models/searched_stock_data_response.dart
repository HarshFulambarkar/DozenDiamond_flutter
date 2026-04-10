class SearchedStockDataResponse {
  bool? status;
  String? message;
  List<SearchedStockData>? data;

  SearchedStockDataResponse({this.status, this.message, this.data});

  SearchedStockDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SearchedStockData>[];
      json['data'].forEach((v) {
        data!.add(new SearchedStockData.fromJson(v));
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

class SearchedStockData {
  int? tickerId;
  String? tickerExchange;
  String? tickerIssuerName;
  String? ticker;
  String? tickerSectorName;
  String? tickerCountry;
  bool? isSelected = false;

  SearchedStockData(
      {this.tickerId,
        this.tickerExchange,
        this.tickerIssuerName,
        this.ticker,
        this.tickerSectorName,
        this.tickerCountry,
        this.isSelected = false,
      });

  SearchedStockData.fromJson(Map<String, dynamic> json) {
    tickerId = json['ticker_id'];
    tickerExchange = json['ticker_exchange'];
    tickerIssuerName = json['ticker_issuer_name'];
    ticker = json['ticker'];
    tickerSectorName = json['ticker_sector_name'];
    tickerCountry = json['ticker_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticker_id'] = this.tickerId;
    data['ticker_exchange'] = this.tickerExchange;
    data['ticker_issuer_name'] = this.tickerIssuerName;
    data['ticker'] = this.ticker;
    data['ticker_sector_name'] = this.tickerSectorName;
    data['ticker_country'] = this.tickerCountry;
    return data;
  }
}