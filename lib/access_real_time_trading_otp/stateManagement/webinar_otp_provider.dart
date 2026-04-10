import 'package:flutter/material.dart';

import '../models/webinar_otp_data_response.dart';
import '../services/webinar_otp_rest_api_service.dart';

class WebinarOtpProvider extends ChangeNotifier {
  WebinarOtpProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;


  TextEditingController webinarOtpTextEditingController = TextEditingController();

  bool _apiCalled = false;

  bool get apiCalled => _apiCalled;

  set apiCalled(bool value) {
    _apiCalled = value;
    notifyListeners();
  }

  WebinarOtpData _webinarOtpData = WebinarOtpData();

  WebinarOtpData get webinarOtpData => _webinarOtpData;

  set webinarOtpData(WebinarOtpData value) {
    _webinarOtpData = value;
    notifyListeners();
  }

  Future<bool> verifyWebinarOtp() async {

    print("inside verifyWebinarOtp");


    try {

      final userId = await WebinarOtpRestApiService().getUserID();

      Map<String, dynamic> request = {
        "otp": webinarOtpTextEditingController.text,
        "userId": userId
      };

      WebinarOtpDataResponse? res =
      await WebinarOtpRestApiService().verifyWebinarOtp(request);

      if(res.status!) {
        print("inside if");
        webinarOtpData = res.data ?? WebinarOtpData();

        print("after data save");
        apiCalled = false;
        return true;
      } else {
        apiCalled = false;
        return false;
      }
    } catch (e) {
      print("inside catch error");
      print(e);
      apiCalled = false;
      return false;
      throw e;
    }

  }
}