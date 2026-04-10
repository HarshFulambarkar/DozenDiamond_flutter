import '../../global/models/api_request_response.dart';

class SelectedStockListRequest implements ApiRequestResponse {
  String? regId;

  SelectedStockListRequest({this.regId});

  @override
  SelectedStockListRequest fromJson(Map<String, dynamic> json) {
    regId = json['reg_id'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reg_id'] = regId;
    return data;
  }
}
