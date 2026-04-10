import '../../global/models/api_request_response.dart';

class DeleteLadderRequest implements ApiRequestResponse {
  int? ladId;
  String? ladName;
  String? stockName;
  String? productType;
  double? minLimitPrice;
  int? timeInMin;

  DeleteLadderRequest({
    required this.ladId,
    this.productType,
    this.minLimitPrice,
    this.timeInMin
  });

  @override
  DeleteLadderRequest fromJson(Map<String, dynamic> json) {
    return DeleteLadderRequest(
      ladId: json['lad_id'],
      productType: json['productType'],
      minLimitPrice: json['minimumLimitPrice'],
      timeInMin: json['timeInMinutes']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lad_id'] = ladId;
    data['productType'] = this.productType;
    data['minimumLimitPrice'] = this.minLimitPrice;
    data['timeInMinutes'] = this.timeInMin;
    return data;
  }
}
