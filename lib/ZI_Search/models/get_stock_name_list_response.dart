import '../../global/models/api_request_response.dart';

class GetStockNameListResponse implements ApiRequestResponse {
  String? tickerIssuerName;
  String? ticker;
  String? tickerGroup;
  String? tickerExchange;
  String? tickerSymbol;
  int? tickerId;
  String? tickerSecurityName;
  String? tickerSectorName;

  GetStockNameListResponse({
    this.tickerIssuerName,
    this.ticker,
    this.tickerGroup,
    this.tickerId,
    this.tickerSymbol,
    this.tickerExchange,
    this.tickerSecurityName,
    this.tickerSectorName,
  });

  @override
  GetStockNameListResponse fromJson(Map<String, dynamic> json) {
    tickerIssuerName = json['ticker_issuer_name'];
    ticker = json['ticker_id'];
    tickerGroup = json['ticker_group'];
    tickerId = json['ticker_id'];
    tickerSymbol = json['ticker_symbol'];
    tickerExchange = json['ticker_exchange'];
    tickerSecurityName = json['ticker_security_name'];
    tickerSectorName = json['ticker_sector_name'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticker_issuer_name'] = tickerIssuerName;
    data['ticker_id'] = ticker;
    data['ticker_id'] = tickerId;
    data['ticker_group'] = tickerGroup;
    data['ticker_symbol'] = tickerSymbol;
    data['ticker_exchange'] = tickerExchange;
    data['ticker_security_name'] = tickerSecurityName;
    data['ticker_sector_name'] = tickerSectorName;
    return data;
  }
}
