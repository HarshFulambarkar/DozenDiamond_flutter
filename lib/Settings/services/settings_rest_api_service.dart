import 'dart:convert';
import 'dart:io';
import 'package:dozen_diamond/Settings/models/get_trading_mode_status_response.dart';
import 'package:dozen_diamond/Settings/models/switching_trading_mode_request.dart';
import 'package:dozen_diamond/Settings/models/switching_trading_mode_response.dart';
import 'package:dozen_diamond/Settings/models/toggle_country_request.dart';
import 'package:dozen_diamond/Settings/models/toggle_country_response.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../global/constants/app_modules.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/shared_preferences_manager.dart';
import '../models/get_multiple_ladder_support_response.dart';
import '../models/multiple_ladder_support_request.dart';
import '../models/multiple_ladder_support_response.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';
import 'dart:io' as io; // for mobile
// import 'dart:html' as html; // for web

class SettingRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<MultipleLadderSupportResponse?> multipleLadderSupport(
      MultipleLadderSupportRequest multipleLadderSupportRequest) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl$userId/setting");
      var payload = json.encode(multipleLadderSupportRequest.toJson());
      var response = await http.put(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return MultipleLadderSupportResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetMultipleLadderSupportResponse?> getMultipleLadderSupport() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl$userId/setting");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return GetMultipleLadderSupportResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetTradingModeStatusResponse> getTradingModeStatus() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl$userId/settings/get-trading-mode-status");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return GetTradingModeStatusResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<SwitchingTradingModeResponse> switchingTradeMode(
      SwitchingTradingModeRequest switchingTradingModeRequest) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      // var url = Uri.parse("$baseUrl_v2$userId/settings/switch-trading-mode");
      var url = Uri.parse("${baseUrl_v2}settings/switch-trading-mode");
      var payload = json.encode(switchingTradingModeRequest.toJson());
      var response = await http.put(body: payload, url, headers: {
        'Content-Type': 'application/json',
        // ApiConstant.authorizationHeaderKeyName: accessToken
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      print(response.body);
      if (httpStatusChecker(response)) {
        return (SwitchingTradingModeResponse()
            .fromJson(jsonDecode(response.body)));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ToggleCountryResponse> toggleCountry(
      ToggleCountryRequest toggleCountryRequest) async {
    try {
      var accessToken = await _generateToken;

      var userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/toggle-country");
      var payload = json.encode(toggleCountryRequest.toJson());
      var response = await http.post(body: payload, url, headers: {
        'Content-Type': 'application/json',
        ApiConstant.authorizationHeaderKeyName: accessToken
      });
      if (httpStatusChecker(response)) {
        return (ToggleCountryResponse().fromJson(jsonDecode(response.body)));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<String> SendContactSupport(
      Map<String, dynamic> contactSupportRequest,
      dynamic imageFile,
      ) async {
    try {
      print("1");
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/contact-support");

      print("2");

      var request = http.MultipartRequest('POST', url);

      print("3");

      request.headers.addAll({
        'Authorization': "${ApiConstant.bearer} $userAccessToken",
      });

      print("4");
      print(imageFile);

      // Add image
      if (imageFile != null) {
        String fileName;
        String ext;
        MediaType contentType;

        if (kIsWeb) {
          var finalImage = imageFile as PlatformFile;

          final fileBytes = finalImage.bytes!;
          fileName = finalImage.name;
          ext = ".${finalImage.extension}".toLowerCase();
          switch (ext) {
            case '.png':
              contentType = MediaType('image', 'png');
              break;
            case '.jpg':
            case '.jpeg':
              contentType = MediaType('image', 'jpeg');
              break;
            case '.gif':
              contentType = MediaType('image', 'gif');
              break;
            default:
              contentType = MediaType('application', 'octet-stream');
          }

          request.files.add(
            http.MultipartFile.fromBytes(
              'bug_image',
              fileBytes,
              filename: fileName,
              contentType: contentType,
            ),
          );
        } else {
          final io.File mobileFile = imageFile;
          if (mobileFile.path != "") {
            fileName = p.basename(mobileFile.path);
            ext = p.extension(fileName).toLowerCase();

            switch (ext) {
              case '.png':
                contentType = MediaType('image', 'png');
                break;
              case '.jpg':
              case '.jpeg':
                contentType = MediaType('image', 'jpeg');
                break;
              case '.gif':
                contentType = MediaType('image', 'gif');
                break;
              default:
                contentType = MediaType('application', 'octet-stream');
            }

            request.files.add(
              await http.MultipartFile.fromPath(
                'bug_image',
                mobileFile.path,
                contentType: contentType,
              ),
            );
          }
        }

        // if(imageFile.path != ""){
        //
        //   String ext = p.extension(imageFile.path).toLowerCase();
        //   MediaType contentType;
        //
        //   switch (ext) {
        //     case '.png':
        //       contentType = MediaType('image', 'png');
        //       break;
        //     case '.jpg':
        //     case '.jpeg':
        //       contentType = MediaType('image', 'jpeg');
        //       break;
        //     case '.gif':
        //       contentType = MediaType('image', 'gif');
        //       break;
        //     default:
        //       contentType = MediaType('application', 'octet-stream');
        //   }
        //
        //   request.files.add(await http.MultipartFile.fromPath(
        //     'bug_image', // ✅ This key should match backend's expected key
        //     imageFile.path,
        //     contentType: contentType,
        //   ));
        // }
      }

      print("5");

      // Add text fields
      contactSupportRequest.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      print("before request send");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print(response.body);
      print(response.statusCode);

      if (httpStatusChecker(response)) {
        return response.statusCode == 200 ? "true" : response.body;
      } else {
        return "Something went wrong";
      }

      // // var accessToken = await _generateToken;
      // String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      //
      // var userId = await _getUserID;
      // var url = Uri.parse("$baseUrl_v2$userId/contact-support");
      // // var payload = json.encode(contactSupportRequest.toJson());
      // var payload = json.encode(contactSupportRequest);
      //
      // print("below is contact support api data");
      // print(url);
      // print(payload);
      //
      // var response = await http.post(body: payload, url, headers: {
      //   'Content-Type': 'application/json',
      //   // ApiConstant.authorizationHeaderKeyName: accessToken
      //   ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      // });
      //
      //
      // print(response.body);
      // print(response.statusCode);
      // if (httpStatusChecker(response)) {
      //   if(response.statusCode == 200) {
      //     return "true";
      //   } else {
      //     return response.body;
      //   }
      //   // return (SwitchingTradingModeResponse()
      //   //     .fromJson(jsonDecode(response.body)));
      // } else {
      //   // throw HttpApiException(errorCode: 404);
      //   return "Something went wrong";
      // }
    } catch (e) {
      // throw e;
      return "Something went wrong";
    }
  }
}
