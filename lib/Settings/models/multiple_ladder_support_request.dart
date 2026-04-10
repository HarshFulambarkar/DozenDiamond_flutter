import '../../global/models/api_request_response.dart';

class MultipleLadderSupportRequest implements ApiRequestResponse {
  bool? regMultipleLadderSupport;

  MultipleLadderSupportRequest({this.regMultipleLadderSupport});

  @override
  MultipleLadderSupportRequest fromJson(Map<String, dynamic> json) {
    regMultipleLadderSupport = json['reg_multiple_ladder_support'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reg_multiple_ladder_support'] = regMultipleLadderSupport;
    return data;
  }
}
