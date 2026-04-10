import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/screens/settings_page.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/custom_code_input_formatter.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../../localization/translation_keys.dart';
import '../stateManagement/webinar_otp_provider.dart';

class AccessRealTimeTradingOtpScreen extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  AccessRealTimeTradingOtpScreen(
      {super.key,
        this.isAuthenticationPresent = false,
        required this.updateIndex});

  @override
  State<AccessRealTimeTradingOtpScreen> createState() => _AccessRealTimeTradingOtpScreenState();
}

class _AccessRealTimeTradingOtpScreenState extends State<AccessRealTimeTradingOtpScreen> {

  late ThemeProvider themeProvider;

  FocusNode otpFocusNode = FocusNode();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late NavigationProvider navigationProvider;
  late WebinarOtpProvider webinarOtpProvider;
  late UserConfigProvider userConfigProvider;

  bool showOtpFieldError = false;
  String otpFieldError = "";

  bool _isObscure = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      FocusScope.of(context).requestFocus(otpFocusNode);


    });

  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {

    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    webinarOtpProvider = Provider.of<WebinarOtpProvider>(context, listen: true);
    userConfigProvider = Provider.of<UserConfigProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);

    return SafeArea(
        child: Center(
          child: Stack(
            children: [
              Center(
                  child: Container(
                      color: (themeProvider.defaultTheme)
                          ? Color(0XFFF5F5F5)
                          : Colors.transparent,
                      width: screenWidth,
                      child: Scaffold(
                          drawer: NavDrawerNew(updateIndex: widget.updateIndex),
                          key: _key,
                          backgroundColor: (themeProvider.defaultTheme)
                              ? Color(0XFFF5F5F5)
                              : Color(0xFF15181F),
                          body: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(
                                      height: 45,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Image.asset(
                                      "lib/global/assets/logos/dozendiamond_logo.jpeg",
                                      width: 25,
                                    ),

                                    SizedBox(
                                      height: 12,
                                    ),

                                    Text(
                                      TranslationKeys.accessRealTimeTrading,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Britanica",
                                      ),
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Text(
                                      "Enter 8-Character OTP that is shared with you in our weekly webinar.",
                                      // "${TranslationKeys.weSentYourA6DigitVerificationCodeAt} your registered email",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Britanica",
                                      ),
                                    ),

                                    SizedBox(
                                      height: 15,
                                    ),

                                    buildOtpSection(context, screenWidth),

                                    SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      "Note: The first two fields of the OTP are your referral code. If you don’t have a referral code, enter DD in the first two fields. \nRemember, the code is case-sensitive. \n Example: DD123456",
                                      // "${TranslationKeys.weSentYourA6DigitVerificationCodeAt} your registered email",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.yellow,
                                        fontFamily: "Britanica",
                                      ),
                                    ),

                                    // questionnaireSection(context, screenWidth),
                                  ],
                                ),
                              ),

                              CustomHomeAppBarWithProviderNew(
                                  backButton: true,
                                  leadingAction: _triggerDrawer,
                                  backIndex: navigationProvider.previousSelectedIndex,
                              ),
                            ],
                          ))
                  )
              ),
            ],
          ),
        )
    );
  }

  Widget buildOtpSection(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              TranslationKeys.verificationCode,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w300
              ),
            ),

            InkWell(
              child: Icon(
                _isObscure
                    ? Icons.visibility_off
                    : Icons.visibility,
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
          focusNode: otpFocusNode,
          keyboardType: TextInputType.text,
          inputFormatters: [
            // FilteringTextInputFormatter.digitsOnly
            // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            CustomCodeInputFormatter(),
          ],
          length: 8, // 6,
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
          controller: webinarOtpProvider.webinarOtpTextEditingController,
          onCompleted: (v) async {
            print("insdie oncompleted");
            // await _submitUserMpin();

            if(webinarOtpProvider.apiCalled == false) {
              webinarOtpProvider.apiCalled = true;
              await webinarOtpProvider.verifyWebinarOtp().then((value) {

                if(value) {
                  if(webinarOtpProvider.webinarOtpData.isQuestionaireSolved == true) {
                    webinarOtpProvider.apiCalled = false;
                    userConfigProvider.getUserConfigData();
                    print("before webinar otp verified popup");

                    print("after webinar otp verified popup");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                        const SettingPage(),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Webinar Otp Verified successfully"),
                      ),
                    );
                  } else {

                    webinarOtpProvider.apiCalled = false;
                    navigationProvider.previousSelectedIndex = navigationProvider.selectedIndex;
                    navigationProvider.selectedIndex = 23;
                    userConfigProvider.getUserConfigData();

                  }


                }
              });
            }

          },
          onChanged: (value) {
            print(value);
            if(value.length == 8) {

            }
          },
          beforeTextPaste: (text) {
            print("Allowing to paste $text");
            return true;
          },
          appContext: context,
        ),



        (showOtpFieldError)?SizedBox(
          height: 3,
        ):Container(),

        (showOtpFieldError)?Text(
          otpFieldError,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xffd41f1f)
          ),
        ):Container(),

      ],
    );
  }
}
