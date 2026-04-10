import 'package:dozen_diamond/global/models/api_request_response.dart';

class SimulateStockRequest implements ApiRequestResponse {
  int? tickerId;
  double? simulatePriceByStepSizeMultiple;

  SimulateStockRequest({this.tickerId, this.simulatePriceByStepSizeMultiple});

  @override
  SimulateStockRequest fromJson(Map<String, dynamic> json) {
    tickerId = json['tickerId'];
    simulatePriceByStepSizeMultiple = json['simulatePriceByStepSizeMultiple'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tickerId'] = tickerId;
    data['simulatePriceByStepSizeMultiple'] = simulatePriceByStepSizeMultiple;
    return data;
  }
}
