import 'dart:convert';

import 'package:dozen_diamond/manage_brokers/smc/models/smc_secret_key_response.dart';
import 'package:dozen_diamond/watchlist/models/add_to_watchlist_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../../../authentication/services/authentication_rest_api_service.dart';
import '../../../../global/constants/api_constants.dart';
import '../../../../global/constants/app_modules.dart';
import '../../../../global/functions/http_api_helpers.dart';
import '../../../../global/models/http_api_exception.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../models/remove_from_watch_list_data_response.dart';
import '../models/searched_stock_data_response.dart';
import '../models/watch_list_data_response.dart';

class WatchlistRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl_withoutUser = ApiConstant.baseUrl_withoutUser;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 0;
    return userId;
  }

  Future<WatchListDataResponse> fetchWatchList() async {

    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl_v2$userId/watchlist/fetch");
      // var url = Uri.parse("https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/723/watchlist/fetch");

      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return WatchListDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<RemoveFromWatchListDataResponse> removeFromWatchList(
      Map<String, dynamic>? requestBody) async {

    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl_v2$userId/watchlist/remove");
      // var url = Uri.parse("https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/723/watchlist/remove");
      var payload = json.encode(requestBody);
      var response = await http.delete(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return RemoveFromWatchListDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<AddToWatchlistResponse> addToWatchList(
      Map<String, dynamic>? requestBody) async {
    // String tempbaseUrl_v2 = "https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/";
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/watchlist/add");
      var url = Uri.parse("${baseUrl_v2}watchlist/add");
      // var url = Uri.parse("https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/959/watchlist/add");
      var payload = json.encode(requestBody);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return AddToWatchlistResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<SearchedStockDataResponse?> getSearchedStock(String stockName) async {
    try {
      var accessToken = await _generateToken;

      var url = Uri.parse("${baseUrl_withoutUser}watchlist-ticker/search?ticker=${stockName}&country=india");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print(url);
      print(response.body);

      if (httpStatusChecker(response)) {
        return SearchedStockDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

}