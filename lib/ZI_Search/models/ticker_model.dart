import '../../global/models/api_request_response.dart';

class TickerModel implements ApiRequestResponse {
  String tickerExchange;
  String tickerIssuerName;
  String ticker;
  int tickerId;
  bool isSelected;
  bool isAddedToWatchList;
  String wlId;

  TickerModel({
    this.tickerIssuerName = "",
    this.tickerId = 0,
    this.tickerExchange = "",
    this.ticker = "",
    this.isSelected = false,
    this.isAddedToWatchList = false,
    this.wlId = "",
  });

  @override
  TickerModel fromJson(Map<String, dynamic> json) {
    tickerId = json['ticker_id'];
    tickerExchange = json['ticker_exchange'];
    tickerIssuerName = json['ticker_issuer_name'];
    ticker = json['ticker'];

    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticker_id'] = tickerId;
    data['ticker_exchange'] = tickerExchange;
    data['ticker_issuer_name'] = tickerIssuerName;
    data['ticker'] = ticker;

    return data;
  }
}
