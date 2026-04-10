import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../F_funds/models/withdrawal_option_model.dart';

class WithdrawalOptionDialogBox extends StatefulWidget {
  final double widthOfWidget;
  const WithdrawalOptionDialogBox({Key? key, this.widthOfWidget = 0})
      : super(key: key);

  @override
  State<WithdrawalOptionDialogBox> createState() =>
      _WithdrawalOptionDialogBoxState();
}

class _WithdrawalOptionDialogBoxState extends State<WithdrawalOptionDialogBox> {
  final List<WithdrawalOptionModel> withDrawalOptionList = [
    WithdrawalOptionModel(
      optionDiscription: "Only the extra cash can be withdrawn", //"Only the profits earned can be withdrawn",
      optionName: "Without affecting the ladder ",
      optionIcon: Icons.wallet,
    ),
    WithdrawalOptionModel(
      optionDiscription:
          "Any amount entered less than the Total cash available amount can be withdrawn",
      optionName: "With affecting the ladder ",
      optionIcon: Icons.money_sharp,
    ),
    WithdrawalOptionModel(
      optionDiscription:
          "Selling all stocks purchased for the company and making another investment in a new company, so, whatever the remaining balance left, that can be withdrawn ",
      optionName: "Exit one stock",
      optionIcon: Icons.account_balance_wallet_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
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
                  Expanded(child: Container()),
                  Expanded(
                    flex: 3,
                    child: Container(
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
                  ),
                  Expanded(child: Container()),
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.yellow,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          child: Text(
                                            "This service is unavailable",
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                Fluttertoast.showToast(
                                    msg: "This feature will unlock soon");
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
}
