class GetCustomerProfileResponse {
  Data? data;

  GetCustomerProfileResponse({this.data});

  GetCustomerProfileResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? status;
  String? message;
  String? errorcode;
  ProfileData? data;

  Data({this.status, this.message, this.errorcode, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errorcode = json['errorcode'];
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errorcode'] = this.errorcode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfileData {
  String? clientcode;
  String? name;
  String? email;
  String? mobileno;
  List<String>? exchanges;
  List<String>? products;
  String? lastlogintime;
  String? broker;

  ProfileData(
      {this.clientcode,
        this.name,
        this.email,
        this.mobileno,
        this.exchanges,
        this.products,
        this.lastlogintime,
        this.broker});

  ProfileData.fromJson(Map<String, dynamic> json) {
    clientcode = (json['clientcode'] != null && json['clientcode'] != "") ? json['clientcode'] : "Not Available";
    name = (json['name'] != null && json['name'] != "") ? json['name'] : "Not Available"; // json['name'];
    email = (json['email'] != null && json['email'] != "") ? json['email'] : "Not Available"; // json['email'];
    mobileno = (json['mobileno'] != null && json['mobileno'] != "") ? json['mobileno'] : "Not Available"; // json['mobileno'];
    exchanges = json['exchanges'].cast<String>();
    products = json['products'].cast<String>();
    lastlogintime = (json['lastlogintime'] != null && json['lastlogintime'] != "") ? json['lastlogintime'] : "Not Available"; // json['lastlogintime'];
    broker = (json['broker'] != null && json['broker'] != "") ? json['broker'] : "Not Available"; // json['broker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientcode'] = this.clientcode;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobileno'] = this.mobileno;
    data['exchanges'] = this.exchanges;
    data['products'] = this.products;
    data['lastlogintime'] = this.lastlogintime;
    data['broker'] = this.broker;
    return data;
  }
}