import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_bottom_sheets.dart';
import '../../global/widgets/my_text_field.dart';
import '../models/withdrawal_option_model.dart';
import '../stateManagement/funds_provider.dart';

class WithdrawalOptionNew extends StatefulWidget {
  final double widthOfWidget;
  const WithdrawalOptionNew({Key? key, this.widthOfWidget = 0})
      : super(key: key);

  @override
  State<WithdrawalOptionNew> createState() => _WithdrawalOptionNewState();
}

class _WithdrawalOptionNewState extends State<WithdrawalOptionNew> {
  late ThemeProvider themeProvider;
  late TradeMainProvider tradeMainProvider;
  late FundsProvider fundsProvider;

  final List<WithdrawalOptionModel> withDrawalOptionList = [
    WithdrawalOptionModel(
      optionDiscription:
          "Extra cash will be withdrawn", //"Only the profits earned can be withdrawn",
      optionName: "Withdraw Extra Cash",
      optionIcon: Icons.wallet,
    ),
    WithdrawalOptionModel(
      optionDiscription:
          // "Any amount entered less than the Total cash available amount can be withdrawn",
          "Available cash will be withdrawn",
      optionName: "Withdraw Available Cash",
      optionIcon: Icons.money_sharp,
    ),
    // WithdrawalOptionModel(
    //   optionDiscription:
    //   "Selling all stocks purchased for the company and making another investment in a new company, so, whatever the remaining balance left, that can be withdrawn ",
    //   optionName: "Exit one stock",
    //   optionIcon: Icons.account_balance_wallet_rounded,
    // ),
  ];

