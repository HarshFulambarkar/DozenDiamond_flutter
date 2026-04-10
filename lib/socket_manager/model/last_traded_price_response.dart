import 'package:dozen_diamond/global/models/api_request_response.dart';

class LastTradedPriceResponse implements ApiRequestResponse {
  String? subscriptionMode;
  String? exchangeType;
  String? token;
  String? sequenceNumber;
  String? exchangeTimestamp;
  String? lastTradedPrice;
  int? tickerId;

  LastTradedPriceResponse(
      {this.subscriptionMode,
      this.exchangeType,
      this.token,
      this.sequenceNumber,
      this.exchangeTimestamp,
      this.lastTradedPrice,
      this.tickerId});

  LastTradedPriceResponse fromJson(Map<String, dynamic> json) {
    subscriptionMode = json['subscription_mode'];
    exchangeType = json['exchange_type'];
    token = json['token'];
    sequenceNumber = json['sequence_number'];
    exchangeTimestamp = json['exchange_timestamp'];
    lastTradedPrice =
        (json['last_traded_price'] != null && json['last_traded_price'] != "")
            ? ((double.tryParse(json['last_traded_price']) ?? 100) / 100)
                .toStringAsFixed(2)
            : "0";
    tickerId = json['ticker_id'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscription_mode'] = this.subscriptionMode;
    data['exchange_type'] = this.exchangeType;
    data['token'] = this.token;
    data['sequence_number'] = this.sequenceNumber;
    data['exchange_timestamp'] = this.exchangeTimestamp;
    data['last_traded_price'] = this.lastTradedPrice;
    data['ticker_id'] = this.tickerId;
    return data;
  }
}
