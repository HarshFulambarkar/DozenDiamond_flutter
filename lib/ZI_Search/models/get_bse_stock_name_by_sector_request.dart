

import '../../global/models/api_request_response.dart';

class GetBseStockNameBySectorRequest extends ApiRequestResponse {
  String? sector;
  int? pageNumber;
  String? stockName;

  GetBseStockNameBySectorRequest(
      {this.sector, this.pageNumber, this.stockName});

  @override
  GetBseStockNameBySectorRequest fromJson(Map<String, dynamic> json) {
    sector = json['sector'];
    pageNumber = json['page_number'];
    stockName = json['stock_name'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sector'] = this.sector;
    data['page_number'] = this.pageNumber;
    data['stock_name'] = this.stockName;
    return data;
  }
}
