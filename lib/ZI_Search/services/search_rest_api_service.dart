import 'dart:convert';

import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:http/http.dart' as http;
import 'package:dozen_diamond/ZI_Search/services/search_rest_api_routes.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/add_stocks_to_selected_stock_list_response.dart';
import '../models/add_stocks_to_selected_stock_list_request.dart';
import '../models/delete_user_stocks_draft_request.dart';
import '../models/delete_user_stocks_draft_response.dart';
import '../models/get_bse_stock_name_by_sector_request.dart';
import '../models/get_searching_stocks_by_name_request.dart';
import '../models/get_searching_stocks_by_name_response.dart';
import '../models/sector_response.dart';
import '../models/get_stock_name_list_request.dart';
import '../models/get_stock_name_list_response.dart';
import '../models/reset_creation_stock_list_response.dart';
import '../models/selected_stock_list_request.dart';
import '../models/selected_stock_list_respone.dart';

class SearchRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  CurrencyConstants currencyConstants = CurrencyConstants();

  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;
  static const simpleBaseUrl = ApiConstant.simpleBaseUrl;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<AddStocksToSelectedStockListResponse?> addStockToSelectedStockList(
      AddStocksToSelectedStockListRequest
          addStocksToSelectedStockListRequest) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      var url = Uri.parse(
          // "$baseUrl_v2$userId${SearchRestApiRoutes.addStockToSelectedStockList}");
          "${baseUrl_v2}selected-stock/add");
      var payload = json.encode({
        "tickerId": addStocksToSelectedStockListRequest.tickerId,
      });
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
      );
      print(response.body);
      print(url);
      print(payload);
      print(json.decode(response.body)['message']);
      if (json.decode(response.body)['message'] != null) {
        print("in if");
      }

      if (httpStatusChecker(response)) {
        final apiResponse = json.decode(response.body);

        return AddStocksToSelectedStockListResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("below is snack bar");

      if (e is HttpApiException) {
        // Handle the HttpApiException
        print('Exception caught: ${e.errorTitle}');
      } else {
        // Handle other exceptions
        print('An unexpected error occurred: $e');
      }
      throw e;
    }
  }

  Future<SelectedStockListResponse?> getSelectedStockList(
      SelectedStockListRequest selectedStockListRequest) async {
    // var accessToken = await _generateToken;

    String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

    final userId = await _getUserID;
    var url = Uri.parse(
        // "$baseUrl_v2$userId${SearchRestApiRoutes.getSelectedStockList}");
        "${baseUrl_v2}selected-stock/fetch");
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      },
    );

    print(response.body);

    if (httpStatusChecker(response)) {
      dynamic apiResponse = json.decode(response.body);

      return SelectedStockListResponse.fromJson(apiResponse);
    } else {
      throw HttpApiException(errorCode: 404);
    }
    try {} catch (e) {
      throw e;
    }
  }

  Future<DeleteStockFromSelectedStockListResponse?>
      deleteStockFromSelectedStockList(
          DeleteStockFromSelectedStockListRequest
              deleteUserStocksDraftRequest) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      var url = Uri.parse(
          // "$baseUrl_v2$userId${SearchRestApiRoutes.deleteStockFromSelectedStockList}");
          "${baseUrl_v2}selected-stock/remove");
      var payload = json.encode({
        // "reg_id": deleteUserStocksDraftRequest.regId,
        "tickerId": deleteUserStocksDraftRequest.ticker,
        "forceDelete": deleteUserStocksDraftRequest.forceDelete
      });
      var response = await http.delete(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
      );
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        final apiResponse = json.decode(response.body);
        return DeleteStockFromSelectedStockListResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetSearchingStocksByNameResponse?> getSearchingStocksByName(
      GetSearchingStocksByNameRequest getSearchingStocksByNameRequest) async {
    try {
      var accessToken = await _generateToken;

      final String urlString =
          "$simpleBaseUrl${SearchRestApiRoutes.searchTicker}?ticker=${Uri.encodeQueryComponent(getSearchingStocksByNameRequest.stockName)}&pageNumber=${getSearchingStocksByNameRequest.pageNumber}&sector=${Uri.encodeQueryComponent(getSearchingStocksByNameRequest.sectorName)}&country=${currencyConstants.selectedCountry}";
      var url = Uri.parse(urlString);
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print(url);
      print(response.body);

      if (httpStatusChecker(response)) {
        return GetSearchingStocksByNameResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<GetStockNameListResponse>?> getStockNameList(
      GetStockNameListRequest getStockNameListRequest) async {
    try {
      var accessToken = await _generateToken;

      var url = Uri.parse("${baseUrl1}getbsestocksnamebysector/");
      var payload = json.encode({
        "sector": getStockNameListRequest.sector,
        "page_number": getStockNameListRequest.pageNumber,
      });
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );
      if (httpStatusChecker(response)) {
        final List<GetStockNameListResponse> sectorList = [];
        List apiResponse = json.decode(response.body);
        for (var i = 0; i < apiResponse.length; i++) {
          sectorList.add(GetStockNameListResponse(
            tickerExchange: apiResponse[i]["ticker_exchange"],
            tickerGroup: apiResponse[i]["ticker_group"],
            tickerId: apiResponse[i]["ticker_id"],
            tickerIssuerName: apiResponse[i]["ticker_issuer_name"],
            tickerSectorName: apiResponse[i]["ticker_sector_name"],
            ticker: apiResponse[i]["ticker"],
            tickerSecurityName: apiResponse[i]["ticker_security_name"],
            tickerSymbol: apiResponse[i]["ticker_symbol"],
          ));
        }
        return sectorList;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<SectorResponse> getSectorList() async {
    try {
      var accessToken = await _generateToken;

      var url = Uri.parse(
          "$simpleBaseUrl${SearchRestApiRoutes.getSectorWiseStockList}");
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );
      print("below is response");
      print(response.body);
      if (httpStatusChecker(response)) {
        return SectorResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("below is error");
      // print(e.toJson());
      throw e;
    }
  }

  Future<ResetCreationStockList> resetCreationStockList() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl$userId/ladder-creation-all-stock/reset");
      var response = await http.put(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return ResetCreationStockList.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetSearchingStocksByNameResponse?> getBseStockNameBySector(
      GetBseStockNameBySectorRequest getBseStockNameBySectorRequest) async {
    try {
      var accessToken = await _generateToken;

      var url = Uri.parse('$baseUrl1/getbsestocksnamebysector');
      var payload = json.encode(getBseStockNameBySectorRequest);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return GetSearchingStocksByNameResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
