import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../AB_Ladder/widgets/review_ladder_dialog_new.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_bottom_sheets.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../localization/translation_keys.dart';
import '../stateManagement/ladder_add_or_withdraw_cash_provider.dart';

class LadderAddOrWithdrawCashScreenNew extends StatelessWidget {
  LadderAddOrWithdrawCashScreenNew({super.key});

  late LadderAddOrWithdrawCashProvider ladderAddOrWithdrawCashProvider;
  late CurrencyConstants currencyConstantsProvider;
  late NavigationProvider navigationProvider;
  late ThemeProvider themeProvider;
  late TradeMainProvider tradeMainProvider;

  @override
  Widget build(BuildContext context) {
    ladderAddOrWithdrawCashProvider =
        Provider.of<LadderAddOrWithdrawCashProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);
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

                          buildAddCashSection(context, screenWidth),

                          SizedBox(
                            height: 20,
                          ),

                          if(tradeMainProvider.tradingOptions != TradingOptions.simulationTradingWithSimulatedPrices)
                            buildDurationDropDownSection(context, screenWidth),

                          if(tradeMainProvider.tradingOptions != TradingOptions.simulationTradingWithSimulatedPrices)
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
              (ladderAddOrWithdrawCashProvider.isWithdraw)
                  ? "Cash Withdraw"
                  : "Add Cash",
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
                  stockName: (ladderAddOrWithdrawCashProvider.selectedLadderData.ladTicker),
                  tickerId: ladderAddOrWithdrawCashProvider.selectedLadderData.ladTickerId ?? 0,
                  initialyProvidedTargetPrice: ladderAddOrWithdrawCashProvider.selectedLadderData.ladTargetPrice ?? 0.0,
                  initialPurchasePrice: ladderAddOrWithdrawCashProvider.selectedLadderData.ladInitialBuyPrice.toString(),
                  currentStockPrice: ladderAddOrWithdrawCashProvider.currentPrice.toString(),
                  allocatedCash: double.parse(ladderAddOrWithdrawCashProvider.selectedLadderData.ladCashAllocated.toString()),
                  cashNeeded: ladderAddOrWithdrawCashProvider.selectedLadderData.ladCashNeeded,
                  isMarketOrder: true,
                  minimumPriceForUpdateLadder: ladderAddOrWithdrawCashProvider.selectedLadderData.ladMinimumPrice,
                  setDefaultBuySellQty: ladderAddOrWithdrawCashProvider.selectedLadderData.ladDefaultBuySellQuantity,
                  newLadder: true,
                  symSecurityCode: ladderAddOrWithdrawCashProvider.selectedLadderData.ladTickerId,
                  stepSize: ladderAddOrWithdrawCashProvider.selectedLadderData.ladStepSize,
                  numberOfStepsAbove: ladderAddOrWithdrawCashProvider.selectedLadderData.ladNumOfStepsAbove,
                  numberOfStepsBelow: ladderAddOrWithdrawCashProvider.selectedLadderData.ladNumOfStepsBelow,
                  initialBuyQty: (ladderAddOrWithdrawCashProvider.selectedLadderData.ladInitialBuyQuantity) ?? 0,
                  actualCashAllocated: ladderAddOrWithdrawCashProvider.selectedLadderData.ladCashAllocated,
                  actualInitialBuyCash: ladderAddOrWithdrawCashProvider.selectedLadderData.ladInitialBuyPrice * ladderAddOrWithdrawCashProvider.selectedLadderData.ladInitialBuyQuantity,
                  ladTargetPriceMultiplier: ladderAddOrWithdrawCashProvider.selectedLadderData.ladTargetPrice,
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
                  "${currencyConstantsProvider.currency}${ladderAddOrWithdrawCashProvider.target}",
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
                  "${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.cashAlreadyAllocated)}",
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
                  "${currencyConstantsProvider.currency}${ladderAddOrWithdrawCashProvider.stepSize.toStringAsFixed(2)}",
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
                  "${ladderAddOrWithdrawCashProvider.orderSize}",
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
                  "${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.currentPrice)}",
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
                  "${ladderAddOrWithdrawCashProvider.currentStockOwn}",
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
                  "${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.cashNeeded)}",
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
                  "Extra Cash Generated",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xff0f0f0f)
                        :Color(0xfff0f0f0),
                  )
              ),

              Text(
                  "${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.extraCashGenerated)}",
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

  Widget buildAddCashSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter cash amount",
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
              controller: ladderAddOrWithdrawCashProvider
                  .addOrWithdrawCashTextController,
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
                ladderAddOrWithdrawCashProvider.updateCheckbox = false;

                if (ladderAddOrWithdrawCashProvider.isWithdraw) {
                  ladderAddOrWithdrawCashProvider
                      .validateWithdrawCashToLadderPrice(context);
                } else {
                  ladderAddOrWithdrawCashProvider
                      .validateAddCashToLadderPrice(context);
                }
              },
            ),
          ),

          SizedBox(
            height: 3,
          ),

          (ladderAddOrWithdrawCashProvider.adderAddOrWithdrawCashError ==
              "")
              ? Container()
              : Text(
            ladderAddOrWithdrawCashProvider
                .adderAddOrWithdrawCashError,
            style: const TextStyle(color: Colors.red),
          ),
          SizedBox(
            height: 5,
          ),

          (ladderAddOrWithdrawCashProvider.isWithdraw)
              ? Container()
              : Text(
            "Your account balance is ${currencyConstantsProvider.currency}${ladderAddOrWithdrawCashProvider.availableCashInAccount}. Minimum cash you can add is ${currencyConstantsProvider.currency}${ladderAddOrWithdrawCashProvider.minimumCashUserCanAdd(context).toStringAsFixed(2)}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: (themeProvider.defaultTheme)?Color(0XFFB0B0B0):Color(0XFFB0B0B0),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDurationDropDownSection(BuildContext context, double screenWidth) {
    String title = ladderAddOrWithdrawCashProvider.isWithdraw
        ? "Select duration for selling stocks"
        : "Select duration for buying stocks";

    final List<String> durations = [
      "5 mins",
      "10 mins",
      "20 mins",
      "30 mins",
      "40 mins",
      "50 mins",
      "60 mins"
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: (themeProvider.defaultTheme)?Color(0xff8f8f9f):Color(0xfff8f8f9)
            ),
          ),

          SizedBox(
            height: 3,
          ),

          CustomContainer(
            borderWidth: 1,
            backgroundColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            padding: 0,
            borderRadius: 10,
            margin: EdgeInsets.zero,
            height: 40,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  child: SizedBox(
                    width: screenWidth - 64,
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          onChanged: (String? newValue) {

                            ladderAddOrWithdrawCashProvider.selectedDuration =
                                newValue ?? "5 mins";
                          },
                          dropdownColor: Colors.black,
                          value: ladderAddOrWithdrawCashProvider.selectedDuration,
                          items: durations.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                    value,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: (themeProvider.defaultTheme)
                                        ?Color(0xff0f0f0f)
                                        :Color(0xfff0f0f0),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        )),
                  ),
                ),
              ],
            ),
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
                value: ladderAddOrWithdrawCashProvider.updateCheckbox,
                activeColor: Colors.blue,
                onChanged: (bool? newValue) {
                  ladderAddOrWithdrawCashProvider.updateCheckbox =
                      newValue ?? false;

                  if (ladderAddOrWithdrawCashProvider
                      .addOrWithdrawCashTextController.text ==
                      "") {
                    ladderAddOrWithdrawCashProvider
                        .adderAddOrWithdrawCashError = "Please enter price";
                  }

                  if (ladderAddOrWithdrawCashProvider.updateCheckbox) {
                    ladderAddOrWithdrawCashProvider
                        .addAndWithdrawLadderCash(context);
                  }
                  // setState(() {
                  //   value = newValue;
                  // });
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Note : Update value by clicking the checkbox!",
              style: GoogleFonts.poppins(

              ),
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
        (ladderAddOrWithdrawCashProvider.isAddWithdrawCash)
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
            ladderAddOrWithdrawCashProvider
                .addOrWithdrawCashTextController.text = "";
            navigationProvider.selectedIndex = 1;
          },
          child: Text('Cancel & Go back',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white)),
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
            if (ladderAddOrWithdrawCashProvider.updateCheckbox &&
                ladderAddOrWithdrawCashProvider.adderAddOrWithdrawCashError ==
                    "") {

              // minLimitPriceAndTimeInMinDialog(context);

              if (ladderAddOrWithdrawCashProvider.isWithdraw) {
                await ladderAddOrWithdrawCashProvider.withdrawCashToLadder();
              } else {
                await ladderAddOrWithdrawCashProvider.addCashToLadder();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Change Accepted Successfully",
                  ),
                ),
              );
              navigationProvider.selectedIndex = 1;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Select checkbox",
                  ),
                ),
              );
            }
          },
          child: Text('Accept Changes',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white)),
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
              child: Text((ladderAddOrWithdrawCashProvider.isWithdraw)
                  ? "New Stock to sell"
                  : (ladderAddOrWithdrawCashProvider.initialBuyExecuted)
                  ? "New Stock to Buy"
                  : "New Inital Buy Quantity",
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
                child: (ladderAddOrWithdrawCashProvider.initialBuyExecuted)
                    ? Text(ladderAddOrWithdrawCashProvider.newStockToBuy
                    .abs()
                    .toStringAsFixed(0),
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
                    (ladderAddOrWithdrawCashProvider.newInitialBuyQuantity)
                        .toString(),
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
                    "${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.newCashNeeded)}",
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
                  "New Extra Cash generated per trade",
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
                    "${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.newExtraCashGeneratedPerTrade)}",
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
                    ladderAddOrWithdrawCashProvider.newOrderSize.toString(),
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
                    ladderAddOrWithdrawCashProvider.newStepSize.toStringAsFixed(2),
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

  Future<void> minLimitPriceAndTimeInMinDialog(BuildContext contextt) {
    return showDialog(
        context: contextt,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateSB) {
            return AlertDialog(
              title: Text(
                // 'Delete Ladder',
                (ladderAddOrWithdrawCashProvider.isWithdraw)
                    ? "Cash Withdraw"
                    : "Add Cash",
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

                            if (ladderAddOrWithdrawCashProvider.limitPrice == 'null' || ladderAddOrWithdrawCashProvider.limitPriceTimeInMin == 'null') {

                              if(ladderAddOrWithdrawCashProvider.limitPrice == 'null') {
                                ladderAddOrWithdrawCashProvider.limitPriceErrorText = "Please enter min limit price";
                              }

                              if(ladderAddOrWithdrawCashProvider.limitPriceTimeInMin == 'null') {
                                ladderAddOrWithdrawCashProvider.limitPriceTimeInMinErrorText = "Please enter time in min";
                              }
                            } else {

                              Navigator.pop(context);
                              if (ladderAddOrWithdrawCashProvider.isWithdraw) {
                                await ladderAddOrWithdrawCashProvider.withdrawCashToLadder();
                              } else {
                                await ladderAddOrWithdrawCashProvider.addCashToLadder();
                              }
                              ScaffoldMessenger.of(contextt).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Change Accepted Successfully",
                                  ),
                                ),
                              );
                              navigationProvider.selectedIndex = 1;
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
            focusedBorderColor: ((ladderAddOrWithdrawCashProvider.limitPriceErrorText != ""))
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
                ladderAddOrWithdrawCashProvider.limitPrice = 'null';
              } else {
                ladderAddOrWithdrawCashProvider.limitPrice = value;
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
        (ladderAddOrWithdrawCashProvider.limitPriceErrorText == "")
            ? Container()
            : Text(ladderAddOrWithdrawCashProvider.limitPriceErrorText,
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
            focusedBorderColor: ((ladderAddOrWithdrawCashProvider.limitPriceTimeInMinErrorText != ""))
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
                ladderAddOrWithdrawCashProvider.limitPriceTimeInMin = 'null';
              } else {
                ladderAddOrWithdrawCashProvider.limitPriceTimeInMin = value;
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
        (ladderAddOrWithdrawCashProvider.limitPriceTimeInMinErrorText == "")
            ? Container()
            : Text(ladderAddOrWithdrawCashProvider.limitPriceTimeInMinErrorText,
            style: TextStyle(color: Colors.red))
      ],
    );
  }
}
