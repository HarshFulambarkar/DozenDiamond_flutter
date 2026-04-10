import 'package:dozen_diamond/global/functions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../AB_Ladder/widgets/review_ladder_dialog_new.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_bottom_sheets.dart';
import '../../global/widgets/my_text_field.dart';
import '../stateManagment/modifyLadderTargetPriceProvider.dart';

class AdjustTargetPriceScreenNew extends StatelessWidget {
  AdjustTargetPriceScreenNew({super.key});

  late ModifyLadderTargetPriceProvider modifyLadderTargetPriceProvider;
  late CurrencyConstants currencyConstantsProvider;
  late NavigationProvider navigationProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {

    modifyLadderTargetPriceProvider =
        Provider.of<ModifyLadderTargetPriceProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return PopScope(
      onPopInvokedWithResult: (value, result) {
        navigationProvider.selectedIndex = navigationProvider.previousSelectedIndex;
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
                    height: MediaQuery.of(context).size.height +
                        AppBar().preferredSize.height * 1.5,
                    width: screenWidth,
                  ),
                ),

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

                          SizedBox(
                            height: 10,
                          ),

                          buildTopSection(context, screenWidth),

                          SizedBox(
                            height: 20,
                          ),

                          buildLadderDetailSection(context, screenWidth),

                          SizedBox(
                            height: 25,
                          ),

                          buildLadderTargetPriceField(context, screenWidth),

                          SizedBox(
                            height: 20,
                          ),

                          buildCheckBoxAndSaveLadderButton(context),

                          SizedBox(
                            height: 20,
                          ),

                          buildBottomLabelSection(context, screenWidth),

                          SizedBox(
                            height: 20,
                          ),

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

  Widget buildTopSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              "Modify Ladder Target Price",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: (themeProvider.defaultTheme)
                    ?Color(0xff0f0f0f)
                    :Color(0xfff0f0f0),
              )
          ),

          InkWell(
            onTap: () {

              CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                ReviewLadderDialogNew(
                  inTradePage: true,
                  stockName: (modifyLadderTargetPriceProvider.selectedLadder.ladTicker),
                  tickerId: modifyLadderTargetPriceProvider.selectedLadder.ladTickerId ?? 0,
                  initialyProvidedTargetPrice: modifyLadderTargetPriceProvider.selectedLadder.ladTargetPrice ?? 0.0,
                  initialPurchasePrice: modifyLadderTargetPriceProvider.selectedLadder.ladInitialBuyPrice.toString(),
                  currentStockPrice: modifyLadderTargetPriceProvider.currentPrice.toString(),
                  allocatedCash: double.parse(modifyLadderTargetPriceProvider.selectedLadder.ladCashAllocated.toString()),
                  cashNeeded: modifyLadderTargetPriceProvider.selectedLadder.ladCashNeeded,
                  isMarketOrder: true,
                  minimumPriceForUpdateLadder: modifyLadderTargetPriceProvider.selectedLadder.ladMinimumPrice,
                  setDefaultBuySellQty: modifyLadderTargetPriceProvider.selectedLadder.ladDefaultBuySellQuantity,
                  newLadder: true,
                  symSecurityCode: modifyLadderTargetPriceProvider.selectedLadder.ladTickerId,
                  stepSize: modifyLadderTargetPriceProvider.selectedLadder.ladStepSize,
                  numberOfStepsAbove: modifyLadderTargetPriceProvider.selectedLadder.ladNumOfStepsAbove,
                  numberOfStepsBelow: modifyLadderTargetPriceProvider.selectedLadder.ladNumOfStepsBelow,
                  initialBuyQty: (modifyLadderTargetPriceProvider.selectedLadder.ladInitialBuyQuantity) ?? 0,
                  actualCashAllocated: modifyLadderTargetPriceProvider.selectedLadder.ladCashAllocated,
                  actualInitialBuyCash: modifyLadderTargetPriceProvider.selectedLadder.ladInitialBuyPrice * modifyLadderTargetPriceProvider.selectedLadder.ladInitialBuyQuantity,
                  ladTargetPriceMultiplier: modifyLadderTargetPriceProvider.selectedLadder.ladTargetPrice,
                ), context,
                height: 850,
              );

            },
            child: Text(
                "Show Ladder",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xff61baff),
                )

            ),
          )
        ],
      ),
    );
  }

  Widget buildLadderDetailSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Target price",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),

              Text(
                  "${currencyConstantsProvider.currency}${modifyLadderTargetPriceProvider.targetPrice}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )

              )
            ],
          ),

          SizedBox(
              height: 5
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Cash already allocated",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),

              Text(
                  "${amountToInrFormat(context, modifyLadderTargetPriceProvider.cashAllocated)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )

              )
            ],
          ),

          SizedBox(
              height: 5
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Step size",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),

              Text(
                  "${currencyConstantsProvider.currency}${modifyLadderTargetPriceProvider.stepSize.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )

              )
            ],
          ),

          SizedBox(
              height: 5
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Order size",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),

              Text(
                  "${modifyLadderTargetPriceProvider.orderSize}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )

              )
            ],
          ),

          SizedBox(
              height: 5
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Current Price",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),

              Text(
                  "${amountToInrFormat(context, modifyLadderTargetPriceProvider.currentPrice)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )

              )
            ],
          ),

          SizedBox(
              height: 5
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Current Stock Owned",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),

              Text(
                  "${modifyLadderTargetPriceProvider.quantitiesOwned}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )

              )
            ],
          ),

          SizedBox(
              height: 5
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Cash needed",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),

              Text(
                  "${amountToInrFormat(context, modifyLadderTargetPriceProvider.cashNeeded)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )

              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLadderTargetPriceField(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Target Price",
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: (themeProvider.defaultTheme)?Color(0xff8f8f9f):Color(0xfff8f8f9)
            ),
          ),

          SizedBox(
            height: 3,
          ),

          SizedBox(
            height: 40,
            child: MyTextField(
              prefixText: "${currencyConstantsProvider.currency} ",
              controller: modifyLadderTargetPriceProvider
                  .modifiedTargetPriceController,
              isFilled: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
              fillColor: (themeProvider.defaultTheme)
                  ?Color(0xffCACAD3):Color(0xff2c2c31),
              borderColor: (themeProvider.defaultTheme)
                  ?Color(0xffCACAD3):Color(0xff2c2c31),
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
              ),
              textInputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(r'^[0-9,\.]+$'),
                ),
              ],
              maxLength: 9,
              elevation: 0,
              keyboardType: TextInputType.number,
              margin: EdgeInsets.zero,
              focusedBorderColor:
              (themeProvider.defaultTheme) ? Colors.black : Colors.white,

              counterText: "",
              borderRadius: 8,
              labelText: '',
              onChanged: (value) {
                modifyLadderTargetPriceProvider.targetPriceCheckBox = false;
                if (modifyLadderTargetPriceProvider
                    .modifiedTargetPriceController.text !=
                    "") {
                  modifyLadderTargetPriceProvider.modifiedTargetPrice =
                      double.tryParse(modifyLadderTargetPriceProvider
                          .modifiedTargetPriceController.text) ??
                          0.0;
                }
              },
              validator: (value) {
                print("inside of validator");
                if (value!.isNotEmpty && value != "") {}
                return null;
              },
            ),
          ),

          SizedBox(
            height: 3,
          ),

          (modifyLadderTargetPriceProvider.targetPriceError ==
              "")
              ? Container()
              : Text(
            modifyLadderTargetPriceProvider
                .targetPriceError,
            style: const TextStyle(color: Colors.red),
          ),
          SizedBox(
            height: 5,
          ),


        ],
      ),
    );
  }

  Widget buildCheckBoxAndSaveLadderButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                tristate: true, // Example with tristate
                value: modifyLadderTargetPriceProvider.targetPriceCheckBox,
                activeColor: Colors.blue,
                side: BorderSide(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white),
                onChanged: (bool? newValue) {
                  // if(modifyLadderTargetPriceProvider.modifiedTargetPrice < modifyLadderTargetPriceProvider.currentPrice * 1.2) {
                  if(modifyLadderTargetPriceProvider.modifiedTargetPrice < modifyLadderTargetPriceProvider.currentPrice * modifyLadderTargetPriceProvider.minK) {
                    // modifyLadderTargetPriceProvider.targetPriceError = "Target price should be greater then ${modifyLadderTargetPriceProvider.currentPrice * 1.2}";
                    modifyLadderTargetPriceProvider.targetPriceError = "Target price should be greater then ${modifyLadderTargetPriceProvider.currentPrice * modifyLadderTargetPriceProvider.minK.roundTo2()}";
                  } else {
                    modifyLadderTargetPriceProvider.targetPriceError = "";
                    modifyLadderTargetPriceProvider.modifyTargetPrice();
                  }
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Note : Update value by clicking the checkbox!",
            )
          ],
        ),
        SizedBox(
          height: // (ladderAddOrWithdrawCashProvider.updateCheckbox)
          (true) ? 10 : 0,
        ),
        // (ladderAddOrWithdrawCashProvider.updateCheckbox &&
        //         ladderAddOrWithdrawCashProvider.adderAddOrWithdrawCashError ==
        //             "")
        (modifyLadderTargetPriceProvider.isModifyingTargetPrice)
            ? CircularProgressIndicator()
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildCancelAndGoBackButton(context),
            buildAcceptChangeButton(context),
          ],
        ),
      ],
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
            modifyLadderTargetPriceProvider.modifiedTargetPriceController.text =
            "";
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
          onPressed: () async {
            if (modifyLadderTargetPriceProvider.targetPriceError == "") {

              // minLimitPriceAndTimeInMinDialog(context);

              modifyLadderTargetPriceProvider
                  .modifyTargetPriceBusinessLogic(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${modifyLadderTargetPriceProvider.targetPriceError}",
                  ),
                ),
              );
            }
          },
          child: const Text('Accept Changes',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildBottomLabelSection(BuildContext context, double screenWidth) {
    return Column(
      children: [

        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                  (modifyLadderTargetPriceProvider.initialBuyExecuted == 1)
                  ? (modifyLadderTargetPriceProvider.modifiedTargetPrice >
                      modifyLadderTargetPriceProvider.targetPrice)
                      ? "Stocks to buy" : "Stocks to sell"
                  : "New Initial Buy Quantity",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: (modifyLadderTargetPriceProvider.modifiedTargetPrice >
                    modifyLadderTargetPriceProvider.targetPrice)
                    ? Text("${modifyLadderTargetPriceProvider.stocksToBuy}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: (themeProvider.defaultTheme)
                          ?Color(0xff0f0f0f)
                          :Color(0xfff0f0f0),
                    )
                  //  "0.0",

                )
                    : Text(
                    "${modifyLadderTargetPriceProvider.stocksToSell}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: (themeProvider.defaultTheme)
                          ?Color(0xff0f0f0f)
                          :Color(0xfff0f0f0),
                    )
                ),
              ),
            ),
          ],
        ),

        SizedBox(
            height: 5
        ),

        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                  "New Cash Needed",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${amountToInrFormat(context, modifyLadderTargetPriceProvider.newCashNeeded)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: (themeProvider.defaultTheme)
                          ?Color(0xff0f0f0f)
                          :Color(0xfff0f0f0),
                    )
                ),
              ),
            ),
          ],
        ),

        SizedBox(
            height: 5
        ),

        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                  "New Number of Steps Above",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${(modifyLadderTargetPriceProvider.newNumberOfStepsAbove).toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: (themeProvider.defaultTheme)
                          ?Color(0xff0f0f0f)
                          :Color(0xfff0f0f0),
                    )
                ),
              ),
            ),
          ],
        ),

        SizedBox(
            height: 5
        ),

        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                  "New Number of Steps Below",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${(modifyLadderTargetPriceProvider.newNumberOfStepsBelow)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: (themeProvider.defaultTheme)
                          ?Color(0xff0f0f0f)
                          :Color(0xfff0f0f0),
                    )
                ),
              ),
            ),
          ],
        ),

        SizedBox(
            height: 5
        ),

        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                  "New Order Size",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    modifyLadderTargetPriceProvider.newOrderSize.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: (themeProvider.defaultTheme)
                          ?Color(0xff0f0f0f)
                          :Color(0xfff0f0f0),
                    )
                ),
              ),
            ),
          ],
        ),

        SizedBox(
            height: 5
        ),

        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                  "New Step Size",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    modifyLadderTargetPriceProvider.newStepSize.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: (themeProvider.defaultTheme)
                          ?Color(0xff0f0f0f)
                          :Color(0xfff0f0f0),
                    )
                ),
              ),
            ),
          ],
        ),

        SizedBox(
            height: 5
        ),

      ],
    );
  }

  Future<void> minLimitPriceAndTimeInMinDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateSB) {
            return AlertDialog(
              title: Text(
                // 'Delete Ladder',
                "Adjust Target Price",
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

                            if (modifyLadderTargetPriceProvider.limitPrice == 'null' || modifyLadderTargetPriceProvider.limitPriceTimeInMin == 'null') {

                              if(modifyLadderTargetPriceProvider.limitPrice == 'null') {
                                modifyLadderTargetPriceProvider.limitPriceErrorText = "Please enter min limit price";
                              }

                              if(modifyLadderTargetPriceProvider.limitPriceTimeInMin == 'null') {
                                modifyLadderTargetPriceProvider.limitPriceTimeInMinErrorText = "Please enter time in min";
                              }
                            } else {

                              Navigator.pop(context);
                              modifyLadderTargetPriceProvider.modifyTargetPriceBusinessLogic(context);
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
            focusedBorderColor: ((modifyLadderTargetPriceProvider.limitPriceErrorText != ""))
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
                modifyLadderTargetPriceProvider.limitPrice = 'null';
              } else {
                modifyLadderTargetPriceProvider.limitPrice = value;
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
        (modifyLadderTargetPriceProvider.limitPriceErrorText == "")
            ? Container()
            : Text(modifyLadderTargetPriceProvider.limitPriceErrorText,
            style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildLimitPriceTimeInMinTextField(BuildContext context) {
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
            focusedBorderColor: ((modifyLadderTargetPriceProvider.limitPriceTimeInMinErrorText != ""))
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
                modifyLadderTargetPriceProvider.limitPriceTimeInMin = 'null';
              } else {
                modifyLadderTargetPriceProvider.limitPriceTimeInMin = value;
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
        (modifyLadderTargetPriceProvider.limitPriceTimeInMinErrorText == "")
            ? Container()
            : Text(modifyLadderTargetPriceProvider.limitPriceTimeInMinErrorText,
            style: TextStyle(color: Colors.red))
      ],
    );
  }

}
