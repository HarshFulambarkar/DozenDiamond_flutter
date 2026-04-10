import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZL_Register/models/mobile_number_codes_model.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/widgets/common_image.dart';
import '../../global/widgets/my_text_field.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../../profile/model/update_profile_data_response.dart';
import '../../profile/services/profile_api_service.dart';
import '../../profile/stateManagement/profile_provider.dart';
import '../models/verify_email_request.dart';
import '../services/signup_email_rest_api_service.dart';

class VerifyOnlyPhoneNumberScreenNew extends StatefulWidget {
  const VerifyOnlyPhoneNumberScreenNew({super.key});

  @override
  State<VerifyOnlyPhoneNumberScreenNew> createState() => _VerifyOnlyPhoneNumberScreenNewState();
}

class _VerifyOnlyPhoneNumberScreenNewState extends State<VerifyOnlyPhoneNumberScreenNew> with CodeAutoFill {

  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late ThemeProvider themeProvider;
  late ProfileProvider profileProvider;
  late AppConfigProvider appConfigProvider;

  bool isEditPhoneNumber = false;

  bool _isObscure = false;
  FocusNode pinFocusNode = FocusNode();

  final otpController = TextEditingController();

  final phoneOtpController = TextEditingController();

  bool showVerificationCodeFieldError = false;
  String verificationCodeFieldError = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(pinFocusNode);
    });
    _listenForOtp();
  }

  void _listenForOtp() async {
    await SmsAutoFill().listenForCode;
    listenForCode();
  }

  @override
  void codeUpdated() {
    setState((){
      print(code);
      phoneOtpController.text = code ?? "";
    });

    // submit otp here
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  // @override
  // void dispose() {
  //   otpController.dispose();
  //   super.dispose();
  // }

  Future<void> verifyEmailShootOtp() async {
    final result =
    await SignupEmailRestApiService().verifyEmail(VerifyEmailRequest(
      // email: textEditingController.text,
      email: profileProvider.profileData.regEmail,
    ));
    if (mounted) {
      if (result?.status == true) {
        navigateAuthenticationProvider.selectedEmail =
            profileProvider.profileData.regEmail ?? "";

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
                        "Verify your phone number",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Britanica",
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      buildPhoneOtpVerificationSection(context, screenWidth),

                    ],
                  ),
                ),
              ),

              bottomNavigationBar: buildBottomNavigationSection(context, screenWidth),
            )
        )
    );
  }

  Widget buildPhoneOtpVerificationSection(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),

        // (profileProvider.profileData.phoneVerified ?? false)
        //     ?Text(
        //   "Phone Number Already Verified",
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w400,
        //     fontFamily: "Britanica",
        //   ),
        // )
        //     :
        Text(
          "We have sent you a 6-digit verification code \nat you phone number.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: "Britanica",
          ),
        ),

        SizedBox(
          height: 15,
        ),

        buildPhoneNumberEditSection(context, screenWidth),

        SizedBox(
          height: 10,
        ),

        // (profileProvider.profileData.phoneVerified ?? false)
        //     ?Container()
        //     :IgnorePointer(
        //     ignoring: profileProvider.profileData.phoneVerified ?? false,
        //     child: buildVerificationPhoneCodeSection(context, screenWidth)
        // ),

        buildVerificationPhoneCodeSection(context, screenWidth),

        SizedBox(
          height: 10,
        ),

        Row(
          children: [

            // (profileProvider.profileData.phoneVerified ?? false)?Text(
            //   "Verified",
            //   style: GoogleFonts.poppins(
            //     fontWeight: FontWeight.w600,
            //     fontSize: 13,
            //     color: Colors.green, //Color(0xff5cbbff),
            //   ),
            // ):
            InkWell(
              onTap: () async {
                profileProvider.sendVerifyPhoneNumberOtp(context);

              },
              child: Text(
                "Resend Phone Code",
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
    );
  }

  Widget buildPhoneNumberEditSection(BuildContext context, double screenWidth) {
    return (isEditPhoneNumber)
        ? Row(
        children: [
          Container(
            height: 33,
            width: screenWidth * 0.7,
            child: MyTextField(
              isFilled: true,
              fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Colors.transparent,
              labelText: "",
              maxLength: 50,
              elevation: 0,
              controller: profileProvider.phoneTextEditingController,
              selectedCountryCode: profileProvider.countryCode,
              textInputFormatters: <TextInputFormatter>[
                // FilteringTextInputFormatter.allow(
                //   RegExp(r'^[0-9,\.]+$'),
                // ),
                // NumberToCurrencyFormatter()
              ],
              onChangedForNumber: (MobileNumberCodeModel? newValue) {
                if (newValue != null) {
                  setState(() {
                    // print("here is the value ${newValue.countryCode}");
                    profileProvider.countryCode = newValue;
                    // print("here is the value ${selectedCountryCode.countryCode}");
                  });
                }
              },
              keyboardType: TextInputType.numberWithOptions(),
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
              ),
              borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
              margin: EdgeInsets.zero,
              contentPadding: EdgeInsets.only(left: 12, bottom: 5),
              focusedBorderColor: Color(0xff5cbbff),
              showLeadingWidget: false  ,
              showTrailingWidget: false,

              prefixText: "", //currencyConstants.currency,

              counterText: "",
              borderRadius: 8,
              hintText: '',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              isForPhoneNumber: true,
              onChanged: (value) {

              },
              onFieldSubmitted: (value) {

              },
            ),
          ),
          SizedBox(width: 5),
          InkWell(
              onTap: () {
                setState(() async {
                  Map<String, dynamic> request = {
                    "reg_mobile": "${profileProvider.countryCode.countryCode}-${profileProvider.phoneTextEditingController.text}",
                  };

                  UpdateProfileDataResponse? res =
                  await ProfileRestApiService().updateProfileData(request);

                  if(res.status!) {

                  } else {

                  }
                  profileProvider.getProfileData();
                  isEditPhoneNumber = false;
                });

                setState(() {

                });
              },
              child: Icon(
                Icons.check,
                size: 20,
                color: Colors.green,
              )),

          SizedBox(width: 5),
          InkWell(
              onTap: () {
                setState(() {
                  isEditPhoneNumber = false;
                });
              },
              child: Icon(
                Icons.close,
                size: 20,
                color: Colors.red,
              ))
        ])
        : Row(
      children: [
        Text(
          // "8888743341",
          profileProvider.profileData.regMobile ?? "Enter Phone Number",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
          ),
        ),
        SizedBox(width: 5),
        InkWell(
            onTap: () {
              setState(() {

                isEditPhoneNumber = true;
                profileProvider.phoneTextEditingController.text = ((profileProvider.profileData.regMobile ?? "-").toString().split("-").length > 1)
                    ?(profileProvider.profileData.regMobile ?? "-").toString().split("-")[1]:"-";

              });
            },
            child: Icon(
              Icons.edit,
              size: 16,
              color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
            ))
      ],
    );
  }


  Widget buildVerificationPhoneCodeSection(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Verification SMS Code",
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
          controller: phoneOtpController,
          onCompleted: (v) async {
            // await verifyEmailOtp();
            // await _submitUserMpin();
            profileProvider.phoneVerificationOtp = v;
            await profileProvider.verifyPhoneNumber(context);
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

              verifyEmailShootOtp();

              navigateAuthenticationProvider.selectedEmail = profileProvider.profileData.regEmail ?? "";
                  // textEditingController.text;

              navigateAuthenticationProvider.previousIndex =
                  navigateAuthenticationProvider.selectedIndex;
              navigateAuthenticationProvider.selectedIndex = 10;

            }
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
