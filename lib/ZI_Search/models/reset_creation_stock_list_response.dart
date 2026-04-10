class ResetCreationStockList {
  String? msg;
  bool? status;
  Null data;

  ResetCreationStockList({this.msg, this.status, this.data});

  ResetCreationStockList.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}
