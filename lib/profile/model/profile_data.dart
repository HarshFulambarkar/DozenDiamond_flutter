// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileData {
  int? regId;
  String? regEmail;
  String? regUsername;
  String? regMobile;
  String? regUserCity;
  String? regUserState;
  String? regCountry;
  String? broker;
  String? subscription;
  String? nameAsPerBroker;
  String? regDateTime;
  String? brokerName;
  String? clientCode;
  bool? emailVerified;
  bool? phoneVerified;
  bool? isMpinGenerated;

  ProfileData({
    this.regId,
    this.regEmail,
    this.regUsername,
    this.regMobile,
    this.regUserCity,
    this.regUserState,
    this.regCountry,
    this.broker,
    this.subscription,
    this.nameAsPerBroker,
    this.regDateTime,
    this.brokerName,
    this.clientCode,
    this.emailVerified,
    this.phoneVerified,
    this.isMpinGenerated,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    regId = json['reg_id'];
    regEmail = json['reg_email'];
    regUsername = json['reg_username'];
    regMobile = json['reg_mobile'];
    regUserCity = json['city'];
    regUserState = json['state'];
    regCountry = json['reg_country'];
    subscription = json['subscription'];
    nameAsPerBroker = json['name_as_per_broker'];
    broker = json['broker'];
    regDateTime = json['reg_datetime'] ?? DateTime.now().toString();
    brokerName = json['broker_name'];
    clientCode = json['client_code'];
    emailVerified = (json['email_verified'] == null)
        ? true
        : (json['email_verified'].toString() == 'false')
        ? false
        : true;
    phoneVerified = (json['phone_verified'] == null)
        ? true
        : (json['phone_verified'].toString() == 'false')
        ? false
        : true;
    isMpinGenerated = (json['mpin_exist'] == null)
        ? true
        : (json['mpin_exist'].toString() == 'false')
        ? false
        : true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reg_id'] = this.regId;
    data['reg_email'] = this.regEmail;
    data['reg_username'] = this.regUsername;
    data['reg_mobile'] = this.regMobile;
    data['city'] = this.regUserCity;
    data['state'] = this.regUserState;
    data['reg_country'] = this.regCountry;
    data['broker'] = this.broker;
    data['subscription'] = this.subscription;
    data['name_as_per_broker'] = this.nameAsPerBroker;
    data['reg_datetime'] = this.regDateTime;
    data['broker_name'] = this.brokerName;
    data['client_code'] = this.clientCode;
    data['email_verified'] = this.emailVerified;
    data['phone_verified'] = this.phoneVerified;
    data['mpin_exist'] = this.isMpinGenerated;
    return data;
  }

  @override
  String toString() {
    return 'ProfileData(regId: $regId, regEmail: $regEmail, regUsername: $regUsername, regMobile: $regMobile, regUserCity: $regUserCity, regUserState: $regUserState, regCountry: $regCountry, subscription: $subscription, broker: $broker, regDateTime: $regDateTime, brokerName: $brokerName, clientCode: $clientCode, emailVerified: $emailVerified, phoneVerified: $phoneVerified, isMpinGenerated: $isMpinGenerated, nameAsPerBroker: $nameAsPerBroker)';
  }
}