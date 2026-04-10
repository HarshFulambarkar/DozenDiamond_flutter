import '../../global/models/api_request_response.dart';

class ClosePositionRequest implements ApiRequestResponse {
  int? postnId;
  String? productType;
  double? minLimitPrice;
  int? timeInMin;

  ClosePositionRequest({this.postnId, this.productType, this.minLimitPrice, this.timeInMin});

  @override
  ClosePositionRequest fromJson(Map<String, dynamic> json) {
    return ClosePositionRequest(
      postnId: json['postnId'],
      productType: json['productType'],
      minLimitPrice: json['minimumLimitPrice'],
      timeInMin: json['timeInMinutes']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postnId'] = this.postnId;
    data['productType'] = this.productType;
    data['minimumLimitPrice'] = this.minLimitPrice;
    data['timeInMinutes'] = this.timeInMin;
    return data;
  }
}
