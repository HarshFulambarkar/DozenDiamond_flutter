import 'dart:convert';
import 'dart:io';
import 'package:dozen_diamond/AB_Ladder/constants/ladder_rest_api_service_dummy_data.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_request.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../models/create_ladder_request.dart';
import '../models/create_ladder_response.dart';
import '../models/delete_ladder_request.dart';
import 'package:dozen_diamond/AB_Ladder/models/get_ladder_response.dart';
import '../models/get_position_by_id_response.dart';
import '../models/toggle_laddder_activation_status_request.dart';
import '../models/toggle_laddder_activation_status_response.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_response.dart';
import '../models/update_ladder_request.dart';
import '../models/update_ladder_response.dart';
import '../models/user_ladder_download_csv_response.dart';

class LadderRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<String> deleteLadder(DeleteLadderRequest deleteLadderRequest) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/ladder/delete");
      // var url = Uri.parse("$baseUrl2$userId/ladder");
      var payload = json.encode(deleteLadderRequest.toJson());
      var response = await http.delete(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );
      if (httpStatusChecker(response)) {
        return "Ladder deleted successfully";
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UpdateLadderResponse?> updateLadder(
    UpdateLadderRequest updateLadderRequest, {
    bool activateLadder = false,
    bool deactivateLadder = false,
  }) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl2$userId/ladder");
      var payload = json.encode(updateLadderRequest.toJson());
      var response = await http.put(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );
      if (httpStatusChecker(response)) {
        return UpdateLadderResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<CreateLadderResponse?> createLadder(CreateLadderRequest createLadderRequest,
      {bool isOneClick = false}) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/ladder/create?is_oneclick=$isOneClick");
      var payload = json.encode(createLadderRequest.toJson());

      print("below is create ladder api");
      print(url);
      print(payload);
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );
      print("here is the payload of the rest api function $payload");
      print("respone of the createLadder rest api function ${response.body}");
      if (httpStatusChecker(response)) {
        return CreateLadderResponse().fromJson(jsonDecode(response.body));
      } else {
        print("here in else");
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
      throw HttpApiException(errorCode: 404, errorTitle: "Insufficient Cash");
      print("error in the createLadder rest api $e");
    }
  }

  Future<bool> userLadderExecutedOrderDownloadCsv(data) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl2$userId/ladder/csv");
      var url = Uri.parse("$baseUrl_v2$userId/order/downloadExecutedOrderCsv");

      var payload = jsonEncode(data);
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      if (httpStatusChecker(response)) {
        return true;
        // return UserLadderDownloadCsvResponse()
        //     .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> userLadderAllOrderDownloadCsv(data) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl2$userId/ladder/csv");
      var url = Uri.parse("$baseUrl_v2$userId/order/downloadAllOrderCsv");

      var payload = jsonEncode(data);
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      if (httpStatusChecker(response)) {
        return true;
        // return UserLadderDownloadCsvResponse()
        //     .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UserLadderDownloadCsvResponse?> userLadderDownloadCsv() async {
    try {
      // var accessToken = await _generateToken;

      final userId = await _getUserID;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      // var url = Uri.parse("$baseUrl2$userId/ladder/csv");
      var url = Uri.parse("$baseUrl_v2$userId/ladder/downloadCsv");
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      if (httpStatusChecker(response)) {
        return UserLadderDownloadCsvResponse().fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ToggleLadderActivationStatusResponse?> toggleLadderActivationStatus(
    ToggleLadderActivationStatusRequest toggleLadderActivationStatusRequest,
  ) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse(
        "$baseUrl_v2$userId/ladder-implementation/update-status",
      );
      var payload = json.encode(toggleLadderActivationStatusRequest.toJson());
      var response = await http.patch(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );
      print("below is /ladder-implementation/update-status");
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return ToggleLadderActivationStatusResponse().fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetLadderResponse?> getLadder(
    int? nextCursor,
    CurrencyConstants currencyConstantsProvider, {
    int? limit,
  }) async {
    try {
      // var accessToken = await _generateToken;
      print("nextCursor $nextCursor");
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      final userId = await _getUserID;

      final queryParams = <String, String>{};

      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      if (nextCursor != null) {
        queryParams['cursor'] = nextCursor.toString();
      }

      final url = Uri.parse(
        "$baseUrl_v2$userId/ladder-implementation/fetch",
      ).replace(queryParameters: queryParams);

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );
      print("getLadder here us the url $url");
      print(
        "getLadder here is the response of rest api function ${response.body}",
      );
      if (httpStatusChecker(response)) {
        print("GetLadderResponse().fromJson(jsonDecode(response.body))");
        return GetLadderResponse().fromJson(jsonDecode(response.body));
      } else {
        if (kDebugMode || kIsWeb) {
          return LadderRestApiServiceDummyData().getLadderDummyData(
            currencyConstantsProvider,
          );
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } catch (e) {
      print("error $e");
      if (kDebugMode || kIsWeb) {
        return LadderRestApiServiceDummyData().getLadderDummyData(
          currencyConstantsProvider,
        );
      } else {
        throw e;
      }
    }
  }

  Future<GetPositionByIdResponse> getPositionById(int ladderId) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl$userId/position/exist?lad_id=$ladderId");
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );
      if (httpStatusChecker(response)) {
        return GetPositionByIdResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<StockHistoricalDataResponse?> checkStockHistoricalData(
    StockHistoricalDataRequest stockData,
  ) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/past-data-check");
      var payload = json.encode(stockData.toJson());
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );
      print("below is historical data fetch response");
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return StockHistoricalDataResponse().fromJson(
          jsonDecode(response.body),
        );
      } else {
        print("in else part");

        throw HttpApiException(errorCode: 404);
      }
    } on HttpApiException catch (e) {
      print("Couldn't find the post 😱");

      throw e;
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return LadderRestApiServiceDummyData()
            .loadLadderRestApiServiceDummyData(
              stockName: stockData.symbolName!,
            );
      } else {
        throw e;
      }
    }
  }

  Future<StockHistoricalDataResponse?> getStockHistoricalData(
    StockHistoricalDataRequest stockData,
  ) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/past-data");
      var payload = json.encode(stockData.toJson());
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );
      print("below is historical data fetch response");
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return StockHistoricalDataResponse().fromJson(
          jsonDecode(response.body),
        );
      } else {
        print("in else part");
        if (kDebugMode || kIsWeb) {
          return LadderRestApiServiceDummyData()
              .loadLadderRestApiServiceDummyData(
                stockName: stockData.symbolName!,
              );
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } on HttpApiException catch (e) {
      print("Couldn't find the post 😱");

      if ((kDebugMode || kIsWeb) && e.errorCode != 404) {
        return LadderRestApiServiceDummyData()
            .loadLadderRestApiServiceDummyData(
              stockName: stockData.symbolName!,
            );
      } else {
        throw e;
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return LadderRestApiServiceDummyData()
            .loadLadderRestApiServiceDummyData(
              stockName: stockData.symbolName!,
            );
      } else {
        throw e;
      }
    }
  }


  Future<bool> restoreLadder(Map<String, dynamic> data) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl2$userId/ladder/csv");
      var url = Uri.parse("$baseUrl_v2$userId/ladder/restore-ladder");

      var payload = jsonEncode(data);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      if (httpStatusChecker(response)) {
        return true;
        // return UserLadderDownloadCsvResponse()
        //     .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> refreshLadder(Map<String, dynamic> data) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl2$userId/ladder/csv");
      var url = Uri.parse("$baseUrl_v2$userId/ladder/refresh-ladder");

      var payload = jsonEncode(data);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      if (httpStatusChecker(response)) {
        return true;
        // return UserLadderDownloadCsvResponse()
        //     .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> reconcileLadder(Map<String, dynamic> data) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl2$userId/ladder/csv");
      var url = Uri.parse("$baseUrl_v2$userId/ladder/reconcile-ladder");

      var payload = jsonEncode(data);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      if (httpStatusChecker(response)) {
        return true;
        // return UserLadderDownloadCsvResponse()
        //     .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
