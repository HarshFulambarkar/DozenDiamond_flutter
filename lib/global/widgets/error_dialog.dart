import 'dart:io';

import 'package:dozen_diamond/ZZZZ_main/mainFile/main.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../kyc/widgets/custom_bottom_sheets.dart';
import '../functions/error_message_bottom_sheet.dart';

enum ErrorAction { retry, closeApp, closeDialog }

class ApiStateProvider extends ChangeNotifier {
  int _apiCallRetry = 3;

  int get apiCallRetry => _apiCallRetry;

  void decrementApiRetry() {
    _apiCallRetry--;
  }

  void resetApiRetry() {
    _apiCallRetry = 3;
  }
}

Future<void> restApiErrorDialog(BuildContext context,
    {required HttpApiException error,
    Function? action,
    ErrorAction? errorAction,
    required ApiStateProvider apiState}) async {
  // Navigator.canPop(context);
  // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
  //     ErrorMessageBottomSheet(
  //       status: "400",
  //       errorTitle: error.errorTitle,
  //       errorDescription: error.errorSuggestion,
  //       request: DateFormat('hh:mm a dd-MM-yyyy').format(DateTime.now()).toString(),
  //     ),
  //     context,
  //     height: 300
  // );
  // await showDialog(
  //   barrierDismissible: false,
  //   context: context,
  //   builder: (context) {
  //     return AlertDialog(
  //       backgroundColor: Colors.transparent,
  //       content: Container(
  //         padding: const EdgeInsets.only(
  //           top: 20,
  //           bottom: 10,
  //           left: 20,
  //           right: 20,
  //         ),
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           color: Colors.black,
  //           borderRadius: BorderRadius.circular(20),
  //           border: Border.all(color: Colors.white),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               error.errorTitle,
  //               style: const TextStyle(color: Colors.white),
  //               textAlign: TextAlign.center,
  //             ),
  //             SizedBox(height: 5),
  //             Text(
  //               "${error.errorSuggestion} \n${DateFormat('hh:mm a dd-MM-yyyy').format(DateTime.now())}",
  //               style: const TextStyle(color: Colors.white),
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             actionWidget(
  //               context: context,
  //               errAction: errorAction,
  //               action: action,
  //               apiState: apiState,
  //               apiError: error,
  //             )
  //           ],
  //         ),
  //       ),
  //     );
  //   },
  // );
}

Widget actionWidget(
    {Function? action,
    ErrorAction? errAction,
    required HttpApiException apiError,
    required BuildContext context,
    required ApiStateProvider apiState}) {
  if (errAction == null) {
    switch (apiError.errorCode) {
      case 400:
        {
          return closeDialogBtn(context: context);
        }
      case 401:
        {
          return closeDialogBtn(context: context);
        }
      case 404:
        {
          return closeDialogBtn(context: context);
        }
      case 404:
        {
          return closeDialogBtn(context: context);
        }
      case 408:
        {
          if (apiState.apiCallRetry > 0) {
            return retryBtn(
                apiState: apiState, context: context, action: action);
          } else {
            return closeAppBtn();
          }
        }
      case 500:
        {
          return closeAppBtn();
        }

      case 502:
        {
          return closeAppBtn();
        }
      default:
        {
          return closeAppBtn();
        }
    }
  } else {
    switch (errAction) {
      case ErrorAction.closeDialog:
        {
          return closeDialogBtn(context: context);
        }
      case ErrorAction.closeApp:
        {
          return closeAppBtn();
        }
      case ErrorAction.retry:
        {
          if (apiState.apiCallRetry > 0) {
            return retryBtn(
                apiState: apiState, context: context, action: action);
          } else {
            return closeAppBtn();
          }
        }
      default:
        {
          return closeDialogBtn(context: context);
        }
    }
  }
}

Widget retryBtn({
  Function? action,
  required BuildContext context,
  required ApiStateProvider apiState,
}) {
  return Column(
    children: [
      Text(
        "( Retry attempt: ${apiState.apiCallRetry} )",
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(
        height: 5,
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();

          if (action != null) {
            action();
            apiState.decrementApiRetry();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Retry",
              style: TextStyle(color: Color(0xFF0099CC), fontSize: 18),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.replay,
              color: Color(0xFF0099CC),
            )
          ],
        ),
      ),
    ],
  );
}

Widget closeAppBtn() {
  return TextButton(
    onPressed: () {
      // if (kIsWeb) {
      //   import 'dart:html' as html;
      //   html.window.location.href = 'https://app.dozendiamonds.com';
      // } else
      if (Platform.isAndroid || Platform.isIOS) {
        exit(0); // Close the app on mobile platforms
      }
    },
    child: const Text(
      "Close app",
      style: TextStyle(color: Color(0xFF0099CC)),
    ),
  );
}

Widget closeDialogBtn({required BuildContext context}) {
  return TextButton(
    onPressed: () {
      Navigator.of(context).pop();
    },
    child: const Text(
      "Ok",
      style: TextStyle(color: Color(0xFF0099CC)),
    ),
  );
}
