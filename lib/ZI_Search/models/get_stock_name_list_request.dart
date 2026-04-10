import '../../global/models/api_request_response.dart';

class GetStockNameListRequest implements ApiRequestResponse {
  String? sector;
  int? pageNumber;

  GetStockNameListRequest({this.sector, this.pageNumber});

  @override
  GetStockNameListRequest fromJson(Map<String, dynamic> json) {
    sector = json['sector'];
    pageNumber = json['page_number'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sector'] = sector;
    data['page_number'] = pageNumber;
    return data;
  }
}
