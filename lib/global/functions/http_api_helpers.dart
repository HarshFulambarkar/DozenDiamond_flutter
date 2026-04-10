import 'dart:convert';

import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:get/get.dart' as getx;
import 'package:http/http.dart';
import '../../global/functions/utils.dart';
import '../../ZZZZ_main/mainFile/main.dart';
import '../widgets/custom_bottom_sheets.dart';
import 'error_message_bottom_sheet.dart';

bool httpStatusChecker(Response response) {
  //    400
  String fourHundredTitle = "Oops! Something went wrong.";
  String fourHundredSuggestion =
      "We encountered a problem processing your request. It seems there's an issue with the information you provided.";
  //    401
  String fourNotOneTitle = "The token provided is invalid or has expired.";
  String fourNotOneSuggestion =
      "Please provide a valid token with your request or login again to obtain a new token. Contact support if you continue to experience issues.";
  //    403
  String fourNotThreeTitle = "A token is required for authentication.";
  String fourNotThreeSuggestion =
      "Please provide a valid token with your request or login again to obtain a new token. Contact support if you continue to experience issues.";
  //    404
  String fourNotFourTitle = "We couldn't find what you're looking for.";
  String fourNotFourSuggestion =
      "The resource you're trying to access doesn't seem to exist.";
  //    408
  String fourNotEightTitle = "Oops! Your request took too long to process.";
  String fourNotEightSuggestion =
      "It seems your request exceeded the time limit.";
  //    500
  String fiveHundredTitle = "Something unexpected happened on our end.";
  String fiveHundredSuggestion =
      "We're experiencing technical difficulties that prevent us from fulfilling your request.";
  //    502
  String fiveNotTwoTitle =
      "Unable to process request:\n Our servers are currently unavailable.";
  String fiveNotTwoSuggestion = "Please try again later!";

  print("inside http_api_helpers");
  print(response.statusCode);
  print(response.body);
  print(response.request);
  try {
    switch (response.statusCode) {
      case 200:
        {
          return true;
        }
      case 201:
        {
          return true;
        }
      case 204:
        {
          return true;
        }
      case 400:
        {
          try {
            Map<String, dynamic> apiResponse = jsonDecode(response.body);
            String errTitle = fourHundredTitle;
            String errSuggestion = fourHundredSuggestion;
            if (apiResponse.containsKey('error')) {
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('description')) {
                errTitle = apiResponse['error']['description'];
              }
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('suggestion')) {
                errSuggestion = apiResponse['error']['suggestion'];
              }
            }

            print("inside 400 error code");

            if(response.request!.toString().contains("login") && response.body.toString().contains("User's email address is not verified.")) {

            } else {
              Utility().errorDialog(getx.Get.context ?? globalNavigatorKey.currentContext!, "400", errTitle, errSuggestion, response.request!.toString());

              // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
              //     ErrorMessageBottomSheet(
              //       status: "400",
              //       errorTitle: errTitle,
              //       errorDescription: errSuggestion,
              //       request: response.request?.toString(),
              //     ),
              //     getx.Get.context ?? globalNavigatorKey.currentContext!,
              //     height: 300
              // );
            }


            throw HttpApiException(
                errorCode: 400,
                errorTitle: errTitle,
                errorSuggestion: errSuggestion);
          } on HttpApiException catch (e) {
            throw e;
          } on FormatException {
            throw HttpApiException(errorCode: 400);
          }
        }
      case 401:
        {
          try {
            Map<String, dynamic> apiResponse = jsonDecode(response.body);
            String errTitle = fourNotOneTitle;
            String errSuggestion = fourNotOneSuggestion;
            if (apiResponse.containsKey('error')) {
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('description')) {
                errTitle = apiResponse['error']['description'];
              }
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('suggestion')) {
                errSuggestion = apiResponse['error']['suggestion'];
              }
            }

            if(response.request!.toString().contains("switch-trading-mode") && errTitle.toString().contains("Your session has expired. Please login again to continue.")) {
              Utility().showEnterBrokerOtpPopUp(getx.Get.context ?? globalNavigatorKey.currentContext!);
            } else {

              Utility().errorDialog(getx.Get.context ?? globalNavigatorKey.currentContext!, "400", errTitle, errSuggestion, response.request!.toString());

              // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
              //     ErrorMessageBottomSheet(
              //       status: "500",
              //       errorTitle: errTitle,
              //       errorDescription: errSuggestion,
              //       request: response.request?.toString(),
              //     ),
              //     getx.Get.context ?? globalNavigatorKey.currentContext!,
              //     height: 300
              // );
            }

            throw HttpApiException(
                errorCode: 401,
                errorTitle: errTitle,
                errorSuggestion: errSuggestion);
          } on HttpApiException catch (e) {
            throw e;
          } on FormatException {
            throw HttpApiException(errorCode: 401);
          }
        }
      case 403:
        {
          try {
            Map<String, dynamic> apiResponse = jsonDecode(response.body);
            String errTitle = fourNotThreeTitle;
            String errSuggestion = fourNotThreeSuggestion;
            if (apiResponse.containsKey('error')) {
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('description')) {
                errTitle = apiResponse['error']['description'];
              }
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('suggestion')) {
                errSuggestion = apiResponse['error']['suggestion'];
              }
            }

            Utility().errorDialog(getx.Get.context ?? globalNavigatorKey.currentContext!, "400", errTitle, errSuggestion, response.request!.toString());

            // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
            //     ErrorMessageBottomSheet(
            //       status: "403",
            //       errorTitle: errTitle,
            //       errorDescription: errSuggestion,
            //       request: response.request?.toString(),
            //     ),
            //     getx.Get.context ?? globalNavigatorKey.currentContext!,
            //     height: 300
            // );
            throw HttpApiException(
                errorCode: 403,
                errorTitle: errTitle,
                errorSuggestion: errSuggestion);
          } on HttpApiException catch (e) {
            throw e;
          } on FormatException {
            throw HttpApiException(errorCode: 403);
          }
        }

      case 404:
        {
          try {
            Map<String, dynamic> apiResponse = jsonDecode(response.body);
            String errTitle = fourNotFourTitle;
            String errSuggestion = fourNotFourSuggestion;
            if (apiResponse.containsKey('error')) {
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('description')) {
                errTitle = apiResponse['error']['description'];
              }
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('suggestion')) {
                errSuggestion = apiResponse['error']['suggestion'];
              }
            }

            if(response.request!.toString().contains("past-data-check") || response.request!.toString().contains("past-data")) {

            } else {

              Utility().errorDialog(getx.Get.context ?? globalNavigatorKey.currentContext!, "400", errTitle, errSuggestion, response.request!.toString());

              // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
              //     ErrorMessageBottomSheet(
              //       status: "404",
              //       errorTitle: errTitle,
              //       errorDescription: errSuggestion,
              //       request: response.request?.toString(),
              //     ),
              //     getx.Get.context ?? globalNavigatorKey.currentContext!,
              //     height: 300
              // );
            }

            throw HttpApiException(
                errorCode: 404,
                errorTitle: errTitle,
                errorSuggestion: errSuggestion);
          } on HttpApiException catch (e) {
            throw e;
          } on FormatException {
            throw HttpApiException(errorCode: 404);
          }
        }
      case 408:
        {
          try {
            Map<String, dynamic> apiResponse = jsonDecode(response.body);
            String errTitle = fourNotEightTitle;
            String errSuggestion = fourNotEightSuggestion;
            if (apiResponse.containsKey('error')) {
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('description')) {
                errTitle = apiResponse['error']['description'];
              }
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('suggestion')) {
                errSuggestion = apiResponse['error']['suggestion'];
              }
            }

            Utility().errorDialog(getx.Get.context ?? globalNavigatorKey.currentContext!, "400", errTitle, errSuggestion, response.request!.toString());

            // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
            //     ErrorMessageBottomSheet(
            //       status: "500",
            //       errorTitle: errTitle,
            //       errorDescription: errSuggestion,
            //       request: response.request?.toString(),
            //     ),
            //     getx.Get.context ?? globalNavigatorKey.currentContext!,
            //     height: 300
            // );
            throw HttpApiException(
                errorCode: 408,
                errorTitle: errTitle,
                errorSuggestion: errSuggestion);
          } on HttpApiException catch (e) {
            throw e;
          } on FormatException {
            throw HttpApiException(errorCode: 408);
          }
        }
      case 502:
        {

          Utility().errorDialog(getx.Get.context ?? globalNavigatorKey.currentContext!, "502", fiveNotTwoTitle, fiveNotTwoSuggestion, response.request!.toString());

          // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
          //     ErrorMessageBottomSheet(
          //       status: "502",
          //       errorTitle: fiveNotTwoTitle,
          //       errorDescription: fiveNotTwoSuggestion,
          //       request: response.request?.toString(),
          //     ),
          //     getx.Get.context ?? globalNavigatorKey.currentContext!,
          //     height: 300
          // );
          throw HttpApiException(
              errorCode: 502,
              errorTitle: fiveNotTwoTitle,
              errorSuggestion: fiveNotTwoSuggestion);
        }
      case 500:
        {
          print("inside case 500");
          try {
            Map<String, dynamic> apiResponse = jsonDecode(response.body);
            String errTitle = fiveHundredTitle;
            String errSuggestion = fiveHundredSuggestion;
            if (apiResponse.containsKey('error')) {
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('description')) {
                errTitle = apiResponse['error']['description'];
              }
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('suggestion')) {
                errSuggestion = apiResponse['error']['suggestion'];
              }
            }



            Utility().errorDialog(getx.Get.context ?? globalNavigatorKey.currentContext!, "500", errTitle, errSuggestion, response.request!.toString());

            // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
            //     ErrorMessageBottomSheet(
            //       status: "500",
            //       errorTitle: errTitle,
            //       errorDescription: errSuggestion,
            //       request: response.request?.toString(),
            //     ),
            //     getx.Get.context ?? globalNavigatorKey.currentContext!,
            //     height: 300
            // );
            throw HttpApiException(
                errorCode: 500,
                errorTitle: errTitle,
                errorSuggestion: errSuggestion);
          } on HttpApiException catch (e) {
            throw e;
          } on FormatException {
            throw HttpApiException(errorCode: 500);
          }
        }
      case 504:
        {
          print("inside case 500");
          try {
            Map<String, dynamic> apiResponse = jsonDecode(response.body);
            String errTitle = fiveHundredTitle;
            String errSuggestion = fiveHundredSuggestion;
            if (apiResponse.containsKey('error')) {
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('description')) {
                errTitle = apiResponse['error']['description'];
              }
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('suggestion')) {
                errSuggestion = apiResponse['error']['suggestion'];
              }
            }

            Utility().errorDialog(getx.Get.context ?? globalNavigatorKey.currentContext!, "504", errTitle, errSuggestion, response.request!.toString());

            // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
            //     ErrorMessageBottomSheet(
            //       status: "504",
            //       errorTitle: errTitle,
            //       errorDescription: errSuggestion,
            //       request: response.request?.toString(),
            //     ),
            //     getx.Get.context ?? globalNavigatorKey.currentContext!,
            //     height: 300
            // );
            throw HttpApiException(
                errorCode: 500,
                errorTitle: errTitle,
                errorSuggestion: errSuggestion);
          } on HttpApiException catch (e) {
            throw e;
          } on FormatException {
            throw HttpApiException(errorCode: 500);
          }
        }
      default:
        {
          try {
            Map<String, dynamic> apiResponse = jsonDecode(response.body);
            String errTitle = fiveHundredTitle;
            String errSuggestion = fiveHundredSuggestion;
            if (apiResponse.containsKey('error')) {
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('description')) {
                errTitle = apiResponse['error']['description'];
              }
              if ((apiResponse['error'] as Map<String, dynamic>)
                  .containsKey('suggestion')) {
                errSuggestion = apiResponse['error']['suggestion'];
              }
            }

            Utility().errorDialog(getx.Get.context ?? globalNavigatorKey.currentContext!, "500", errTitle, errSuggestion, response.request!.toString());

            // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
            //     ErrorMessageBottomSheet(
            //       status: "500",
            //       errorTitle: errTitle,
            //       errorDescription: errSuggestion,
            //       request: response.request?.toString(),
            //     ),
            //     getx.Get.context ?? globalNavigatorKey.currentContext! ?? globalNavigatorKey.currentContext!,
            //     height: 300
            // );
            throw HttpApiException(
                errorCode: 500,
                errorTitle: errTitle,
                errorSuggestion: errSuggestion);
          } on HttpApiException catch (e) {
            throw e;
          } on FormatException {
            throw HttpApiException(
                errorCode: 500,
                errorTitle: fiveHundredTitle,
                errorSuggestion: fiveHundredSuggestion +
                    "\n\nStatus code: ${response.statusCode}");
          }
        }
    }
  } on HttpApiException catch (e) {
    throw e;
  }
}
