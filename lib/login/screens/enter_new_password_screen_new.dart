import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../authentication/stateManagement/authenticationProvider.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/widgets/error_dialog.dart';
import '../../global/widgets/my_text_field.dart';
import '../../localization/stringConstants.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../services/login_rest_api_service.dart';

class EnterNewPasswordScreenNew extends StatefulWidget {
  const EnterNewPasswordScreenNew({super.key});

  @override
  State<EnterNewPasswordScreenNew> createState() =>
      _EnterNewPasswordScreenNewState();
}

class _EnterNewPasswordScreenNewState extends State<EnterNewPasswordScreenNew> {
  late AuthenticationProvider authenticationProvider;
  late NavigateAuthenticationProvider navigateAuthenticationProvider;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final passwordTextEditingController = TextEditingController();
  final confirmPasswordTextEditingController = TextEditingController();

  String passwordFieldError = "";
  bool showPasswordFieldError = false;

  String confirmPasswordFieldError = "";
  bool showConfirmPasswordFieldError = false;

  ApiStateProvider? _apiStateProvider;

  @override
  void initState() {
    super.initState();
    _apiStateProvider = Provider.of(context, listen: false);
  }

  Future<void> _submitPassword() async {
    // navigateAuthenticationProvider.previousIndex =
    //     navigateAuthenticationProvider.selectedIndex;
    // navigateAuthenticationProvider.selectedIndex = 9;

    try {
      Map<String, dynamic> request = {
        "otp": navigateAuthenticationProvider.forgotPasswordOtp,
        "new_password": passwordTextEditingController.text,
        "confirm_password": confirmPasswordTextEditingController.text,
      };

      final value = await LoginRestApiService().resetPassword(request);

      if (value) {
        navigateAuthenticationProvider.previousIndex =
            navigateAuthenticationProvider.selectedIndex;
        navigateAuthenticationProvider.selectedIndex = 1;
        Fluttertoast.showToast(
            msg: 'Password Reset successfully', backgroundColor: Colors.black38, timeInSecForIosWeb: 4);
      } else {
        Fluttertoast.showToast(
            msg: 'Invalid Password', backgroundColor: Colors.black38);
      }
    } on HttpApiException catch (err) {
      // Fluttertoast.showToast(
      //     msg:
      //     'Invalid Password',
      //     backgroundColor: Colors.black38);
      restApiErrorDialog(context,
          error: err, action: _submitPassword, apiState: _apiStateProvider!);

      // navigateAuthenticationProvider.previousIndex =
      //     navigateAuthenticationProvider.selectedIndex;
      // navigateAuthenticationProvider.selectedIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);

    return WillPopScope(
        onWillPop: () async {
          navigateAuthenticationProvider.selectedIndex =
              navigateAuthenticationProvider.previousIndex;
          navigateAuthenticationProvider.previousIndex =
              navigateAuthenticationProvider.selectedIndex;
          return false;
        },
        child: Center(
          child: Container(
            width: screenWidth,
            child: Scaffold(
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
                      "Go Back",
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

              // resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16.0),
                child: Form(
                  key: _formkey,
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
                        "Enter New Password",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Britanica",
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: screenWidth - 34,
                        child: Text(
                            "Make sure your new password is unique an contains atleast 8 characters (including a combination of upper-case letters, lower-case letters, numbers and special characters.",
                            style: StringConstants().subtitleStyle),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      buildPasswordField(context, screenWidth),
                      SizedBox(
                        height: 15,
                      ),
                      buildPasswordField2(context, screenWidth),
                    ],
                  ),
                ),
              ),

              bottomNavigationBar:
                  buildBottomNavigationSection(context, screenWidth),
            ),
          ),
        ));
  }

  Widget buildPasswordField(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          height: 40,
          child: MyTextField(
            borderColor: Color(0xff2c2c31),
            textStyle: TextStyle(
              color: Colors.white,
            ),
            elevation: 0,
            margin: EdgeInsets.zero,
            focusedBorderColor: (showPasswordFieldError)
                ? Color(0xffd41f1f)
                : Color(0xff5cbbff),
            maxLine: 1,
            borderRadius: 8,
            controller: passwordTextEditingController,
            isPasswordField: true,
            labelText: '',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value3) {
              if (value3!.isEmpty) {
                passwordFieldError = "* Required";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value3.contains(" ")) {
                passwordFieldError = "Space is not allowed in password";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value3.length < 8) {
                passwordFieldError = "Password should be atleast 8 characters";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'[A-Z]').hasMatch(value3)) {
                passwordFieldError =
                "Password should contain at least one upper case letter.";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'[a-z]').hasMatch(value3)) {
                passwordFieldError =
                "Password should contain at least one lower case letter.";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'\d').hasMatch(value3)) {
                passwordFieldError =
                "Password should contain at least one number.";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value3)) {
                passwordFieldError =
                "Password should contain at least one special character.";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else {
                passwordFieldError = "";
                showPasswordFieldError = false;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              }
            },
            onChanged: (String) {},
          ),
        ),
        (showPasswordFieldError)
            ? SizedBox(
                height: 3,
              )
            : Container(),
        (showPasswordFieldError)
            ? Text(
                passwordFieldError,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffd41f1f)),
              )
            : Container(),
      ],
    );
  }

  Widget buildPasswordField2(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Confirm Password",
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          height: 40,
          child: MyTextField(
            borderColor: Color(0xff2c2c31),
            textStyle: TextStyle(
              color: Colors.white,
            ),
            elevation: 0,
            margin: EdgeInsets.zero,
            focusedBorderColor: (showConfirmPasswordFieldError)
                ? Color(0xffd41f1f)
                : Color(0xff5cbbff),
            maxLine: 1,
            borderRadius: 8,
            controller: confirmPasswordTextEditingController,
            isPasswordField: true,
            labelText: '',
            onChanged: (String) {
              if (confirmPasswordTextEditingController.text !=
                  passwordTextEditingController.text) {
                showConfirmPasswordFieldError = true;
                confirmPasswordFieldError = "Password Should match.";
              } else {
                showConfirmPasswordFieldError = false;
                confirmPasswordFieldError = "";
              }

              setState(() {});
            },
          ),
        ),
        (showConfirmPasswordFieldError)
            ? SizedBox(
                height: 3,
              )
            : Container(),
        (showConfirmPasswordFieldError)
            ? Text(
                confirmPasswordFieldError,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16.0),
                    child: CustomContainer(
                      onTap: () {
                        if (passwordTextEditingController.text == "") {
                          passwordFieldError = 'Enter New Password';
                          showPasswordFieldError = true;
                        } else if (confirmPasswordTextEditingController.text ==
                            "") {
                          confirmPasswordFieldError = 'Enter Confirm Password';
                          showConfirmPasswordFieldError = true;
                        } else if (passwordTextEditingController.text !=
                            confirmPasswordTextEditingController.text) {
                          passwordFieldError = 'Password does not match';
                          showPasswordFieldError = true;

                          confirmPasswordFieldError = 'Password does not match';
                          showConfirmPasswordFieldError = true;
                        } else {
                          final passwordRegex = RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

                          if (passwordRegex
                              .hasMatch(passwordTextEditingController.text)) {
                            passwordFieldError = '';
                            showPasswordFieldError = false;

                            confirmPasswordFieldError = '';
                            showConfirmPasswordFieldError = false;
                            _submitPassword();
                          } else {
                            passwordFieldError =
                                'Password must container number, one capital and small letter and one special character';
                            showPasswordFieldError = true;

                            confirmPasswordFieldError =
                                'Password must container number, one capital and small letter and one special character';
                            showConfirmPasswordFieldError = true;
                          }
                        }

                        setState(() {});
                      },
                      backgroundColor:
                          // !showEmailFieldError
                          //     ?
                          Color(0xfff0f0f0),
                      // : Color.fromRGBO(168, 168, 168, 1),
                      borderRadius: 12,
                      height: 52,
                      width: screenWidth - 34,
                      child: Center(
                        child: Text(
                          "Continue",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              // color: !showEmailFieldError
                              //     ? Colors.black
                              //     : Color.fromRGBO(242, 242, 242, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
