import 'package:dozen_diamond/authentication/stateManagement/authenticationProvider.dart';
import 'package:dozen_diamond/create_ladder_easy/widgets/custom_container.dart';
import 'package:dozen_diamond/global/widgets/my_text_field.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/error_dialog.dart';
import 'package:dozen_diamond/localization/stringConstants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../global/functions/helper.dart';

import '../../global/models/http_api_exception.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/widgets/common_image.dart';
import '../../login/widgets/forgotPasswordDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../login/models/forgot_password_request.dart';
import '../../login/services/login_rest_api_service.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';

class ForgotPasswordScreenNew extends StatefulWidget {
  const ForgotPasswordScreenNew({super.key});

  @override
  State<ForgotPasswordScreenNew> createState() =>
      _ForgotPasswordScreenNewState();
}

class _ForgotPasswordScreenNewState extends State<ForgotPasswordScreenNew> {
  late AuthenticationProvider authenticationProvider;
  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late AppConfigProvider appConfigProvider;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  ApiStateProvider? _apiStateProvider;
  final bool _isObscure1 = false;
  String emailFieldError = "";
  bool showEmailFieldError = true;
  StringConstants strings = StringConstants();
  @override
  void initState() {
    super.initState();
    _apiStateProvider = Provider.of(context, listen: false);
  }

  Future<void> forgotPassword() async {
    try {
      await LoginRestApiService().forgotPassword(ForgotPasswordRequest(
        email: authenticationProvider.forgotPasswordEmailController.text
            .toString(),
      ));
      ApiStateProvider().resetApiRetry();
      if (mounted) {
        Fluttertoast.showToast(
            msg:
                'Email sent successfully to registered email ID containing OTP to reset password.',
            backgroundColor: Colors.black38);
        navigateAuthenticationProvider.previousIndex =
            navigateAuthenticationProvider.selectedIndex;
        navigateAuthenticationProvider.selectedIndex = 8;
      }
    } on HttpApiException catch (err) {
      authenticationProvider.forgotPasswordEmailController.clear();
      restApiErrorDialog(context,
          error: err, action: forgotPassword, apiState: _apiStateProvider!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);

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
                  centerTitle: false,
                  title: InkWell(
                    onTap: () {
                      print(navigateAuthenticationProvider.selectedIndex);
                      navigateAuthenticationProvider.selectedIndex = 1;
                          // navigateAuthenticationProvider.previousIndex;
                      navigateAuthenticationProvider.previousIndex =
                          navigateAuthenticationProvider.selectedIndex;

                      print(navigateAuthenticationProvider.selectedIndex);
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
                      navigateAuthenticationProvider.selectedIndex = 1;
                          // navigateAuthenticationProvider.previousIndex;
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
                        strings.forgotPassword,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Britanica",
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      forgetPasswordSubtitle(context),
                      SizedBox(
                        height: 15,
                      ),
                      emailFieldForForgotPassword(context),
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

  Widget forgetPasswordSubtitle(BuildContext context) {
    return Text(strings.forgotPasswordSubTitle, style: strings.subtitleStyle);
  }

  Widget emailFieldForForgotPassword(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings.email, style: strings.aboveFieldText),

        SizedBox(
          height: 3
        ),

        SizedBox(
          height: 40,
          child: MyTextField(
            controller: authenticationProvider.forgotPasswordEmailController,
            elevation: 0,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            margin: EdgeInsets.zero,
            borderColor: Color(0xff2c2c31),
            focusedBorderColor:
                (showEmailFieldError) ? Color(0xffd41f1f) : Color(0xff5cbbff),
            borderRadius: 8,
            labelText: '',
            validator: (value) {
              if (value!.isEmpty) {
                emailFieldError = "* Required";
                showEmailFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                emailFieldError = "Enter Correct Email Address";
                showEmailFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
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
            onChanged: (value) {},
          ),
        ),
        showEmailFieldError
            ? Text(emailFieldError, style: strings.warningText)
            : Container()
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
                        if (!showEmailFieldError &&
                            authenticationProvider
                                    .forgotPasswordEmailController.text !=
                                "") {
                          forgotPassword();
                        } else {
                          Fluttertoast.showToast(msg: "Enter Email");
                        }
                      },
                      backgroundColor: !showEmailFieldError
                          ? Color(0xfff0f0f0)
                          : Color.fromRGBO(168, 168, 168, 1),
                      borderRadius: 12,
                      height: 52,
                      width: screenWidth - 34,
                      child: Center(
                        child: Text(
                          strings.continueButton,
                          style: GoogleFonts.poppins(
                              color: !showEmailFieldError
                                  ? Colors.black
                                  : Color.fromRGBO(242, 242, 242, 1),
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
