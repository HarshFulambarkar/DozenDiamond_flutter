import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dozen_diamond/navigateAuthentication/stateManagement/navigate_authentication_provider.dart';

import '../../ZG_signupEmail/models/verify_email_otp_request.dart';
import '../../global/functions/helper.dart';
import '../services/signup_email_rest_api_service.dart';

class VerifyEmailDialog extends StatefulWidget {
  const VerifyEmailDialog({super.key, required this.resendOtp});

  final Function resendOtp;

  @override
  State<VerifyEmailDialog> createState() => _VerifyEmailDialogState();
}

class _VerifyEmailDialogState extends State<VerifyEmailDialog> {
  final otpController = TextEditingController();

  late NavigateAuthenticationProvider navigateAuthenticationProvider;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyEmailOtp() async {
    // Navigator.of(context).pop();
    progressbar(context);
    print("before calling");
    try {
      final result = await SignupEmailRestApiService()
          .verifyEmailOtp(VerifyEmailOtpRequest(
        otp: otpController.text,
      ));
      Navigator.of(context).pop();
      if (result?.status == true) {
        SharedPreferences.getInstance().then((pref) {
          Navigator.of(context).pop();
          if (result?.data?.regMpin!.isEmpty ?? true) {
            pref.setString("reg_user", result?.data?.regUsername ?? "");
            pref.setInt("reg_id", result!.data!.regId!);
            navigateAuthenticationProvider.previousIndex =
                navigateAuthenticationProvider.selectedIndex;
            navigateAuthenticationProvider.regId = result!.data!.regId!;
            navigateAuthenticationProvider.selectedIndex = 6;
          } else {
            pref.setString("reg_user", result?.data?.regUsername ?? "");
            pref.setInt("reg_id", result!.data!.regId!);
            navigateAuthenticationProvider.previousIndex =
                navigateAuthenticationProvider.selectedIndex;
            navigateAuthenticationProvider.selectedIndex = 3;
          }
        });
      } else {
        showCustomAlertDialogFromHelper(context, result?.msg ?? "");
      }
    } catch (e) {
      print("inside view catch");

      Navigator.of(context).pop();
      otpController.clear();
      showCustomAlertDialogFromHelper(
          context, "The provided OTP is invalid or has expired.");
    }
  }

  @override
  Widget build(BuildContext context) {
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      actionsAlignment: MainAxisAlignment.start,
      backgroundColor: const Color(0xFF15181F),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Verify your email address"),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: PinCodeTextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              length: 6,
              obscureText: false,
              obscuringCharacter: "*",
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                fieldHeight: 40,
                fieldWidth: 30,
                shape: PinCodeFieldShape.box,
                activeColor: Colors.blue,
                activeFillColor: Colors.blue,
                disabledColor: Colors.white,
                errorBorderColor: Colors.white,
                inactiveColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedColor: Colors.white,
                selectedFillColor: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              animationDuration: const Duration(milliseconds: 300),
              controller: otpController,
              onCompleted: (v) async {
                // await _submitUserMpin();
              },
              onChanged: (value) {
                setState(() {
                  checkCondition();
                });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                return true;
              },
              appContext: context,
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.resendOtp();
              },
              child: Text(
                "Resend Otp",
                style: TextStyle(color: Colors.blue),
              )),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: const BorderSide(
                        color: Color(0xFF0099CC),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF0099CC)),
                    ),
                  ),
                ),
              ),
              if (checkCondition())
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF0099CC),
                            ),
                          ),
                          onPressed: () async {
                            await verifyEmailOtp();
                          },
                          child: const Text('Ok'))),
                ),
            ],
          )
        ],
      ),
    );
  }

  bool checkCondition() {
    if (otpController.text.isEmpty || otpController.text.length < 6) {
      return false;
    } else {
      return true;
    }
  }
}
