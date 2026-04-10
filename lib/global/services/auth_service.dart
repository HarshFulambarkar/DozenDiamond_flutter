import 'package:flutter/services.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

import '../functions/error_message_bottom_sheet.dart';
import '../widgets/custom_bottom_sheets.dart';
import 'package:dozen_diamond/global/functions/utils.dart';

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  // final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<bool> isBiometricAvailable() async {
    return await _localAuth.canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _localAuth.getAvailableBiometrics();
  }

  Future<bool> authenticateWithBiometrics(BuildContext context) async {
    try {
      return await _localAuth
          .authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      )
          .then((onValue) {
        print("in isde authenticate with biometircs");
        print(onValue);
        print(_localAuth.hashCode);
        return onValue;
      });
    } on PlatformException catch (e) {
      print("iside catch block");
      print(e);
      if (e.code == 'LockedOut') {
        _showPopup(
          context,
          'Locked Out',
          'Too many failed attempts. Please wait 30 seconds before trying again.',
        );
      } else if (e.code == 'NotAvailable') {
        _showPopup(
          context,
          'Biometric Not Available',
          'Biometric authentication is not available on this device.',
        );
      } else {
        _showPopup(context, 'Error', 'An unknown error occurred: ${e.message}');
      }
      return false;
    }
  }

  void _showPopup(BuildContext context, String title, String message) {

    Utility().errorDialog(context, "400", title, message, "");

    // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
    //     ErrorMessageBottomSheet(
    //       status: "400",
    //       errorTitle: title,
    //       errorDescription: message,
    //       request: "",
    //     ),
    //     context,
    //     height: 300
    // );

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text(title),
    //     content: Text(message),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
  }
}
