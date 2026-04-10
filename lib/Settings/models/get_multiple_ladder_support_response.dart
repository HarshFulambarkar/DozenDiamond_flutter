import '../../global/models/api_request_response.dart';

class GetMultipleLadderSupportResponse implements ApiRequestResponse {
  Data? data;
  bool? status;
  String? msg;

  GetMultipleLadderSupportResponse({this.data, this.status, this.msg});

  @override
  GetMultipleLadderSupportResponse fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data().fromJson(json['data']) : null;
    status = json['status'];
    msg = json['msg'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    data['msg'] = msg;
    return data;
  }
}

class Data implements ApiRequestResponse {
  bool? regMultipleLadderSupport;

  Data({this.regMultipleLadderSupport});

  @override
  Data fromJson(Map<String, dynamic> json) {
    regMultipleLadderSupport = json['reg_multiple_ladder_support'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reg_multiple_ladder_support'] = regMultipleLadderSupport;
    return data;
  }
}
