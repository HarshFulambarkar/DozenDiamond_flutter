import 'package:dozen_diamond/DD_Navigation/widgets/common_screen.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../../manage_brokers/screens/broker_list.dart';
import '../stateManagement/theme_provider.dart';
import 'package:dozen_diamond/global/functions/utils.dart';

Widget showConfirmationDialog(
    int indexValue, String message, BuildContext context) {
  ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
  return AlertDialog(
    backgroundColor: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xFF15181F),
    title: Text(
        "Are you sure",
      style: TextStyle(
        color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
      ),
    ),
    content: Text(
        "Are You sure you want to switch to $message",
      style: TextStyle(
        color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
      ),
    ),
    actions: [
      Consumer<TradeMainProvider>(builder: (context, value, child) {
        return ElevatedButton(
          child: Text(
              "Confirm",
            style: TextStyle(
              color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
            ),
          ),
          onPressed: () {
            if (indexValue == 0) {
              value.tradingOptions =
                  TradingOptions.simulationTradingWithSimulatedPrices;
            } else if (indexValue == 1) {
              value.tradingOptions =
                  TradingOptions.simulationTradingWithRealValues;
            } else {
              value.tradingOptions = TradingOptions.tradingWithRealCash;
            }
            Provider.of<TradeMainProvider>(context, listen: false)
                .switchingTradeMode(indexValue);

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

Widget showWarningDialog(String message, BuildContext context) {
  return AlertDialog(
    backgroundColor: const Color(0xFF15181F),
    title: Text("Attention", style: TextStyle(color: Colors.red)),
    content: Text(
        "To Turn off $message, you need to activate any other Trading options"),
    actions: [
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Back")),
    ],
  );
}

Widget switchTarding() {
  return Consumer<TradeMainProvider>(builder: (context, value, child) {
    AppConfigProvider appConfigProvider =
        Provider.of<AppConfigProvider>(context, listen: true);
    UserConfigProvider userConfigProvider = Provider.of<UserConfigProvider>(context, listen: true);
    if (value.tradingOptions == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              // decoration: BoxDecoration(color: Colors.amber),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("Simulation (Paper trading)",
                              style: TextStyle(fontSize: 16)),
                        ),
                        Switch(
                          value: value.tradingOptions ==
                                  TradingOptions
                                      .simulationTradingWithSimulatedPrices
                              ? true
                              : false,
                          onChanged: (value1) => {
                            if (value1)
                              {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return showConfirmationDialog(0,
                                        "Simulation (Paper trading)", context);
                                  },
                                ),
                              }
                            else
                              {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return showWarningDialog(
                                          "Simulation (Paper trading)",
                                          context);
                                    })
                              },
                          },
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.white,
                          activeColor: const Color(0xFF0099CC),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("Real time (Paper trading)",
                              style: TextStyle(fontSize: 16)),
                        ),
                        Switch(
                          value: value.tradingOptions ==
                                  TradingOptions.simulationTradingWithRealValues
                              ? true
                              : false,
                          onChanged: (value1) => {
                            if (value1)
                              {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return showConfirmationDialog(1,
                                        "Real time (Paper trading)", context);
                                  },
                                ),
                              }
                            else
                              {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return showWarningDialog(
                                          "Real time (Paper trading)", context);
                                    })
                              },
                          },
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.white,
                          activeColor: const Color(0xFF0099CC),
                        ),
                      ],
                    ),

                    (appConfigProvider.appConfigData.data?.realTradingEnable != true)
                        ? (appConfigProvider.appConfigData.data?.realTradingEnable == false  ||
                            userConfigProvider.userConfigData.realTradingEnable == false)
                            ? Container()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text("Real Trading",
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Switch(
                                    value: value.tradingOptions ==
                                            TradingOptions.tradingWithRealCash
                                        ? true
                                        : false,
                                    onChanged: (value1) => {
                                      // Fluttertoast.showToast(
                                      //     msg: "Real Market trading is currently locked")
                                      if (value1)
                                        {
                                          handleRealTrading(context),

                                        }
                                      else
                                        {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return showWarningDialog(
                                                    "Real Trading",
                                                    context);
                                              })
                                        },
                                    },
                                    inactiveTrackColor: Colors.grey,
                                    inactiveThumbColor: Colors.white,
                                    activeColor: const Color(0xFF0099CC),
                                  ),
                                ],
                              )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text("Real Trading",
                                    style: TextStyle(fontSize: 16)),
                              ),
                              Switch(
                                value: value.tradingOptions ==
                                        TradingOptions.tradingWithRealCash
                                    ? true
                                    : false,
                                onChanged: (value1) => {
                                  // Fluttertoast.showToast(
                                  //     msg: "Real Market trading is currently locked")
                                  if (value1)
                                    {

                                      handleRealTrading(context),

                                    }
                                  else
                                    {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return showWarningDialog(
                                                "Real Time Trading", context);
                                          })
                                    },
                                },
                                inactiveTrackColor: Colors.grey,
                                inactiveThumbColor: Colors.white,
                                activeColor: const Color(0xFF0099CC),
                              ),
                            ],
                          ),
                  ]),
            ),
          ),
        ],
      );
    }
  });
}

