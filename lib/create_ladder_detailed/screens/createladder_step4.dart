import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/AB_Ladder/widgets/review_ladder_dialog.dart';
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/terms_info_contant.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/widgets/info_icon_display.dart';
import 'package:dozen_diamond/create_ladder_easy/services/rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_easy/stateManagement/create_ladder_easy_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/global/services/num_formatting.dart';
import 'package:dozen_diamond/global/widgets/text_form_field_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../create_ladder/screens/show_ladder_creation_option_dialog_new.dart';
import '../../global/widgets/custom_container.dart';
import '../../kyc/widgets/custom_bottom_sheets.dart';

class CreateLadder4 extends StatefulWidget {
  const CreateLadder4({super.key});

  @override
  State<CreateLadder4> createState() => _CreateLadder4State();
}

class _CreateLadder4State extends State<CreateLadder4> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  RestApiService restApiService = RestApiService();
  CreateLadderProvider? _stateProvider;
  ThemeProvider? _themeProvider;
  late ThemeProvider themeProvider;
  TradeMainProvider? _tradeMainProvider;
  LadderProvider? _ladderProvider;
  // ActivityProvider? _activityProvider;
  late NavigationProvider _navigationProvider;
  bool _isBtnClicked = false;

  late CurrencyConstants currencyConstantsProvider;

  late CreateLadderEasyProvider createLadderEasyProvider;

  TermsInfoConstant termsInfoConstant = TermsInfoConstant();

  void initState() {
    super.initState();
    _stateProvider = Provider.of(context, listen: false);
    _themeProvider = Provider.of(context, listen: false);
    _tradeMainProvider = Provider.of(context, listen: false);
    _ladderProvider = Provider.of(context, listen: false);
    // _activityProvider = Provider.of(context, listen: false);
    currencyConstantsProvider = Provider.of(context, listen: false);
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  Widget stepsizeUi() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text("Step Size", style: TextStyle(fontSize: 16)),
                  SizedBox(
                    width: 27,
                    height: 27,
                    child: InfoIconDisplay().infoIconDisplay(
                        context,
                        termsInfoConstant.titleStepSize,
                        termsInfoConstant.messageStepSize),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 30,
            ),
            SizedBox(
              width: 100,
              height: 30,
              child: TextFormField(
                controller: _stateProvider!.stepSizeController,
                onTap: () {
                  List<String> splittedValues = doublValueSplitterBydot(
                      _stateProvider!
                          .ladderCreationParametersScreen3.clpStepSize!.text);
                  _stateProvider!.updateStepSize(
                    splittedValues[0],
                    splittedValues[1],
                    _stateProvider!.ladderCreationParametersScreen3.clpStepSize!
                        .text.length,
                  );
                },
                onChanged: (inputStepSize) {
                  List<String> splittedValues =
                      doublValueSplitterBydot(inputStepSize);
                  _stateProvider!.updateStepSize(
                    splittedValues[0],
                    splittedValues[1],
                    _stateProvider!.stepSizeController.selection.baseOffset,
                  );
                },
                decoration: allocatedAmountFieldDecoration(
                    CurrencyIcon(
                      color: _themeProvider!.defaultTheme
                          ? Colors.black
                          : Colors.white,
                      size: 18,
                    ),
                    _themeProvider!.defaultTheme),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget stepsizeWarningUi() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        _stateProvider!.stepSizeWarning,
        style: TextStyle(
            color:
                (themeProvider.defaultTheme) ? Colors.orange : Colors.yellow),
      ),
    );
  }

  Widget numberOfStepsBelowUi() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Steps Below (SB)",
                    style: TextStyle(
                        fontSize: 16,
                        color: (themeProvider.defaultTheme)
                            ? Colors.white
                            : Colors.black)),
                SizedBox(
                  width: 27,
                  height: 27,
                  child: InfoIconDisplay().infoIconDisplay(
                      context,
                      termsInfoConstant.titleNumberOfStepsBelow,
                      termsInfoConstant.messageNumberOfStepsBelow,
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.black),
                )
              ],
            ),
            SizedBox(
              width: 30,
            ),
            Container(
              height: 30,
              width: 50,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Color.fromARGB(255, 21, 24, 31),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                " ${_stateProvider!.numberOfStepsBelow}",
                style: TextStyle(
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buySellQtyUi(CreateLadderProvider value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Order Size",
                        style: TextStyle(
                            fontSize: 16,
                            color: (themeProvider.defaultTheme)
                                ? Colors.white
                                : Colors.black)),
                    SizedBox(
                      height: 27,
                      width: 27,
                      child: InfoIconDisplay().infoIconDisplay(
                          context,
                          termsInfoConstant.titleDefaultBuySellQty,
                          termsInfoConstant.messageDefaultBuySellQty,
                          color: (themeProvider.defaultTheme)
                              ? Colors.white
                              : Colors.black),
                    ),
                  ],
                ),
                // ceilOrFloorBuySellQtyUi(value)
              ],
            ),
            Container(
              height: 30,
              width: 50,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Color.fromARGB(255, 21, 24, 31),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                " ${_stateProvider!.buySellQtyController.text}",
                style: TextStyle(
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            // Container(
            //   height: 30,
            //   width: 70,
            //   child: TextFormField(
            //     controller: _stateProvider!.buySellQtyController,
            //     onChanged: (inputBuySellQty) {
            //       _stateProvider!.updateBuySellQty(
            //         inputBuySellQty.replaceAll(',', ''),
            //         _stateProvider!.buySellQtyController.selection.baseOffset,
            //       );
            //     },
            //     decoration: allocatedAmountFieldDecoration(
            //         null, _themeProvider!.defaultTheme),
            //     keyboardType: TextInputType.number,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget numberOfPriceStepBetweenInitialBuyAndTarget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Calculated Steps above",
                style: TextStyle(
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ? Colors.white
                        : Colors.black)),
            SizedBox(
              width: 27,
              height: 27,
              child: InfoIconDisplay().infoIconDisplay(
                  context,
                  termsInfoConstant.titleDefaultBuySellQty,
                  termsInfoConstant.messageDefaultBuySellQty,
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Colors.black),
            )
          ],
        ),
        Container(
          height: 30,
          width: 70,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: (themeProvider.defaultTheme)
                  ? Colors.white
                  : Color.fromARGB(255, 21, 24, 31),
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "${_stateProvider!.calculatedNumberOfStepsAbove}",
            // "${numToComma(_stateProvider!.calculatedNumberOfStepsAbove)}",
            style: TextStyle(
                fontSize: 16,
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget buySellQtyFormulaUi(bool ceilValue) {
    return Container(
      width: 500,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Order Size",
              style: TextStyle(
                fontSize: 16,
                color:
                    (themeProvider.defaultTheme) ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "=  ",
              style: TextStyle(
                fontSize: 16,
                color:
                    (themeProvider.defaultTheme) ? Colors.white : Colors.black,
              ),
            ),
            Text(
              ceilValue ? "Ceil" : "FLOOR ",
              style: TextStyle(
                fontSize: 16,
                color:
                    (themeProvider.defaultTheme) ? Colors.white : Colors.black,
              ),
            ),
            Text(
              '(',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w100,
                color:
                    (themeProvider.defaultTheme) ? Colors.white : Colors.black,
              ),
            ),
            Column(
              children: [
                Text('Initial buy qty',
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.black,
                    )),
                SizedBox(
                  height: 2,
                ),
                Container(
                  width: 201,
                  child: Divider(
                    color: (themeProvider.defaultTheme)
                        ? Colors.white
                        : Colors.black,
                    indent: 10,
                    thickness: 1,
                    endIndent: 10,
                    height: 1,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text('Na',
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.black,
                    ))
              ],
            ),
            Text(
              ')',
              style: TextStyle(
                  fontSize: 28,
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w100),
            ),
          ],
        ),
      ),
    );
  }

  Widget cashNeeded(CurrencyConstants currencyConstantsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Cash Needed:", style: TextStyle(fontSize: 16)),
            SizedBox(
              width: 27,
              height: 27,
              child: InfoIconDisplay().infoIconDisplay(
                context,
                termsInfoConstant.titleInitial,
                termsInfoConstant.messageInitial,
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
              ),
            )
          ],
        ),
        Text(
          "${currencyConstantsProvider.currency} ${numToComma(_stateProvider!.cashNeeded)}",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget cashNeededFormulaUi() {
    return Container(
      width: 500,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Cash Needed ",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "=  ",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Order Size * Nb ",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '(',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w100),
            ),
            Column(
              children: [
                Text('Recent buy price', style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 2,
                ),
                Container(
                  width: 201,
                  child: Divider(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    indent: 10,
                    thickness: 1,
                    endIndent: 10,
                    height: 1,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text('2', style: TextStyle(fontSize: 16))
              ],
            ),
            Text(
              ')',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w100),
            ),
          ],
        ),
      ),
    );
  }

  Widget cashLeft(CurrencyConstants currencyConstantsProvider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Cash Left", style: TextStyle(fontSize: 16)),
                InfoIconDisplay().infoIconDisplay(
                    context,
                    termsInfoConstant.titleInitial,
                    termsInfoConstant.messageInitial)
              ],
            ),
            SizedBox(
              width: 30,
            ),
            Container(
              height: 30,
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(5)),
              child: Text(
                "${currencyConstantsProvider.currency} ${numToComma(_stateProvider!.cashLeft)}",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        Container(
          width: 500,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Cash Left ",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "=  ",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Cash Allocated - Actual initial buy cash",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buySellQtyWarningUi() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        _stateProvider!.buySellQtyWarning,
        style: TextStyle(color: Colors.yellow),
      ),
    );
  }

  Widget numberOfStepsAboveWarningUi() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        _stateProvider!.numberOfStepsAboveWarning,
        style: TextStyle(color: Colors.yellow),
      ),
    );
  }

  Widget heading(CurrencyConstants currencyConstantsProvide) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Select steps for ${_stateProvider!.ladderCreationParametersScreen1.clpTicker} ladder",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget limitCashNeededCheckBox(CreateLadderProvider createLadderProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: createLadderProvider.limitCashNeeded,
          onChanged: (bool? limitCashNeeded) {
            createLadderProvider
                .updateLimitCashNeeded(limitCashNeeded ?? false);
          },
          fillColor: MaterialStateColor.resolveWith((states) => Colors.blue),
        ),
        SizedBox(
          width: 10,
        ),
        Text("Limit Cash needed to a less than cash left")
      ],
    );
  }

  Widget actualCashAllocatedUi(CurrencyConstants currencyConstantsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Actual Cash Allocated:", style: TextStyle(fontSize: 16)),
            SizedBox(
              width: 27,
              height: 27,
              child: InfoIconDisplay().infoIconDisplay(
                  context,
                  termsInfoConstant.titleInitial,
                  termsInfoConstant.messageInitial,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white),
            )
          ],
        ),
        SizedBox(
          width: 30,
        ),
        Text(
          "${currencyConstantsProvider.currency} ${numToComma(_stateProvider!.actualCashAllocated)}",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget backBtn() {
    return ElevatedButton(
      onPressed: () {
        _navigationProvider.selectedIndex = 6;
      },
      style: ElevatedButton.styleFrom(
          backgroundColor:
              (themeProvider.defaultTheme) ? Colors.red : Colors.orange),
      child: Text(
        "Back",
        style: TextStyle(
            color: (themeProvider.defaultTheme) ? Colors.white : Colors.white),
      ),
    );
  }

  Widget recommendedParameters() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Recommended Parameters",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] ?? false,
            onChanged: (bool value) {
              Fluttertoast.showToast(msg: "These feature is currently locked");
              // _stateProvider!.isRecommendedParametersEnabledScreen3 = value;
            },
          ),
        ],
      ),
    );
  }

  Future<void> refreshLadderActivities(
      CurrencyConstants currencyConstantsProvider) async {
    try {
      await _ladderProvider!.fetchAllLadder(currencyConstantsProvider);
      // await _activityProvider!.fetchActivities();
      // await _tradeMainProvider!.initialGetLadderData();
      // await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
    } on HttpApiException catch (err) {
      throw err;
    }
  }

  Widget suggestedNumberOfStepsAbove() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Steps above (Suggested by user)",
                        style: TextStyle(fontSize: 16)),
                    Text(
                        "Range: 1 to ${_stateProvider!.ladderCreationParametersScreen3.clpInitialBuyQuantity.text}",
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(
                  width: 27,
                  height: 27,
                  child: InfoIconDisplay().infoIconDisplay(
                      context,
                      termsInfoConstant.titleDefaultBuySellQty,
                      termsInfoConstant.messageDefaultBuySellQty,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white),
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 30,
              width: 80,
              child: TextFormField(
                controller: _stateProvider!.numberOfStepsAboveController,
                onChanged: (inputNumberOfStepsAbove) {
                  _stateProvider!.updateNumberOfStepsAbove(
                    inputNumberOfStepsAbove,
                    _stateProvider!
                        .numberOfStepsAboveController.selection.baseOffset,
                  );

                  if (_stateProvider!.numberOfStepsAboveController.text != "" &&
                      _stateProvider!.numberOfStepsAboveController.text !=
                          "0") {
                    _stateProvider!.stepSizeController.text = (_stateProvider!
                            .calculateFieldStepSize(double.parse(_stateProvider!
                                .numberOfStepsAboveController.text)))
                        .toStringAsFixed(2);
                  }
                },
                decoration: allocatedAmountFieldDecoration(
                    null, _themeProvider!.defaultTheme),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        buildStepAboveSuggestedSlider(context),
      ],
    );
  }

  Widget suggestedStepSize() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Step Size (Suggested by user)",
                        style: TextStyle(fontSize: 16)),
                    Text(
                        "Range: ${(((double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpTargetPrice!.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0)) / (double.tryParse(_stateProvider!.ladderCreationParametersScreen3.clpInitialBuyQuantity.text.replaceAll(",", "")) ?? 0.0)).toStringAsFixed(2)} to ${((double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpTargetPrice!.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0)).toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(
                  width: 27,
                  height: 27,
                  child: InfoIconDisplay().infoIconDisplay(
                      context,
                      termsInfoConstant.titleStepSize,
                      termsInfoConstant.messageStepSize,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white),
                )
              ],
            ),
            SizedBox(
              width: 30,
            ),
            SizedBox(
              width: 100,
              height: 30,
              child: TextFormField(
                controller: _stateProvider!.stepSizeController,
                onTap: () {
                  List<String> splittedValues = doublValueSplitterBydot(
                      _stateProvider!
                          .ladderCreationParametersScreen3.clpStepSize!.text);
                  _stateProvider!.updateStepSize(
                    splittedValues[0],
                    splittedValues[1],
                    _stateProvider!.ladderCreationParametersScreen3.clpStepSize!
                        .text.length,
                  );
                },
                onChanged: (inputStepSize) {
                  List<String> splittedValues =
                      doublValueSplitterBydot(inputStepSize);
                  _stateProvider!.updateStepSize(
                    splittedValues[0],
                    splittedValues[1],
                    _stateProvider!.stepSizeController.selection.baseOffset,
                  );

                  if (_stateProvider!.stepSizeController.text != "" &&
                      _stateProvider!.stepSizeController.text != "0") {
                    _stateProvider!.numberOfStepsAboveController.text =
                        (_stateProvider!.calculateFieldNumberOfStepAbove(
                                double.parse(
                                    _stateProvider!.stepSizeController.text)))
                            .toString();
                  }
                },
                decoration: allocatedAmountFieldDecoration(
                    CurrencyIcon(
                      color: _themeProvider!.defaultTheme
                          ? Colors.black
                          : Colors.white,
                      size: 18,
                    ),
                    _themeProvider!.defaultTheme),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        buildStepSizeSuggestedSlider(context),
      ],
    );
  }

  Widget calculatedStepSize() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Calculated Step Size",
                style: TextStyle(
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ? Colors.white
                        : Colors.black)),
            SizedBox(
              width: 27,
              height: 27,
              child: InfoIconDisplay().infoIconDisplay(
                  context,
                  termsInfoConstant.titleDefaultBuySellQty,
                  termsInfoConstant.messageDefaultBuySellQty,
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Colors.black),
            )
          ],
        ),
        Container(
          height: 30,
          width: 100,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: (themeProvider.defaultTheme)
                  ? Colors.white
                  : Color.fromARGB(255, 21, 24, 31),
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "${currencyConstantsProvider.currency} ${numToComma(_stateProvider!.calculatedStepSize)}",
            style: TextStyle(
                fontSize: 16,
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget nextCreateLadderBtn() {
    return ElevatedButton(
        onPressed: () {
          print(_stateProvider!
              .ladderCreationParametersScreen3.clpInitialBuyQuantity.text);

          double initialBuyQty = 0;
          if (_stateProvider!
                  .ladderCreationParametersScreen3.clpInitialBuyQuantity.text !=
              "") {
            initialBuyQty = double.parse(_stateProvider!
                .ladderCreationParametersScreen3.clpInitialBuyQuantity.text
                .replaceAll(",", "")
                .replaceAll(" ", ""));
          }

          print(_stateProvider!.stepSize);
          print(_stateProvider!.numberOfStepsAbove);
          print(initialBuyQty);

          if (_stateProvider!.stepSize <= 0 ||
              _stateProvider!.numberOfStepsAbove <= 0 ||
              initialBuyQty <= 0) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return warningMessageDialog(
                    "Cash Allocated is not enough for creating a ladder please add more cash",
                    context);
              },
            );
          } else {
            if (!_isBtnClicked) {
              _isBtnClicked = true;
              showDialog(
                context: context,
                builder: (context) {
                  _isBtnClicked = false;
                  print(
                      "here is the cashNeeded for you ${_stateProvider!.cashNeeded}");
                  return ReviewLadderDialog(
                    stockName: _stateProvider!
                        .ladderCreationParametersScreen1.clpTicker!,
                    tickerId: _stateProvider!
                        .ladderCreationParametersScreen1.clpTickerId!,
                    initialyProvidedTargetPrice:
                        _stateProvider?.targetPrice ?? 0.0,
                    initialPurchasePrice:
                        _stateProvider!.initialBuyPrice.toString(),
                    currentStockPrice:
                        _stateProvider!.initialBuyPrice.toString(),
                    allocatedCash: double.parse(
                        _stateProvider!.actualCashAllocated.toString()),
                    cashNeeded: _stateProvider!.cashNeeded,
                    isMarketOrder: true,
                    minimumPriceForUpdateLadder: _stateProvider!.minimumPrice,
                    setDefaultBuySellQty: _stateProvider!.buySellQty,
                    newLadder: true,
                    symSecurityCode: _stateProvider!
                        .ladderCreationParametersScreen1.clpTickerId,
                    stepSize: _stateProvider!.calculatedStepSize,
                    numberOfStepsAbove:
                        _stateProvider!.calculatedNumberOfStepsAbove,
                    numberOfStepsBelow: _stateProvider!.numberOfStepsBelow,
                    initialBuyQty: int.tryParse((_stateProvider!
                            .ladderCreationParametersScreen3
                            .clpInitialBuyQuantity
                            .text
                            .replaceAll(",", "")
                            .split(".")[0])) ??
                        0,
                    actualCashAllocated: _stateProvider!.actualCashAllocated,
                    actualInitialBuyCash: _stateProvider!.actualInitialBuyCash,
                    ladTargetPriceMultiplier:
                        _stateProvider!.targetPriceMultiplier,
                    // assignedCash: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0,
                    assignedCash: double.tryParse(_stateProvider!.cashAllocatedControllerList[_stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
                  );
                },
              ).then((dialogBoxResponse) async {
                refreshLadderActivities(currencyConstantsProvider);
                print("Dialog $dialogBoxResponse");

                if (dialogBoxResponse == "ladderCreated") {
                  if (_stateProvider!.index ==
                      _stateProvider!.ladderCreationScreen3.length - 1) {
                    if (_stateProvider!.index == 0) {
                      _tradeMainProvider!.updateTabBarIndex = 0;
                      print("hello from the if statement");
                      _navigationProvider.selectedIndex = 1;
                    }
                    _tradeMainProvider!.updateTabBarIndex = 0;
                    _navigationProvider.selectedIndex = 1;
                  } else {
                    // if (_stateProvider!.index == 0) {
                    //   Navigator.pop(context);
                    // }
                    _stateProvider!.index = _stateProvider!.index + 1;
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => LadderCreationOptionScreen(
                    //       indexOfLadder: _stateProvider!.index,
                    //       message: "Choose your ladder creation option",
                    //       navigationProvider: _navigationProvider,
                    //       createLadderEasyProvider: createLadderEasyProvider,
                    //       value:
                    //           _stateProvider, // Replace with the correct value object
                    //     ),
                    //   ),
                    // );

                    CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                        LadderCreationOptionScreenNew(
                          indexOfLadder: _stateProvider!.index,
                          message: "Choose your ladder creation option",
                          navigationProvider: _navigationProvider,
                          createLadderEasyProvider: createLadderEasyProvider,
                          value:
                          _stateProvider, // Replace with the correct value object
                        ),
                        context,
                        // height: 500
                        height: 580 // + 80
                    );

                    _navigationProvider.selectedIndex = 5;
                    // showDialog(
                    //     context: context,
                    //     barrierDismissible: false,
                    //     builder: (context) {
                    //       return showLadderCreationOptionDialog(
                    //         _stateProvider!.index,
                    //           "Select Ladder creation option",
                    //           context,
                    //           value,
                    //           _navigationProvider,
                    //           createLadderEasyProvider);
                    //     },
                    //   );

                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => CreateLadder4(),
                    //   ),
                    // );
                  }
                }
              }).catchError((err) {
                print(err);
              });
            }
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor:
                (themeProvider.defaultTheme) ? Colors.green : Colors.orange),
        child: Text(
          "Show ladder",
          style: TextStyle(
              color:
                  (themeProvider.defaultTheme) ? Colors.white : Colors.white),
        ));
  }

  Widget ceilOrFloorBuySellQtyUi(CreateLadderProvider createLadderProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Ceil",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          height: 15,
          width: 15,
          child: Checkbox(
              value: createLadderProvider.ceilBuySellQty,
              onChanged: (bool? ceil) {
                print("ceil is here $ceil");
                createLadderProvider.updateCeilingBuySellQtyBool =
                    ceil ?? false;
              },
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.blue)),
        )
      ],
    );
  }

  Widget formulaCheckBox(bool forQuantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Show Formula',
          style: TextStyle(
              fontSize: 12,
              color:
                  (themeProvider.defaultTheme) ? Colors.black : Colors.yellow),
        ),
        SizedBox(
          width: 25,
          height: 30,
          child: Checkbox(
            value: forQuantity
                ? _stateProvider!.displayFormulaOfOrderSize
                : _stateProvider!.displayFormulaOfCashNeeded,
            onChanged: (bool? value) {
              forQuantity
                  ? _stateProvider!.displayFormulaOfOrderSize = value ?? false
                  : _stateProvider!.displayFormulaOfCashNeeded = value ?? false;
            },
            side: BorderSide(
              color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white, // White outline
              width: 2, // You can adjust the width if needed
            ),
          ),
        ),
      ],
    );
  }

  Widget initialBuyPriceUi(CurrencyConstants currencyConstantsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Initial buy price:",
          style: TextStyle(fontSize: 16),
        ),
        Text(
          "${currencyConstantsProvider.currency} ${_stateProvider!.initialBuyPrice}",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget calculatedInitialBuyQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Calculated Initial buy Quantity:",
          style: TextStyle(fontSize: 16),
        ),
        Text(
          " ${_stateProvider!.ladderCreationParametersScreen3.clpInitialBuyQuantity.text}",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    createLadderEasyProvider =
        Provider.of<CreateLadderEasyProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    CurrencyConstants currencyConstantsProvider = Provider.of(context);
    return Scaffold(
      key: _key,
      drawer: const NavDrawerNew(),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                color: (themeProvider.defaultTheme)
                    ? Color(0XFFF5F5F5)
                    : Colors.transparent,
                height: MediaQuery.of(context).size.height,
                width: screenWidth,
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: Container(
                  color: (themeProvider.defaultTheme)
                      ? Color(0XFFF5F5F5)
                      : Colors.transparent,
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: AppBar().preferredSize.height * 1.2,
                      ),
                      Consumer<CreateLadderProvider>(
                        builder: (context, value, child) {
                          return _stateProvider!.ladderCreationScreen3.isEmpty
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    heading(currencyConstantsProvider),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 30.0, right: 20.0),
                                            child: Consumer<ThemeProvider>(
                                                builder: (context, themeValue,
                                                    child) {
                                              return Column(
                                                children: [
                                                  initialBuyPriceUi(
                                                      currencyConstantsProvider),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  calculatedInitialBuyQuantity(),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  cashNeeded(
                                                      currencyConstantsProvider),
                                                  formulaCheckBox(false),
                                                  _stateProvider!
                                                          .displayFormulaOfCashNeeded
                                                      ? cashNeededFormulaUi()
                                                      : SizedBox(),
                                                  actualCashAllocatedUi(
                                                      currencyConstantsProvider),
                                                  ///////////////////////////////////

                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: (themeProvider
                                                                  .defaultTheme)
                                                              ? Color(
                                                                  0xFF0066C0)
                                                              : Colors.grey,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4.0))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            numberOfPriceStepBetweenInitialBuyAndTarget(),
                                                            SizedBox(height: 5),
                                                            numberOfStepsBelowUi(),
                                                            SizedBox(height: 5),
                                                            calculatedStepSize(),
                                                            SizedBox(height: 5),
                                                            buySellQtyUi(value),
                                                            if (_stateProvider!
                                                                    .buySellQtyWarning
                                                                    .length !=
                                                                0)
                                                              buySellQtyWarningUi(),
                                                            formulaCheckBox(
                                                                true),
                                                            _stateProvider!
                                                                    .displayFormulaOfOrderSize
                                                                ? buySellQtyFormulaUi(
                                                                    value
                                                                        .ceilBuySellQty)
                                                                : SizedBox(),
                                                            SizedBox(
                                                              height: 2,
                                                            ),
                                                            //////////////////

                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  recommendedParameters(),
                                                  SizedBox(height: 15),
                                                  suggestedNumberOfStepsAbove(),
                                                  if (_stateProvider!
                                                          .numberOfStepsAboveWarning
                                                          .length !=
                                                      0)
                                                    numberOfStepsAboveWarningUi(),
                                                  SizedBox(height: 5),
                                                  suggestedStepSize(),
                                                  if (value.stepSizeWarning
                                                          .length !=
                                                      0)
                                                    stepsizeWarningUi(),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      "Warning: Suggested values by user are used to guide the calculated values and may not be accepted exactly by the app",
                                                      style: TextStyle(
                                                          color: (themeProvider
                                                                  .defaultTheme)
                                                              ? Colors.red
                                                              : Colors.yellow)),
                                                  SizedBox(height: 5),
                                                  SizedBox(height: 5),
                                                ],
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              backBtn(),
                                              nextCreateLadderBtn()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            buildPageNumberCircle(context, screenWidth),
            CustomHomeAppBarWithProvider(
                backButton: false,
                leadingAction: _triggerDrawer,
                widthOfWidget: screenWidth),
          ],
        ),
      ),
    );
  }

  Widget buildPageNumberCircle(BuildContext context, screenWidth) {
    return Center(
      child: Container(
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height * 1.2,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomContainer(
                  borderColor: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                  borderWidth: 1,
                  borderRadius: 50,
                  backgroundColor: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Text(
                      "3",
                      style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget warningMessageDialog(String msg, BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 10,
              left: 20,
              right: 20,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(
                10,
              ),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Warning",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Ok",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStepAboveSuggestedSlider(BuildContext context) {
    double min = 1;
    double max = 2;
    if (_stateProvider!.ladderCreationParametersScreen3.clpInitialBuyQuantity
        .text.isNotEmpty) {
      max = double.parse(_stateProvider!
          .ladderCreationParametersScreen3.clpInitialBuyQuantity.text
          .replaceAll(",", ""));
    }

    double stepsAbove = 1;
    if (_stateProvider!.numberOfStepsAboveController.text.isNotEmpty) {
      stepsAbove = double.parse(_stateProvider!
          .numberOfStepsAboveController.text
          .replaceAll(",", ""));
    }

    // print("below are values of buildBuyQtySliderbuildStepAboveSuggestedSlider");
    // print(min);
    // print(max);
    // print(stepsAbove);
    // print(_stateProvider!.numberOfStepsAboveController.text);

    return Slider(
      value: (_stateProvider!.numberOfStepsAboveController.text == "")
          ? min
          : (stepsAbove > max)
              ? max
              : (stepsAbove < min)
                  ? min
                  : stepsAbove,
      max: max <= 1 ? 2 : max,
      divisions:
          ((max - min) <= 0) ? 10 : int.parse((max - min).toStringAsFixed(0)),
      min: min,
      label: _stateProvider!.numberOfStepsAboveController.text,
      onChanged: (double value) {
        _stateProvider!.numberOfStepsAboveController.value = TextEditingValue(
          text: value.toString(),
          selection: TextSelection.fromPosition(TextPosition(
              offset: _stateProvider!
                  .numberOfStepsAboveController.selection.baseOffset)),
        );

        _stateProvider!.updateNumberOfStepsAbove(
          _stateProvider!.numberOfStepsAboveController.text,
          _stateProvider!.numberOfStepsAboveController.selection.baseOffset,
        );

        if (_stateProvider!.numberOfStepsAboveController.text != "" &&
            _stateProvider!.numberOfStepsAboveController.text != "0") {
          _stateProvider!.stepSizeController.text = (_stateProvider!
                  .calculateFieldStepSize(double.parse(
                      _stateProvider!.numberOfStepsAboveController.text)))
              .toStringAsFixed(2);
        }
      },
    );
  }

  Widget buildStepSizeSuggestedSlider(BuildContext context) {
    double min = double.parse(
        (((double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpTargetPrice!.text.replaceAll(",", "")) ??
                        0.0) -
                    (double.tryParse(_stateProvider!
                            .ladderCreationParametersScreen1
                            .clpInitialPurchasePrice!
                            .text
                            .replaceAll(",", "")) ??
                        0.0)) /
                (double.tryParse(_stateProvider!.ladderCreationParametersScreen3
                        .clpInitialBuyQuantity.text
                        .replaceAll(",", "")) ??
                    0.0))
            .toStringAsFixed(2));
    double max = double.parse(((double.tryParse(_stateProvider!
                    .ladderCreationParametersScreen1.clpTargetPrice!.text
                    .replaceAll(",", "")) ??
                0.0) -
            (double.tryParse(_stateProvider!.ladderCreationParametersScreen1
                    .clpInitialPurchasePrice!.text
                    .replaceAll(",", "")) ??
                0.0))
        .toStringAsFixed(2));
    double stepsAbove = (_stateProvider!.stepSizeController.text == "")
        ? min
        : double.parse(
            _stateProvider!.stepSizeController.text.replaceAll(",", ""));
    return Slider(
      value: (_stateProvider!.stepSizeController.text == "")
          ? min
          : (stepsAbove > max)
              ? max
              : (stepsAbove < min)
                  ? min
                  : stepsAbove,
      max: max <= 1 ? 2 : max,
      divisions:
          ((max - min) <= 0) ? 1 : int.parse((max - min).toStringAsFixed(0)),
      min: min,
      label: _stateProvider!.stepSizeController.text,
      onChanged: (double value) {
        _stateProvider!.stepSizeController.value = TextEditingValue(
          text: value.toString(),
          selection: TextSelection.fromPosition(TextPosition(
              offset: _stateProvider!.stepSizeController.selection.baseOffset)),
        );

        List<String> splittedValues =
            doublValueSplitterBydot(_stateProvider!.stepSizeController.text);
        _stateProvider!.updateStepSize(
          splittedValues[0],
          splittedValues[1],
          _stateProvider!.stepSizeController.selection.baseOffset,
        );

        if (_stateProvider!.stepSizeController.text != "" &&
            _stateProvider!.stepSizeController.text != "0") {
          _stateProvider!.numberOfStepsAboveController.text = (_stateProvider!
                  .calculateFieldNumberOfStepAbove(
                      double.parse(_stateProvider!.stepSizeController.text)))
              .toString();
        }
      },
    );
  }
}
