

import '../../global/models/api_request_response.dart';

class DeleteStockFromSelectedStockListResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  // Data? data;

  DeleteStockFromSelectedStockListResponse(
      {this.status, this.message}); //, this.data});

  @override
  DeleteStockFromSelectedStockListResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.data != null) {
    //   data['data'] = this.data!.toJson();
    // }
    return data;
  }
}

class Data implements ApiRequestResponse {
  List<String>? ladders;
  bool? anyLadderActive;

  Data({this.ladders, this.anyLadderActive});

  @override
  Data fromJson(Map<String, dynamic> json) {
    ladders = json['Ladders'].cast<String>();
    anyLadderActive = json['anyLadderActive'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Ladders'] = this.ladders;
    data['anyLadderActive'] = this.anyLadderActive;
    return data;
  }
}
