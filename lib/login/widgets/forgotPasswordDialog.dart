import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:dozen_diamond/navigateAuthentication/stateManagement/navigate_authentication_provider.dart';

import '../../global/functions/helper.dart';

import '../../global/models/http_api_exception.dart';
import '../../login/models/reset_password_link_request.dart';
import '../services/login_rest_api_service.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late NavigateAuthenticationProvider navigateAuthenticationProvider;

  bool _isObscure = true;
  bool _isObscure2 = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    try {
      progressbar(context);
      final result = await LoginRestApiService()
          .resetPasswordLink(ResetPasswordLinkRequest(
        newpassword: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        otp: otpController.text,
      ));

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      navigateAuthenticationProvider.selectedIndex =
          navigateAuthenticationProvider.previousIndex;
      // Navigator.of(context).pop();
      await showCustomAlertDialogFromHelper(context, result?.message ?? "");
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  Widget formFieldMaker({
    String? Function(String?)? validator,
    String? label,
    required bool isHidden,
    required void Function()? onPressed,
    required TextEditingController controllerName,
    required IconData iconName,
    required Widget icon,
    required String validatorName,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    AutovalidateMode? autovalidateMode,
    String? hintText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        onChanged: onChanged,
        autofocus: false,
        obscureText: isHidden,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: controllerName,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          suffixIconColor: Colors.white,
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: icon,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(17),
            child: Icon(iconName, color: Colors.white),
          ),
          focusColor: Colors.white,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        validator: validator,
      ),
    );
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
          const Text("Enter OTP"),
          Container(
            margin: const EdgeInsets.only(top: 20),
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
                return true;
              },
              appContext: context,
            ),
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                formFieldMaker(
                  onChanged: (p0) {
                    setState(() {
                      checkCondition();
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onPressed: () {
                    setState(
                      () {
                        _isObscure = !_isObscure;
                      },
                    );
                  },
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  label: 'Password',
                  hintText: "Enter your password",
                  keyboardType: TextInputType.text,
                  validator: (value3) {
                    if (value3!.isEmpty) {
                      return "* Required";
                    } else if (value3.length < 6) {
                      return "Password should be atleast 6 characters";
                    } else if (!RegExp(r'[A-Z]').hasMatch(value3)) {
                      return "Password should contain at least one upper case letter.";
                    } else if (!RegExp(r'[a-z]').hasMatch(value3)) {
                      return "Password should contain at least one lower case letter.";
                    } else if (!RegExp(r'\d').hasMatch(value3)) {
                      return "Password should contain at least one digit character.";
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                        .hasMatch(value3)) {
                      return "Password should contain at least one special character.";
                    } else {
                      return null;
                    }
                  },
                  isHidden: _isObscure,
                  controllerName: passwordController,
                  iconName: Icons.lock_outline,
                  validatorName: 'password',
                ),
                formFieldMaker(
                  onChanged: (p0) {
                    setState(() {
                      checkCondition();
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onPressed: () {
                    setState(
                      () {
                        _isObscure2 = !_isObscure2;
                      },
                    );
                  },
                  icon: Icon(
                    _isObscure2 ? Icons.visibility : Icons.visibility_off,
                  ),
                  label: 'Confirm Password',
                  hintText: "Enter your password",
                  isHidden: _isObscure2,
                  keyboardType: TextInputType.text,
                  validator: (value4) {
                    if (value4!.isEmpty) {
                      return "* Required";
                    } else if (value4.length < 6) {
                      return "Confirm Password should be atleast 6 characters";
                    } else if (!RegExp(r'[A-Z]').hasMatch(value4)) {
                      return "Password should contain at least one upper case letter.";
                    } else if (!RegExp(r'[a-z]').hasMatch(value4)) {
                      return "Password should contain at least one lower case letter.";
                    } else if (!RegExp(r'\d').hasMatch(value4)) {
                      return "Password should contain at least one digit character.";
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                        .hasMatch(value4)) {
                      return "Password should contain at least one special character.";
                    } else if (confirmPasswordController.text !=
                        passwordController.text) {
                      return "Password Missmatch";
                    } else {
                      return null;
                    }
                  },
                  controllerName: confirmPasswordController,
                  iconName: Icons.lock_outline,
                  validatorName: 'password',
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
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
                          if (_formkey.currentState?.validate() == true) {
                            await resetPassword();
                          }
                        },
                        child: const Text('Ok'))),
              ),
          ],
        )
      ],
    );
  }

  bool checkCondition() {
    if (otpController.text.isEmpty ||
        otpController.text.length < 6 ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        passwordController.text != confirmPasswordController.text) {
      return false;
    } else {
      return true;
    }
  }
}
