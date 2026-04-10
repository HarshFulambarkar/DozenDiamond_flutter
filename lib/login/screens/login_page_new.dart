import 'dart:io';

import 'package:dozen_diamond/ZG_signupEmail/services/signup_email_rest_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZG_signupEmail/models/verify_email_request.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/widgets/common_image.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/error_dialog.dart';
import '../../global/widgets/my_text_field.dart';
import '../../localization/translation_keys.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../../profile/stateManagement/profile_provider.dart';
import '../models/login_user_request.dart';
import '../services/login_rest_api_service.dart';
import '../stateManagement/auth_provider.dart';

class LoginPageNew extends StatefulWidget {
  final bool forgotMpin;
  const LoginPageNew({
    Key? key,
    this.forgotMpin = false,
  }) : super(key: key);

  @override
  State<LoginPageNew> createState() => _LoginPageNewState();
}

class _LoginPageNewState extends State<LoginPageNew> {
  final textEditingController = TextEditingController();
  final textEditingController1 = TextEditingController();
  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late AuthProvider authProvider;
  late ThemeProvider themeProvider;
  late ProfileProvider profileProvider;
  late AppConfigProvider appConfigProvider;
  ApiStateProvider? _apiStateProvider;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String emailFieldError = "";
  bool showEmailFieldError = false;

  @override
  void initState() {
    print("in login screen");
    super.initState();
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    SharedPreferences.getInstance().then((value) async {
      if (value.getInt("reg_id") != null && !widget.forgotMpin) {
        if(profileProvider.profileData.emailVerified == false || profileProvider.profileData.phoneVerified == false) {
          // navigateAuthenticationProvider.previousIndex =
          //     navigateAuthenticationProvider.selectedIndex;
          // navigateAuthenticationProvider.selectedIndex = 7;
        } else {
          navigateAuthenticationProvider.previousIndex =
              navigateAuthenticationProvider.selectedIndex;
          navigateAuthenticationProvider.selectedIndex = 3;
        }

      }
    });
    _apiStateProvider = Provider.of(context, listen: false);
  }

