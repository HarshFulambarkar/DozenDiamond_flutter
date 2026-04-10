import 'dart:io';

import 'package:bottom_picker/cupertino/cupertino_date_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/loading_dialog.dart';
import 'package:dozen_diamond/reminders/services/reminder_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../modify_ladder_target_price/stateManagment/modifyLadderTargetPriceProvider.dart';
import '../../subscriptions/screens/subscriptions_list_screen.dart';
import '../../subscriptions/stateManagement/subscription_provider.dart';
import '../stateManagement/app_config_provider.dart';
import '../stateManagement/user_config_provider.dart';
import '../widgets/my_text_field.dart';

class Utility {
  Future<void> openAppStore(String appUrl) async {
    // const appPackageName = 'com.example.walldivine'; // Replace with your app's package name
    const appPackageName =
        'com.wallpaper.app.hd.4k'; // Replace with your app's package name
    // final appStoreUrl = 'https://apps.apple.com/us/app/walldivine-4k-wallpapers/id6739001814';
    final appStoreUrl = appUrl;

    print("launching");
    print(appStoreUrl);
    if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
      await launchUrl(Uri.parse(appStoreUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $appStoreUrl';
    }
  }

  Future<void> openPlayStore(String appUrl) async {
    // const appPackageName = 'com.example.walldivine'; // Replace with your app's package name
    const appPackageName =
        'com.wallpaper.app.hd4k'; // Replace with your app's package name
    // final playStoreUrl = 'https://play.google.com/store/apps/details?id=$appPackageName';
    final playStoreUrl = appUrl;

    if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
      await launchUrl(Uri.parse(playStoreUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $playStoreUrl';
    }
  }

  BigInt toUnits(String s, int scale) {
    // scale = number of decimal places to preserve, e.g., 2 for cents, 3 for mill, 2 for 0.05? (use 2 or 3+ as needed)
    final parts = s.split('.');
    final whole = BigInt.parse(parts[0]);
    final frac = parts.length > 1 ? parts[1] : '0';
    final padded = (frac + '0' * scale).substring(0, scale);
    return whole * BigInt.from(10).pow(scale) + BigInt.parse(padded);
  }

  Future<dynamic> showUpdate(
      BuildContext context, String isSkip, String updateUrl) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              // height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New update available",
                      // "A new update available",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Text(
                      "Exciting update available, upgrade now to enjoy an even better experience",
                      // "Exciting update available! Upgrade now to enjoy an even better experience!",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // TextField(
                    //   decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       hintText: 'A new update Available'),
                    // ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                // InAppUpdate.performImmediateUpdate()
                                //     .catchError((e) => showSnack(e.toString()));
                                if (Platform.isIOS) {
                                  openAppStore(updateUrl);
                                } else {
                                  openPlayStore(updateUrl);
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.green,
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(5),
                                // ),
                                // side: const BorderSide(
                                //   color: Color(0xFF0099CC),
                                // ),
                              ),
                              // style: ElevatedButton.styleFrom().copyWith(
                              //   backgroundColor: MaterialStateProperty<Color?>?.green,
                              // ),
                              child: Text('Update',
                                  style: TextStyle(color: Colors.white)
                                  // style: TextStyle(fontSize: 17)
                                  )),
                          // child: CustomContainer(
                          //   height: 50,
                          //   onTap: () {
                          //
                          //     // InAppUpdate.performImmediateUpdate()
                          //     //     .catchError((e) => showSnack(e.toString()));
                          //     if(Platform.isIOS) {
                          //       openAppStore(updateUrl);
                          //     } else {
                          //       openPlayStore(updateUrl);
                          //     }
                          //
                          //   },
                          //   child: Center(
                          //     child: Text(
                          //       "Update",
                          //       // "Update",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //   ),
                          //   backgroundColor: Colors.blue,
                          // ),
                        ),
                        (isSkip == "false")
                            ? Expanded(
                                child: CustomContainer(
                                  height: 50,
                                  onTap: () {
                                    // InAppUpdate.performImmediateUpdate()
                                    //     .catchError((e) => showSnack(e.toString()));
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                    child: Text(
                                      "Skip",
                                      // "Skip",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              )
                            : Container(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showLoadingDialog() {
    Get.dialog(LoadingDialog(), barrierDismissible: false);
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen!) Get.back(closeOverlays: false);
    ;
  }

  String? formatUtcToLocal(String? utcTime) {
    if (utcTime == null || utcTime.isEmpty) return null; // handle null safely

    try {
      // Parse ISO string (intl not required here, DateTime.parse handles ISO 8601 well)
      DateTime parsedUtc = DateTime.parse(utcTime);

      // Convert to local
      DateTime localTime = parsedUtc.toLocal();

      // Format output
      return DateFormat('dd/MM/yyyy hh:mm:ss a').format(localTime);
    } catch (e) {
      return "NA"; // return null if invalid string
    }
    // DateTime unFormatedUtcTime =
    // new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").tryParse(utcTime!, true) ?? DateTime.now();
    // DateTime formatedUtcTime = DateTime.parse(unFormatedUtcTime.toString());
    // DateFormat outputFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');
    // String localTime =
    // outputFormat.format(formatedUtcTime.toLocal()); // UTC to local time
    // return localTime;
  }

  Future<dynamic> showEnterBrokerOtpPopUp(BuildContext context) {
    UserConfigProvider userConfigProvider =
        Provider.of<UserConfigProvider>(context, listen: false);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          double screenWidth = screenWidthRecognizer(context);
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.only(bottom: 5),
              width: screenWidth,
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
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 8.0),
                      //   child: InkWell(
                      //     onTap: () {
                      //       Navigator.of(context).pop();
                      //     },
                      //     child: Icon(
                      //         Icons.clear,
                      //         color: Colors.white
                      //     ),
                      //   ),
                      // ),

                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: const Text(
                          "Enter Broker TOTP",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFffffff),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   "TOTP",
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     color: Color(0xFFffffff),
                            //   ),
                            // ),

                            SizedBox(
                              height: 5,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PinCodeTextField(
                                  // focusNode: pinFocusNode,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  length: 6,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  textStyle: TextStyle(
                                    color: Color(0xFFffffff),
                                  ),
                                  keyboardType: TextInputType.number,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    activeColor: Colors.blue,
                                    activeFillColor: Colors.blue,
                                    disabledColor: Colors.white,
                                    errorBorderColor: Colors.white,
                                    inactiveColor: Colors.white,
                                    inactiveFillColor: Colors.white,
                                    selectedColor: Colors.white,
                                    selectedFillColor: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  controller:
                                      userConfigProvider.brokerTotpController,
                                  onCompleted: (v) async {},
                                  onChanged: (value) {
                                    print(value);
                                  },
                                  beforeTextPaste: (text) {
                                    print("Allowing to paste $text");
                                    return true;
                                  },
                                  appContext: context,
                                ),
                                (userConfigProvider.brokerTotpError == "")
                                    ? Container()
                                    : Text(userConfigProvider.brokerTotpError,
                                        style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF0099CC),
                          ),
                        ),
                        onPressed: () async {
                          if (userConfigProvider.brokerTotpController.text ==
                              "") {
                            // userConfigProvider.brokerTotp Error = "Enter Valid TOTP";
                          } else {
                            userConfigProvider.brokerTotpError = "";
                            userConfigProvider.submitBrokerTotp(context);
                          }
                        },
                        child: const Text(
                          'Submit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFffffff),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ]),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> showPlanExpiringPopUp(BuildContext context, DateTime expiryDate) {
    UserConfigProvider userConfigProvider =
    Provider.of<UserConfigProvider>(context, listen: false);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          double screenWidth = screenWidthRecognizer(context);
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.only(bottom: 5),
              width: screenWidth,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                              Icons.clear,
                              color: Colors.white
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: const Text(
                          "Plan Expiring",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFffffff),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your plan is going to expire on ${DateFormat('dd MMM yyyy, hh:mm a').format(expiryDate)}, renew your plan to continue using our services.",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFffffff),
                              ),
                            ),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          padding:
                          EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF0099CC),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          SubscriptionProvider subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
                          subscriptionProvider.getSubscriptionPlans();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SubscriptionsListScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Renew',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFffffff),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ]),
                  ),
                ],
              ),
            ),
          );
        });
  }

  double findBrokeragePerExeOrder(
      double orderSize, List<double> executedPrice) {
    try {
      double totalCalculatedBrokerage = 0.0;
      double averageCalculatedBrokerage = 0.0;

      for (int i = 0; i < executedPrice.length; i++) {
        double orderExecutionCost = orderSize * executedPrice[i];
        double calculatedBrokerage = orderExecutionCost * 0.1 / 100;
        if (calculatedBrokerage > 20) {
          calculatedBrokerage = 20.00;
        } else if (calculatedBrokerage < 2) {
          calculatedBrokerage = 2.0;
        } else {
          calculatedBrokerage = calculatedBrokerage;
        }
        totalCalculatedBrokerage =
            totalCalculatedBrokerage + calculatedBrokerage;
      }

      // averageCalculatedBrokerage = totalCalculatedBrokerage/executedPrice.length;

      return totalCalculatedBrokerage;
    } catch (error) {
      print("Error in the find Brokerage per exe order: ${error}");
      return 2.0;
      // throw error;
    }
  }

  bool checkForSubscription(BuildContext context) {

    print("inside checkForSubscription");

    UserConfigProvider userConfigProvider = Provider.of<UserConfigProvider>(context, listen: false);
    TradeMainProvider tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: false);

    print(tradeMainProvider.tradingOptions);
    print(TradingOptions.tradingWithRealCash);
    print(userConfigProvider.userConfigData.userSubscriptionVerified);

    if(tradeMainProvider.tradingOptions != TradingOptions.tradingWithRealCash) {
      return true;
    }

    if(userConfigProvider.userConfigData.userSubscriptionVerified == false) {
      if((tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)) {

        showDialog(
          context: context,
          builder: (context) {
            return noSubscriptionDialog(context);
          },
        );

        return userConfigProvider.userConfigData.userSubscriptionVerified ?? false;
      }

      return userConfigProvider.userConfigData.userSubscriptionVerified ?? false;
    }


    return userConfigProvider.userConfigData.userSubscriptionVerified ?? false;
  }

  Widget noSubscriptionDialog(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return AlertDialog(
      backgroundColor: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xFF15181F),
      title: Text(
        "Subscribe to a plan",
        style: TextStyle(
          color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
        ),
      ),
      content: Text(
        "To activate ladder you need to subscribe to a plan.",
        style: TextStyle(
          color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
        ),
      ),
      actions: [
        Consumer<TradeMainProvider>(builder: (context, value, child) {
          return ElevatedButton(
            child: Text(
              "Subscribe",
              style: TextStyle(
                color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              SubscriptionProvider subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
              subscriptionProvider.getSubscriptionPlans();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SubscriptionsListScreen(),
                ),
              );


            },
          );
        }),
        ElevatedButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Future<void> minLimitPriceAndTimeInMinDialog(BuildContext context, String type, String orderId, String message) {

    AppConfigProvider appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateSB) {
            return AlertDialog(
              title: Text(
                // 'Delete Ladder',
                type,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text('Select Product type'),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  //
                  // buildLimitAndMarketDropDown(context, setStateSB),

                  SizedBox(
                    height: 5,
                  ),

                  Text(message),

                  SizedBox(
                    height: 15,
                  ),

                  Text('Enter Minimum Limit Price'),

                  SizedBox(
                    height: 5,
                  ),

                  buildLimitPriceTextField(context),

                  SizedBox(
                    height: 10,
                  ),

                  Text('Enter Time in Min'),

                  SizedBox(
                    height: 5,
                  ),
                  buildLimitPriceTimeInMinTextField(context),
                ],
              ),
              actions: [
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            // ClosePositionRequest closePositionReq;
                            // stockName = stock;

                            if (appConfigProvider.limitPrice == 'null' || appConfigProvider.limitPriceTimeInMin == 'null') {

                              if(appConfigProvider.limitPrice == 'null') {
                                appConfigProvider.limitPriceErrorText = "Please enter min limit price";
                              }

                              if(appConfigProvider.limitPriceTimeInMin == 'null') {
                                appConfigProvider.limitPriceTimeInMinErrorText = "Please enter time in min";
                              }
                            } else {

                              Navigator.pop(context);
                              appConfigProvider.updateGradedOrder(orderId, double.parse(appConfigProvider.limitPrice), int.parse(appConfigProvider.limitPriceTimeInMin));
                              // appConfigProvider.modifyTargetPriceBusinessLogic(context);
                            }

                            setStateSB(() {});
                          },
                          child: Text(
                            'Proceed',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.blue,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                )
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              backgroundColor: const Color(0xFF15181F),
            );
          });
        });
  }

  Widget buildLimitPriceTextField(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    AppConfigProvider appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

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
            maxLength: 9,
            elevation: 0,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            // textStyle: (themeProvider.defaultTheme)
            //     ? TextStyle(color: Colors.black)
            //     : kBodyText,
            // borderColor: Color(0xff2c2c31),
            margin: EdgeInsets.zero,
            focusedBorderColor: ((appConfigProvider.limitPriceErrorText != ""))
                ? Color(0xffd41f1f)
                : Color(0xff5cbbff),
            counterText: "",
            textInputFormatters: [
              FilteringTextInputFormatter.digitsOnly

              // FilteringTextInputFormatter.allow(
              //   RegExp(r'^[0-9,\.]+$'),
              // ),
            ],
            borderRadius: 8,

            labelText: '',
            onChanged: (value) {
              print(value);

              if (value.isEmpty) {
                appConfigProvider.limitPrice = 'null';
              } else {
                appConfigProvider.limitPrice = value;
              }
            },
          ),
        ),
        // MyTextField(
        //   textInputFormatters: <TextInputFormatter>[
        //     FilteringTextInputFormatter.digitsOnly
        //   ],
        //   borderRadius: 5,
        //
        //   currencyFormat: false,
        //   isFilled: true,
        //   elevation: 0,
        //   isLabelEnabled: false,
        //   borderWidth: 1,
        //   fillColor: Colors.transparent,
        //   contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        //
        //   onChanged: (value) {
        //     print(value);
        //
        //     if (value.isEmpty) {
        //       ladderProvider.limitPrice = 'null';
        //     } else {
        //       ladderProvider.limitPrice = value;
        //     }
        //   },
        //   borderColor: Colors.white,
        //   labelText: "Enter Price",
        //   hintText: "Enter Price",
        //   maxLength: 9,
        //   counterText: "",
        //
        //   overrideHintText: true,
        //
        //   focusedBorderColor: Colors.white,
        //   isPasswordField: false,
        //
        //   isEnabled: true,
        //   // showLeadingWidget: true,
        //
        //   keyboardType: TextInputType.number,
        //
        //   validator: (value) {},
        // ),
        (appConfigProvider.limitPriceErrorText == "")
            ? Container()
            : Text(appConfigProvider.limitPriceErrorText,
            style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildLimitPriceTimeInMinTextField(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    AppConfigProvider appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            maxLength: 4,
            elevation: 0,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            // textStyle: (themeProvider.defaultTheme)
            //     ? TextStyle(color: Colors.black)
            //     : kBodyText,
            // borderColor: Color(0xff2c2c31),
            margin: EdgeInsets.zero,
            focusedBorderColor: ((appConfigProvider.limitPriceTimeInMinErrorText != ""))
                ? Color(0xffd41f1f)
                : Color(0xff5cbbff),
            counterText: "",
            textInputFormatters: [
              FilteringTextInputFormatter.digitsOnly

              // FilteringTextInputFormatter.allow(
              //   RegExp(r'^[0-9,\.]+$'),
              // ),
            ],
            borderRadius: 8,

            labelText: '',
            onChanged: (value) {
              print(value);

              print(value);

              if (value.isEmpty) {
                appConfigProvider.limitPriceTimeInMin = 'null';
              } else {
                appConfigProvider.limitPriceTimeInMin = value;
              }
            },
          ),
        ),

        // MyTextField(
        //   textInputFormatters: <TextInputFormatter>[
        //     FilteringTextInputFormatter.digitsOnly
        //   ],
        //   borderRadius: 5,
        //
        //   currencyFormat: false,
        //   isFilled: true,
        //   elevation: 0,
        //   isLabelEnabled: false,
        //   borderWidth: 1,
        //   fillColor: Colors.transparent,
        //   contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        //
        //   onChanged: (value) {
        //     print(value);
        //
        //     if (value.isEmpty) {
        //       positionProvider.limitPrice = 'null';
        //     } else {
        //       positionProvider.limitPrice = value;
        //     }
        //   },
        //   borderColor: Colors.white,
        //   labelText: "Enter Price",
        //   hintText: "Enter Price",
        //   maxLength: 9,
        //   counterText: "",
        //
        //   overrideHintText: true,
        //
        //   focusedBorderColor: Colors.white,
        //   isPasswordField: false,
        //
        //   isEnabled: true,
        //   // showLeadingWidget: true,
        //
        //   keyboardType: TextInputType.number,
        //
        //   validator: (value) {},
        // ),
        (appConfigProvider.limitPriceTimeInMinErrorText == "")
            ? Container()
            : Text(appConfigProvider.limitPriceTimeInMinErrorText,
            style: TextStyle(color: Colors.red))
      ],
    );
  }

  Future<void> errorDialog(BuildContext context, String status, String errorTitle, String errorDescription, String request) {
    double screenWidth = screenWidthRecognizer(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: screenWidth - 40,
            padding: const EdgeInsets.only(bottom: 5),
            // width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
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
                      width: screenWidth * 0.7,
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      child: Text(
                        "${errorTitle}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                    Text(
                      "${errorDescription}",
                      style: TextStyle(
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    )

                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
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
    );
  }

  Future<String> fillVariableInMessage(String message) async {
    String userName = "";
    await SharedPreferences.getInstance().then((value) {
      userName = value.getString("reg_user") ?? "";
    });
    return message.replaceAll("#user_name#", userName);
  }

  Future<void> showInAppMessage(BuildContext context, String title, String description) async {
    double screenWidth = screenWidthRecognizer(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    title = await fillVariableInMessage(title);
    description = await fillVariableInMessage(description);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: screenWidth - 40,
              padding: const EdgeInsets.only(bottom: 5),
              // width: double.infinity,
              decoration: BoxDecoration(
                color: themeProvider.defaultTheme ? Colors.white : Color(0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
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
                        width: screenWidth * 0.7,
                        margin: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          "${title.replaceAll("#user_name#", "")}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                      Text(
                        "${description.replaceAll("#user_name#", "")}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      )

                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
    );
  }


  Widget aadhaarVerifyDialog(BuildContext context, bool isSkippable) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return AlertDialog(
      backgroundColor: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xFF15181F),
      title: Text(
        "Aadhaar Verification",
        style: TextStyle(
          color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
        ),
      ),
      content: Text(
        "You will need to verify you aadhaar card to enable real trading",
        // "Enter otp you get from webinar and verify you webinar and then proceed",
        style: TextStyle(
          color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
        ),
      ),
      actions: [
        Consumer<TradeMainProvider>(builder: (context, value, child) {
          return ElevatedButton(
            child: Text(
              "Proceed",
              style: TextStyle(
                color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);



            },
          );
        }),
        ElevatedButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

}
