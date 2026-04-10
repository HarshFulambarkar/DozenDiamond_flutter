

import '../../global/models/api_request_response.dart';

class DeleteStockFromSelectedStockListRequest implements ApiRequestResponse {
  String? regId;
  int? ticker;
  bool? forceDelete;

  DeleteStockFromSelectedStockListRequest(
      {this.regId, this.ticker, this.forceDelete});

  @override
  DeleteStockFromSelectedStockListRequest fromJson(Map<String, dynamic> json) {
    regId = json['reg_id'];
    ticker = json['ticker'];
    forceDelete = json['forceDelete'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reg_id'] = this.regId;
    data['ticker'] = this.ticker;
    data['forceDelete'] = this.forceDelete;
    return data;
  }
}
