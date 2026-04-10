import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/merge_ladder/model/merge_ladder_request.dart';
import 'package:dozen_diamond/merge_ladder/services/mergeLadderService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../AB_Ladder/widgets/review_ladder_dialog_new.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_bottom_sheets.dart';
import '../model/ladder_list_model.dart';
import '../stateManagement/dart/merge_ladder_provider.dart';

class MergeLadderScreen extends StatelessWidget {
  MergeLadderScreen({super.key});

  late NavigationProvider navigationProvider;
  late CurrencyConstants currencyConstantsProvider;
  late MergeLadderProvider mergeLadderProvider;

  @override
  Widget build(BuildContext context) {
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    mergeLadderProvider =
        Provider.of<MergeLadderProvider>(context, listen: true);
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Merge Ladders',
                                style: TextStyle(fontSize: 20),
                              ),

                              // InkWell(
                              //   onTap: () {
                              //
                              //     CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                              //       ReviewLadderDialogNew(
                              //         inTradePage: true,
                              //         stockName: (mergeLadderProvider.selectedLadderL1.ladTicker),
                              //         tickerId: mergeLadderProvider.selectedLadderL1.ladTickerId ?? 0,
                              //         initialyProvidedTargetPrice: mergeLadderProvider.selectedLadderL1.ladTargetPrice ?? 0.0,
                              //         initialPurchasePrice: mergeLadderProvider.selectedLadderL1.ladInitialBuyPrice.toString(),
                              //         currentStockPrice: mergeLadderProvider.currentPrice.toString(),
                              //         allocatedCash: double.parse(mergeLadderProvider.selectedLadderL1.ladCashAllocated.toString()),
                              //         cashNeeded: mergeLadderProvider.selectedLadderL1.ladCashNeeded,
                              //         isMarketOrder: true,
                              //         minimumPriceForUpdateLadder: mergeLadderProvider.selectedLadderL1.ladMinimumPrice,
                              //         setDefaultBuySellQty: mergeLadderProvider.selectedLadderL1.ladDefaultBuySellQuantity,
                              //         newLadder: true,
                              //         symSecurityCode: mergeLadderProvider.selectedLadderL1.ladTickerId,
                              //         stepSize: mergeLadderProvider.selectedLadderL1.ladStepSize,
                              //         numberOfStepsAbove: mergeLadderProvider.selectedLadderL1.ladNumOfStepsAbove,
                              //         numberOfStepsBelow: mergeLadderProvider.selectedLadderL1.ladNumOfStepsBelow,
                              //         initialBuyQty: (mergeLadderProvider.selectedLadderL1.ladInitialBuyQuantity) ?? 0,
                              //         actualCashAllocated: mergeLadderProvider.selectedLadderL1.ladCashAllocated,
                              //         actualInitialBuyCash: mergeLadderProvider.selectedLadderL1.ladInitialBuyPrice * mergeLadderProvider.selectedLadderL1.ladInitialBuyQuantity,
                              //         ladTargetPriceMultiplier: mergeLadderProvider.selectedLadderL1.ladTargetPrice,
                              //       ), context,
                              //       height: 850,
                              //     );
                              //
                              //   },
                              //   child: Text(
                              //       "Show Ladder",
                              //       style: GoogleFonts.poppins(
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 18,
                              //         color: Color(0xff61baff),
                              //       )
                              //
                              //   ),
                              // )
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
                            'Target : ${amountToInrFormat(context, double.parse(mergeLadderProvider.selectedLadderL1.ladTargetPrice ?? "0.0"))}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Cash Already Allocated : ${amountToInrFormat(context, double.parse(mergeLadderProvider.selectedLadderL1.ladCashAllocated))}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Step Size : ${amountToInrFormat(context, (double.parse(mergeLadderProvider.selectedLadderL1.ladTargetPrice) - double.parse(mergeLadderProvider.selectedLadderL1.ladInitialBuyPrice)) / mergeLadderProvider.selectedLadderL1.ladNumOfStepsAbove)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Order Size : ${mergeLadderProvider.selectedLadderL1.ladDefaultBuySellQuantity}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Current Price : ${amountToInrFormat(context, mergeLadderProvider.currentPrice)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Current Stock Owned : ${mergeLadderProvider.selectedLadderL1.ladCurrentQuantity}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Cash Needed : ${amountToInrFormat(context, double.parse(mergeLadderProvider.selectedLadderL1.ladCashNeeded))}',
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          buildLadderTable(context),
                          // (mergeLadderProvider.selectedLadderId != "")
                          (true)
                              ? SizedBox(
                                  height: 30,
                                )
                              : Container(),
                          // (mergeLadderProvider.selectedLadderId.toString() != "")
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
            if (mergeLadderProvider.selectedLadderId.toString() != "") {
              double l1Cash = double.tryParse(mergeLadderProvider
                      .selectedLadderL1.ladCashAllocated
                      .trim()) ??
                  0.0;
              double l2Cash = double.tryParse(mergeLadderProvider
                      .selectedLadderL2.ladCashAllocated
                      .trim()) ??
                  0.0;

              MergeLadderService().saveMergedLadder(
                  MergeLadderRequest(
                      ladderIds: [
                        mergeLadderProvider.selectedLadderL1.ladId,
                        mergeLadderProvider.selectedLadderL2.ladId
                      ],
                      mergeLadderData: MergeLadderData(
                          continueTradingAfterHittingTargetPrice: 1,
                          ladStatus: mergeLadderProvider
                              .selectedLadderL1.ladStatus.name,
                          ladPositionId: mergeLadderProvider
                              .selectedLadderL1.ladPositionId,
                          ladTickerId:
                              mergeLadderProvider.selectedLadderL1.ladTickerId,
                          ladTradingMode: mergeLadderProvider
                              .selectedLadderL1.ladTradingMode,
                          ladUnsoldStockCashGain: 0,
                          ladReinvestExtraCash: 0,
                          ladLastTradeOrderPrice: 0,
                          ladLastTradePrice: 0,
                          ladMinimumPrice: 0.0,
                          ladNumOfStepsAbove: mergeLadderProvider.NaOptimalL3,
                          ladNumOfStepsBelow:
                              (mergeLadderProvider.currentPrice /
                                      mergeLadderProvider.stepSize3)
                                  .floor(),
                          ladRealizedProfit: 0,
                          ladStepSize: mergeLadderProvider.stepSize3,
                          ladTargetPrice: mergeLadderProvider.targetPrice3,
                          targetPriceMultiplier:
                              (mergeLadderProvider.targetPrice3 /
                                  mergeLadderProvider.initialBuyPrice3),
                          ladCashAllocated: l1Cash + l2Cash,
                          ladCashGain: 0.0,
                          ladCashLeft: 0.0,
                          ladCashNeeded: mergeLadderProvider.cashNeeded3,
                          ladCurrentQuantity: mergeLadderProvider
                                  .selectedLadderL1.ladCurrentQuantity +
                              mergeLadderProvider
                                  .selectedLadderL2.ladCurrentQuantity,
                          ladDefaultBuySellQuantity:
                              mergeLadderProvider.defaultQuantity3,
                          ladExchange: "BSE",
                          ladExtraCashGenerated: 0.0,
                          ladExtraCashLeft: 0.0,
                          ladInitialBuyPrice:
                              mergeLadderProvider.initialBuyPrice3,
                          ladInitialBuyQuantity:
                              mergeLadderProvider.initialQuantity3,
                          ladTicker:
                              mergeLadderProvider.selectedLadderL1.ladTicker,
                        ladCashAssigned: (double.parse(mergeLadderProvider.selectedLadderL1.ladCashAssigned ?? "0") + double.parse(mergeLadderProvider.selectedLadderL2.ladCashAssigned ?? "0")).toString()
                      )),
                  context);
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
          child: const Text('Merge Ladders',
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
              itemCount: mergeLadderProvider.ladderList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildLadderTableBodyTitleElement(
                  mergeLadderProvider.ladderList[index],
                  context,
                );
                // return Column(
                //   children: [
                //     for (var i = 0; i < mergeLadderProvider.stockLadders[index].ladders.length; i++)
                //       buildLadderTableBodyTitleElement(
                //         mergeLadderProvider.stockLadders[index].ladders[i],
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
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
              border: Border.all(color: Colors.white, width: 0.5),
            ),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                tristate: true, // Example with tristate
                value: mergeLadderProvider.selectedLadderId ==
                    ladderData.ladId.toString(),
                activeColor: Colors.blue,
                onChanged: (bool? newValue) {
                  if (mergeLadderProvider.selectedLadderId !=
                      ladderData.ladId.toString()) {
                    mergeLadderProvider.selectedLadderId =
                        ladderData.ladId.toString();
                    mergeLadderProvider.selectedLadderL2 = ladderData;
                    mergeLadderProvider.mergeLadders();
                  } else {
                    mergeLadderProvider.selectedLadderId = "";
                  }
                },
              ),
            ),
          ),
        ),
      ]),
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
                "Target",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${amountToInrFormat(context, mergeLadderProvider.targetPrice3)}"
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
                "New Initial Buy Price",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${amountToInrFormat(context, mergeLadderProvider.initialBuyPrice3)}"
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
                "New Initial Buy Quantity",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("${mergeLadderProvider.initialQuantity3}"
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
                    "${amountToInrFormat(context, mergeLadderProvider.cashNeeded3)}"
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
                "New Step Size",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(mergeLadderProvider.stepSize3.toString()
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
                "New Buy sell quantity",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(mergeLadderProvider.defaultQuantity3.toString()
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
}
