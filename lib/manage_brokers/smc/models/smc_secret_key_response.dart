class SmcSecretKeyResponse {
  bool? status;
  String? message;
  String? data;

  SmcSecretKeyResponse({this.status, this.message, this.data});

  SmcSecretKeyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}