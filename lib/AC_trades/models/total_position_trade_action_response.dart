import '../../global/models/api_request_response.dart';

class TotalPositionTradeActionResponse implements ApiRequestResponse {
  Data? data;
  String? msg;
  bool? status;

  TotalPositionTradeActionResponse({this.data, this.msg, this.status});

  @override
  TotalPositionTradeActionResponse fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data().fromJson(json['data']) : null;
    msg = json['msg'];
    status = json['status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? totalUnit;
  int? curntPositionUnit;
  String? curntBalance;
  String? futureBalance;

  Data(
      {this.totalUnit,
      this.curntPositionUnit,
      this.curntBalance,
      this.futureBalance});

  @override
  Data fromJson(Map<String, dynamic> json) {
    totalUnit = json['total_unit'];
    curntPositionUnit = json['curnt_position_unit'];
    curntBalance = json['curnt_balance'];
    futureBalance = json['future_balance'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_unit'] = this.totalUnit;
    data['curnt_position_unit'] = this.curntPositionUnit;
    data['curnt_balance'] = this.curntBalance;
    data['future_balance'] = this.futureBalance;
    return data;
  }
}
