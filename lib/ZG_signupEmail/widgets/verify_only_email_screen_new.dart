import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/functions/helper.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/widgets/common_image.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../../profile/stateManagement/profile_provider.dart';
import '../models/verify_email_otp_request.dart';
import '../models/verify_email_request.dart';
import '../services/signup_email_rest_api_service.dart';

class VerifyOnlyEmailScreenNew extends StatefulWidget {
  const VerifyOnlyEmailScreenNew({super.key});

  @override
  State<VerifyOnlyEmailScreenNew> createState() => _VerifyOnlyEmailScreenNewState();
}

class _VerifyOnlyEmailScreenNewState extends State<VerifyOnlyEmailScreenNew> {
  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late ThemeProvider themeProvider;
  late ProfileProvider profileProvider;
  late AppConfigProvider appConfigProvider;

  bool _isObscure = false;
  FocusNode pinFocusNode = FocusNode();

  final otpController = TextEditingController();

  bool showVerificationCodeFieldError = false;
  String verificationCodeFieldError = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(pinFocusNode);
    });
  }

  Future<void> verifyEmailOtp() async {
    // Navigator.of(context).pop();
    // progressbar(context);
    print("before calling");
    try {
      final result = await SignupEmailRestApiService()
          .verifyEmailOtp(VerifyEmailOtpRequest(
        otp: otpController.text,
      ));
      // Navigator.of(context).canPop();
      if (result?.status == true) {
        SharedPreferences.getInstance().then((pref) {

        });
      } else {
        showCustomAlertDialogFromHelper(context, result?.msg ?? "");
      }
    } catch (e) {
      print("inside view catch");

      // Navigator.of(context).canPop();
      otpController.clear();
      showCustomAlertDialogFromHelper(
          context, "The provided OTP is invalid or has expired.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    navigateAuthenticationProvider = Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    profileProvider = Provider.of<ProfileProvider>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);

    return Center(
        child: Container(
            width: screenWidth,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  centerTitle: false,
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
                          fontWeight: FontWeight.w500
                      ),
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16.0),
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
                        "Verify your email address",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Britanica",
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // (profileProvider.profileData.emailVerified ?? false)
                      //     ?Text(
                      //   "Email Already Verified",
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w400,
                      //     fontFamily: "Britanica",
                      //   ),
                      // ) :
                      Text(
                        "We have sent you a 6-digit verification code \nat you email.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Britanica",
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      // (profileProvider.profileData.emailVerified ?? false)
                      //     ?Container()
                      //     :IgnorePointer(
                      //     ignoring: profileProvider.profileData.emailVerified ?? false,
                      //     child: buildVerificationCodeSection(context, screenWidth)
                      // ),

                      buildVerificationCodeSection(context, screenWidth),

                      SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [

                          // (profileProvider.profileData.emailVerified ?? false)?Text(
                          //   "Verified",
                          //   style: GoogleFonts.poppins(
                          //     fontWeight: FontWeight.w600,
                          //     fontSize: 13,
                          //     color: Colors.green, //Color(0xff5cbbff),
                          //   ),
                          // ):
                          InkWell(
                            onTap: () async {

                              final result =
                              await SignupEmailRestApiService().verifyEmail(VerifyEmailRequest(
                                email: navigateAuthenticationProvider.selectedEmail,
                              ));

                              if (result?.status == true) {

                              }

                            },
                            child: Text(
                              "Resend Email Code",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xff5cbbff),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),

              bottomNavigationBar: buildBottomNavigationSection(context, screenWidth),
            )
        )
    );
  }

  Widget buildVerificationCodeSection(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Verification Email Code",
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w300
              ),
            ),

            InkWell(
              child: Icon(
                _isObscure
                    ? Icons.visibility
                    : Icons.visibility_off,
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

        SizedBox(
            height: 5
        ),

        PinCodeTextField(
          // focusNode: pinFocusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
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
          animationDuration:
          const Duration(milliseconds: 300),
          controller: otpController,
          onCompleted: (v) async {
            await verifyEmailOtp();
            await profileProvider.getProfileData();

            if(profileProvider.profileData.emailVerified == true && profileProvider.profileData.phoneVerified == true) {

              SharedPreferences.getInstance().then((pref) {
                if (profileProvider.profileData.isMpinGenerated ?? true) {

                  pref.setString("reg_user", profileProvider.profileData.regUsername ?? "");
                  pref.setInt("reg_id", profileProvider.profileData.regId!);
                  navigateAuthenticationProvider.previousIndex =
                      navigateAuthenticationProvider.selectedIndex;
                  navigateAuthenticationProvider.selectedIndex = 3;


                } else {

                  pref.setString("reg_user", profileProvider.profileData.regUsername ?? "");
                  pref.setInt("reg_id", profileProvider.profileData.regId!);
                  navigateAuthenticationProvider.previousIndex =
                      navigateAuthenticationProvider.selectedIndex;
                  navigateAuthenticationProvider.regId = profileProvider.profileData.regId!;
                  navigateAuthenticationProvider.selectedIndex = 6;

                }
              });


            } else {

              profileProvider.getProfileData();
              profileProvider.sendVerifyPhoneNumberOtp(context);

              navigateAuthenticationProvider.previousIndex =
                  navigateAuthenticationProvider.selectedIndex;
              navigateAuthenticationProvider.selectedIndex = 11;

            }

            // await _submitUserMpin();
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



        (showVerificationCodeFieldError)?SizedBox(
          height: 3,
        ):Container(),

        (showVerificationCodeFieldError)?Text(
          verificationCodeFieldError,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xffd41f1f)
          ),
        ):Container(),

      ],
    );
  }

  Widget buildBottomNavigationSection(BuildContext context, screenWidth) {
    return Container(
      width: screenWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: 18,
              ),

              Container(
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Already a user? Click here to ",
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    InkWell(
                      onTap: () {

                        navigateAuthenticationProvider.previousIndex =
                            navigateAuthenticationProvider.selectedIndex;
                        navigateAuthenticationProvider.selectedIndex = 1;

                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1a94f2),
                        ),
                      ),
                    )
                  ],
                ),
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
