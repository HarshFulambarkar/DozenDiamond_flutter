import 'package:dozen_diamond/authentication/stateManagement/authenticationProvider.dart';
import 'package:dozen_diamond/localization/stringConstants.dart';
import 'package:dozen_diamond/login/models/forgot_password_request.dart';
import 'package:dozen_diamond/login/services/login_rest_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../DD_Navigation/widgets/common_screen.dart';
import '../../global/functions/helper.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/services/auth_service.dart';
import '../../global/services/socket_manager.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/error_dialog.dart';
import '../../navigateAuthentication/screens/navigate_authentication_screen.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';
import '../../ZM_mpin/models/get_validate_mpin_request.dart';
import '../../ZM_mpin/services/mpin_rest_api_service.dart';

class ForgotPasswordVerificationScreen extends StatefulWidget {
  final bool fetchUserData;
  const ForgotPasswordVerificationScreen(
      {super.key, this.fetchUserData = false});

  @override
  State<ForgotPasswordVerificationScreen> createState() =>
      _ForgotPasswordVerificationScreenState();
}

class _ForgotPasswordVerificationScreenState
    extends State<ForgotPasswordVerificationScreen> {
  SocketManager socketManager = SocketManager();
  FocusNode pinFocusNode = FocusNode();

  AuthenticationProvider? authenticationProvider;

  StringConstants strings = StringConstants();

  final textEditingController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isObscure = true;

  bool isBiometricAvailable = false;

  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late WebSocketServiceProvider webSocketServiceProvider;
  late ThemeProvider themeProvider;

  bool showMpinFieldError = false;
  String mpinFieldError = "";

  ApiStateProvider? _apiStateProvider;
  @override
  void initState() {
    super.initState();
    _apiStateProvider = Provider.of(context, listen: false);
    webSocketServiceProvider = Provider.of(context, listen: false);
    authenticationProvider = Provider.of(context, listen: false);
    authenticationProvider!.startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(pinFocusNode);
    });
  }

  Future<void> _submitOtp() async {
    if (textEditingController.text.length < 6) return;
    // progressbar(context);
    final pref = await SharedPreferences.getInstance();

    // navigateAuthenticationProvider.previousIndex =
    //     navigateAuthenticationProvider.selectedIndex;
    // navigateAuthenticationProvider.selectedIndex = 9;

    try {

      Map<String, dynamic> request = {
        "otp": textEditingController.text,
      };

      final value = await LoginRestApiService().verifyOtpForResetPassword(request);

      if (value) {

        navigateAuthenticationProvider.forgotPasswordOtp = textEditingController.text;

        navigateAuthenticationProvider.previousIndex =
            navigateAuthenticationProvider.selectedIndex;
        navigateAuthenticationProvider.selectedIndex = 9;
      } else {
        Fluttertoast.showToast(
            msg:
            'Invalid OTP',
            backgroundColor: Colors.black38);

      }
    } on HttpApiException catch (err) {
      restApiErrorDialog(context,
          error: err, action: _submitOtp, apiState: _apiStateProvider!);
      // Fluttertoast.showToast(
      //     msg:
      //     'Invalid OTP',
      //     backgroundColor: Colors.black38);
    }
  }

  String maskEmail(String email) {
    List<String> parts = email.split('@');
    if (parts.length != 2) {
      return 'Invalid email';
    }

    String username = parts[0];
    String domain = parts[1];

    if (username.length <= 4) {
      return email;
    }

    String maskedUsername = username.substring(0, 2) +
        '*' * (username.length - 4) +
        username.substring(username.length - 2);

    return '$maskedUsername@$domain';
  }

  Future<void> resendCode() async {
    try {
      await LoginRestApiService().forgotPassword(ForgotPasswordRequest(
        email: authenticationProvider!.forgotPasswordEmailController.text
            .toString(),
      ));
      ApiStateProvider().resetApiRetry();
      if (mounted) {
        authenticationProvider!.showResendCode = false;
        authenticationProvider!.startCountdown();
        Fluttertoast.showToast(
            msg:
                'Email sent successfully to registered email ID containing OTP to reset password.',
            backgroundColor: Colors.black38);
      }
    } on HttpApiException catch (err) {
      authenticationProvider!.forgotPasswordEmailController.clear();
      restApiErrorDialog(context,
          error: err, action: resendCode, apiState: _apiStateProvider!);
    }
  }

  @override
  Widget build(BuildContext context) {
    authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);

    return Center(
        child: Container(
            width: screenWidth,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: InkWell(
                    onTap: () {
                      navigateAuthenticationProvider.selectedIndex =
                          navigateAuthenticationProvider.previousIndex;
                      navigateAuthenticationProvider.previousIndex =
                          navigateAuthenticationProvider.selectedIndex;
                    },
                    child: Text(
                      strings.goBack,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  leadingWidth: 15,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {
                      navigateAuthenticationProvider.selectedIndex =
                          navigateAuthenticationProvider.previousIndex;
                      navigateAuthenticationProvider.previousIndex =
                          navigateAuthenticationProvider.selectedIndex;
                      // navigateAuthenticationProvider.selectedIndex = 4;
                    },
                  )),
              body: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "lib/global/assets/logos/dozendiamond_logo.jpeg",
                      width: 25,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      strings.forgotPassword,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Britanica",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        text: strings.sixDigitVerification,
                        style: strings.subtitleStyleForSignup.copyWith(
                          color: themeProvider.defaultTheme ? Colors.black : Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: maskEmail(authenticationProvider!
                                .forgotPasswordEmailController.text),
                            style: strings.subtitleStyleForSignup.copyWith(
                              color: themeProvider.defaultTheme ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    buildMpinSection(context, screenWidth),
                    authenticationProvider!.showResendCode
                        ? InkWell(
                            onTap: () {
                              resendCode();
                            },
                            child: Text(
                              strings.resendCode,
                              style: strings.inkWellStyle,
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              text: strings.requestAgain,
                              style: strings.infoStyle,
                              children: [
                                TextSpan(
                                  text:
                                      " ${authenticationProvider!.countdown}s",
                                  style: strings.inkWellStyle,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              bottomNavigationBar:
                  buildBottomNavigationSection(context, screenWidth),
            )));
  }

  Widget buildMpinSection(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              strings.verificationCode,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w300),
            ),
            InkWell(
              child: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            )
          ],
        ),
        SizedBox(height: 5),
        PinCodeTextField(
          focusNode: pinFocusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          length: 6,
          obscureText: _isObscure,
          obscuringCharacter: "*",
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            activeColor: Color(0xff2c2c31),
            activeFillColor: Color(0xff2c2c31),
            disabledColor: Color(0xff2c2c31),
            errorBorderColor: Color(0xffd42f1f),
            inactiveColor: Color(0xff2c2c31),
            inactiveFillColor: Color(0xff2c2c31),
            selectedColor: Color(0xff5cbbff),
            selectedFillColor: Color(0xff2c2c31),
            borderRadius: BorderRadius.circular(9),
          ),
          animationDuration: const Duration(milliseconds: 300),
          controller: textEditingController,
          onCompleted: (v) async {
            await _submitOtp();
          },
          onChanged: (value) {
            print(value);
          },
          beforeTextPaste: (text) {
            print("Allowing to paste $text");
            return true;
          },
          appContext: context,
        ),
        (showMpinFieldError)
            ? SizedBox(
                height: 3,
              )
            : Container(),
        (showMpinFieldError)
            ? Text(
                mpinFieldError,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffd41f1f)),
              )
            : Container(),
      ],
    );
  }

  Widget buildBottomNavigationSection(BuildContext context, screenWidth) {
    return Container(
      width: screenWidth,
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16.0),
                child: CustomContainer(
                  onTap: () async {
                    if (textEditingController.text.length >= 6) {
                      await _submitOtp();
                    } else {
                      showMpinFieldError = true;
                      mpinFieldError = "Enter Mpin";
                      setState(() {});
                    }
                  },
                  backgroundColor: Color(0xfff0f0f0),
                  borderRadius: 12,
                  height: 52,
                  width: screenWidth - 34,
                  child: Center(
                    child: Text(
                      strings.continueButton,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                children: [
                  Text(
                    "New here? ",
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      navigateAuthenticationProvider.previousIndex = navigateAuthenticationProvider.selectedIndex;
                      navigateAuthenticationProvider.selectedIndex = 0;
                    },
                    child: Text(
                      "Create your account",
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1a94f2),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
