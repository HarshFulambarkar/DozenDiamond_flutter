import 'dart:io';

import 'package:dozen_diamond/Settings/models/multiple_ladder_support_request.dart';
import 'package:dozen_diamond/Settings/screens/trading_options_info.dart';
import 'package:dozen_diamond/Settings/services/settings_rest_api_service.dart';
import 'package:dozen_diamond/Settings/stateManagement/setting_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/kyc/kyc_main.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import 'package:dozen_diamond/global/widgets/my_text_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:dozen_diamond/Settings/widgets/switch_trading.dart';

import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../depositories_verification/screens/depositories_verification_section.dart';
import '../../formula_section/screens/formula_screen.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/helper.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../../global/widgets/customer_support_dialog.dart';
import '../../kyc/screens/verify_aadhaar_screen.dart';
import '../../login/services/login_rest_api_service.dart';
import '../../manage_brokers/screens/broker_list.dart';
import '../../navigateAuthentication/screens/navigate_authentication_screen.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../../subscriptions/screens/subscribed_screen.dart';
import '../../subscriptions/screens/subscriptions_list_screen.dart';
import '../../subscriptions/stateManagement/subscription_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var switchOnOff = false;
  ThemeProvider? _themeProvider;
  late ThemeProvider themeProvider;
  TradeMainProvider? _tradeMainProvider;
  TextStyle checkerFont = TextStyle(fontSize: 16);
  late SettingProvider settingProvider;
  late SubscriptionProvider subscriptionProvider;
  late AppConfigProvider appConfigProvider;
  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late UserConfigProvider userConfigProvider;
  //
  late CurrencyConstants currencyConstants;

  @override
  void initState() {
    super.initState();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _tradeMainProvider = Provider.of(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserConfigProvider userConfigProvider = Provider.of<UserConfigProvider>(context, listen: false);
      userConfigProvider.getUserConfigData();
      callInitialApi();
    });
  }

  void callInitialApi() async {
    try {
      _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  Future<void> getUserLadderSupportSettings() async {
    try {
      await SettingRestApiService().getMultipleLadderSupport().then((res) {
        if (res?.status == true) {
          setState(() {
            switchOnOff = res?.data?.regMultipleLadderSupport ?? false;
          });
        }
      });
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  Future<void> userLadderSetting() async {
    try {
      await SettingRestApiService()
          .multipleLadderSupport(MultipleLadderSupportRequest(
        regMultipleLadderSupport: switchOnOff,
      ))
          .then((res) {
        if (res?.status == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                res?.msg ?? "",
              ),
            ),
          );
        }
      });
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  Widget ladderOption() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ladder options", style: TextStyle(fontSize: 17)),
          SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("Ladder Creation Type"),
                Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(children: [
                        Text("Easy"),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Checkbox(
                            tristate: true, // Example with tristate
                            value:
                                (settingProvider.selectedLadderCreationType ==
                                    "beginner"),
                            activeColor: Colors.blue,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue),
                            onChanged: (bool? newValue) async {
                              settingProvider.selectedLadderCreationType =
                                  "beginner";
                              await SharedPreferenceManager
                                  .saveLadderCreationType(settingProvider
                                      .selectedLadderCreationType);
                            },
                          ),
                        ),
                      ]),
                      Row(children: [
                        Text("Detailed"),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Checkbox(
                            tristate: true, // Example with tristate
                            value:
                                (settingProvider.selectedLadderCreationType ==
                                    "advance"),
                            activeColor: Colors.blue,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue),
                            onChanged: (bool? newValue) async {
                              settingProvider.selectedLadderCreationType =
                                  'advance';
                              await SharedPreferenceManager
                                  .saveLadderCreationType(settingProvider
                                      .selectedLadderCreationType);
                            },
                          ),
                        ),
                      ]),
                      Row(children: [
                        Text("Custom"),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Checkbox(
                            tristate: true, // Example with tristate
                            value:
                                (settingProvider.selectedLadderCreationType ==
                                    "custom"),
                            activeColor: Colors.blue,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue),
                            onChanged: (bool? newValue) async {
                              settingProvider.selectedLadderCreationType =
                                  'custom';
                              await SharedPreferenceManager
                                  .saveLadderCreationType(settingProvider
                                      .selectedLadderCreationType);
                            },
                          ),
                        ),
                      ])
                    ])
              ])
        ],
      ),
    );
  }

  Widget themeChanger() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Theme",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Default", style: checkerFont),
                Consumer<ThemeProvider>(builder: (context, value, child) {
                  return Radio<ThemeController>(
                      value: ThemeController.Dark,
                      groupValue: value.themeController,
                      onChanged: (value) {
                        _themeProvider?.themeController = value!;

                        _themeProvider?.defaultTheme = false;
                      });
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Light", style: checkerFont),
                Consumer<ThemeProvider>(builder: (context, value, child) {
                  return Radio<ThemeController>(
                      value: ThemeController.Light,
                      groupValue: value.themeController,
                      onChanged: (value) {
                        _themeProvider?.themeController = value!;

                        _themeProvider?.defaultTheme = true;
                      });
                }),
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  Widget buildFontSizeSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15, top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // settingProvider.isThemeExpanded =
              // !settingProvider.isThemeExpanded;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.font_download,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Font Size",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 15,
                    color: (settingProvider.isThemeExpanded)
                        ? Colors.blue
                        : Colors.white)
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          (true)
              ? Row(
            children: [
              Row(
                children: [
                  Consumer<ThemeProvider>(
                      builder: (context, value, child) {
                        return Radio<TextScaleFactorController>(
                            value: TextScaleFactorController.Small,
                            groupValue: value.textScaleFactorController,
                            onChanged: (value) {
                              _themeProvider?.textScaleFactorController = value!;
                              _themeProvider?.textScaleFactor = 0.9;
                              _themeProvider?.saveScaleFactor();

                            });
                      }),
                  Text("Small", style: checkerFont),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  Consumer<ThemeProvider>(
                      builder: (context, value, child) {
                        return Radio<TextScaleFactorController>(
                            value: TextScaleFactorController.Medium,
                            groupValue: value.textScaleFactorController,
                            onChanged: (value) {
                              _themeProvider?.textScaleFactorController = value!;

                              _themeProvider?.textScaleFactor = 1;
                              _themeProvider?.saveScaleFactor();
                            });
                      }),
                  Text("Medium", style: checkerFont),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  Consumer<ThemeProvider>(
                      builder: (context, value, child) {
                        return Radio<TextScaleFactorController>(
                            value: TextScaleFactorController.Large,
                            groupValue: value.textScaleFactorController,
                            onChanged: (value) {
                              _themeProvider?.textScaleFactorController = value!;

                              _themeProvider?.textScaleFactor = 1.1;
                              _themeProvider?.saveScaleFactor();
                            });
                      }),
                  Text("Large", style: checkerFont),
                ],
              ),
            ],
          )
              : Container(),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget multipleLadder() {
    Widget header(String title) {
      return Container(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            StatefulBuilder(
              builder: (context, setLocalState) {
                return Switch(
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                  activeColor: const Color(0xFF0099CC),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: switchOnOff,
                  onChanged: (value) async {
                    setLocalState(() {
                      switchOnOff = value;
                    });
                    await userLadderSetting();
                  },
                );
              },
            )
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: const Text("Ladder Creation",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 10.0,
        ),
        header(
          "Enable Multiple Ladder Creation",
        ),
        const SizedBox(
          height: 30.0,
        )
      ],
    );
  }

  Widget displaySettings(Function targetfunction) {
    return Container(
        padding: EdgeInsets.only(left: 15), child: targetfunction());
  }

  Widget tradingOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Trading Options",
              style: TextStyle(fontSize: 17),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TradingOptionsInfo()));
              },
              icon: Icon(Icons.info_outline),
              iconSize: 20,
            )
          ],
        ),
        switchTarding(),
      ],
    );
  }

  Widget switchCountry() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Country options", style: TextStyle(fontSize: 17)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Switch to USAS"),
            Switch(
              value: currencyConstants.isCountryUsa,
              onChanged: (value) {
                currencyConstants.isCountryUsa = value;
              },
              inactiveTrackColor: Colors.grey,
              inactiveThumbColor: Colors.white,
              activeColor: const Color(0xFF0099CC),
            )
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    currencyConstants = Provider.of<CurrencyConstants>(context, listen: true);
    settingProvider = Provider.of<SettingProvider>(context, listen: true);
    subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    userConfigProvider = Provider.of<UserConfigProvider>(context, listen: true);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  color: (themeProvider.defaultTheme)
                      ? Color(0XFFF5F5F5)
                      : Colors.transparent,
                  width: screenWidth == 0 ? null : screenWidth,
                  child: Padding(
                    // padding: const EdgeInsets.only(top: 60.0),
                    padding: const EdgeInsets.only(top: 45.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // header(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, top: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.settings,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Settings",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 25,
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),

                        (appConfigProvider.appConfigData.data?.themeEnable! ==
                                false)
                            ? Container()
                            : themeChangeNew(),

                        (false)
                            ? Container()
                            : DepositoriesVerificationSection(),

                        (false)
                            ? Container()
                            : buildFontSizeSection(),

                        (appConfigProvider
                                    .appConfigData.data?.tradingOptionEnable! ==
                                false)
                            ? Container()
                            : tradingOptionNew(),

                        (appConfigProvider
                                    .appConfigData.data?.countryOptionEnable! ==
                                false)
                            ? Container()
                            : countryOptionNew(),

                        (appConfigProvider
                                    .appConfigData.data?.ladderOptionEnable! ==
                                false)
                            ? Container()
                            : ladderOptionsNew(),

                        // displaySettings(themeChanger),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // displaySettings(tradingOptions),
                        //
                        // // mainContent(),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // switchCountry(),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // ladderOption(),

                        (appConfigProvider
                                    .appConfigData.data?.subscriptionEnable! ==
                                false)
                            ? Container()
                            : subscriptionOption(context),

                        (appConfigProvider
                                    .appConfigData.data?.manageBrokersEnable! ==
                                false)
                            ? Container()
                            : manageBrokersOption(context),

                        (appConfigProvider.appConfigData.data
                                    ?.contactCustomerSupportEnable! ==
                                false)
                            ? Container()
                            : contactCustomerSupportOption(context),

                        (appConfigProvider.appConfigData.data?.kycEnable! ==
                                false)
                            ? Container()
                            : kycOption(context),

                        (appConfigProvider.appConfigData.data?.formulaEnable! ==
                                false)
                            ? Container()
                            : formulaSectionOption(context),

                        deleteAccountSectionOption(context),

                        SizedBox(
                          height: 20,
                        ),
                        // displaySettings(multipleLadder),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: CustomHomeAppBarWithProviderNew(
                  backButton: true,
                  widthOfWidget: screenWidth,
                  isForPop:
                      true, //these leadingAction button is not working, I have tired making it work, but it isn't.
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget themeChangeNew() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              settingProvider.isThemeExpanded =
                  !settingProvider.isThemeExpanded;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.contrast,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Theme",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 15,
                    color: (settingProvider.isThemeExpanded)
                        ? Colors.blue
                        : Colors.white)
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          (settingProvider.isThemeExpanded)
              ? Row(
                  children: [
                    Row(
                      children: [
                        Consumer<ThemeProvider>(
                            builder: (context, value, child) {
                          return Radio<ThemeController>(
                              value: ThemeController.Dark,
                              groupValue: value.themeController,
                              onChanged: (value) {
                                _themeProvider?.themeController = value!;

                                _themeProvider?.defaultTheme = false;
                              });
                        }),
                        Text("Default", style: checkerFont),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Consumer<ThemeProvider>(
                            builder: (context, value, child) {
                          return Radio<ThemeController>(
                              value: ThemeController.Light,
                              groupValue: value.themeController,
                              onChanged: (value) {
                                _themeProvider?.themeController = value!;

                                _themeProvider?.defaultTheme = true;
                              });
                        }),
                        Text("Light", style: checkerFont),
                      ],
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget tradingOptionNew() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              settingProvider.isTradingOptionsExpanded =
                  !settingProvider.isTradingOptionsExpanded;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_graph,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Trading Options",
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TradingOptionsInfo()));
                      },
                      icon: Icon(Icons.info_outline),
                      iconSize: 20,
                    )
                  ],
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 15,
                    color: (settingProvider.isTradingOptionsExpanded)
                        ? Colors.blue
                        : Colors.white)
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          (settingProvider.isTradingOptionsExpanded)
              ? switchTarding()
              : Container(),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget countryOptionNew() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              settingProvider.isCountryOptionsExpanded =
                  !settingProvider.isCountryOptionsExpanded;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.map,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Country Options",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 15,
                    color: (settingProvider.isCountryOptionsExpanded)
                        ? Colors.blue
                        : Colors.white)
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          (settingProvider.isCountryOptionsExpanded)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text("Switch to USA"),
                      Switch(
                        value: currencyConstants.isCountryUsa,
                        onChanged: (value) {
                          currencyConstants.isCountryUsa = value;
                        },
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.white,
                        activeColor: const Color(0xFF0099CC),
                      )
                    ])
              : Container(),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget ladderOptionsNew() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              settingProvider.isLadderOptionExpanded =
                  !settingProvider.isLadderOptionExpanded;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "lib/global/assets/logos/ladder.png",
                      width: 20,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    // Icon(
                    //     Icons.stairs_outlined,
                    //     size: 20
                    // ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Ladder Options",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 15,
                    color: (settingProvider.isLadderOptionExpanded)
                        ? Colors.blue
                        : Colors.white)
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          (settingProvider.isLadderOptionExpanded)
              ? Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Easy", style: TextStyle(fontSize: 16)),
                      Switch(
                        value: (settingProvider.selectedLadderCreationType ==
                            "beginner"),
                        onChanged: (value1) async {
                          settingProvider.selectedLadderCreationType =
                              "beginner";
                          await SharedPreferenceManager.saveLadderCreationType(
                              settingProvider.selectedLadderCreationType);
                        },
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.white,
                        activeColor: const Color(0xFF0099CC),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Detailed", style: TextStyle(fontSize: 16)),
                      Switch(
                        value: (settingProvider.selectedLadderCreationType ==
                            "advance"),
                        onChanged: (value1) async {
                          settingProvider.selectedLadderCreationType =
                              'advance';
                          await SharedPreferenceManager.saveLadderCreationType(
                              settingProvider.selectedLadderCreationType);
                        },
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.white,
                        activeColor: const Color(0xFF0099CC),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Custom", style: TextStyle(fontSize: 16)),
                      Switch(
                        value: (settingProvider.selectedLadderCreationType ==
                            "custom"),
                        onChanged: (value1) async {
                          settingProvider.selectedLadderCreationType = 'custom';
                          await SharedPreferenceManager.saveLadderCreationType(
                              settingProvider.selectedLadderCreationType);
                        },
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.white,
                        activeColor: const Color(0xFF0099CC),
                      ),
                    ],
                  ),
                ])
              : Container(),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget subscriptionOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {

              if (userConfigProvider.userConfigData.userSubscriptionVerified ??
                  false) {
                subscriptionProvider.getSubscribedDetails(context);
                subscriptionProvider.getSubscriptionPlans();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SubscriptionsListScreen(),
                  ),
                );
              } else {
                subscriptionProvider.getSubscriptionPlans();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SubscriptionsListScreen(),
                  ),
                );
              }


              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => SubscribedScreen(),
              //   ),
              // );

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.subscriptions,
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Subscriptions",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.blue)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget manageBrokersOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BrokerList(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.manage_accounts,
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Manage Brokers",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.blue)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget contactCustomerSupportOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              settingProvider.subjectTextEditingController.clear();
              settingProvider.messageTextEditingController.clear();
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) => contactCustomerSupportDialog(context),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.contact_page,
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Contact Customer Support",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.blue)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget formulaSectionOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FormulaScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.equalizer,
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Formula",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.blue)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget kycOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VerifyAadhaarScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.verified,
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Kyc",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.blue)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  // Widget contactCustomerSupportDialog(BuildContext context) {
  //   double screenWidth = screenWidthRecognizer(context);
  //   return Dialog(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     child: Container(
  //       width: screenWidth - 40,
  //       padding: const EdgeInsets.only(bottom: 5),
  //       // width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: Color(
  //             0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
  //         borderRadius: BorderRadius.circular(20),
  //         border: Border.all(
  //           color: Colors.white54,
  //         ),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.symmetric(
  //                   vertical: 20,
  //                   horizontal: 10,
  //                 ),
  //                 child: const Text(
  //                   "Contact Customer Support",
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(mainAxisSize: MainAxisSize.min, children: [
  //
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       border: Border.all(
  //                         color: themeProvider.defaultTheme ? Colors.black : Colors.white,
  //                       ),
  //                       borderRadius: BorderRadius.circular(5),
  //                     ),
  //                     padding: EdgeInsets.symmetric(horizontal: 10),
  //                     height: 45,
  //                     margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
  //                     child: Consumer<SettingProvider>(builder: (context, value, child) {
  //                       return DropdownButtonHideUnderline(
  //                         child: DropdownButton<String>(
  //                           padding: EdgeInsets.zero,
  //                           iconSize: 24.0,
  //                           hint: Text(value.selectedContactSupportCategory,
  //                             style: TextStyle(
  //                                 color: (themeProvider.defaultTheme)?Colors.black:Colors.white
  //                             ),
  //                           ),
  //                           value: value.selectedContactSupportCategory,
  //                           onChanged: (valuee) {
  //                             setState(() {
  //                               value.selectedContactSupportCategory = valuee ?? "";
  //                             });
  //
  //                           },
  //                           dropdownColor: themeProvider.defaultTheme ? Colors.white : Colors.black,
  //                           items: [
  //                             "Select Category",
  //                             "Ladder Creation",
  //                             "Orders",
  //                             "Analytics",
  //                             "Watchlist",
  //                             "Report a Bug",
  //                             "Feedback",
  //                             "Suggestion",
  //                           ].map(
  //                                 (String? option) => DropdownMenuItem<String>(
  //                               child: Text(option!),
  //                               value: option,
  //                             ),
  //                           )
  //                               .toList(),
  //                         ),
  //                       );
  //                     }
  //                     ),
  //                   ),
  //
  //                   Consumer<SettingProvider>(builder: (context, value, child) {
  //                     return Padding(
  //                       padding: const EdgeInsets.only(right: 4.0),
  //                       child: Column(
  //                         children: [
  //                           (kIsWeb)?Container():(value.bugImage != null)?Container():InkWell(
  //                             onTap: () async {
  //                               final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 10);
  //
  //                               if(image!.path.split(".").last == "png" || image.path.split(".").last == "PNG" || image.path.split(".").last == "jpeg" || image.path.split(".").last == "jpg"){
  //                                 // verificationController.droneImage1.value = File(image.path);
  //                                 value.bugImage = File(image.path);
  //
  //                               }else{
  //                                 ScaffoldMessenger.of(context).showSnackBar(
  //                                   SnackBar(content: Text('Invalid Image format')),
  //                                 );
  //                               }
  //                             },
  //                             child: Row(
  //                               children: [
  //                                 Icon(
  //                                   Icons.attach_file,
  //                                   size: 20,
  //                                 ),
  //
  //                                 // Image.asset(
  //                                 //   AssetConstants.attacheIconImage,
  //                                 //   height: 20,
  //                                 //   width: 20,
  //                                 // ),
  //
  //                                 SizedBox(
  //                                   width: 5,
  //                                 ),
  //
  //                                 Text(
  //                                   "Add Attachment",
  //                                   textScaleFactor: 0.9,
  //                                   style: GoogleFonts.inter(
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.w500
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //
  //                           (value.bugImage != null)?Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //
  //                               SizedBox(
  //                                 height: 5,
  //                               ),
  //
  //                               Text(
  //                                 "Image -1",
  //                                 textScaleFactor: 0.9,
  //                                 style: GoogleFonts.inter(
  //                                     fontSize: 14,
  //                                     color: (themeProvider.defaultTheme)?Colors.black:Colors.white
  //                                 ),
  //                               ),
  //
  //                               SizedBox(
  //                                 height: 4,
  //                               ),
  //
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Container(
  //                                     width: 80,
  //                                     child: Text(
  //                                       "${value.bugImage?.path.split('/').last}",
  //                                       textScaleFactor: 0.9,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: GoogleFonts.inter(
  //                                           fontSize: 10,
  //                                           color: (themeProvider.defaultTheme)?Colors.black:Colors.white
  //
  //                                       ),
  //                                     ),
  //                                   ),
  //
  //                                   Row(
  //                                     children: [
  //                                       InkWell(
  //                                         onTap: () {
  //                                           // value.bugImage = File("");
  //                                           value.bugImage = null;
  //                                           // verificationController.droneImages.removeAt(index);
  //                                         },
  //                                         child: Icon(
  //                                           Icons.delete,
  //                                           size: 16,
  //                                         ),
  //                                         // child: Image.asset(
  //                                         //   AssetConstants.deleteIconImage,
  //                                         //   height: 16,
  //                                         // ),
  //                                       ),
  //
  //                                       // SizedBox(
  //                                       //   width: 16,
  //                                       // ),
  //                                       //
  //                                       // Icon(
  //                                       //   Icons.check_circle,
  //                                       //   size: 16,
  //                                       // )
  //
  //                                       // Image.asset(
  //                                       //   AssetConstants.circleCheckImage,
  //                                       //   height: 16,
  //                                       // )
  //                                     ],
  //                                   )
  //                                 ],
  //                               ),
  //                             ],
  //                           ):Container(),
  //                         ],
  //                       ),
  //                     );
  //                   }
  //                   )
  //                 ],
  //               ),
  //
  //               MyTextField(
  //                   isFilled: true,
  //                   fillColor: (themeProvider.defaultTheme)
  //                       ? Color(0xffCACAD3)
  //                       : Color(0xff2c2c31),
  //                   borderColor: (themeProvider.defaultTheme)
  //                       ? Color(0xffCACAD3)
  //                       : Color(0xff2c2c31),
  //                   elevation: 0,
  //                   isLabelEnabled: false,
  //                   controller: settingProvider.subjectTextEditingController,
  //                   borderWidth: 1,
  //                   // fillColor: Colors.transparent,
  //                   contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
  //                   borderRadius: 5,
  //                   labelText: "Subject",
  //                   maxLine: 1,
  //                   // borderColor: Colors.white,
  //                   focusedBorderColor: Colors.white,
  //                   onChanged: (value) {}),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               MyTextField(
  //                   controller: settingProvider.messageTextEditingController,
  //                   isFilled: true,
  //                   fillColor: (themeProvider.defaultTheme)
  //                       ? Color(0xffCACAD3)
  //                       : Color(0xff2c2c31),
  //                   borderColor: (themeProvider.defaultTheme)
  //                       ? Color(0xffCACAD3)
  //                       : Color(0xff2c2c31),
  //                   elevation: 0,
  //                   isLabelEnabled: false,
  //                   borderWidth: 1,
  //                   // fillColor: Colors.transparent,
  //                   contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
  //                   borderRadius: 5,
  //                   labelText: "Message",
  //                   maxLine: 5,
  //                   // borderColor: Colors.white,
  //                   focusedBorderColor: Colors.white,
  //                   onChanged: (value) {})
  //             ]),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 12.0, right: 12),
  //             child: Row(
  //               children: [
  //                 SizedBox(
  //                   width: 5,
  //                 ),
  //                 Expanded(
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text(
  //                       'Cancel',
  //                       style: TextStyle(fontSize: 16, color: Colors.white),
  //                     ),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.red,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //                 Expanded(
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       if (settingProvider.subjectTextEditingController.text !=
  //                               "" &&
  //                           settingProvider.messageTextEditingController.text !=
  //                               "") {
  //                         final value =
  //                             await settingProvider.sendContactSupportMain(
  //                                 settingProvider
  //                                     .subjectTextEditingController.text,
  //                                 settingProvider
  //                                     .messageTextEditingController.text);
  //
  //                         if (value == "true") {
  //                           Navigator.pop(context);
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(
  //                               content: Text("Mail sent successfully"),
  //                             ),
  //                           );
  //                         } else {
  //                           Navigator.pop(context);
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(
  //                               content: Text(value),
  //                             ),
  //                           );
  //                         }
  //                       } else {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(
  //                             content: Text("Please enter subject and message"),
  //                           ),
  //                         );
  //                       }
  //                     },
  //                     child: Text('Send',
  //                         style: TextStyle(fontSize: 16, color: Colors.white)),
  //                     style: ElevatedButton.styleFrom(
  //                       side: BorderSide(color: Colors.blue),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 5,
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget contactCustomerSupportDialog(BuildContext context) {
    return CustomerSupportDialog();
  }

  Widget deleteAccountSectionOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (contextt) {
                    return AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 10,
                          left: 20,
                          right: 20,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Are you sure you want to delete your account",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(contextt).pop();
                                      SharedPreferences.getInstance()
                                          .then((value) async {
                                        LoginRestApiService().signOutGoogle();
                                        LoginRestApiService().deleteAccount(
                                            {}).then((valuee) async {
                                          await value.remove("reg_id");
                                          await value.remove("reg_user");
                                          print("came here");
                                          // Navigator.of(context).pop();
                                          navigateAuthenticationProvider.selectedIndex = 1;

                                          print("came here before navigating");
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           NavigateAuthenticationScreen()), // this removes all previous routes
                                          // );
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NavigateAuthenticationScreen()),
                                            (Route<dynamic> route) =>
                                                false, // this removes all previous routes
                                          );

                                          Fluttertoast.showToast(
                                              msg:
                                              "Successfully deleted the account");
                                        });
                                      });
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: Color(0xFF0099CC),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "No",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Delete Account",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.blue)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }
}
