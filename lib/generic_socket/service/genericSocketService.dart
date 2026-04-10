import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dozen_diamond/generic_socket/models/genericSocketModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../global/constants/app_modules.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../global/functions/utils.dart';

class GenericRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const domainWs = ApiConstant.wsDomain;
  WebSocketChannel? _channel;

  Future<int> get _getUserID => authentication.getUserID();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Future<String> getPlatformUniqueId() async {
    if (kIsWeb) {
      // Web platform
      print("Running on Web");
      // Generate a unique identifier for web, such as a UUID or userAgent
      return "web-${DateTime.now().millisecondsSinceEpoch}";
    } else if (Platform.isAndroid) {
      // Android platform
      try {
        // var id = await AndroidId().getId(); // Unique Android ID
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print("below is id");
        print(androidInfo.id);

        return androidInfo.id; // Unique Android ID
      } catch (e) {
        print('Error fetching Android ID: $e');
        return "android-fallback-${DateTime.now().millisecondsSinceEpoch}";
      }
    } else if (Platform.isIOS) {
      // iOS platform
      try {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        if (iosInfo.identifierForVendor != null) {
          print('Running on iOS with ID: ${iosInfo.identifierForVendor}');
          return iosInfo.identifierForVendor!;
        } else {
          return "ios-fallback-${DateTime.now().millisecondsSinceEpoch}";
        }
      } catch (e) {
        print('Error fetching iOS ID: $e');
        return "ios-fallback-${DateTime.now().millisecondsSinceEpoch}";
      }
    } else {
      // Other platforms (macOS, Windows, Linux, etc.)
      return "unsupported-platform-${DateTime.now().millisecondsSinceEpoch}";
    }
  }

  // Future<bool> genericSocketRestService(String deviceId, BuildContext context) async {
  //   try {
  //     var userId = await _getUserID;
  //     var url =
  //         Uri.parse("$domainWs/generic?userId=$userId&deviceId=$deviceId");
  //
  //     print("here is the domain $url");
  //
  //     _channel = WebSocketChannel.connect(url);
  //     print("here is the channel $_channel");
  //
  //     final completer = Completer<bool>();
  //
  //     bool isPopupOpen = false;
  //
  //     _channel!.stream.listen(
  //       (event) {
  //         final decodedJson = jsonDecode(event) as Map<String, dynamic>;
  //         print("here is the event $event");
  //
  //         GenericSocketResponse genericSocketResponse =
  //             GenericSocketResponse().fromJson(decodedJson);
  //
  //         print(
  //             "here is the response from generic socket ${genericSocketResponse.isBlocked} and ${genericSocketResponse.toJson()}");
  //
  //         // Complete the future when we get a response
  //         if (!completer.isCompleted) {
  //           completer.complete(genericSocketResponse.isBlocked ?? false);
  //         }
  //
  //         if(genericSocketResponse.type == "CLOSE_POSITION"
  //         || genericSocketResponse.type == "DELETE_LADDER"
  //             || genericSocketResponse.type == "ADD_CASH"
  //             || genericSocketResponse.type == "WITHDRAW_CASH"
  //             || genericSocketResponse.type == "UPDATE_TARGET_PRICE") {
  //
  //           if(isPopupOpen == false) {
  //             isPopupOpen = true;
  //             Utility().minLimitPriceAndTimeInMinDialog(
  //                 context,
  //                 genericSocketResponse.type.toString(),
  //                 genericSocketResponse.orderId.toString(),
  //                 genericSocketResponse.orderMessage.toString()
  //             );
  //           }
  //
  //
  //         }
  //       },
  //       onError: (error) {
  //         print("WebSocket error: $error");
  //         if (!completer.isCompleted) {
  //           completer.complete(false);
  //
  //         }
  //         // genericSocketRestService(deviceId, context);
  //       },
  //       onDone: () {
  //         print("WebSocket connection closed.");
  //         if (!completer.isCompleted) {
  //           completer.complete(false);
  //         }
  //         genericSocketRestService(deviceId, context);
  //       },
  //     );
  //
  //     // Wait for the WebSocket response
  //     return completer.future;
  //   } catch (e) {
  //     print("Error in genericSocketRestService: $e");
  //     return false;
  //   }
  // }
}
