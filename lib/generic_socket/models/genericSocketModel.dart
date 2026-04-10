import 'package:dozen_diamond/global/models/api_request_response.dart';

class GenericSocketResponse implements ApiRequestResponse {
  bool? isBlocked;
  List<String>? message;
  bool? showAnotherLoginButton;
  String? iconBase64;
  String? orderMessage;
  int? orderId;
  String? type;

  GenericSocketResponse(
      {this.isBlocked,
      this.message,
      this.showAnotherLoginButton,
      this.iconBase64,
        this.orderMessage,
        this.orderId,
        this.type,
      });

  GenericSocketResponse fromJson(Map<String, dynamic> json) {
    isBlocked = json['isBlocked'];
    // message = json['message'].cast<String>();
    showAnotherLoginButton = json['show_another_login_button'];
    iconBase64 = json['icon_base_64'];
    orderMessage = json['orderMessage'];
    orderId = json['orderId'];
    type = json['type'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isBlocked'] = this.isBlocked;
    data['message'] = this.message;
    data['show_another_login_button'] = this.showAnotherLoginButton;
    data['icon_base_64'] = this.iconBase64;
    data['orderMessage'] = this.orderMessage;
    data['orderId'] = this.orderId;
    data['type'] = this.type;
    return data;
  }
}
