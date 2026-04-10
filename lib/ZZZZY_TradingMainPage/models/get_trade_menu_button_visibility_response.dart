import 'package:dozen_diamond/global/models/api_request_response.dart';

class GetTradeMenuButtonVisibilityResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  Data? data;

  GetTradeMenuButtonVisibilityResponse(
      {this.status, this.message, this.success, this.data});

  GetTradeMenuButtonVisibilityResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Success implements ApiRequestResponse {
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});

  Success fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}

class Data implements ApiRequestResponse {
  IsAbleToSendCsv? isAbleToSendCsv;
  String? currentTradingStatus;
  bool? isStartTradingOn;
  bool? anyLadderActive;
  bool? anyLadderExists;

  Data(
      {this.isAbleToSendCsv,
      this.currentTradingStatus,
      this.isStartTradingOn,
      this.anyLadderActive,
      this.anyLadderExists});

  Data fromJson(Map<String, dynamic> json) {
    isAbleToSendCsv = json['isAbleToSendCsv'] != null
        ? new IsAbleToSendCsv().fromJson(json['isAbleToSendCsv'])
        : null;
    currentTradingStatus = json['currentTradingStatus'];
    isStartTradingOn = json['isStartTradingOn'];
    anyLadderActive = json['anyLadderActive'];
    anyLadderExists = json['anyLadderExists'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.isAbleToSendCsv != null) {
      data['isAbleToSendCsv'] = this.isAbleToSendCsv!.toJson();
    }
    data['currentTradingStatus'] = this.currentTradingStatus;
    data['isStartTradingOn'] = this.isStartTradingOn;
    data['anyLadderActive'] = this.anyLadderActive;
    data['anyLadderExists'] = this.anyLadderExists;
    return data;
  }
}

class IsAbleToSendCsv implements ApiRequestResponse {
  bool? position;
  bool? trade;
  bool? ladder;
  bool? openOrder;
  bool? activity;

  IsAbleToSendCsv(
      {this.position, this.trade, this.ladder, this.openOrder, this.activity});

  IsAbleToSendCsv fromJson(Map<String, dynamic> json) {
    position = json['position'];
    trade = json['trade'];
    ladder = json['ladder'];
    openOrder = json['open_order'];
    activity = json['activity'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.position;
    data['trade'] = this.trade;
    data['ladder'] = this.ladder;
    data['open_order'] = this.openOrder;
    data['activity'] = this.activity;
    return data;
  }
}
