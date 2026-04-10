import 'package:dozen_diamond/ZI_Search/models/ticker_model.dart';

import '../../global/models/api_request_response.dart';

class GetSearchingStocksByNameResponse implements ApiRequestResponse {
  List<TickerModel>? data;
  String? msg;
  bool? status;

  GetSearchingStocksByNameResponse({this.data, this.msg, this.status});

  @override
  GetSearchingStocksByNameResponse fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TickerModel>[];
      json['data'].forEach((v) {
        data!.add(TickerModel().fromJson(v));
      });
    }
    msg = json['msg'];
    status = json['status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    data['status'] = status;
    return data;
  }
}