  Future<void> verifyEmailShootOtp() async {
    final result =
        await SignupEmailRestApiService().verifyEmail(VerifyEmailRequest(
      email: textEditingController.text,
    ));
    if (mounted) {
      if (result?.status == true) {
        navigateAuthenticationProvider.selectedEmail =
            textEditingController.text;

        // navigateAuthenticationProvider.previousIndex =
        //     navigateAuthenticationProvider.selectedIndex;
        // navigateAuthenticationProvider.selectedIndex = 7;

        navigateAuthenticationProvider.previousIndex =
            navigateAuthenticationProvider.selectedIndex;
        navigateAuthenticationProvider.selectedIndex = 10;

        // return showDialog(
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (context) {
        //     return VerifyEmailDialog(
        //       resendOtp: verifyEmailShootOtp,
        //     );
        //   },
        // );
      }
    }
  }

  void _loginUser() async {
    LoginRestApiService()
        .getLoginUser(LoginUserRequest(
      useremail: textEditingController.text,
      password: textEditingController1.text,
    ))
        .then((res) {
      ApiStateProvider().resetApiRetry();
      SharedPreferences.getInstance().then((pref) async {
        if(res!.data!.emailVerified == false || res.data!.phoneVerified == false) {

          pref.setString("reg_user", res.data?.regUsername ?? "");
          pref.setString("reg_user_email", res.data?.regEmail ?? "");
          pref.setString(
              "reg_account_status", res.data?.regAccountStatus ?? "");
          pref.setInt("reg_id", res.data!.regId!);

          // new code start here

          if(res.data!.emailVerified == false) {

            verifyEmailShootOtp();

            navigateAuthenticationProvider.selectedEmail = textEditingController.text;

            navigateAuthenticationProvider.previousIndex = navigateAuthenticationProvider.selectedIndex;
            navigateAuthenticationProvider.selectedIndex = 10;

          } else if(res.data!.phoneVerified == false) {

            profileProvider.getProfileData();
            profileProvider.sendVerifyPhoneNumberOtp(context);

            navigateAuthenticationProvider.previousIndex =
                navigateAuthenticationProvider.selectedIndex;
            navigateAuthenticationProvider.selectedIndex = 11;

          }

          // new code end here

          // old code start here if something went wrong uncomment below code

          // if(res.data!.phoneVerified == false) {
          //
          //   profileProvider.getProfileData();
          //   profileProvider.sendVerifyPhoneNumberOtp(context);
          // }
          //
          // if(res.data!.emailVerified == false) {
          //
          //   verifyEmailShootOtp();
          //
          // }
          //
          //
          //
          // navigateAuthenticationProvider.selectedEmail =
          //     textEditingController.text;
          //
          // navigateAuthenticationProvider.previousIndex =
          //     navigateAuthenticationProvider.selectedIndex;
          // navigateAuthenticationProvider.selectedIndex = 7;

          // old code start here if something went wrong uncomment above code

        } else if (widget.forgotMpin || !res.data!.regMpinExist!) {
          print("in if");
          navigateAuthenticationProvider.previousIndex =
              navigateAuthenticationProvider.selectedIndex;
          navigateAuthenticationProvider.regId = res.data!.regId!;
          navigateAuthenticationProvider.selectedIndex = 6;
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MpinGenerationPage(
          //       regId: res!.data!.regId!,
          //     ),
          //   ),
          // );
        } else if (res.data?.regAccountStatus == "BLOCKED") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Account Blocked"),
                content: Text(
                    "Your account is blocked. Please login with another account."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {

          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // bool hasAgreed = prefs.getBool('hasAgreedToTerms') ?? false;
          //
          // if (hasAgreed) {
          //   print("in else");
          //   print(res.data?.regEmail);
          //   pref.setString("reg_user", res.data?.regUsername ?? "");
          //   pref.setString("reg_user_email", res.data?.regEmail ?? "");
          //   pref.setString(
          //       "reg_account_status", res.data?.regAccountStatus ?? "");
          //   pref.setInt("reg_id", res.data!.regId!);
          //   navigateAuthenticationProvider.previousIndex =
          //       navigateAuthenticationProvider.selectedIndex;
          //   navigateAuthenticationProvider.selectedIndex = 3;
          // } else {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (_) => TermsOfUseScreen(
          //         onAgree: () {
          //
          //           Navigator.pushAndRemoveUntil(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) =>
          //                     NavigateAuthenticationScreen()),
          //                 (Route<dynamic> route) =>
          //             false, // this removes all previous routes
          //           );
          //
          //           print("in else");
          //           print(res.data?.regEmail);
          //           pref.setString("reg_user", res.data?.regUsername ?? "");
          //           pref.setString("reg_user_email", res.data?.regEmail ?? "");
          //           pref.setString(
          //               "reg_account_status", res.data?.regAccountStatus ?? "");
          //           pref.setInt("reg_id", res.data!.regId!);
          //           navigateAuthenticationProvider.previousIndex =
          //               navigateAuthenticationProvider.selectedIndex;
          //           navigateAuthenticationProvider.selectedIndex = 3;
          //         },
          //       ),
          //     ),
          //   );
          // }


          print("in else");
          print(res.data?.regEmail);
          pref.setString("reg_user", res.data?.regUsername ?? "");
          pref.setString("reg_user_email", res.data?.regEmail ?? "");
          pref.setString(
              "reg_account_status", res.data?.regAccountStatus ?? "");
          pref.setInt("reg_id", res.data!.regId!);

          if(res.data!.emailVerified == false || res.data!.phoneVerified == false) {

            if(res.data!.phoneVerified == false) {

              profileProvider.getProfileData();
              profileProvider.sendVerifyPhoneNumberOtp(context);
            }

            if(res.data!.emailVerified == false) {

              verifyEmailShootOtp();

            }



            navigateAuthenticationProvider.selectedEmail =
                textEditingController.text;

            navigateAuthenticationProvider.previousIndex =
                navigateAuthenticationProvider.selectedIndex;
            navigateAuthenticationProvider.selectedIndex = 7;

          } else {

            navigateAuthenticationProvider.previousIndex =
                navigateAuthenticationProvider.selectedIndex;
            navigateAuthenticationProvider.selectedIndex = 3;

          }

          // navigateAuthenticationProvider.previousIndex =
          //     navigateAuthenticationProvider.selectedIndex;
          // navigateAuthenticationProvider.selectedIndex = 3;


        }
      });
    }).catchError((err) {
      textEditingController1.clear();
      if (err.runtimeType == HttpApiException &&
          err.errorCode == 400 &&
          err.errorTitle == "User's email address is not verified.") {
        Fluttertoast.showToast(
          msg: 'Email sent to registered email ID containing verification pin!',
        );
        // verifyEmailShootOtp();
      } else {
        print("hello from the error dialog");
        restApiErrorDialog(context,
            error: err, action: _loginUser, apiState: _apiStateProvider!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    authProvider = Provider.of<AuthProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    profileProvider = Provider.of<ProfileProvider>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: ((value, result) async {

          // navigateAuthenticationProvider.selectedIndex =
          //     navigateAuthenticationProvider.previousIndex;
          // navigateAuthenticationProvider.previousIndex =
          //     navigateAuthenticationProvider.selectedIndex;
          // return false;
        }),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: Center(
            child: Container(
              width: screenWidth,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: widget.forgotMpin == true
                    ? AppBar(
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
                        ))
                    : AppBar(
                        backgroundColor: Colors.transparent,
                      ),
                // resizeToAvoidBottomInset: false,
                backgroundColor: (themeProvider.defaultTheme)?Colors.white:Colors.transparent, //Colors.transparent,
                body: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 160, // fill screen
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16.0),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonImage(
                                  imageUrl: appConfigProvider.appConfigData.data?.logo?.koshUrl ?? "", // "https://example.com/photo.png",
                                  fallbackAsset: "lib/global/assets/logos/dozendiamond_logo.jpeg",
                                  width: 25,
                                ),
                                // Image.asset(
                                //   "lib/global/assets/logos/dozendiamond_logo.jpeg",
                                //   width: 25,
                                // ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "Login to your account",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Britanica",
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                if (widget.forgotMpin) ...[
                                  const FittedBox(
                                    child: Text(
                                      "Please verify your credentials before \nresetting your MPin",
                                      // "Please enter your Credential\nfor resetting your Mpin.",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white, //Colors.lightBlueAccent,
                                          height: 1.3),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                                buildEmailField(context, screenWidth),
                                SizedBox(
                                  height: 15,
                                ),
                                buildPasswordField(context, screenWidth),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print(navigateAuthenticationProvider.selectedIndex);
                                    navigateAuthenticationProvider.previousIndex =
                                        navigateAuthenticationProvider.selectedIndex;
                                    navigateAuthenticationProvider.selectedIndex = 4;
                                    print(navigateAuthenticationProvider.selectedIndex);
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xff5cbbff),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 18,
                                ),

                                buildFacebookAndGoogleAndApple(context),
                                // (kIsWeb == false)?buildFacebookAndGoogleAndApple(context):Container(),
                              ],
                            ),
                          ),
                        ),

                        buildBottomNavigationSection(context, screenWidth)
                      ],
                    ),
                  ),
                ),

