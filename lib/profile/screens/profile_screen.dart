import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer_new.dart';
import 'package:dozen_diamond/ZL_Register/constants/countryCodeFlags.dart';
import 'package:dozen_diamond/ZL_Register/models/country_state_model.dart';
import 'package:dozen_diamond/ZL_Register/models/mobile_number_codes_model.dart';
import 'package:dozen_diamond/global/widgets/shimmer_loading_view.dart';
import 'package:dozen_diamond/profile/widgets/country_state_city_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../../global/widgets/custom_bottom_sheets.dart';
import '../../global/widgets/my_text_field.dart';
import '../../localization/translation_keys.dart';
import '../stateManagement/profile_provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ProfileScreen extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  ProfileScreen({
    super.key,
    this.isAuthenticationPresent = false,
    required this.updateIndex,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with CodeAutoFill {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late ThemeProvider themeProvider;
  late NavigationProvider navigationProvider;
  late ProfileProvider profileProvider;
  late UserConfigProvider userConfigProvider;

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  // @override
  // void initState() {
  //   super.initState();
  //
  //   // profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   //   profileProvider.getProfileData();
  //   // });
  //
  //   _listenForOtp();
  //
  // }

  CountryStateCityData cscData = CountryStateCityData();

  String? _country = "India";
  String? _state;
  City? _city;

  loadCountries() async {
    await cscData.load();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _state = profileProvider.profileData.regUserState;
    final cities = cscData.citiesOf(_country!, _state!);
    _city = cities.firstWhere((city) {
      return city.name == profileProvider.profileData.regUserCity;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCountries();
    // profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   profileProvider.getProfileData();
    // });

    _listenForOtp();
  }

  void _listenForOtp() async {
    await SmsAutoFill().listenForCode;
    listenForCode();
  }

  @override
  void codeUpdated() {
    setState(() {
      print(code);
    });

    // submit otp here
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    profileProvider = Provider.of<ProfileProvider>(context, listen: true);
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
                  drawer: NavDrawerNew(
                    updateIndex: widget.updateIndex,
                  ),
                  key: _key,
                  backgroundColor: (themeProvider.defaultTheme)
                      ? Color(0XFFF5F5F5)
                      : Color(0xFF15181F),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 45),
                            SizedBox(height: 10),

                            SizedBox(height: 10),

                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    TranslationKeys.myProfile,
                                    style: TextStyle(
                                      fontFamily: 'Britanica',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: (themeProvider.defaultTheme)
                                          ? Color(0xff141414)
                                          : Color(0xfff0f0f0),
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () async {
                                      profileProvider.isEditProfileEnable =
                                      !profileProvider.isEditProfileEnable;
                                      // profileProvider.isProfileLoading = !profileProvider.isProfileLoading;
                                      if (profileProvider.isEditProfileEnable) {
                                        profileProvider.fillDataInTextField();
                                      } else {
                                        await profileProvider.updateProfile();
                                        profileProvider.resetDataInTextField();
                                      }
                                    },
                                    child: (profileProvider.isEditProfileEnable)
                                        ? Text(
                                      TranslationKeys.saveChanges,
                                      style: TextStyle(
                                        fontFamily: 'Britanica',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color:
                                        (themeProvider.defaultTheme)
                                            ? Color(0xff0090ff)
                                            : Color(0xff0090ff),
                                      ),
                                    )
                                        : Text(
                                      TranslationKeys.edit,
                                      style: TextStyle(
                                        fontFamily: 'Britanica',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color:
                                        (themeProvider.defaultTheme)
                                            ? Color(0xff0090ff)
                                            : Color(0xff0090ff),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),

                            buildProfilePicSection(context),

                            SizedBox(height: 25),

                            // (profileProvider.isEditProfileEnable)
                            //     ?buildEditProfileSection(context, screenWidth)
                            //     :buildProfileDetailSection(context, screenWidth),
                            buildProfileDetailSection(context, screenWidth),

                            SizedBox(height: 25),

                            (userConfigProvider.userConfigData.phoneVerified ==
                                false)
                                ? buildVerifyPhoneNumberSection(
                              context,
                              screenWidth,
                            )
                                : Container(),
                          ],
                        ),
                      ),

                      CustomHomeAppBarWithProviderNew(
                        backButton: true,
                        backIndex: navigationProvider.previousSelectedIndex,
                        leadingAction: _triggerDrawer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfilePicSection(BuildContext context) {
    return (profileProvider.isProfileLoading)
        ? (themeProvider.defaultTheme)
        ? ShimmerLoadingView.circularLoadingViewDark(40)
        : ShimmerLoadingView.circularLoadingView(40)
        : CustomContainer(
      padding: 0,
      borderRadius: 50,
      backgroundColor: Color(0xffebfbfe),
      child: Icon(Icons.person, color: Color(0xff0b87ac), size: 80),
    );
  }

  Widget buildProfileDetailSectionLoading(
      BuildContext context,
      double screenWidth,
      ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(60, 25)
                  : ShimmerLoadingView.loadingContainer(60, 25),

              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(
                screenWidth * 0.6,
                25,
              )
                  : ShimmerLoadingView.loadingContainer(screenWidth * 0.6, 25),
            ],
          ),
        ),

        SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(60, 25)
                  : ShimmerLoadingView.loadingContainer(60, 25),

              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(
                screenWidth * 0.6,
                25,
              )
                  : ShimmerLoadingView.loadingContainer(screenWidth * 0.6, 25),
            ],
          ),
        ),

        SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(60, 25)
                  : ShimmerLoadingView.loadingContainer(60, 25),

              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(
                screenWidth * 0.6,
                25,
              )
                  : ShimmerLoadingView.loadingContainer(screenWidth * 0.6, 25),
            ],
          ),
        ),

        SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(60, 25)
                  : ShimmerLoadingView.loadingContainer(60, 25),

              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(
                screenWidth * 0.6,
                25,
              )
                  : ShimmerLoadingView.loadingContainer(screenWidth * 0.6, 25),
            ],
          ),
        ),

        SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(60, 25)
                  : ShimmerLoadingView.loadingContainer(60, 25),

              (themeProvider.defaultTheme)
                  ? ShimmerLoadingView.loadingContainerDark(
                screenWidth * 0.6,
                25,
              )
                  : ShimmerLoadingView.loadingContainer(screenWidth * 0.6, 25),
            ],
          ),
        ),

        SizedBox(height: 20),
      ],
    );
  }

  Widget buildProfileDetailSection(BuildContext context, double screenWidth) {
    List<Map<String, dynamic>> profileDataMap = [
      {
        "title": TranslationKeys.name,
        "value": profileProvider.profileData.regUsername ?? "-",
        "isEditable": true,
      },
      {
        "title": TranslationKeys.phoneNumber,
        "value": profileProvider.profileData.regMobile ?? "-",
        "isEditable": false,
      },
      {
        "title": TranslationKeys.email,
        "value": profileProvider.profileData.regEmail ?? "-",
        "isEditable": false,
      },
      {
        "title": TranslationKeys.country,
        "value": profileProvider.profileData.regCountry ?? "-",
        "isEditable": false,
      },
      {
        "title": TranslationKeys.state,
        "value": profileProvider.profileData.regUserState ?? "-",
        "isEditable": true,
      },
      {
        "title": TranslationKeys.city,
        "value": profileProvider.profileData.regUserCity ?? "-",
        "isEditable": true,
      },

      {
        "title": TranslationKeys.joinedOn,
        "value":
        "${DateFormat('dd.MM.yyyy').format(DateTime.parse(profileProvider.profileData.regDateTime ?? DateTime.now().toString()))}",
        "isEditable": false,
      },
      {
        "title": TranslationKeys.brokerDetails,
        "value": profileProvider.profileData.brokerName ?? "-",
        "isEditable": false,
      },
      {
        "title": TranslationKeys.clientCode,
        "value": profileProvider.profileData.clientCode ?? "-",
        "isEditable": false,
      },
      {
        "title": TranslationKeys.subscription,
        "value": profileProvider.profileData.subscription ?? "-",
        "isEditable": false,
      },
      {
        "title": TranslationKeys.nameAsPerBroker,
        "value": profileProvider.profileData.nameAsPerBroker ?? "-",
        "isEditable": false,
      },
    ];

    Widget buildEditField(String title) {
      switch (title) {
        case TranslationKeys.name:
          return SizedBox(
            height: 33,
            width: screenWidth * 0.7,
            child: MyTextField(
              isFilled: true,
              fillColor: (themeProvider.defaultTheme)
                  ? Color(0xffDADDE6)
                  : Colors.transparent,
              labelText: "",
              maxLength: 50,
              elevation: 0,
              controller: profileProvider.nameTextEditingController,
              textInputFormatters: <TextInputFormatter>[
                // FilteringTextInputFormatter.allow(
                //   RegExp(r'^[0-9,\.]+$'),
                // ),
                // NumberToCurrencyFormatter()
              ],
              keyboardType: TextInputType.text,
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: (themeProvider.defaultTheme)
                    ? Colors.black
                    : Color(0xfff0f0f0),
              ),
              borderColor: (themeProvider.defaultTheme)
                  ? Color(0xffDADDE6)
                  : Color(0xff2c2c31),
              margin: EdgeInsets.zero,
              contentPadding: EdgeInsets.only(left: 12, bottom: 5),
              focusedBorderColor: Color(0xff5cbbff),
              showLeadingWidget: false,
              showTrailingWidget: false,

              prefixText: "", //currencyConstants.currency,

              counterText: "",
              borderRadius: 8,
              hintText: '',
              onChanged: (value) {},
              onFieldSubmitted: (value) {},
            ),
          );
        case TranslationKeys.country:
          return CountryDropdown(
            data: cscData,
            value: _country,
            onChanged: (val) {
              setState(() {
                _country = val;
                _state = null;
                _city = null;
              });
            },
          );
        case TranslationKeys.state:
          return StateDropdown(
            data: cscData,
            selectedCountry: _country,
            value: _state,
            onChanged: (val) {
              setState(() {
                _state = val;
                _city = null;
                profileProvider.state = val;
                profileProvider.city = null;
              });
            },
          );
        case TranslationKeys.city:
          return CityDropdown(
            data: cscData,
            selectedCountry: _country,
            selectedState: _state,
            value: _city,
            onChanged: (val) {
              setState(() {
                _city = val;
                profileProvider.city = val;
              });
            },
          );
        default:
          return Container();
      }
    }

    return (profileProvider.isProfileLoading)
        ? buildProfileDetailSectionLoading(context, screenWidth)
        : ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: profileDataMap.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 20);
      },
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  profileDataMap[index]['title'].toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ? Color(0xff141414)
                        : Color(0xfff0f0f0),
                  ),
                ),
              ),
              (profileDataMap[index]['isEditable'] &&
                  profileProvider.isEditProfileEnable)
                  ? buildEditField(profileDataMap[index]['title'])
                  : Expanded(
                    flex: 5,
                    child: Text(
                                    profileDataMap[index]['value'].toString(),
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ? Color(0xff141414)
                        : Color(0xfff0f0f0),
                                    ),
                                  ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget buildVerifyPhoneNumberSection(
      BuildContext context,
      double screenWidth,
      ) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12.0, bottom: 0),
      child: CustomContainer(
        borderRadius: 15,
        // backgroundColor: Color(0xff28282a),
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0xffdadde6)
            : Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            color: (themeProvider.defaultTheme)
                                ? Color(0xff141414)
                                : Color(0xfff0f0f0),
                            size: 16,
                          ),

                          SizedBox(width: 5),

                          Text(
                            'Verify your phone number',
                            // "Basic Plan",
                            style: GoogleFonts.poppins(
                              color: (themeProvider.defaultTheme)
                                  ? Color(0xff141414)
                                  : Color(0xfff0f0f0),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Container(
                        width: screenWidthRecognizer(context) * 0.8,
                        child: Text(
                          'We will send you a verification code on your phone number',

                          // "You will get full app access with paper trading in this plan.",
                          style: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ? Color(0xff141414)
                                : Color(0xffa2b0bc), //Color(0xff545455),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            // Optional: limits the text to 2 lines
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Icon(
                  //   CupertinoIcons.cube_box,
                  //   color: Colors.white,
                  //   size: 20,
                  // )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          profileProvider.sendVerifyPhoneNumberOtp(context);
                          double screenWidth = screenWidthRecognizer(context);
                          CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                            buildPhoneOtpBottomSheet(context, screenWidth),
                            context,
                            height: 260,
                          );
                        },
                        child: Text(
                          "Verify",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1a94f2),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPhoneOtpBottomSheet(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: (themeProvider.defaultTheme)
            ? Color(0xfff0f0f0)
            : Color(0xff1d1d1f),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 22),

            // Icon(
            //   Icons.money_outlined,
            //   color: Color(0xff0090ff),
            //   size: 35,
            // ),
            //
            // SizedBox(
            //   height: 12,
            // ),
            Text(
              "Enter OTP",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: (themeProvider.defaultTheme)
                    ? Colors.black
                    : Color(0xfff0f0f0),
              ),
            ),

            SizedBox(height: 15),

            PinCodeTextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              length: 6,
              obscureText: false,
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
              // controller: profileProvider.phoneVerifyOtpEditingController,
              onCompleted: (v) async {
                print("below is otp");
                print(v);
                profileProvider.phoneVerificationOtp = v;
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

            SizedBox(height: 22),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    profileProvider.phoneVerificationOtp = "";
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.5,
                      // color: Color(0xfff0f0f0)
                      color: Color(0xff0090ff),
                    ),
                  ),
                ),

                SizedBox(width: 22),
                //
                CustomContainer(
                  // backgroundColor: (themeProvider.defaultTheme)
                  //     ?Colors.black
                  //     :Color(0xfff0f0f0),
                  backgroundColor: Color(0xff0090ff),
                  borderRadius: 12,
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  padding: 0,
                  onTap: () async {
                    Navigator.pop(context);
                    await profileProvider.verifyPhoneNumber(context);
                    userConfigProvider.getUserConfigData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                      right: 32,
                      top: 8,
                      bottom: 8.0,
                    ),
                    child: Text(
                      "Confirm",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.5,
                        color: Color(0xfff0f0f0),
                        // color: (themeProvider.defaultTheme)
                        //     ?Color(0xfff0f0f0)
                        //     :Color(0xff1a1a25)
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}