import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../AA_positions/stateManagement/position_provider.dart';
import '../../AB_Ladder/stateManagement/ladder_provider.dart';
import '../../AC_trades/stateManagement/trades_provider.dart';
import '../../AD_Orders/stateManagement/order_provider.dart';
import '../../AE_Activity/stateManagement/activity_provider.dart';
import '../../F_Funds/stateManagement/funds_provider.dart';
import '../../Settings/screens/settings_page.dart';
import '../../Settings/stateManagement/setting_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../broker_info/stateManagement/broker_info_provider.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/helper.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../login/services/login_rest_api_service.dart';
import '../../navigateAuthentication/screens/navigate_authentication_screen.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../../profile/stateManagement/profile_provider.dart';
import '../../run_revert/screens/runRevertScreen.dart';
import '../../run_revert/stateManagement/runRevertProvider.dart';
import '../services/drawer_rest_api_service.dart';
import '../stateManagement/navigation_provider.dart';

// import 'package:dozen_diamond/AA_positions/stateManagement/position_provider.dart';
// import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
// import 'package:dozen_diamond/AC_trades/stateManagement/trades_provider.dart';
// import 'package:dozen_diamond/AD_Orders/stateManagement/order_provider.dart';
// import 'package:dozen_diamond/AE_Activity/stateManagement/activity_provider.dart';
// import 'package:dozen_diamond/DD_Navigation/services/drawer_rest_api_service.dart';
// import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
// import 'package:dozen_diamond/F_Funds/stateManagement/funds_provider.dart';
// import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
// import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
// import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
// import 'package:dozen_diamond/global/constants/currency_constants.dart';
// import 'package:dozen_diamond/global/models/http_api_exception.dart';
// import 'package:dozen_diamond/navigateAuthentication/screens/navigate_authentication_screen.dart';
// import 'package:dozen_diamond/navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
// import 'package:dozen_diamond/run_revert/screens/runRevertScreen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../Settings/stateManagement/setting_provider.dart';
// import '../../broker_info/stateManagement/broker_info_provider.dart';
// import '../../global/functions/helper.dart';
// import '../../global/functions/screenWidthRecoginzer.dart';
// import '../../global/stateManagement/app_config_provider.dart';
// import '../../global/widgets/my_text_field.dart';
// import '../../login/services/login_rest_api_service.dart';
// import '../../run_revert/stateManagement/runRevertProvider.dart';
// import '../../settings/screens/settings_page.dart';
// import 'package:url_launcher/url_launcher.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final Function? updateIndex;
  const NavigationDrawerWidget({super.key, this.updateIndex});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  String username = "";
  bool showAccountOption = false;
  LadderProvider? _ladderProvider;
  OrderProvider? _orderProvider;
  ActivityProvider? _activityProvider;
  PositionProvider? _positionProvider;
  TradesProvider? _tradesProvider;
  TradeMainProvider? _tradeMainProvider;
  FundsProvider? _fundsProvider;
  late NavigationProvider _navigationProvider;
  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late BrokerInfoProvider brokerInfoProvider;
  late AppConfigProvider appConfigProvider;
  late TradeMainProvider tradeMainProvider;
  late RunRevertProvider runRevertProvider;
  late SettingProvider settingProvider;
  late ThemeProvider themeProvider;
  late ProfileProvider profileProvider;
  late UserConfigProvider userConfigProvider;
  CustomHomeAppBarProvider? _customHomeAppBarProvider;
  CurrencyConstants? _currencyConstantsProvider;
  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _tradeMainProvider = Provider.of(context, listen: false);
    _ladderProvider = Provider.of(context, listen: false);
    _orderProvider = Provider.of(context, listen: false);
    _positionProvider = Provider.of(context, listen: false);
    _activityProvider = Provider.of(context, listen: false);
    _tradesProvider = Provider.of(context, listen: false);
    _fundsProvider = Provider.of(context, listen: false);
    _customHomeAppBarProvider = Provider.of(context, listen: false);
    _tradeMainProvider = Provider.of(context, listen: false);
    _currencyConstantsProvider = Provider.of(context, listen: false);
    SharedPreferences.getInstance().then((value) {
      setState(() {
        username = value.getString("reg_user") ?? "";
      });
    });
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userConfigProvider =
          Provider.of<UserConfigProvider>(context, listen: false);
      userConfigProvider.getUserConfigData();
    });
  }

  Future<void> showResetOptionDialog(BuildContext context, String msg) async {
    await showDialog(
      context: context,
      builder: (context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
                    Text(
                      msg,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    )
                  ],
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
                          Navigator.of(context).pop();
                          showCustomAlertDialogFromHelper(context,
                              "Are you sure you want to reset your account?",
                                  () async {
                                resetRetainSimulationAccountRequest();
                              });
                        },
                        child: const Text(
                          "Retain all ladders",
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
                          showCustomAlertDialogFromHelper(context,
                              "Are you sure you want to reset your account?",
                                  () async {
                                resetSimulationAccountRequest();
                              });
                        },
                        child: const Text(
                          "Erase all ladders",
                          style: TextStyle(
                            // color: Colors.white,
                            color: Color(0xFF0099CC),
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
      },
    );
  }

  Future<bool> resetRetainSimulationAccountRequest() async {
    try {
      String currentTradingMode = "SIMULATION-PAPER";

      if (tradeMainProvider.tradingOptions ==
          TradingOptions.simulationTradingWithSimulatedPrices) {
        currentTradingMode = "SIMULATION-PAPER";
      }

      if (tradeMainProvider.tradingOptions ==
          TradingOptions.simulationTradingWithRealValues) {
        currentTradingMode = "REALTIME-PAPER";
      }

      if (tradeMainProvider.tradingOptions ==
          TradingOptions.tradingWithRealCash) {
        currentTradingMode = "REAL";
      }

      Map<String, dynamic> request = {
        // "current_trading_mode": tradeMainProvider.tradingOptions.name,
        "current_trading_mode": currentTradingMode,
      };

      bool? res = await DrawerRestApiService().resetWithRetainAccount(request);

      if (res!) {
        await _customHomeAppBarProvider!.fetchUserAccountDetails();
        await _fundsProvider!.callInitialApi();
        await _customHomeAppBarProvider!.getAppPackageInfo();
        await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
        await _tradeMainProvider!
            .initialGetLadderData(_currencyConstantsProvider!);
        await _ladderProvider!.fetchAllLadder(_currencyConstantsProvider!);
        await _tradeMainProvider!.getActiveLadderTickers(context);
        await _tradesProvider!.fetchTrades(_currencyConstantsProvider!);
        await _orderProvider!.fetchOrders(_currencyConstantsProvider!);
        await _positionProvider!.fetchPositions(_currencyConstantsProvider!);

        await _activityProvider!.fetchActivities();
        Scaffold.of(context).closeDrawer();
        Fluttertoast.showToast(msg: "Successfully reset done");
        return true;
      } else {
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

  void resetSimulationAccountRequest() async {
    try {
      await DrawerRestApiService().resetCompleteSimulation();
      await _customHomeAppBarProvider!.fetchUserAccountDetails();
      await _fundsProvider!.callInitialApi();
      await _customHomeAppBarProvider!.getAppPackageInfo();
      await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
      await _tradeMainProvider!
          .initialGetLadderData(_currencyConstantsProvider!);
      await _ladderProvider!.fetchAllLadder(_currencyConstantsProvider!);
      await _tradeMainProvider!.getActiveLadderTickers(context);
      await _tradesProvider!.fetchTrades(_currencyConstantsProvider!);
      await _orderProvider!.fetchOrders(_currencyConstantsProvider!);
      await _positionProvider!.fetchPositions(_currencyConstantsProvider!);

      await _activityProvider!.fetchActivities();
      Scaffold.of(context).closeDrawer();
      Fluttertoast.showToast(msg: "Successfully reset done");
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Help'),
          content: Text('This will redirect you to our website.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                final Uri url = Uri.parse(
                    'https://dozendiamonds.com/help-center/'); // Replace with your website URL
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not open the website.')),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget contactCustomerSupportDialog(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: screenWidth - 40,
        padding: const EdgeInsets.only(bottom: 5),
        // width: double.infinity,
        decoration: BoxDecoration(
          color: Color(
              0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white54,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: const Text(
                    "Contact Customer Support",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                MyTextField(
                    isFilled: true,
                    fillColor: (themeProvider.defaultTheme)
                        ? Color(0xffCACAD3)
                        : Color(0xff2c2c31),
                    borderColor: (themeProvider.defaultTheme)
                        ? Color(0xffCACAD3)
                        : Color(0xff2c2c31),
                    elevation: 0,
                    isLabelEnabled: false,
                    controller: settingProvider.subjectTextEditingController,
                    borderWidth: 1,
                    // fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    borderRadius: 5,
                    labelText: "Subject",
                    maxLine: 1,
                    // borderColor: Colors.white,
                    focusedBorderColor: Colors.white,
                    onChanged: (value) {}),
                SizedBox(
                  height: 5,
                ),
                MyTextField(
                    controller: settingProvider.messageTextEditingController,
                    isFilled: true,
                    fillColor: (themeProvider.defaultTheme)
                        ? Color(0xffCACAD3)
                        : Color(0xff2c2c31),
                    borderColor: (themeProvider.defaultTheme)
                        ? Color(0xffCACAD3)
                        : Color(0xff2c2c31),
                    elevation: 0,
                    isLabelEnabled: false,
                    borderWidth: 1,
                    // fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    borderRadius: 5,
                    labelText: "Message",
                    maxLine: 5,
                    // borderColor: Colors.white,
                    focusedBorderColor: Colors.white,
                    onChanged: (value) {})
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (settingProvider.subjectTextEditingController.text !=
                            "" &&
                            settingProvider.messageTextEditingController.text !=
                                "") {
                          final value =
                          await settingProvider.sendContactSupportMain(
                              settingProvider
                                  .subjectTextEditingController.text,
                              settingProvider
                                  .messageTextEditingController.text);

                          if (value == "true") {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Mail sent successfully"),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(value),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please enter subject and message"),
                            ),
                          );
                        }
                      },
                      child: Text('Send',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    brokerInfoProvider = Provider.of<BrokerInfoProvider>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);
    runRevertProvider = Provider.of<RunRevertProvider>(context, listen: false);
    settingProvider = Provider.of<SettingProvider>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    userConfigProvider = Provider.of<UserConfigProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);

    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
        child: Drawer(
            elevation: 10,
            child: Consumer<ThemeProvider>(builder: (context, value, child) {
              return Container(
                color: value.defaultTheme ? Color(0xFFc9d9d9) : Color(0xFF141414),
                child: Column(
                  children: [

                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Menu",
                            style: TextStyle(
                              fontFamily: "Britanica",
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: (themeProvider.defaultTheme)
                                  ? Color(0xff0f0f0f)
                                  : Color(0xfff0f0f0),
                            ),
                          ),
                          CustomContainer(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            backgroundColor: (themeProvider.defaultTheme)
                                ? Color(0xffd9d9d9)
                                : Color(0xff2b2b2f),
                            padding: 0,
                            margin: EdgeInsets.zero,
                            borderRadius: 50,
                            height: 20,
                            width: 20,
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: 15,
                              color: Color(0xffa8a8a8),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18.0),
                      child: CustomContainer(
                        onTap: () {
                          Navigator.of(context).pop();

                          _navigationProvider.previousSelectedIndex =
                              _navigationProvider.selectedIndex;
                          _navigationProvider.selectedIndex = 25;

                          profileProvider.resetDataInTextField();
                          profileProvider.getProfileData();
                        },
                        margin: EdgeInsets.zero,
                        padding: 0,
                        backgroundColor: (themeProvider.defaultTheme)
                            ? Color(0xffbedaf0)
                            : Color(0xff085b9a),
                        borderRadius: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CustomContainer(
                                padding: 0,
                                borderRadius: 50,
                                backgroundColor: Color(0xffebfbfe),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xff0b87ac),
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: screenWidth * 0.4,
                                    child: Text(
                                      username,
                                      style: TextStyle(
                                          fontFamily: "Britanica",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: (themeProvider.defaultTheme)
                                              ? Color(0xff0f0f0f)
                                              : Color(0xfff0f0f0)),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.4,
                                    child: Text(
                                      "Joined ${DateFormat('dd.MM.yyyy').format(DateTime.parse(profileProvider.profileData.regDateTime ?? DateTime.now().toString()))}",
                                      style: TextStyle(
                                          fontFamily: "Britanica",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: (themeProvider.defaultTheme)
                                              ? Color(0xff0f0f0f)
                                              : Color(0xfff0f0f0)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        child: Stack(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              // height: MediaQuery.of(context).size.height * 0.55,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 20, right: 20.0),
                                  //   child: CustomContainer(
                                  //     padding: 0,
                                  //     margin: EdgeInsets.zero,
                                  //     backgroundColor: Colors.transparent,
                                  //     height: 50,
                                  //     onTap: () {
                                  //       Navigator.of(context).pop();
                                  //
                                  //       _navigationProvider.previousSelectedIndex =
                                  //           _navigationProvider.selectedIndex;
                                  //       _navigationProvider.selectedIndex = 23;
                                  //       // _navigationProvider.selectedIndex = 24;
                                  //     },
                                  //     child: Row(
                                  //       children: [
                                  //         Icon(
                                  //           Icons.question_mark,
                                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0),
                                  //           size: 15,
                                  //         ),
                                  //
                                  //         SizedBox(
                                  //           width: 10,
                                  //         ),
                                  //
                                  //         Container(
                                  //           width: screenWidth * 0.5,
                                  //           child: Text(
                                  //             "Questionnaire",
                                  //             style: GoogleFonts.poppins(
                                  //               fontWeight: FontWeight.w400,
                                  //               fontSize: 15,
                                  //               color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

                                  (appConfigProvider.appConfigData.data
                                      ?.addFundsEnableDrawer! ==
                                      false)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _navigationProvider.selectedIndex =
                                        0;
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                            color:
                                            (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Add Funds",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (appConfigProvider.appConfigData.data
                                      ?.createLadderEnableDrawer! ==
                                      false)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _navigationProvider.selectedIndex =
                                        4;
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "lib/global/assets/logos/ladder.png",
                                            width: 18,
                                            color:
                                            (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Create Ladder",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (appConfigProvider.appConfigData.data
                                      ?.tradeEnableDrawer! ==
                                      false)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _navigationProvider.selectedIndex =
                                        1;
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "lib/global/assets/icons/suitcase.png",
                                            width: 18,
                                            color:
                                            (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Trade",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (appConfigProvider.appConfigData.data
                                      ?.analyticsEnableDrawer! ==
                                      false)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _navigationProvider.selectedIndex =
                                        2;
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "lib/global/assets/icons/data-analytics-icon.png",
                                            width: 18,
                                            color:
                                            (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Analytics",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (appConfigProvider.appConfigData.data
                                      ?.dematInfoEnableDrawer! ==
                                      false)
                                      ? Container()
                                      : (tradeMainProvider.tradingOptions ==
                                      TradingOptions.tradingWithRealCash)
                                      ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor:
                                      Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        brokerInfoProvider
                                            .getCustomerProfile();
                                        brokerInfoProvider
                                            .getHoldings();
                                        brokerInfoProvider
                                            .getAllHoldings();
                                        brokerInfoProvider
                                            .getCustomerFundsAndMargins();
                                        _navigationProvider
                                            .selectedIndex = 19;
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.perm_device_info,
                                            color: (themeProvider
                                                .defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Demat Info",
                                              style:
                                              GoogleFonts.poppins(
                                                fontWeight:
                                                FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                      : Container(),

                                  (appConfigProvider.appConfigData.data
                                      ?.monitorEnableDrawer! ==
                                      false)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.of(context).pop();

                                        _navigationProvider.selectedIndex =
                                        20;
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.monitor,
                                            color:
                                            (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Monitor",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (appConfigProvider.appConfigData.data
                                      ?.strategiesEnableDrawer! ==
                                      false)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.of(context).pop();

                                        _navigationProvider.selectedIndex =
                                        21;
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.app_registration_rounded,
                                            color:
                                            (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Strategies",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (appConfigProvider.appConfigData.data
                                      ?.resetCompleteSimulationEnableDrawer! ==
                                      false)
                                      ? Container()
                                      : (tradeMainProvider.tradingOptions ==
                                      TradingOptions.tradingWithRealCash)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor:
                                      Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        showResetOptionDialog(context,
                                            "Start a new run by?");
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.loop,
                                            color: (themeProvider
                                                .defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Start New Run",
                                              style:
                                              GoogleFonts.poppins(
                                                fontWeight:
                                                FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (appConfigProvider.appConfigData.data
                                      ?.resetCompleteSimulationEnableDrawer! ==
                                      false)
                                      ? Container()
                                      : (tradeMainProvider.tradingOptions ==
                                      TradingOptions.tradingWithRealCash)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor:
                                      Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        runRevertProvider
                                            .getAllRunOfAUser();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RunRevertScreen(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .settings_backup_restore_sharp,
                                            color: (themeProvider
                                                .defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              (tradeMainProvider
                                                  .tradingOptions ==
                                                  TradingOptions
                                                      .simulationTradingWithSimulatedPrices)
                                                  ? 'Revert to Previous Run' //'Reset complete simulation'
                                                  : 'Revert to Previous Run',
                                              style:
                                              GoogleFonts.poppins(
                                                fontWeight:
                                                FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (false)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        // _showHelpDialog(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.refresh,
                                            color:
                                            (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Reminder",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (false)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        _showHelpDialog(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.help_outline,
                                            color:
                                            (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Help",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  (false)
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20.0),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 40,
                                      onTap: () {
                                        settingProvider
                                            .subjectTextEditingController
                                            .clear();
                                        settingProvider
                                            .messageTextEditingController
                                            .clear();
                                        showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) =>
                                              contactCustomerSupportDialog(
                                                  context),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.support_agent,
                                            color:
                                            (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Customer Support",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: (themeProvider
                                                    .defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 150,
                                  )

                                  // (appConfigProvider.appConfigData.data?.settingsEnableDrawer! ==
                                  //     false)
                                  //     ? Container()
                                  //     : Padding(
                                  //   padding: const EdgeInsets.only(left: 20, right: 20.0),
                                  //   child: CustomContainer(
                                  //     padding: 0,
                                  //     margin: EdgeInsets.zero,
                                  //     backgroundColor: Colors.transparent,
                                  //     height: 50,
                                  //     onTap: () {
                                  //       Navigator.of(context).pop();
                                  //       Navigator.of(context).push(
                                  //         MaterialPageRoute(
                                  //           builder: (context) => const SettingPage(),
                                  //         ),
                                  //       );
                                  //     },
                                  //     child: Row(
                                  //       children: [
                                  //         Icon(
                                  //           Icons.settings,
                                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0),
                                  //           size: 16,
                                  //         ),
                                  //
                                  //         SizedBox(
                                  //           width: 10,
                                  //         ),
                                  //
                                  //         Container(
                                  //           width: screenWidth * 0.5,
                                  //           child: Text(
                                  //             "Settings",
                                  //             style: GoogleFonts.poppins(
                                  //               fontWeight: FontWeight.w400,
                                  //               fontSize: 15,
                                  //               color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  //
                                  // (appConfigProvider.appConfigData.data?.logoutEnableDrawer! ==
                                  //     false)
                                  //     ? Container()
                                  //     : Padding(
                                  //   padding: const EdgeInsets.only(left: 20, right: 20.0),
                                  //   child: CustomContainer(
                                  //     padding: 0,
                                  //     margin: EdgeInsets.zero,
                                  //     backgroundColor: Colors.transparent,
                                  //     height: 50,
                                  //     onTap: () {
                                  //       showCustomAlertDialogFromHelper(
                                  //           context, "Are you sure you want to logout", () {
                                  //         SharedPreferences.getInstance()
                                  //             .then((value) async {
                                  //           LoginRestApiService().signOutGoogle();
                                  //           await value.remove("reg_id");
                                  //           await value.remove("reg_user");
                                  //           Navigator.of(context).pop();
                                  //           navigateAuthenticationProvider.selectedIndex =
                                  //           1;
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
                                  //           // Navigator.of(context).pushRemove(
                                  //           //     '/', (Route<dynamic> route) => false);
                                  //         });
                                  //       });
                                  //     },
                                  //     child: Row(
                                  //       children: [
                                  //         Icon(
                                  //           Icons.logout,
                                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0),
                                  //           size: 16,
                                  //         ),
                                  //
                                  //         SizedBox(
                                  //           width: 10,
                                  //         ),
                                  //
                                  //         Container(
                                  //           width: screenWidth * 0.5,
                                  //           child: Text(
                                  //             "Logout",
                                  //             style: GoogleFonts.poppins(
                                  //               fontWeight: FontWeight.w400,
                                  //               fontSize: 15,
                                  //               color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                color: value.defaultTheme
                                    ? Color(0xFFc9d9d9)
                                    : Color(0xFF141414),
                                child: Column(
                                  children: [
                                    (appConfigProvider.appConfigData.data
                                        ?.settingsEnableDrawer! ==
                                        false)
                                        ? Container()
                                        : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20.0),
                                      child: CustomContainer(
                                        padding: 0,
                                        margin: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        height: 50,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              const SettingPage(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.settings,
                                              color: (themeProvider
                                                  .defaultTheme)
                                                  ? Color(0xff0f0f0f)
                                                  : Color(0xfff0f0f0),
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: screenWidth * 0.5,
                                              child: Text(
                                                "Settings",
                                                style: GoogleFonts.poppins(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize: 15,
                                                  color: (themeProvider
                                                      .defaultTheme)
                                                      ? Color(0xff141414)
                                                      : Color(0xfff0f0f0),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    (appConfigProvider.appConfigData.data
                                        ?.logoutEnableDrawer! ==
                                        false)
                                        ? Container()
                                        : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20.0),
                                      child: CustomContainer(
                                        padding: 0,
                                        margin: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        height: 50,
                                        onTap: () {
                                          showCustomAlertDialogFromHelper(
                                              context,
                                              "Are you sure you want to logout",
                                                  () {
                                                SharedPreferences.getInstance()
                                                    .then((value) async {
                                                  LoginRestApiService()
                                                      .signOutGoogle();
                                                  await value.remove("reg_id");
                                                  await value
                                                      .remove("reg_user");
                                                  Navigator.of(context).pop();
                                                  navigateAuthenticationProvider
                                                      .selectedIndex = 1;

                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NavigateAuthenticationScreen()),
                                                        (Route<dynamic> route) =>
                                                    false, // this removes all previous routes
                                                  );

                                                  // Navigator.of(context).pushRemove(
                                                  //     '/', (Route<dynamic> route) => false);
                                                });
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              color: (themeProvider
                                                  .defaultTheme)
                                                  ? Color(0xff0f0f0f)
                                                  : Color(0xfff0f0f0),
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: screenWidth * 0.5,
                                              child: Text(
                                                "Logout",
                                                style: GoogleFonts.poppins(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize: 15,
                                                  color: (themeProvider
                                                      .defaultTheme)
                                                      ? Color(0xff141414)
                                                      : Color(0xfff0f0f0),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            })),
      ),
    );
  }
}

// class NavigationDrawerWidget extends StatefulWidget {
//   final Function? updateIndex;
//   const NavigationDrawerWidget({super.key, this.updateIndex});
//
//   @override
//   State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
// }
//
// class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
//   String username = "";
//   bool showAccountOption = false;
//   LadderProvider? _ladderProvider;
//   OrderProvider? _orderProvider;
//   ActivityProvider? _activityProvider;
//   PositionProvider? _positionProvider;
//   TradesProvider? _tradesProvider;
//   TradeMainProvider? _tradeMainProvider;
//   FundsProvider? _fundsProvider;
//   late NavigationProvider _navigationProvider;
//   late NavigateAuthenticationProvider navigateAuthenticationProvider;
//   late BrokerInfoProvider brokerInfoProvider;
//   late AppConfigProvider appConfigProvider;
//   late TradeMainProvider tradeMainProvider;
//   late RunRevertProvider runRevertProvider;
//   late SettingProvider settingProvider;
//   late ThemeProvider themeProvider;
//   CustomHomeAppBarProvider? _customHomeAppBarProvider;
//   CurrencyConstants? _currencyConstantsProvider;
//   void _updateState() {
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _tradeMainProvider = Provider.of(context, listen: false);
//     _ladderProvider = Provider.of(context, listen: false);
//     _orderProvider = Provider.of(context, listen: false);
//     _positionProvider = Provider.of(context, listen: false);
//     _activityProvider = Provider.of(context, listen: false);
//     _tradesProvider = Provider.of(context, listen: false);
//     _fundsProvider = Provider.of(context, listen: false);
//     _customHomeAppBarProvider = Provider.of(context, listen: false);
//     _tradeMainProvider = Provider.of(context, listen: false);
//     _currencyConstantsProvider = Provider.of(context, listen: false);
//     SharedPreferences.getInstance().then((value) {
//       setState(() {
//         username = value.getString("reg_user") ?? "";
//       });
//     });
//     _navigationProvider =
//         Provider.of<NavigationProvider>(context, listen: false);
//   }
//
//   Future<void> showResetOptionDialog(BuildContext context, String msg) async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.transparent,
//           content: Container(
//             padding: const EdgeInsets.only(
//               top: 20,
//               bottom: 10,
//               left: 20,
//               right: 20,
//             ),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(
//                 20,
//               ),
//               border: Border.all(
//                 color: Colors.white,
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Icon(
//                         Icons.close,
//                         size: 20,
//                       ),
//                     ),
//                     Text(
//                       msg,
//                       style: const TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 1,
//                     )
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           showCustomAlertDialogFromHelper(context,
//                               "Are you sure you want to reset your account?",
//                               () async {
//                             resetRetainSimulationAccountRequest();
//                           });
//                         },
//                         child: const Text(
//                           "Retain all ladders",
//                           style: TextStyle(
//                             color: Color(0xFF0099CC),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           showCustomAlertDialogFromHelper(context,
//                               "Are you sure you want to reset your account?",
//                               () async {
//                             resetSimulationAccountRequest();
//                           });
//                         },
//                         child: const Text(
//                           "Erase all ladders",
//                           style: TextStyle(
//                             // color: Colors.white,
//                             color: Color(0xFF0099CC),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     navigateAuthenticationProvider =
//         Provider.of<NavigateAuthenticationProvider>(context, listen: true);
//     brokerInfoProvider = Provider.of<BrokerInfoProvider>(context, listen: true);
//     appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);
//     tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);
//     runRevertProvider = Provider.of<RunRevertProvider>(context, listen: false);
//     settingProvider = Provider.of<SettingProvider>(context, listen: false);
//     themeProvider = Provider.of<ThemeProvider>(context, listen: false);
//     return ClipRRect(
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
//       child: Drawer(
//         elevation: 10,
//         child: Consumer<ThemeProvider>(builder: (context, value, child) {
//           return Container(
//             color: value.defaultTheme ? Color(0xFFF6F1EE) : Color(0xFF15181F),
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.07),
//                 Column(
//                   children: [
//                     Image.asset(
//                       "lib/global/assets/images/ic_profile.png",
//                       color: value.defaultTheme ? Colors.black : Colors.white70,
//                       height: 80,
//                       width: 80,
//                     ),
//                     Text(
//                       username,
//                       style: TextStyle(fontSize: 15),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Divider(
//                   thickness: 0.8,
//                   color: value.defaultTheme ? Colors.black : Colors.white70,
//                   height: 0.3,
//                 ),
//                 if (showAccountOption) ...[
//                   Container(
//                     decoration: BoxDecoration(
//                       color: value.defaultTheme
//                           ? Colors.white54
//                           : Color(0xFF15181F),
//                     ),
//                     child: ListTile(
//                       onTap: () {
//                         Fluttertoast.showToast(
//                             msg: "This feature will unlock soon");
//                       },
//                       // leading: Image.asset(
//                       //   "lib/global/assets/icons/suitcase.png",
//                       //   width: 25,
//                       //   color: Colors.white70,
//                       // ),
//                       title: Container(
//                         margin: EdgeInsets.only(left: 70),
//                         child: const Text(
//                           'Rebalance frequency',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.white70,
//                     height: 1,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: value.defaultTheme
//                           ? Colors.white54
//                           : Color(0xFF15181F),
//                     ),
//                     child: ListTile(
//                       onTap: () {
//                         Fluttertoast.showToast(
//                             msg: "This feature will unlock soon");
//                       },
//                       // leading: Image.asset(
//                       //   "lib/global/assets/icons/suitcase.png",
//                       //   width: 70,
//                       //   color: Colors.white70,
//                       // ),
//                       title: Container(
//                         margin: EdgeInsets.only(left: 70),
//                         child: const Text(
//                           'Review allocation',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Divider(
//                   //   color: Colors.white70,
//                   //   height: 1,
//                   // ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: value.defaultTheme
//                           ? Colors.white54
//                           : Color(0xFF15181F),
//                     ),
//                     child: ListTile(
//                       onTap: () {
//                         Fluttertoast.showToast(
//                             msg: "This feature will unlock soon");
//                       },
//                       // leading: Image.asset(
//                       //   "lib/global/assets/icons/suitcase.png",
//                       //   width: 70,
//                       //   color: Colors.white70,
//                       // ),
//                       title: Container(
//                         margin: EdgeInsets.only(left: 70),
//                         child: const Text(
//                           'Review ladder',
//                           style: TextStyle(fontSize: 15, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.white70,
//                     height: 1,
//                   ),
//                 ],
//
//                 // // (appConfigProvider.appConfigData.data?.dematInfoEnableDrawer! ==
//                 // (false)
//                 //     ? Container()
//                 //     : InkWell(
//                 //         onTap: () {
//                 //           Navigator.of(context).pop();
//                 //
//                 //           _navigationProvider.previousSelectedIndex =
//                 //               _navigationProvider.selectedIndex;
//                 //           _navigationProvider.selectedIndex = 23;
//                 //           // _navigationProvider.selectedIndex = 24;
//                 //         },
//                 //         child: Container(
//                 //           decoration: BoxDecoration(
//                 //             color: value.defaultTheme
//                 //                 ? Colors.white
//                 //                 : Color(0xFF15181F),
//                 //           ),
//                 //           child: ListTile(
//                 //             leading: Icon(
//                 //               Icons.question_mark,
//                 //               color: value.defaultTheme
//                 //                   ? Colors.black
//                 //                   : Colors.white70,
//                 //             ),
//                 //             title: Text(
//                 //               "Questionnaire",
//                 //               style: TextStyle(
//                 //                   fontSize: 15,
//                 //                   color: value.defaultTheme
//                 //                       ? Colors.black
//                 //                       : Colors.white),
//                 //             ),
//                 //           ),
//                 //         ),
//                 //       ),
//
//                 (appConfigProvider.appConfigData.data?.addFundsEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : Container(
//                         decoration: BoxDecoration(
//                           color: value.defaultTheme
//                               ? Colors.white54
//                               : Color(0xFF15181F),
//                         ),
//                         child: ListTile(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             _navigationProvider.selectedIndex = 0;
//                           },
//                           leading: Icon(
//                             Icons.account_balance_wallet_outlined,
//                             color: value.defaultTheme
//                                 ? Colors.black
//                                 : Colors.white70,
//                           ),
//                           title: Text(
//                             'Add Funds',
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: value.defaultTheme
//                                     ? Colors.black
//                                     : Colors.white),
//                           ),
//                         ),
//                       ),
//
//                 (appConfigProvider
//                             .appConfigData.data?.createLadderEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : Container(
//                         decoration: BoxDecoration(
//                           color: value.defaultTheme
//                               ? Colors.white54
//                               : Color(0xFF15181F),
//                         ),
//                         child: ListTile(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             _navigationProvider.selectedIndex = 4;
//                           },
//                           leading: Image.asset(
//                             "lib/global/assets/logos/ladder.png",
//                             width: 25,
//                             color: value.defaultTheme
//                                 ? Colors.black
//                                 : Colors.white70,
//                           ),
//                           title: Text(
//                             'Create ladder',
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: value.defaultTheme
//                                     ? Colors.black
//                                     : Colors.white),
//                           ),
//                         ),
//                       ),
//
//                 (appConfigProvider.appConfigData.data?.tradeEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : Container(
//                         decoration: BoxDecoration(
//                           color: value.defaultTheme
//                               ? Colors.white54
//                               : Color(0xFF15181F),
//                         ),
//                         child: ListTile(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             _navigationProvider.selectedIndex = 1;
//                           },
//                           leading: Image.asset(
//                             "lib/global/assets/icons/suitcase.png",
//                             width: 25,
//                             color: value.defaultTheme
//                                 ? Colors.black
//                                 : Colors.white70,
//                           ),
//                           title: Text(
//                             'Trade',
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: value.defaultTheme
//                                     ? Colors.black
//                                     : Colors.white),
//                           ),
//                         ),
//                       ),
//
//                 (appConfigProvider.appConfigData.data?.analyticsEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : Container(
//                         decoration: BoxDecoration(
//                           color: value.defaultTheme
//                               ? Colors.white54
//                               : Color(0xFF15181F),
//                         ),
//                         child: ListTile(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             _navigationProvider.selectedIndex = 2;
//                           },
//                           leading: Image.asset(
//                             "lib/global/assets/icons/data-analytics-icon.png",
//                             width: 25,
//                             color: value.defaultTheme
//                                 ? Colors.black
//                                 : Colors.white70,
//                           ),
//                           title: Text(
//                             'Analytics',
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: value.defaultTheme
//                                     ? Colors.black
//                                     : Colors.white),
//                           ),
//                         ),
//                       ),
//
//                 (appConfigProvider.appConfigData.data?.dematInfoEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                           brokerInfoProvider.getCustomerProfile();
//                           brokerInfoProvider.getHoldings();
//                           brokerInfoProvider.getAllHoldings();
//                           brokerInfoProvider.getCustomerFundsAndMargins();
//                           _navigationProvider.selectedIndex = 19;
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: value.defaultTheme
//                                 ? Colors.white
//                                 : Color(0xFF15181F),
//                           ),
//                           child: ListTile(
//                             leading: Icon(
//                               Icons.perm_device_info,
//                               color: value.defaultTheme
//                                   ? Colors.black
//                                   : Colors.white70,
//                             ),
//                             title: Text(
//                               "Demat Info",
//                               style: TextStyle(
//                                   fontSize: 15,
//                                   color: value.defaultTheme
//                                       ? Colors.black
//                                       : Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                 (appConfigProvider.appConfigData.data?.monitorEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop();
//
//                           _navigationProvider.selectedIndex = 20;
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: value.defaultTheme
//                                 ? Colors.white
//                                 : Color(0xFF15181F),
//                           ),
//                           child: ListTile(
//                             leading: Icon(
//                               Icons.monitor,
//                               color: value.defaultTheme
//                                   ? Colors.black
//                                   : Colors.white70,
//                             ),
//                             title: Text(
//                               "Monitor",
//                               style: TextStyle(
//                                   fontSize: 15,
//                                   color: value.defaultTheme
//                                       ? Colors.black
//                                       : Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                 (appConfigProvider
//                             .appConfigData.data?.strategiesEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop();
//
//                           _navigationProvider.selectedIndex = 21;
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: value.defaultTheme
//                                 ? Colors.white
//                                 : Color(0xFF15181F),
//                           ),
//                           child: ListTile(
//                             leading: Icon(
//                               Icons.app_registration_rounded,
//                               color: value.defaultTheme
//                                   ? Colors.black
//                                   : Colors.white70,
//                             ),
//                             title: Text(
//                               "Strategies",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: value.defaultTheme
//                                     ? Colors.black
//                                     : Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                 (appConfigProvider.appConfigData.data?.settingsEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => const SettingPage(),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: value.defaultTheme
//                                 ? Colors.white
//                                 : Color(0xFF15181F),
//                           ),
//                           child: ListTile(
//                             leading: Icon(
//                               Icons.settings_rounded,
//                               color: value.defaultTheme
//                                   ? Colors.black
//                                   : Colors.white70,
//                             ),
//                             title: Text(
//                               "Settings",
//                               style: TextStyle(
//                                   fontSize: 15,
//                                   color: value.defaultTheme
//                                       ? Colors.black
//                                       : Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                 (appConfigProvider.appConfigData.data!
//                             .resetCompleteSimulationEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : (tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)
//                     ?Container()
//                     :Container(
//                         decoration: BoxDecoration(
//                           color: value.defaultTheme
//                               ? Colors.white54
//                               : Color(0xFF15181F),
//                         ),
//                         child: ListTile(
//                           onTap: () {
//                             // showCustomAlertDialogFromHelper(context,
//                             //     "Are you sure you want to reset your account?",
//                             //     () async {
//                             //   resetSimulationAccountRequest();
//                             // });
//
//                             showResetOptionDialog(
//                                 context, "Start a new run by?");
//                           },
//                           leading: Icon(
//                             Icons.loop,
//                             color: value.defaultTheme
//                                 ? Colors.black
//                                 : Colors.white70,
//                           ),
//                           title: Text(
//                             (tradeMainProvider.tradingOptions ==
//                                     TradingOptions
//                                         .simulationTradingWithSimulatedPrices)
//                                 ? 'Start New Run' //'Reset complete simulation'
//                                 : 'Start New Run', //"Reset complete real time trading",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: value.defaultTheme
//                                     ? Colors.black
//                                     : Colors.white),
//                           ),
//                         ),
//                       ),
//
//                 // (appConfigProvider.appConfigData.data?.resetCompleteSimulationEnableDrawer! == false)
//                 //     ?Container()
//                 //     :Container(
//                 //   decoration: BoxDecoration(
//                 //     color:
//                 //     value.defaultTheme ? Colors.white54 : Color(0xFF15181F),
//                 //   ),
//                 //   child: ListTile(
//                 //     onTap: () {
//                 //       showCustomAlertDialogFromHelper(context,
//                 //           "Are you sure you want to reset your simulation account?",
//                 //               () async {
//                 //             resetSimulationAccountRequest();
//                 //           });
//                 //     },
//                 //     leading: Icon(
//                 //       Icons.loop,
//                 //       color: value.defaultTheme ? Colors.black : Colors.white70,
//                 //     ),
//                 //     title: Text(
//                 //       (tradeMainProvider.tradingOptions == TradingOptions
//                 //           .simulationTradingWithSimulatedPrices)
//                 //           ?'Revert to Previous Run' //'Reset complete simulation'
//                 //           :'Revert to Previous Run', //"Reset complete real time trading",
//                 //       style: TextStyle(
//                 //           fontSize: 15,
//                 //           color:
//                 //           value.defaultTheme ? Colors.black : Colors.white),
//                 //     ),
//                 //   ),
//                 // ),
//
//                 (appConfigProvider.appConfigData.data!
//                             .resetCompleteSimulationEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : (tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)?Container():Container(
//                         decoration: BoxDecoration(
//                           color: value.defaultTheme
//                               ? Colors.white54
//                               : Color(0xFF15181F),
//                         ),
//                         child: ListTile(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             runRevertProvider.getAllRunOfAUser();
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => RunRevertScreen(),
//                               ),
//                             );
//                           },
//                           leading: Icon(
//                             Icons.settings_backup_restore_sharp,
//                             color: value.defaultTheme
//                                 ? Colors.black
//                                 : Colors.white,
//                           ),
//                           title: Text(
//                             (tradeMainProvider.tradingOptions ==
//                                     TradingOptions
//                                         .simulationTradingWithSimulatedPrices)
//                                 ? 'Revert to Previous Run' //'Reset complete simulation'
//                                 : 'Revert to Previous Run',
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: value.defaultTheme
//                                     ? Colors.black
//                                     : Colors.white),
//                           ),
//                         ),
//                       ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color:
//                         value.defaultTheme ? Colors.white54 : Color(0xFF15181F),
//                   ),
//                   child: ListTile(
//                     onTap: () => _showHelpDialog(context),
//                     leading: Icon(
//                       Icons.help_outline, // Help icon
//                       color: value.defaultTheme ? Colors.black : Colors.white70,
//                     ),
//                     title: Text(
//                       'Help',
//                       style: TextStyle(
//                           fontSize: 15,
//                           color:
//                               value.defaultTheme ? Colors.black : Colors.white),
//                     ),
//                   ),
//                 ),
//
//                 Container(
//                   decoration: BoxDecoration(
//                     color:
//                         value.defaultTheme ? Colors.white54 : Color(0xFF15181F),
//                   ),
//                   child: ListTile(
//                     onTap: () {
//                       settingProvider.subjectTextEditingController.clear();
//                       settingProvider.messageTextEditingController.clear();
//                       showDialog(
//                         barrierDismissible: true,
//                         context: context,
//                         builder: (context) =>
//                             contactCustomerSupportDialog(context),
//                       );
//                     },
//                     leading: Icon(
//                       Icons.support_agent, // Help icon
//                       color: value.defaultTheme ? Colors.black : Colors.white70,
//                     ),
//                     title: Text(
//                       'Customer Support',
//                       style: TextStyle(
//                           fontSize: 15,
//                           color:
//                               value.defaultTheme ? Colors.black : Colors.white),
//                     ),
//                   ),
//                 ),
//
//                 (appConfigProvider.appConfigData.data?.logoutEnableDrawer! ==
//                         false)
//                     ? Container()
//                     : Container(
//                         decoration: BoxDecoration(
//                           color: value.defaultTheme
//                               ? Colors.white54
//                               : Color(0xFF15181F),
//                         ),
//                         child: ListTile(
//                           onTap: () {
//                             showCustomAlertDialogFromHelper(
//                                 context, "Are you sure you want to logout", () {
//                               SharedPreferences.getInstance()
//                                   .then((value) async {
//                                 LoginRestApiService().signOutGoogle();
//                                 await value.remove("reg_id");
//                                 await value.remove("reg_user");
//                                 Navigator.of(context).pop();
//                                 navigateAuthenticationProvider.selectedIndex =
//                                     1;
//
//                                 Navigator.pushAndRemoveUntil(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           NavigateAuthenticationScreen()),
//                                   (Route<dynamic> route) =>
//                                       false, // this removes all previous routes
//                                 );
//
//                                 // Navigator.of(context).pushRemove(
//                                 //     '/', (Route<dynamic> route) => false);
//                               });
//                             });
//                           },
//                           leading: Image.asset(
//                             "lib/global/assets/icons/ic_logout.png",
//                             width: 25,
//                             color: value.defaultTheme
//                                 ? Colors.black
//                                 : Colors.white70,
//                           ),
//                           title: Text(
//                             'Log Out',
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: value.defaultTheme
//                                     ? Colors.black
//                                     : Colors.white),
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Future<bool> resetRetainSimulationAccountRequest() async {
//     try {
//       String currentTradingMode = "SIMULATION-PAPER";
//
//       if (tradeMainProvider.tradingOptions ==
//           TradingOptions.simulationTradingWithSimulatedPrices) {
//         currentTradingMode = "SIMULATION-PAPER";
//       }
//
//       if (tradeMainProvider.tradingOptions ==
//           TradingOptions.simulationTradingWithRealValues) {
//         currentTradingMode = "REALTIME-PAPER";
//       }
//
//       if (tradeMainProvider.tradingOptions ==
//           TradingOptions.tradingWithRealCash) {
//         currentTradingMode = "REAL";
//       }
//
//       Map<String, dynamic> request = {
//         // "current_trading_mode": tradeMainProvider.tradingOptions.name,
//         "current_trading_mode": currentTradingMode,
//       };
//
//       bool? res = await DrawerRestApiService().resetWithRetainAccount(request);
//
//       if (res!) {
//         await _customHomeAppBarProvider!.fetchUserAccountDetails();
//         await _fundsProvider!.callInitialApi();
//         await _customHomeAppBarProvider!.getAppPackageInfo();
//         await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
//         await _tradeMainProvider!
//             .initialGetLadderData(_currencyConstantsProvider!);
//         await _ladderProvider!.fetchAllLadder(_currencyConstantsProvider!);
//         await _tradeMainProvider!.getActiveLadderTickers(context);
//         await _tradesProvider!.fetchTrades(_currencyConstantsProvider!);
//         await _orderProvider!.fetchOrders(_currencyConstantsProvider!);
//         await _positionProvider!.fetchPositions(_currencyConstantsProvider!);
//
//         await _activityProvider!.fetchActivities();
//         Scaffold.of(context).closeDrawer();
//         Fluttertoast.showToast(msg: "Successfully reset done");
//         return true;
//       } else {
//         return false;
//       }
//     } on HttpApiException catch (err) {
//       print(err.errorSuggestion);
//       print(err.errorTitle);
//       print(err.errorCode);
//       Fluttertoast.showToast(msg: err.errorTitle);
//       return false;
//     }
//   }
//
//   void resetSimulationAccountRequest() async {
//     try {
//       await DrawerRestApiService().resetCompleteSimulation();
//       await _customHomeAppBarProvider!.fetchUserAccountDetails();
//       await _fundsProvider!.callInitialApi();
//       await _customHomeAppBarProvider!.getAppPackageInfo();
//       await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
//       await _tradeMainProvider!
//           .initialGetLadderData(_currencyConstantsProvider!);
//       await _ladderProvider!.fetchAllLadder(_currencyConstantsProvider!);
//       await _tradeMainProvider!.getActiveLadderTickers(context);
//       await _tradesProvider!.fetchTrades(_currencyConstantsProvider!);
//       await _orderProvider!.fetchOrders(_currencyConstantsProvider!);
//       await _positionProvider!.fetchPositions(_currencyConstantsProvider!);
//
//       await _activityProvider!.fetchActivities();
//       Scaffold.of(context).closeDrawer();
//       Fluttertoast.showToast(msg: "Successfully reset done");
//     } on HttpApiException catch (err) {
//       print(err.errorTitle);
//     }
//   }
//
//   void _showHelpDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.black,
//           title: Text('Help'),
//           content: Text('This will redirect you to our website.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(), // Close dialog
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close dialog
//                 final Uri url = Uri.parse(
//                     'https://dozendiamonds.com/help-center/'); // Replace with your website URL
//                 if (await canLaunchUrl(url)) {
//                   await launchUrl(url);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Could not open the website.')),
//                   );
//                 }
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget contactCustomerSupportDialog(BuildContext context) {
//     double screenWidth = screenWidthRecognizer(context);
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         width: screenWidth - 40,
//         padding: const EdgeInsets.only(bottom: 5),
//         // width: double.infinity,
//         decoration: BoxDecoration(
//           color: Color(
//               0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: Colors.white54,
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(
//                     vertical: 20,
//                     horizontal: 10,
//                   ),
//                   child: const Text(
//                     "Contact Customer Support",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 MyTextField(
//                     isFilled: true,
//                     fillColor: (themeProvider.defaultTheme)
//                         ? Color(0xffCACAD3)
//                         : Color(0xff2c2c31),
//                     borderColor: (themeProvider.defaultTheme)
//                         ? Color(0xffCACAD3)
//                         : Color(0xff2c2c31),
//                     elevation: 0,
//                     isLabelEnabled: false,
//                     controller: settingProvider.subjectTextEditingController,
//                     borderWidth: 1,
//                     // fillColor: Colors.transparent,
//                     contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                     borderRadius: 5,
//                     labelText: "Subject",
//                     maxLine: 1,
//                     // borderColor: Colors.white,
//                     focusedBorderColor: Colors.white,
//                     onChanged: (value) {}),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 MyTextField(
//                     controller: settingProvider.messageTextEditingController,
//                     isFilled: true,
//                     fillColor: (themeProvider.defaultTheme)
//                         ? Color(0xffCACAD3)
//                         : Color(0xff2c2c31),
//                     borderColor: (themeProvider.defaultTheme)
//                         ? Color(0xffCACAD3)
//                         : Color(0xff2c2c31),
//                     elevation: 0,
//                     isLabelEnabled: false,
//                     borderWidth: 1,
//                     // fillColor: Colors.transparent,
//                     contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                     borderRadius: 5,
//                     labelText: "Message",
//                     maxLine: 5,
//                     // borderColor: Colors.white,
//                     focusedBorderColor: Colors.white,
//                     onChanged: (value) {})
//               ]),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 12.0, right: 12),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (settingProvider.subjectTextEditingController.text !=
//                                 "" &&
//                             settingProvider.messageTextEditingController.text !=
//                                 "") {
//                           final value =
//                               await settingProvider.sendContactSupportMain(
//                                   settingProvider
//                                       .subjectTextEditingController.text,
//                                   settingProvider
//                                       .messageTextEditingController.text);
//
//                           if (value == "true") {
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text("Mail sent successfully"),
//                               ),
//                             );
//                           } else {
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(value),
//                               ),
//                             );
//                           }
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("Please enter subject and message"),
//                             ),
//                           );
//                         }
//                       },
//                       child: Text('Send',
//                           style: TextStyle(fontSize: 16, color: Colors.black)),
//                       style: ElevatedButton.styleFrom(
//                         side: BorderSide(color: Colors.blue),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