                // bottomSheet: buildBottomNavigationSection(context, screenWidth),
                // bottomNavigationBar: buildBottomNavigationSection(context, screenWidth),
              ),
            ),
          ),
        ));
  }

  Widget buildEmailField(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          height: 40,
          child: MyTextField(
            maxLine:1,
            isFilled: true,
            fillColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            elevation: 0,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white,
            ),
            keyboardType: TextInputType.emailAddress,
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            margin: EdgeInsets.zero,
            focusedBorderColor:
                (showEmailFieldError) ? Color(0xffd41f1f) : Color(0xff5cbbff),
            validator: (value2) {
              if (value2!.isEmpty) {
                // return "* Required";
                emailFieldError = "* Required";
                showEmailFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value2)) {
                emailFieldError = "Enter Correct Email Address";
                showEmailFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                // return "Enter Correct Email Address";
                return null;
              } else {
                emailFieldError = "";
                showEmailFieldError = false;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              }
            },
            controller: textEditingController,
            borderRadius: 8,
            labelText: '',
            onChanged: (String) {},
          ),
        ),
        (showEmailFieldError)
            ? SizedBox(
                height: 3,
              )
            : Container(),
        (showEmailFieldError)
            ? Text(
                emailFieldError,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffd41f1f)),
              )
            : Container(),
      ],
    );
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
            isFilled: true,
            fillColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white,
            ),
            elevation: 0,
            margin: EdgeInsets.zero,
            focusedBorderColor: Color(0xff5cbbff),
            maxLine: 1,
            borderRadius: 8,
            controller: textEditingController1,
            isPasswordField: true,
            labelText: '',
            onChanged: (String) {},
          ),
        )
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
                  onTap: () {
                    if (_formkey.currentState?.validate() == true &&
                        showEmailFieldError == false) {
                      _loginUser();
                    }
                  },
                  backgroundColor: (textEditingController.text == "" ||
                          textEditingController1.text == "")
                      ? Color(0xffa8a8a8)
                      : (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  borderRadius: 12,
                  height: 52,
                  width: screenWidth - 34,
                  child: Center(
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                          color: (textEditingController.text == "" ||
                                  textEditingController1.text == "")
                              ? Color.fromRGBO(242, 242, 242, 1)
                              : (themeProvider.defaultTheme)?Colors.white:Color.fromRGBO(11, 11, 11, 1),
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
                      navigateAuthenticationProvider.previousIndex =
                          navigateAuthenticationProvider.selectedIndex;
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
                height: 18 + 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFacebookAndGoogleAndApple(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          TranslationKeys.orContinueWith,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
            fontSize: 13
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomContainer(
            //   onTap: () async {
            //     // final success = await authProvider.loginWithFacebook();
            //   },
            //   height: 50,
            //   width: 50,
            //   borderRadius: 12,
            //   padding: 0,
            //   paddingEdge: EdgeInsets.zero,
            //   margin: EdgeInsets.zero,
            //   backgroundColor: Colors.grey, //Color(0xff4285f4),
            //   child: Center(
            //     child: Image.asset(
            //       'lib/login/assets/images/facebook_icon.png',
            //       height: 22,
            //     ),
            //   ),
            // ),
            //
            // SizedBox(
            //   width: 16,
            // ),

            // (kIsWeb)?GoogleSigninWeb(context: context, forgotMpin: widget.forgotMpin,) :
            CustomContainer(
              onTap: () async {
                if(authProvider.googleLoginButtonClick == false) {

                  authProvider.googleLoginButtonClick = true;
                  await LoginRestApiService().signOutGoogle();

                  await authProvider.loginWithGoogle(false)
                      .then((res) {
                    ApiStateProvider().resetApiRetry();
                    SharedPreferences.getInstance().then((pref) {
                      if(res!.data!.emailVerified == false || res.data!.phoneVerified == false) {

                        pref.setString("reg_user", res.data?.regUsername ?? "");
                        pref.setString("reg_user_email", res.data?.regEmail ?? "");
                        pref.setString(
                            "reg_account_status", res.data?.regAccountStatus ?? "");
                        pref.setInt("reg_id", res.data!.regId!);

                        if(res.data!.phoneVerified == false) {

                          profileProvider.getProfileData();
                          profileProvider.sendVerifyPhoneNumberOtp(context);
                        }

                        if(res.data!.emailVerified == false) {

                          verifyEmailShootOtp();

                        }



                        navigateAuthenticationProvider.selectedEmail =
                            textEditingController.text;

                        navigateAuthenticationProvider.previousIndex =
                            navigateAuthenticationProvider.selectedIndex;
                        navigateAuthenticationProvider.selectedIndex = 7;

                      } else if (widget.forgotMpin || !res.data!.regMpinExist!) {
                        print("in if");
                        navigateAuthenticationProvider.previousIndex =
                            navigateAuthenticationProvider.selectedIndex;
                        navigateAuthenticationProvider.regId = res.data!.regId!;
                        navigateAuthenticationProvider.selectedIndex = 6;
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MpinGenerationPage(
                        //       regId: res!.data!.regId!,
                        //     ),
                        //   ),
                        // );
                      } else if (res.data?.regAccountStatus == "BLOCKED") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Account Blocked"),
                              content: Text(
                                  "Your account is blocked. Please login with another account."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        print("in else");
                        print(res.data?.regEmail);
                        pref.setString("reg_user", res.data?.regUsername ?? "");
                        pref.setString("reg_user_email", res.data?.regEmail ?? "");
                        pref.setString(
                            "reg_account_status", res.data?.regAccountStatus ?? "");
                        pref.setInt("reg_id", res.data!.regId!);
                        if(res.data!.emailVerified == false || res.data!.phoneVerified == false) {

                          if(res.data!.emailVerified == false) {

                            profileProvider.getProfileData();
                            profileProvider.sendVerifyPhoneNumberOtp(context);
                          }

                          if(res.data!.emailVerified == false) {

                            verifyEmailShootOtp();

                          }



                          navigateAuthenticationProvider.selectedEmail =
                              textEditingController.text;

                          navigateAuthenticationProvider.previousIndex =
                              navigateAuthenticationProvider.selectedIndex;
                          navigateAuthenticationProvider.selectedIndex = 7;

                        } else {

                          navigateAuthenticationProvider.previousIndex =
                              navigateAuthenticationProvider.selectedIndex;
                          navigateAuthenticationProvider.selectedIndex = 3;

                        }
                        // navigateAuthenticationProvider.previousIndex =
                        //     navigateAuthenticationProvider.selectedIndex;
                        // navigateAuthenticationProvider.selectedIndex = 3;
                      }
                    });
                  }).catchError((err) {
                    authProvider.googleLoginButtonClick = false;
                    textEditingController1.clear();
                    if (err.runtimeType == HttpApiException &&
                        err.errorCode == 400 &&
                        err.errorTitle == "User's email address is not verified.") {
                      Fluttertoast.showToast(
                        msg: 'Email sent to registered email ID containing verification pin!',
                      );
                      // verifyEmailShootOtp();
                    } else {
                      print("hello from the error dialog");
                      restApiErrorDialog(context,
                          error: err, action: _loginUser, apiState: _apiStateProvider!);
                    }
                  });

                } else {

                }

              },
              height: 50,
              width: 50,
              borderRadius: 12,
              padding: 0,
              paddingEdge: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              backgroundColor: Color(0xfff1f5f9),
              child: Center(
                child: Image.asset(
                  'lib/login/assets/images/google_icon.png',
                  height: 22,
                ),
              ),
            ),

            (kIsWeb)?Container():(Platform.isIOS)?Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: CustomContainer(
                onTap: () async {

                  // authProvider.loginWithApple();
                  await authProvider.loginWithApple(false)
                      .then((res) {
                    ApiStateProvider().resetApiRetry();
                    SharedPreferences.getInstance().then((pref) {
                      if(res.data!.emailVerified == false || res.data!.phoneVerified == false) {

                        pref.setString("reg_user", res.data?.regUsername ?? "");
                        pref.setString("reg_user_email", res.data?.regEmail ?? "");
                        pref.setString(
                            "reg_account_status", res.data?.regAccountStatus ?? "");
                        pref.setInt("reg_id", res.data!.regId!);

                        if(res.data!.phoneVerified == false) {

                          profileProvider.getProfileData();
                          profileProvider.sendVerifyPhoneNumberOtp(context);
                        }

                        if(res.data!.emailVerified == false) {

                          verifyEmailShootOtp();

                        }



                        navigateAuthenticationProvider.selectedEmail =
                            textEditingController.text;

                        navigateAuthenticationProvider.previousIndex =
                            navigateAuthenticationProvider.selectedIndex;
                        navigateAuthenticationProvider.selectedIndex = 7;

                      } else if (widget.forgotMpin || !res.data!.regMpinExist!) {
                        print("in if");
                        navigateAuthenticationProvider.previousIndex =
                            navigateAuthenticationProvider.selectedIndex;
                        navigateAuthenticationProvider.regId = res.data!.regId!;
                        navigateAuthenticationProvider.selectedIndex = 6;
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MpinGenerationPage(
                        //       regId: res!.data!.regId!,
                        //     ),
                        //   ),
                        // );
                      } else if (res.data?.regAccountStatus == "BLOCKED") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Account Blocked"),
                              content: Text(
                                  "Your account is blocked. Please login with another account."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        print("in else");
                        print(res.data?.regEmail);
                        pref.setString("reg_user", res.data?.regUsername ?? "");
                        pref.setString("reg_user_email", res.data?.regEmail ?? "");
                        pref.setString(
                            "reg_account_status", res.data?.regAccountStatus ?? "");
                        pref.setInt("reg_id", res.data!.regId!);
                        if(res.data!.emailVerified == false || res.data!.phoneVerified == false) {

                          if(res.data!.emailVerified == false) {

                            profileProvider.getProfileData();
                            profileProvider.sendVerifyPhoneNumberOtp(context);
                          }

                          if(res.data!.emailVerified == false) {

                            verifyEmailShootOtp();

                          }



                          navigateAuthenticationProvider.selectedEmail =
                              textEditingController.text;

                          navigateAuthenticationProvider.previousIndex =
                              navigateAuthenticationProvider.selectedIndex;
                          navigateAuthenticationProvider.selectedIndex = 7;

                        } else {

                          navigateAuthenticationProvider.previousIndex =
                              navigateAuthenticationProvider.selectedIndex;
                          navigateAuthenticationProvider.selectedIndex = 3;

                        }
                        // navigateAuthenticationProvider.previousIndex =
                        //     navigateAuthenticationProvider.selectedIndex;
                        // navigateAuthenticationProvider.selectedIndex = 3;
                      }
                    });
                  }).catchError((err) {
                    textEditingController1.clear();
                    if (err.runtimeType == HttpApiException &&
                        err.errorCode == 400 &&
                        err.errorTitle == "User's email address is not verified.") {
                      Fluttertoast.showToast(
                        msg: 'Email sent to registered email ID containing verification pin!',
                      );
                      // verifyEmailShootOtp();
                    } else {
                      print("hello from the error dialog");
                      restApiErrorDialog(context,
                          error: err, action: _loginUser, apiState: _apiStateProvider!);
                    }
                  });
                },
                height: 50,
                width: 50,
                borderRadius: 12,
                padding: 0,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                backgroundColor: Color(0xfff1f5f9),
                child: Center(
                  child: Icon(
                    Icons.apple,
                    color: Colors.black,
                    size: 32,
                  )
                  // child: Image.asset(
                  //   'lib/login/assets/images/google_icon.png',
                  //   height: 22,
                  // ),
                ),
              ),
            ):Container()
          ],
        )
      ],
    );
  }
}
