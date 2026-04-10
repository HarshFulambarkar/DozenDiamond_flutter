class UserConfigData {
  int? userConfigurationId;
  int? regId;
  String? tradingMode;
  bool? isQuestionSolvedInRealTrade;
  int? brokerId;
  bool? webinarOtpVerified;
  bool? aadhaarCardVerified;
  bool? userSubscriptionVerified;
  String? subscriptionDate;
  bool? brokerExpired;
  bool? realTradingEnable;
  bool? phoneVerified;
  DateTime? planExpiryDateTime;
  String? createdAt;
  String? updatedAt;

  UserConfigData(
      {this.userConfigurationId,
        this.regId,
        this.tradingMode,
        this.isQuestionSolvedInRealTrade,
        this.brokerId,
        this.webinarOtpVerified,
        this.aadhaarCardVerified,
        this.userSubscriptionVerified,
        this.subscriptionDate,
        this.brokerExpired,
        this.realTradingEnable = true,
        this.phoneVerified = false,
        this.planExpiryDateTime,
        this.createdAt,
        this.updatedAt});

  UserConfigData.fromJson(Map<String, dynamic> json) {
    userConfigurationId = json['user_configuration_id'];
    regId = json['reg_id'];
    tradingMode = json['trading_mode'];
    isQuestionSolvedInRealTrade = (json['isQuestionSolvedInRealTrade'] == 1 || json['isQuestionSolvedInRealTrade'] == true) ? true : false;
    brokerId = json['broker_id'];
    webinarOtpVerified = (json['webinar_otp_verified'] == 1 || json['webinar_otp_verified'] == true) ? true : false;
    aadhaarCardVerified = (json['aadhaar_card_verified'] == 1 || json['aadhaar_card_verified'] == true) ? true : false;
    userSubscriptionVerified = (json['user_subscription_verified'] == 1 || json['user_subscription_verified'] == true) ? true : false;
    subscriptionDate = json['subscription_date'];
    brokerExpired = (json['broker_expired'] == 1 || json['broker_expired'] == true) ? true : false;
    realTradingEnable = (json['is_real_trading_enable'] == 1 || json['is_real_trading_enable'] == true) ? true : false;
    phoneVerified = (json['phone_number_verify'] == 1 || json['phone_number_verify'] == true) ? true : false;
    planExpiryDateTime = (json['plan_expiry_date_time'] == "null" || json['plan_expiry_date_time'] == "" || json['plan_expiry_date_time'] == null) ? null : DateTime.parse(json['plan_expiry_date_time']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_configuration_id'] = this.userConfigurationId;
    data['reg_id'] = this.regId;
    data['trading_mode'] = this.tradingMode;
    data['isQuestionSolvedInRealTrade'] = this.isQuestionSolvedInRealTrade;
    data['broker_id'] = this.brokerId;
    data['webinar_otp_verified'] = this.webinarOtpVerified;
    data['aadhaar_card_verified'] = this.aadhaarCardVerified;
    data['user_subscription_verified'] = this.userSubscriptionVerified;
    data['subscription_date'] = this.subscriptionDate;
    data['broker_expired'] = this.brokerExpired;
    data['is_real_trading_enable'] = this.realTradingEnable;
    data['phone_number_verify'] = this.phoneVerified;
    data['plan_expiry_date_time'] = this.planExpiryDateTime;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}