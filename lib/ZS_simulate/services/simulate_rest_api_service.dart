import 'dart:convert';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';

import '../../global/constants/app_modules.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/shared_preferences_manager.dart';
import '../models/simulate_stock_reponse.dart';
import '../models/simulate_stock_request.dart';

class SimulateRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<SimulateStockReponse?> simulateStock(
      SimulateStockRequest simulateStockRequest) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/simulate-stock/price");
      var payload = json.encode(simulateStockRequest.toJson());
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return SimulateStockReponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
