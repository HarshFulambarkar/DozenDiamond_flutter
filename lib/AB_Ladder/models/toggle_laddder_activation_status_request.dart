import '../../global/models/api_request_response.dart';

class ToggleLadderActivationStatusRequest implements ApiRequestResponse {
  int? ladId;
  String? ladStatus;
  bool? ladReinvestExtraCash;

  ToggleLadderActivationStatusRequest({
    this.ladId,
    this.ladStatus,
    this.ladReinvestExtraCash,
  });

  @override
  ToggleLadderActivationStatusRequest fromJson(Map<String, dynamic> json) {
    return ToggleLadderActivationStatusRequest(
      ladId: json['lad_id'],
      ladStatus: json['lad_status'],
      ladReinvestExtraCash: json['lad_reinvest_extra_cash'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lad_id'] = ladId;
    data['lad_status'] = ladStatus;
    data['lad_reinvest_extra_cash'] = ladReinvestExtraCash;
    return data;
  }
}