  double parseAndTrim(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value.trim()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);
    fundsProvider = Provider.of<FundsProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);

    return Consumer<ThemeProvider>(builder: (context, value, child) {
      double totalCash = parseAndTrim(
              fundsProvider.accountCashDetails?.data?.accountUnallocatedCash) +
          parseAndTrim(
              fundsProvider.accountCashDetails?.data?.accountExtraCashLeft);

      return Dialog(
        backgroundColor: value.defaultTheme ? Colors.white : Color(0xff1c1c1c),
        child: Container(
          padding: const EdgeInsets.only(bottom: 5),
          width: widget.widthOfWidget,
          decoration: BoxDecoration(
            color: value.defaultTheme ? Colors.white : Color(0xff1c1c1c),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              // strokeAlign: StrokeAlign.outside,
              style: BorderStyle.solid,
              color: Colors.white,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: value.defaultTheme ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      top: 20,
                      // horizontal: 10,
                    ),
                    child: const Text(
                      "Withdraw Funds",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: withDrawalOptionList
                    .map(
                      (e) => Column(
                        children: [
                          Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                0,
                              ),
                              // side: BorderSide(color: Colors.white)),
                              // elevation: 20,
                            ),
                            color: value.defaultTheme
                                ? Colors.white
                                : Color(0xff1c1c1c),
                            child: ListTile(
                              dense: true,
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: value.defaultTheme
                                    ? Color(0xff1c1c1c)
                                    : Colors.white,
                                size: 18,
                              ),
                              leading: Icon(
                                e.optionIcon,
                                color: value.defaultTheme
                                    ? Color(0xff1c1c1c)
                                    : Colors.white,
                              ),
                              title: Text(
                                e.optionName,
                                style: TextStyle(
                                  color: value.defaultTheme
                                      ? Color(0xff1c1c1c)
                                      : Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.optionDiscription,
                                      style: TextStyle(
                                        color: value.defaultTheme
                                            ? Color(0xff1c1c1c)
                                            : Colors.white54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        ((e.optionName.toLowerCase() ==
                                                "withdraw extra cash"))
                                            ? "Extra Cash: ${amountToInrFormat(context, double.tryParse(fundsProvider.accountCashDetails?.data?.accountExtraCashLeft ?? "0.0")) ?? "N/A"}"
                                            : "Available Cash: ${amountToInrFormat(context, totalCash)}",
                                        style: TextStyle(
                                          color: value.defaultTheme
                                              ? Color(0xff1c1c1c)
                                              : Colors.white54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                // Navigator.of(context).pop();
                                // switch (e.optionName) {
                                //   case "Exit one stock":
                                //     Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             const BottomNavigationbar(
                                //           bottomNavigatonIndex: 1,
                                //         ),
                                //       ),
                                //     );
                                //     break;
                                //   default:
                                //     Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             const WithdrawFunds(),
                                //       ),
                                //     );
                                // }
                                // Fluttertoast.showToast(
                                //     msg: "This feature will unlock soon");
                                if (e.optionName.toLowerCase() ==
                                    "withdraw extra cash") {
                                  CustomBottomSheets
                                      .showBottomSheetWithHeightWithoutClose(
                                          buildWithdrawExtraCashBottomSheet(
                                              context, screenWidth),
                                          context,
                                          height: 260);
                                } else {
                                  CustomBottomSheets
                                      .showBottomSheetWithHeightWithoutClose(
                                          buildWithdrawAvailableCashBottomSheet(
                                              context, screenWidth),
                                          context,
                                          height: 260);
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              color: value.defaultTheme
                                  ? Colors.black
                                  : Colors.white54,
                              height: 0.1,
                              thickness: 0.5,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildWithdrawExtraCashBottomSheet(
      BuildContext context, double screenWidth) {
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 22,
          ),
          Icon(
            Icons.money_outlined,
            color: Color(0xff0090ff),
            size: 35,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "Withdraw Extra Cash",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Color(0xfff0f0f0),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Form(
            child: SizedBox(
              width: screenWidth - 32,
              height: 40,
              child: MyTextField(
                isFilled: true,
                fillColor: (themeProvider.defaultTheme)
                    ? Color(0xffCACAD3)
                    : Color(0xff2c2c31),
                borderColor: (themeProvider.defaultTheme)
                    ? Color(0xffCACAD3)
                    : Color(0xff2c2c31),
                textStyle: TextStyle(
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
                maxLength: 14,
                elevation: 0,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                // textStyle: (themeProvider.defaultTheme)
                //     ? TextStyle(color: Colors.black)
                //     : kBodyText,
                // borderColor: Color(0xff2c2c31),
                margin: EdgeInsets.zero,
                // focusedBorderColor: (showAddCashFieldError)
                //     ? Color(0xffd41f1f)
                //     : Color(0xff5cbbff),
                // validator: (value2) {
                //   if (value2!.isEmpty) {
                //     // return "* Required";
                //     addCashFieldError = "* Required";
                //     showAddCashFieldError = true;
                //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //       setState(() {});
                //     });
                //     return null;
                //   } else if (!RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$')
                //       .hasMatch(value2)) {
                //     emailFieldError = "Enter Correct Email Address";
                //     showEmailFieldError = true;
                //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //       setState(() {});
                //     });
                //     // return "Enter Correct Email Address";
                //     return null;
                //   } else {
                //     emailFieldError = "";
                //     showEmailFieldError = false;
                //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //       setState(() {});
                //     });
                //     return null;
                //   }
                // },
                counterText: "",
                textInputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[0-9,\.]+$'),
                  ),
                  NumberToCurrencyFormatter()
                ],
                controller:
                    fundsProvider.withdrawExtraCashTextEditingController,
                borderRadius: 8,
                labelText: '',
                onChanged: (String) {},
              ),
            ),
          ),
          SizedBox(
            height: 22,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.5,
                      // color: Color(0xfff0f0f0)
                      color: Color(0xff0090ff)),
                ),
              ),

              SizedBox(
                width: 22,
              ),
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

                  if (fundsProvider
                              .withdrawExtraCashTextEditingController.text ==
                          "" &&
                      fundsProvider.withdrawExtraCashTextEditingController.text
                          .isEmpty) {
                  } else {
                    fundsProvider
                        .withdrawExtraCash(
                      tradeMainProvider.tradingOptions,
                    )
                        .then((onValue) {
                      print("before calling fundsProvider.callInitialApi");
                      fundsProvider.callInitialApi();
                      print("after calling fundsProvider.callInitialApi");

                      print("inside value of withdrawExtraCash");
                      Navigator.pop(context);
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 8, bottom: 8.0),
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.5,
                        color: Color(0xfff0f0f0)
                        // color: (themeProvider.defaultTheme)
                        //     ?Color(0xfff0f0f0)
                        //     :Color(0xff1a1a25)
                        ),
                  ),
                ),
              ),

              SizedBox(
                width: 18,
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget buildWithdrawAvailableCashBottomSheet(
      BuildContext context, double screenWidth) {
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 22,
          ),
          Icon(
            Icons.money_outlined,
            color: Color(0xff0090ff),
            size: 35,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "Withdraw Available Cash",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Color(0xfff0f0f0),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Form(
            child: SizedBox(
              width: screenWidth - 32,
              height: 40,
              child: MyTextField(
                isFilled: true,
                fillColor: (themeProvider.defaultTheme)
                    ? Color(0xffCACAD3)
                    : Color(0xff2c2c31),
                borderColor: (themeProvider.defaultTheme)
                    ? Color(0xffCACAD3)
                    : Color(0xff2c2c31),
                textStyle: TextStyle(
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
                maxLength: 14,
                elevation: 0,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                // textStyle: (themeProvider.defaultTheme)
                //     ? TextStyle(color: Colors.black)
                //     : kBodyText,
                // borderColor: Color(0xff2c2c31),
                margin: EdgeInsets.zero,
                // focusedBorderColor: (showAddCashFieldError)
                //     ? Color(0xffd41f1f)
                //     : Color(0xff5cbbff),
                // validator: (value2) {
                //   if (value2!.isEmpty) {
                //     // return "* Required";
                //     addCashFieldError = "* Required";
                //     showAddCashFieldError = true;
                //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //       setState(() {});
                //     });
                //     return null;
                //   } else if (!RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$')
                //       .hasMatch(value2)) {
                //     emailFieldError = "Enter Correct Email Address";
                //     showEmailFieldError = true;
                //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //       setState(() {});
                //     });
                //     // return "Enter Correct Email Address";
                //     return null;
                //   } else {
                //     emailFieldError = "";
                //     showEmailFieldError = false;
                //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //       setState(() {});
                //     });
                //     return null;
                //   }
                // },
                counterText: "",
                textInputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[0-9,\.]+$'),
                  ),
                  NumberToCurrencyFormatter()
                ],
                controller:
                    fundsProvider.withdrawAvailableCashTextEditingController,
                borderRadius: 8,
                labelText: '',
                onChanged: (String) {},
              ),
            ),
          ),
          SizedBox(
            height: 22,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.5,
                      // color: Color(0xfff0f0f0)
                      color: Color(0xff0090ff)),
                ),
              ),

              SizedBox(
                width: 22,
              ),
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

                  if (fundsProvider.withdrawAvailableCashTextEditingController
                              .text ==
                          "" &&
                      fundsProvider.withdrawAvailableCashTextEditingController
                          .text.isEmpty) {
                  } else {
                    fundsProvider
                        .withdrawAvailableCash(
                      tradeMainProvider.tradingOptions,
                    )
                        .then((onValue) {
                      print("before calling fundsProvider.callInitialApi");
                      fundsProvider.callInitialApi();
                      print("after calling fundsProvider.callInitialApi");

                      print("inside value of withdrawAvailableCash");
                      Navigator.pop(context);
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 8, bottom: 8.0),
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.5,
                        color: Color(0xfff0f0f0)
                        // color: (themeProvider.defaultTheme)
                        //     ?Color(0xfff0f0f0)
                        //     :Color(0xff1a1a25)
                        ),
                  ),
                ),
              ),

              SizedBox(
                width: 18,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
