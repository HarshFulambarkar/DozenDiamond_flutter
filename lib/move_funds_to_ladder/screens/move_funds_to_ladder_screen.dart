import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/move_funds_to_ladder/stateManagement/move_funds_to_ladder_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/services/num_formatting.dart';
import '../model/ladder_list_model.dart';

class MoveFundsToLadderScreen extends StatelessWidget {
  MoveFundsToLadderScreen({super.key});

  late NavigationProvider navigationProvider;
  late CurrencyConstants currencyConstantsProvider;
  late MoveFundsToLadderProvider moveFundsToLadderProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    moveFundsToLadderProvider =
        Provider.of<MoveFundsToLadderProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return WillPopScope(
      onWillPop: () async {
        navigationProvider.selectedIndex =
            navigationProvider.previousSelectedIndex;

        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    color: (themeProvider.defaultTheme)
                        ? Color(0XFFF5F5F5)
                        : Colors.transparent,
                    width: screenWidth == 0 ? null : screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 45,
                          ),
                          // SizedBox(
                          //   height: AppBar().preferredSize.height * 1.5,
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Move Assets to Ladder',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Selected Ladder',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Target : ${amountToInrFormat(context, double.parse(moveFundsToLadderProvider.selectedLadderL1.ladTargetPrice ?? "0.0"))}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Cash Already Allocated : ${amountToInrFormat(context, double.parse(moveFundsToLadderProvider.selectedLadderL1.ladCashAllocated))}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Step Size : ${amountToInrFormat(context, (double.parse(moveFundsToLadderProvider.selectedLadderL1.ladTargetPrice) - double.parse(moveFundsToLadderProvider.selectedLadderL1.ladInitialBuyPrice)) / moveFundsToLadderProvider.selectedLadderL1.ladNumOfStepsAbove)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Order Size : ${moveFundsToLadderProvider.selectedLadderL1.ladDefaultBuySellQuantity}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Current Price : ${amountToInrFormat(context, moveFundsToLadderProvider.currentPrice)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Current Stock Owned : ${moveFundsToLadderProvider.selectedLadderL1.ladCurrentQuantity}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Cash Needed : ${amountToInrFormat(context, double.parse(moveFundsToLadderProvider.selectedLadderL1.ladCashNeeded))}',
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          buildLadderTable(context),
                          // (moveFundsToLadderProvider.selectedLadderId != "")
                          (true)
                              ? SizedBox(
                                  height: 30,
                                )
                              : Container(),
                          // (moveFundsToLadderProvider.selectedLadderId.toString() != "")
                          (true)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildCancelAndGoBackButton(context),
                                    buildAcceptChangeButton(context),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          buildBottomLabelSection(context),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomHomeAppBarWithProviderNew(
                  backButton: true,
                  widthOfWidget: screenWidth,
                  backIndex:
                      1, //these leadingAction button is not working, I have tired making it work, but it isn't.
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCancelAndGoBackButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.red, //const Color(0xFF0099CC),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(
              color: Colors.red, //Color(0xFF0099CC),
            ),
          ),
          onPressed: () {
            navigationProvider.selectedIndex = 1;
          },
          child: const Text('Cancel & Go back',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildAcceptChangeButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFF0099CC),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(
              color: Color(0xFF0099CC),
            ),
          ),
          onPressed: () {
            if (moveFundsToLadderProvider.selectedLadderId.toString() != "" &&
                moveFundsToLadderProvider.cashNeededIsGreater == false) {
              double l1Cash = double.tryParse(moveFundsToLadderProvider
                      .selectedLadderL1.ladCashAllocated
                      .trim()) ??
                  0.0;
              double l2Cash = double.tryParse(moveFundsToLadderProvider
                      .selectedLadderL2.ladCashAllocated
                      .trim()) ??
                  0.0;

              moveFundsToLadderProvider.moveFundsToLadder().then((value) {
                if (value) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return showMoveFundsToLadderDialog(
                            "Moved Funds to Ladder successfully", context);
                      }).whenComplete(() {
                    final navigationProvider =
                        Provider.of<NavigationProvider>(context, listen: false);
                    navigationProvider.selectedIndex = 1;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Something went wrong ladder",
                      ),
                    ),
                  );
                }
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Select ladder",
                  ),
                ),
              );
            }

            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       "Ladder Merged Successfully",
            //     ),
            //   ),
            // );
          },
          // child: const Text('Move Funds to Ladders',
          child: const Text('Move assets to Ladders',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildLadderTable(BuildContext context) {
    return Column(
      children: [
        buildLadderTableHeading(context, "Target", "Initial Buy Price",
            "Number of Stocks", "Cash Needed", "Active or Inactive", "Select"),
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          child: ListView.builder(
              itemCount: moveFundsToLadderProvider.ladderList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildLadderTableBodyTitleElement(
                  moveFundsToLadderProvider.ladderList[index],
                  context,
                );
                // return Column(
                //   children: [
                //     for (var i = 0; i < moveFundsToLadderProvider.stockLadders[index].ladders.length; i++)
                //       buildLadderTableBodyTitleElement(
                //         moveFundsToLadderProvider.stockLadders[index].ladders[i],
                //           context,
                //       ),
                //   ],
                // );
              }),
        ),
      ],
    );
  }

  Widget buildLadderTableHeading(
      BuildContext context,
      String heading1,
      String heading2,
      String heading3,
      String heading4,
      String heading5,
      String heading6,
      {bool currentPriceCell = false,
      Key? key,
      bool formatToComma = false}) {
    return IntrinsicHeight(
      key: key,
      child: Row(children: [
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              heading1,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.greenAccent, fontSize: 15),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              heading2,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.greenAccent, fontSize: 15),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              heading3,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.greenAccent, fontSize: 15),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              heading4,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.greenAccent, fontSize: 15),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              heading5,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.greenAccent, fontSize: 15),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              heading6,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.greenAccent, fontSize: 15),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildLadderTableBodyTitleElement(
      Ladder ladderData, BuildContext context,
      {bool currentPriceCell = false, Key? key, bool formatToComma = false}) {
    return IntrinsicHeight(
      key: key,
      child: Row(children: [
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              ladderData.ladTargetPrice,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              amountToInrFormat(
                      context, double.parse(ladderData.ladInitialBuyPrice)) ??
                  "0.0",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              ladderData.ladCurrentQuantity.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              amountToInrFormat(
                      context, double.parse(ladderData.ladCashNeeded)) ??
                  "0.0",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: Text(
              ladderData.ladStatus.name,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, width: 0.5),
            ),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                tristate: true, // Example with tristate
                value: (moveFundsToLadderProvider.selectedLadderId ==
                        ladderData.ladId.toString() &&
                    moveFundsToLadderProvider.cashNeededIsGreater == false),
                activeColor: Colors.blue,
                onChanged: (bool? newValue) async {
                  if (moveFundsToLadderProvider.selectedLadderId !=
                      ladderData.ladId.toString()) {
                    moveFundsToLadderProvider.selectedLadderId =
                        ladderData.ladId.toString();
                    moveFundsToLadderProvider.selectedLadderL2 = ladderData;

                    final value = await moveFundsToLadderProvider
                        .assignValueAndCallMoveToLadder();

                    if (value == false) {
                      showDialog(
                          context: context,
                          builder: (ctx) => allocateCashDialogbox(context),
                          barrierDismissible: false);
                    } else {}
                  } else {
                    moveFundsToLadderProvider.selectedLadderId = "";
                    moveFundsToLadderProvider.cashNeededIsGreater = false;
                  }
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget showMoveFundsToLadderDialog(String message, BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF15181F),
      // title: Text("Info", style: TextStyle(color: Colors.white)),
      content: Text("$message", style: TextStyle(color: Colors.white)),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final navigationProvider =
                  Provider.of<NavigationProvider>(context, listen: false);
              navigationProvider.selectedIndex = 1;
            },
            child: Text("OK")),
      ],
    );
  }

  Widget buildBottomLabelSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "New Order Size",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("${moveFundsToLadderProvider.newOrderSize}"
                    // "0.0",

                    ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "New Number of Steps Above",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${moveFundsToLadderProvider.newNumberofStepsAbove.toStringAsFixed(2)}"
                    // "0.0",

                    ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                // "Total Cost Allocated",
                "New Step Size",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${moveFundsToLadderProvider.newStepSize.toStringAsFixed(2)}"
                    // "0.0",

                    ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "New Cash Needed",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${amountToInrFormat(context, moveFundsToLadderProvider.newCashNeeded)}"
                    // "-",

                    ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "New Number of Steps Below Size",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    moveFundsToLadderProvider.newNumberofStepsBelow.toString()
                    // "-",

                    ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  Widget allocateCashDialogbox(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  iconSize: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: const Text(
                    "Add cash or sell some stock",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
              ],
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: false // value.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text(
                    'Add Cash',
                    style: TextStyle(
                        color: false // value.defaultTheme
                            ? Colors.grey
                            : Colors.white,
                        fontSize: 16),
                  ),
                  onTap: () async {},
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: false // value.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text(
                    'Sell Stocks',
                    style: TextStyle(
                        color: false // value.defaultTheme
                            ? Colors.grey
                            : Colors.white,
                        fontSize: 16),
                  ),
                  onTap: () async {},
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
