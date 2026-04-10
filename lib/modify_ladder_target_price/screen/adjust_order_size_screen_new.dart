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

class AdjustOrderSizeScreenNew extends StatelessWidget {
  AdjustOrderSizeScreenNew({super.key});

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
        navigationProvider.selectedIndex =
            navigationProvider.previousSelectedIndex;
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

                          buildOrderSizeField(context, screenWidth),

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
              "Adjust Order Size",
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
                  "Cash Needed",
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

  Widget buildOrderSizeField(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Size",
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
              prefixText: "",
              controller:
              modifyLadderTargetPriceProvider.modifiedOrderSizeController,
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
                // FilteringTextInputFormatter.allow(
                //   RegExp(r'^[0-9,\.]+$'),
                // ),
                FilteringTextInputFormatter.digitsOnly,
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
                modifyLadderTargetPriceProvider.orderSizeCheckBox = false;
                if (modifyLadderTargetPriceProvider
                    .modifiedOrderSizeController.text !=
                    "") {
                  modifyLadderTargetPriceProvider.modifiedOrderSize =
                      int.tryParse(modifyLadderTargetPriceProvider
                          .modifiedOrderSizeController.text) ??
                          0;
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

          // (modifyLadderTargetPriceProvider.targetPriceError ==
          //     "")
          //     ? Container()
          //     : Text(
          //   modifyLadderTargetPriceProvider
          //       .targetPriceError,
          //   style: const TextStyle(color: Colors.red),
          // ),
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
                value: modifyLadderTargetPriceProvider
                    .orderSizeCheckBox, //ladderAddOrWithdrawCashProvider.updateCheckbox,
                activeColor: Colors.blue,
                side: BorderSide(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white),
                onChanged: (bool? newValue) {
                  modifyLadderTargetPriceProvider.modifyOrderSize();
                  // setState(() {
                  //   value = newValue;
                  // });
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
        (modifyLadderTargetPriceProvider.isModifyingOrderSize)
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
            // ladderAddOrWithdrawCashProvider
            //     .addOrWithdrawCashTextController.text = "";
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
            if (false) {
            } else {
              modifyLadderTargetPriceProvider
                  .modifyOrderSizeBusinessLogic(context);
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
                    modifyLadderTargetPriceProvider.newStepSize
                        .toStringAsFixed(2),
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

}