void handleRealTrading(context) {

  UserConfigProvider userConfigProvider = Provider.of<UserConfigProvider>(context, listen: false);

  print("inside handleRealTrading");
  print(userConfigProvider.userConfigData.webinarOtpVerified == false);

  // if(userConfigProvider.userConfigData.brokerId == null) {
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return integrateBrokerDialog(context);
  //     },
  //   );
  //
  // } else

  // if(userConfigProvider.userConfigData.aadhaarCardVerified == null || userConfigProvider.userConfigData.aadhaarCardVerified == false) {
  if(false) {

    showDialog(
      context: context,
      builder: (context) {
        return Utility().aadhaarVerifyDialog(context, false);
      },
    );

  } else if(userConfigProvider.userConfigData.webinarOtpVerified == null || userConfigProvider.userConfigData.webinarOtpVerified == false) {

    showDialog(
      context: context,
      builder: (context) {
        return webinarVerifyOtpDialog(context);
      },
    );

  } else if(userConfigProvider.userConfigData.isQuestionSolvedInRealTrade == null || userConfigProvider.userConfigData.isQuestionSolvedInRealTrade == false) {

    showDialog(
      context: context,
      builder: (context) {
        return solveQuestionnaireDialog(context);
      },
    );

  } else if(userConfigProvider.userConfigData.brokerId == null) {

    showDialog(
      context: context,
      builder: (context) {
        return integrateBrokerDialog(context);
      },
    );

  } else {
    showDialog(
      context: context,
      builder: (context) {
        return showConfirmationDialog(
            2, "Real Trading", context);
      },
    );
  }

}

Widget integrateBrokerDialog(BuildContext context) {
  ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
  return AlertDialog(
    backgroundColor: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xFF15181F),
    title: Text(
      "Integrate Broker",
      style: TextStyle(
        color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
      ),
    ),
    content: Text(
      "You have not integrated any broker on our platform, first integrate broker then proceed",
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

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BrokerList(),
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

Widget webinarVerifyOtpDialog(BuildContext context) {
  ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
  return AlertDialog(
    backgroundColor: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xFF15181F),
    title: Text(
      "Webinar Verification",
      style: TextStyle(
        color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
      ),
    ),
    content: Text(
      "You will need an OTP from a webinar after you click Proceed.",
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
            NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
            navigationProvider.previousSelectedIndex = navigationProvider.selectedIndex;
            // navigationProvider.selectedIndex = 23;
            navigationProvider.selectedIndex = 24;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CommonScreen(),
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

Widget solveQuestionnaireDialog(BuildContext context) {
  ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
  return AlertDialog(
    backgroundColor: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xFF15181F),
    title: Text(
      "Solve Questionnaire",
      style: TextStyle(
        color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
      ),
    ),
    content: Text(
      "Pass our questionnaire to enable real time trading",
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
            NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
            navigationProvider.previousSelectedIndex = navigationProvider.selectedIndex;
            navigationProvider.selectedIndex = 23;
            // navigationProvider.selectedIndex = 24;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CommonScreen(),
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
