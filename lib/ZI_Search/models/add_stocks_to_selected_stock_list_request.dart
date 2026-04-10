

import '../../global/models/api_request_response.dart';

class AddStocksToSelectedStockListRequest implements ApiRequestResponse {
  int tickerId;

  AddStocksToSelectedStockListRequest({required this.tickerId});

  @override
  AddStocksToSelectedStockListRequest fromJson(Map<String, dynamic> json) {
    tickerId = json['ticker_id'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tickerId'] = tickerId;
    return data;
  }
}
