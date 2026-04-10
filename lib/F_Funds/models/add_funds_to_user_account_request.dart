import '../../global/models/api_request_response.dart';

class AddFundsToUserAccountRequest implements ApiRequestResponse {
  String? amount;

  AddFundsToUserAccountRequest({this.amount});

  @override
  AddFundsToUserAccountRequest fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    return data;
  }
}
