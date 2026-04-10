import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
import '../../global/functions/utils.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/customer_support_dialog.dart';
import '../../global/widgets/my_text_field.dart';
import '../../login/services/login_rest_api_service.dart';
import '../../navigateAuthentication/screens/navigate_authentication_screen.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../../profile/stateManagement/profile_provider.dart';
import '../../run_revert/screens/runRevertScreen.dart';
import '../../run_revert/stateManagement/runRevertProvider.dart';
import '../services/drawer_rest_api_service.dart';
import '../stateManagement/navigation_provider.dart';
import '../../ZI_Search/stateManagement/search_provider.dart';
import '../../global/constants/shared_preferences_manager.dart';

// import 'dart:html' as html; // Only for web
// import 'dart:io' as io;

class NavDrawerNew extends StatefulWidget {
  final Function? updateIndex;
  const NavDrawerNew({super.key, this.updateIndex});

  @override
  State<NavDrawerNew> createState() => _NavDrawerNewState();
}

class _NavDrawerNewState extends State<NavDrawerNew> {
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

   late SearchProvider searchProvider;

  CurrencyConstants? _currencyConstantsProvider;
  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  String version = "1.0.0";
  String buildNumber = "1";
  Future<void> getAppVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;

    setState(() {
      version = packageInfo.version; // e.g. "1.0.0"
      buildNumber = packageInfo.buildNumber; // e.g. "1"
    });
    // print('App Name: $appName');
    // print('Package Name: $packageName');
    print('Version: $version');
    print('Build Number: $buildNumber');
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
    _navigationProvider = Provider.of<NavigationProvider>(
      context,
      listen: false,
    );

    getAppVersionInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userConfigProvider = Provider.of<UserConfigProvider>(
        context,
        listen: false,
      );
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
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
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
                      child: Icon(Icons.close, size: 20),
                    ),
                    Text(msg, style: const TextStyle(color: Colors.white)),
                    SizedBox(width: 1),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showCustomAlertDialogFromHelper(
                            context,
                            "Are you sure you want to reset your account?",
                            () async {
                              resetRetainSimulationAccountRequest();
                            },
                          );
                        },
                        child: const Text(
                          "Retain all ladders",
                          style: TextStyle(color: Color(0xFF0099CC)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showCustomAlertDialogFromHelper(
                            context,
                            "Are you sure you want to reset your account?",
                            () async {
                              resetSimulationAccountRequest();
                            },
                          );
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
                ),
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
        await _tradeMainProvider!.initialGetLadderData(
          _currencyConstantsProvider!,
        );
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
      await _tradeMainProvider!.initialGetLadderData(
        _currencyConstantsProvider!,
      );
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
          backgroundColor: (themeProvider.defaultTheme)
              ? Colors.white
              : Colors.black,
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
                  'https://dozendiamonds.com/help-center/',
                ); // Replace with your website URL
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

  // Widget contactCustomerSupportDialog(BuildContext context) {
  //   double screenWidth = screenWidthRecognizer(context);
  //   return Dialog(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     child: Container(
  //       width: screenWidth - 40,
  //       padding: const EdgeInsets.only(bottom: 5),
  //       // width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: themeProvider.defaultTheme ? Colors.white : Color(0xFF15181F),
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
  //             child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
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
  //                         return DropdownButtonHideUnderline(
  //                           child: DropdownButton<String>(
  //                             padding: EdgeInsets.zero,
  //                             iconSize: 24.0,
  //                             hint: Text(value.selectedContactSupportCategory,
  //                               style: TextStyle(
  //                                   color: (themeProvider.defaultTheme)?Colors.black:Colors.white
  //                               ),
  //                             ),
  //                             value: value.selectedContactSupportCategory,
  //                             onChanged: (valuee) {
  //                               setState(() {
  //                                 value.selectedContactSupportCategory = valuee ?? "";
  //                               });
  //
  //                             },
  //                             dropdownColor: themeProvider.defaultTheme ? Colors.white : Colors.black,
  //                             items: [
  //                                   "Select Category",
  //                                   "Ladder Creation",
  //                                   "Orders",
  //                                   "Analytics",
  //                                   "Watchlist",
  //                                   "Report a Bug",
  //                                   "Feedback",
  //                                   "Suggestion",
  //                             ].map(
  //                                   (String? option) => DropdownMenuItem<String>(
  //                                 child: Text(option!),
  //                                 value: option,
  //                               ),
  //                             )
  //                                 .toList(),
  //                           ),
  //                         );
  //                       }
  //                     ),
  //                   ),
  //
  //                   Consumer<SettingProvider>(builder: (context, value, child) {
  //                       return Padding(
  //                         padding: const EdgeInsets.only(right: 4.0),
  //                         child: Column(
  //                           children: [
  //                             (kIsWeb)?Container():(value.bugImage != null)?Container():InkWell(
  //                               onTap: () async {
  //                                 if(kIsWeb) {
  //
  //                                   // final uploadInput = html.FileUploadInputElement();
  //                                   // uploadInput.accept = 'image/*';
  //                                   // uploadInput.click();
  //                                   //
  //                                   // uploadInput.onChange.listen((e) async {
  //                                   //   final file = uploadInput.files?.first;
  //                                   //   if (file == null) return;
  //                                   //
  //                                   //   final ext = file.name.split('.').last.toLowerCase();
  //                                   //   if (['png', 'jpeg', 'jpg'].contains(ext)) {
  //                                   //     // onImagePicked(file, ext); // Pass html.File to the caller
  //                                   //     value.bugImage = file; // from dart:html
  //                                   //   } else {
  //                                   //     ScaffoldMessenger.of(context).showSnackBar(
  //                                   //       SnackBar(content: Text('Invalid Image format')),
  //                                   //     );
  //                                   //   }
  //                                   // });
  //
  //                                 } else {
  //
  //                                 //   final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 10);
  //                                 //
  //                                 //   print(image!.path.split(".").last);
  //                                 //   if(image!.path.split(".").last == "png" || image.path.split(".").last == "PNG" || image.path.split(".").last == "jpeg" || image.path.split(".").last == "jpg"){
  //                                 //     // verificationController.droneImage1.value = File(image.path);
  //                                 //     value.bugImage = File(image.path);
  //                                 //
  //                                 //   }else{
  //                                 //     ScaffoldMessenger.of(context).showSnackBar(
  //                                 //       SnackBar(content: Text('Invalid Image format')),
  //                                 //     );
  //                                 //   }
  //
  //                                   final result = await FilePicker
  //                                       .platform
  //                                       .pickFiles(
  //                                     type: FileType.custom,
  //
  //                                     allowMultiple: false,
  //                                   );
  //
  //                                   if (result != null &&
  //                                       result.files.isNotEmpty) {
  //                                     PlatformFile pickedFile =
  //                                         result.files.first;
  //                                     String fileExtension =
  //                                         pickedFile.extension
  //                                             ?.toLowerCase() ??
  //                                             '';
  //
  //                                     print(
  //                                       "File extension: $fileExtension",
  //                                     );
  //
  //                                     // Check if it's a valid format
  //
  //                                     if (pickedFile.path != null) {
  //                                       value.bugImage = File(
  //                                         pickedFile.path!,
  //                                       );
  //
  //                                       // Optional: Show success message
  //                                       ScaffoldMessenger.of(
  //                                         context,
  //                                       ).showSnackBar(
  //                                         SnackBar(
  //                                           content: Text(
  //                                             'File selected: ${pickedFile.name}',
  //                                           ),
  //                                         ),
  //                                       );
  //                                     } else {
  //                                       ScaffoldMessenger.of(
  //                                         context,
  //                                       ).showSnackBar(
  //                                         SnackBar(
  //                                           content: Text(
  //                                             'Could not access file path',
  //                                           ),
  //                                         ),
  //                                       );
  //                                     }
  //                                   } else {
  //                                     // User canceled the picker
  //                                     print("File picker canceled");
  //                                   }
  //
  //
  //                                 }
  //
  //
  //
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   Icon(
  //                                     Icons.attach_file,
  //                                     size: 20,
  //                                   ),
  //
  //                                   // Image.asset(
  //                                   //   AssetConstants.attacheIconImage,
  //                                   //   height: 20,
  //                                   //   width: 20,
  //                                   // ),
  //
  //                                   SizedBox(
  //                                     width: 5,
  //                                   ),
  //
  //                                   Text(
  //                                     "Add Attachment",
  //                                     textScaleFactor: 0.9,
  //                                     style: GoogleFonts.inter(
  //                                         fontSize: 12,
  //                                         fontWeight: FontWeight.w500
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //
  //                             (value.bugImage != null)?Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //
  //                                 SizedBox(
  //                                   height: 5,
  //                                 ),
  //
  //                                 Text(
  //                                   "Image -1",
  //                                   textScaleFactor: 0.9,
  //                                   style: GoogleFonts.inter(
  //                                       fontSize: 14,
  //                                       color: (themeProvider.defaultTheme)?Colors.black:Colors.white
  //                                   ),
  //                                 ),
  //
  //                                 SizedBox(
  //                                   height: 4,
  //                                 ),
  //
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Container(
  //                                       width: 80,
  //                                       child: Text(
  //                                         (kIsWeb)?"":"${value.bugImage.path.split('/').last}",
  //                                         textScaleFactor: 0.9,
  //                                         overflow: TextOverflow.ellipsis,
  //                                         style: GoogleFonts.inter(
  //                                           fontSize: 10,
  //                                           color: (themeProvider.defaultTheme)?Colors.black:Colors.white
  //
  //                                         ),
  //                                       ),
  //                                     ),
  //
  //                                     Row(
  //                                       children: [
  //                                         InkWell(
  //                                           onTap: () {
  //                                             // value.bugImage = File("");
  //                                             value.bugImage = null;
  //                                             // verificationController.droneImages.removeAt(index);
  //                                           },
  //                                           child: Icon(
  //                                             Icons.delete,
  //                                             size: 16,
  //                                           ),
  //                                           // child: Image.asset(
  //                                           //   AssetConstants.deleteIconImage,
  //                                           //   height: 16,
  //                                           // ),
  //                                         ),
  //
  //                                         // SizedBox(
  //                                         //   width: 16,
  //                                         // ),
  //                                         //
  //                                         // Icon(
  //                                         //   Icons.check_circle,
  //                                         //   size: 16,
  //                                         // )
  //
  //                                         // Image.asset(
  //                                         //   AssetConstants.circleCheckImage,
  //                                         //   height: 16,
  //                                         // )
  //                                       ],
  //                                     )
  //                                   ],
  //                                 ),
  //                               ],
  //                             ):Container(),
  //                           ],
  //                         ),
  //                       );
  //                     }
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
  //                       // if (settingProvider.subjectTextEditingController.text !=
  //                       //     "" &&
  //                       //     settingProvider.messageTextEditingController.text !=
  //                       //         "") {
  //                       //   final value =
  //                       //   await settingProvider.sendContactSupportMain(
  //                       //       settingProvider
  //                       //           .subjectTextEditingController.text,
  //                       //       settingProvider
  //                       //           .messageTextEditingController.text);
  //                       //
  //                       //   if (value == "true") {
  //                       //     Navigator.pop(context);
  //                       //     ScaffoldMessenger.of(context).showSnackBar(
  //                       //       SnackBar(
  //                       //         content: Text("Mail sent successfully"),
  //                       //       ),
  //                       //     );
  //                       //   } else {
  //                       //     Navigator.pop(context);
  //                       //     ScaffoldMessenger.of(context).showSnackBar(
  //                       //       SnackBar(
  //                       //         content: Text(value),
  //                       //       ),
  //                       //     );
  //                       //   }
  //                       // } else {
  //                       //   ScaffoldMessenger.of(context).showSnackBar(
  //                       //     SnackBar(
  //                       //       content: Text("Please enter subject and message"),
  //                       //     ),
  //                       //   );
  //                       // }
  //
  //                       if (settingProvider.subjectTextEditingController.text !=
  //                           "" &&
  //                           settingProvider.messageTextEditingController.text !=
  //                               "") {
  //                         print("Sending info");
  //                         final value = await settingProvider
  //                             .sendContactSupportMain(
  //                           settingProvider
  //                               .subjectTextEditingController
  //                               .text,
  //                           settingProvider
  //                               .messageTextEditingController
  //                               .text,
  //                         );
  //                         print(value);
  //                         if (value == "true") {
  //                           Navigator.pop(context);
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(content: Text("Mail sent successfully")),
  //                           );
  //                         } else {
  //                           Navigator.pop(context);
  //                           ScaffoldMessenger.of(
  //                             context,
  //                           ).showSnackBar(SnackBar(content: Text(value)));
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
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    double screenWidth = screenWidthRecognizer(context);

    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
        child: Drawer(
          elevation: 10,
          child: Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return Container(
                color: value.defaultTheme
                    ? Color(0xFFc9d9d9)
                    : Color(0xFF141414),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
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
                          ),
                          CustomContainer(
                            onTap: () {
                              Navigator.of(context).pop();

                              _navigationProvider.previousSelectedIndex =
                                  _navigationProvider.selectedIndex;
                              _navigationProvider.selectedIndex = 29;
                            },
                            backgroundColor: (themeProvider.defaultTheme)
                                ? Color(0xffd9d9d9)
                                : Color(0xff2b2b2f),
                            padding: 0,
                            margin: EdgeInsets.zero,
                            borderRadius: 50,
                            height: 25,
                            width: 25,
                            child: Icon(
                              Icons.notifications,
                              size: 20,
                              color: Color(0xffa8a8a8),
                            ),
                          ),
                          SizedBox(width: 10),
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
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
                              SizedBox(width: 10),
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
                                            : Color(0xfff0f0f0),
                                      ),
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
                                            : Color(0xfff0f0f0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                                  (appConfigProvider
                                              .appConfigData
                                              .data
                                              ?.addFundsEnableDrawer! ==
                                          false)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            height: 50,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _navigationProvider
                                                      .selectedIndex =
                                                  0;
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .account_balance_wallet_outlined,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Add Cash",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                // In your NavDrawerNew file, update the "Create Ladder" section:

(appConfigProvider.appConfigData.data?.createLadderEnableDrawer! == false)
    ? Container()
    : Padding(
        padding: const EdgeInsets.only(left: 20, right: 20.0),
        child: CustomContainer(
          padding: 0,
          margin: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          height: 50,
          onTap: () {
            Navigator.of(context).pop();
            // Direct navigation - same as BottomNavBarNew when value = true
            _navigationProvider.selectedIndex = 3;
          },
          child: Row(
            children: [
              Image.asset(
                "lib/global/assets/logos/ladder.png",
                width: 18,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff0f0f0f)
                    : Color(0xfff0f0f0),
              ),
              SizedBox(width: 10),
              Container(
                width: screenWidth * 0.5,
                child: Text(
                  "Create Ladder",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: (themeProvider.defaultTheme)
                        ? Color(0xff141414)
                        : Color(0xfff0f0f0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

                                  (appConfigProvider
                                              .appConfigData
                                              .data
                                              ?.tradeEnableDrawer! ==
                                          false)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            height: 50,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _navigationProvider
                                                      .selectedIndex =
                                                  1;
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "lib/global/assets/icons/suitcase.png",
                                                  width: 18,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Trade",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  (appConfigProvider
                                              .appConfigData
                                              .data
                                              ?.analyticsEnableDrawer! ==
                                          false)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            height: 50,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _navigationProvider
                                                      .selectedIndex =
                                                  2;
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "lib/global/assets/icons/data-analytics-icon.png",
                                                  width: 18,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                ),

                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Analytics",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  (appConfigProvider
                                              .appConfigData
                                              .data
                                              ?.dematInfoEnableDrawer! ==
                                          false)
                                      ? Container()
                                      : (tradeMainProvider.tradingOptions ==
                                            TradingOptions.tradingWithRealCash)
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            height: 50,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              brokerInfoProvider
                                                  .getCustomerProfile();
                                              brokerInfoProvider.getHoldings();
                                              brokerInfoProvider
                                                  .getAllHoldings();
                                              brokerInfoProvider
                                                  .getCustomerFundsAndMargins();
                                              _navigationProvider
                                                      .selectedIndex =
                                                  19;
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.perm_device_info,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Demat Info",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  (appConfigProvider
                                              .appConfigData
                                              .data
                                              ?.monitorEnableDrawer! ==
                                          false)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            height: 50,
                                            onTap: () {
                                              Navigator.of(context).pop();

                                              _navigationProvider
                                                      .selectedIndex =
                                                  20;
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.monitor,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Monitor",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  (appConfigProvider
                                              .appConfigData
                                              .data
                                              ?.strategiesEnableDrawer! ==
                                          false)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            height: 50,
                                            onTap: () {
                                              Navigator.of(context).pop();

                                              _navigationProvider
                                                      .selectedIndex =
                                                  21;
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .app_registration_rounded,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Strategies",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  (appConfigProvider
                                              .appConfigData
                                              .data
                                              ?.resetCompleteSimulationEnableDrawer! ==
                                          false)
                                      ? Container()
                                      : (tradeMainProvider.tradingOptions ==
                                            TradingOptions.tradingWithRealCash)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            height: 50,
                                            onTap: () {
                                              showResetOptionDialog(
                                                context,
                                                "Start a new run by?",
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.loop,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Start New Run",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  (appConfigProvider
                                              .appConfigData
                                              .data
                                              ?.resetCompleteSimulationEnableDrawer! ==
                                          false)
                                      ? Container()
                                      : (tradeMainProvider.tradingOptions ==
                                            TradingOptions.tradingWithRealCash)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
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
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    (tradeMainProvider
                                                                .tradingOptions ==
                                                            TradingOptions
                                                                .simulationTradingWithSimulatedPrices)
                                                        ? 'Revert to Previous Run' //'Reset complete simulation'
                                                        : 'Revert to Previous Run',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  (false)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            height: 50,
                                            onTap: () {
                                              Navigator.of(context).pop();

                                              _navigationProvider
                                                      .previousSelectedIndex =
                                                  _navigationProvider
                                                      .selectedIndex;
                                              _navigationProvider
                                                      .selectedIndex =
                                                  26;
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.download,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Downloads",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20.0,
                                    ),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.pop(context);
                                        _navigationProvider.selectedIndex = 30;
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.article,
                                            color: (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),

                                          SizedBox(width: 10),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Articles",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color:
                                                    (themeProvider.defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20.0,
                                    ),
                                    child: CustomContainer(
                                      padding: 0,
                                      margin: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      height: 50,
                                      onTap: () {
                                        Navigator.pop(context);
                                        _navigationProvider.selectedIndex = 31;
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.list,
                                            color: (themeProvider.defaultTheme)
                                                ? Color(0xff0f0f0f)
                                                : Color(0xfff0f0f0),
                                            size: 16,
                                          ),

                                          SizedBox(width: 10),
                                          Container(
                                            width: screenWidth * 0.5,
                                            child: Text(
                                              "Rank List",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color:
                                                (themeProvider.defaultTheme)
                                                    ? Color(0xff141414)
                                                    : Color(0xfff0f0f0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  (false)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
                                          child: CustomContainer(
                                            padding: 0,
                                            margin: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            height: 50,
                                            onTap: () {
                                              Navigator.pop(context);
                                              _navigationProvider
                                                      .selectedIndex =
                                                  28;
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.refresh,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Reminder",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  (false)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
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
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Help",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  (false)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20.0,
                                          ),
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
                                                      context,
                                                    ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.support_agent,
                                                  color:
                                                      (themeProvider
                                                          .defaultTheme)
                                                      ? Color(0xff0f0f0f)
                                                      : Color(0xfff0f0f0),
                                                  size: 16,
                                                ),

                                                SizedBox(width: 10),
                                                Container(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    "Customer Support",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color:
                                                          (themeProvider
                                                              .defaultTheme)
                                                          ? Color(0xff141414)
                                                          : Color(0xfff0f0f0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  SizedBox(height: 150),

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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (appConfigProvider
                                                .appConfigData
                                                .data
                                                ?.settingsEnableDrawer! ==
                                            false)
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20.0,
                                            ),
                                            child: CustomContainer(
                                              padding: 0,
                                              margin: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
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
                                                    color:
                                                        (themeProvider
                                                            .defaultTheme)
                                                        ? Color(0xff0f0f0f)
                                                        : Color(0xfff0f0f0),
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    width: screenWidth * 0.5,
                                                    child: Text(
                                                      "Settings",
                                                      style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15,
                                                        color:
                                                            (themeProvider
                                                                .defaultTheme)
                                                            ? Color(0xff141414)
                                                            : Color(0xfff0f0f0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    (appConfigProvider
                                                .appConfigData
                                                .data
                                                ?.logoutEnableDrawer! ==
                                            false)
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20.0,
                                            ),
                                            child: CustomContainer(
                                              padding: 0,
                                              margin: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
                                              height: 50,
                                              onTap: () {
                                                showCustomAlertDialogFromHelper(
                                                  context,
                                                  "Are you sure you want to logout",
                                                  () {
                                                    SharedPreferences.getInstance().then((
                                                      value,
                                                    ) async {
                                                      LoginRestApiService()
                                                          .signOutGoogle();
                                                      await value.remove(
                                                        "reg_id",
                                                      );
                                                      await value.remove(
                                                        "reg_user",
                                                      );
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                      navigateAuthenticationProvider
                                                              .selectedIndex =
                                                          1;

                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              NavigateAuthenticationScreen(),
                                                        ),
                                                        (
                                                          Route<dynamic> route,
                                                        ) =>
                                                            false, // this removes all previous routes
                                                      );

                                                      // Navigator.of(context).pushRemove(
                                                      //     '/', (Route<dynamic> route) => false);
                                                    });
                                                  },
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.logout,
                                                    color:
                                                        (themeProvider
                                                            .defaultTheme)
                                                        ? Color(0xff0f0f0f)
                                                        : Color(0xfff0f0f0),
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    width: screenWidth * 0.5,
                                                    child: Text(
                                                      "Logout",
                                                      style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15,
                                                        color:
                                                            (themeProvider
                                                                .defaultTheme)
                                                            ? Color(0xff141414)
                                                            : Color(0xfff0f0f0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                    SizedBox(height: 3),

                                    Text(
                                      "v${version}+${buildNumber}",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
