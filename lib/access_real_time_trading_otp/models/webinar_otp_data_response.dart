import '../../global/models/api_request_response.dart';

class WebinarOtpDataResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  WebinarOtpData? data;

  WebinarOtpDataResponse({this.status, this.message, this.data});
  @override
  WebinarOtpDataResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new WebinarOtpData().fromJson(json['data'])
        : null;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WebinarOtpData implements ApiRequestResponse {
  String? oTP;
  String? acronym;
  int? verifiedFor;
  bool? isQuestionaireSolved;

  WebinarOtpData({this.oTP, this.acronym, this.verifiedFor, this.isQuestionaireSolved});

  @override
  WebinarOtpData fromJson(Map<String, dynamic> json) {
    oTP = json['OTP'];
    acronym = json['acronym'];
    verifiedFor = json['verifiedFor'];
    isQuestionaireSolved = json['isQuestionaireSolved'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OTP'] = this.oTP;
    data['acronym'] = this.acronym;
    data['verifiedFor'] = this.verifiedFor;
    data['isQuestionaireSolved'] = this.isQuestionaireSolved;
    return data;
  }
}