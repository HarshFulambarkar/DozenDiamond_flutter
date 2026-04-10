import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/create_ladder/screens/show_ladder_creation_option_dialog.dart';
import 'package:dozen_diamond/AB_Ladder/widgets/review_ladder_dialog.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/global/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../create_ladder/screens/show_ladder_creation_option_dialog_new.dart';
import '../../global/constants/currency_constants.dart';
import '../../kyc/widgets/custom_bottom_sheets.dart';
import '../stateManagement/create_ladder_easy_provider.dart';
import '../utils/utility.dart';

class CreateLadderEasyScreen extends StatefulWidget {
  const CreateLadderEasyScreen({Key? key}) : super(key: key);

  @override
  State<CreateLadderEasyScreen> createState() => _CreateLadderEasyScreenState();
}

class _CreateLadderEasyScreenState extends State<CreateLadderEasyScreen> {
  late CreateLadderEasyProvider createLadderEasyProvider;
  late NavigationProvider navigationProvider;
  late CurrencyConstants _currencyConstantsProvider;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late TradeMainProvider tradeMainProvider;
  late CreateLadderProvider stateProvider;
  late ThemeProvider themeProvider;
  ScrollController _scrollbar = ScrollController();

  @override
  void initState() {
    print("inside init state");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("inside add post frame callback");
      prepareScreen();
    });
  }

  void _triggerDrawer() {
    print("acjar");
    _key.currentState!.openDrawer();
  }

  Future<void> prepareScreen() async {
    print("inside prepareScreen");
    stateProvider = Provider.of<CreateLadderProvider>(context, listen: false);
    createLadderEasyProvider =
        Provider.of<CreateLadderEasyProvider>(context, listen: false);
    navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);

    print("before goint in if");
    print(createLadderEasyProvider.ladderDetailsList.isNotEmpty);
    if (createLadderEasyProvider.ladderDetailsList.isNotEmpty) {
      print("iside if");
      createLadderEasyProvider.tickerId =
          createLadderEasyProvider.ladderDetailsList[0].ladTickerId!.toString();
      createLadderEasyProvider.ticker =
          createLadderEasyProvider.ladderDetailsList[0].ladTicker!;
      createLadderEasyProvider.tickerPrice = double.parse(
          createLadderEasyProvider.ladderDetailsList[0].ladInitialBuyPrice!
              .replaceAll(",", ""));
      createLadderEasyProvider.initialBuyPrice = double.parse(
          createLadderEasyProvider.ladderDetailsList[0].ladInitialBuyPrice!
              .replaceAll(",", ""));
      createLadderEasyProvider.priorCashAllocation = double.parse(
          createLadderEasyProvider.ladderDetailsList[0].ladCashAllocated!
              .replaceAll(",", ""));
    }

    storeInitialValuesInFields();
  }

  storeInitialValuesInFields() {
    createLadderEasyProvider.targetValue = createLadderEasyProvider
            .tickerPrice *
        2; //((((createLadderEasyProvider.tickerPrice * 1.2) + 1)+(createLadderEasyProvider.tickerPrice * 50))/2).floorToDouble();
    createLadderEasyProvider.targetTextEditingController.text =
        createLadderEasyProvider.targetValue.toStringAsFixed(0);

    createLadderEasyProvider.initialBuyQuantityValue =
        Utility().calculateInitialBuyQuantityMaxValue(
      createLadderEasyProvider.targetValue,
      createLadderEasyProvider.tickerPrice!,
      createLadderEasyProvider.priorCashAllocation!,
      createLadderEasyProvider.tickerPrice!,
    );
    createLadderEasyProvider.initialBuyQuantityTextEditingController.text =
        createLadderEasyProvider.initialBuyQuantityValue.toString();

    if (createLadderEasyProvider.initialBuyQuantityValue > 40) {
      createLadderEasyProvider.numberOfStepsAboveValue = 40;
    } else {
      createLadderEasyProvider.numberOfStepsAboveValue =
          createLadderEasyProvider.initialBuyQuantityValue.toDouble();
    }
    createLadderEasyProvider.numberOfStepAboveForSlider =
        createLadderEasyProvider.numberOfStepsAboveValue;
    createLadderEasyProvider.numberOfStepsAboveTextEditingController.text =
        createLadderEasyProvider.numberOfStepsAboveValue.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    createLadderEasyProvider = Provider.of(context);
    navigationProvider = Provider.of(context);
    tradeMainProvider = Provider.of(context);
    _currencyConstantsProvider = Provider.of(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return WillPopScope(
      onWillPop: () async {
        navigationProvider.selectedIndex =
            navigationProvider.previousSelectedIndex;
        navigationProvider.previousSelectedIndex = 3;
        return false;
      },
      child: Scaffold(
        key: _key,
        drawer: const NavDrawerNew(),
        body: SingleChildScrollView(
          child: SafeArea(
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
                Center(
                  child: Container(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: AppBar().preferredSize.height * 1.2,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  backBtn(),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: const Text(
                                      'Create Ladder (Easy)',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Ticker (${createLadderEasyProvider.ticker}) and Current Price (${_currencyConstantsProvider.currency}${Utility.amountFormat(createLadderEasyProvider.tickerPrice)})",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Prior Cash Allocation : ${_currencyConstantsProvider.currency}${Utility.amountFormat(createLadderEasyProvider.priorCashAllocation)}",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              RawScrollbar(
                                controller: _scrollbar,
                                thumbVisibility: true,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.58,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: SingleChildScrollView(
                                    controller: _scrollbar,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        buildLabelAndFieldSection(context),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        buildCheckBoxAndSaveLadderButton(
                                            context),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        buildBottomLabelSection(context),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                CustomHomeAppBarWithProvider(
                  backButton: false,
                  leadingAction: _triggerDrawer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget backBtn() {
    return ElevatedButton(
      onPressed: () async {
        await stateProvider.changeCashAllocated();

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => LadderCreationOptionScreen(
        //       indexOfLadder: stateProvider.index,
        //       message: "Choose your ladder creation option",
        //       navigationProvider: navigationProvider,
        //       createLadderEasyProvider: createLadderEasyProvider,
        //       value: stateProvider, // Replace with the correct value object
        //     ),
        //   ),
        // );

        CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
            LadderCreationOptionScreenNew(
              indexOfLadder: stateProvider.index,
              message: "Choose your ladder creation option",
              navigationProvider: navigationProvider,
              createLadderEasyProvider: createLadderEasyProvider,
              value: stateProvider, // Replace with the correct value object
            ),
            context,
            // height: 500
            height: 580 // + 80
        );

        navigationProvider.selectedIndex =
            navigationProvider.previousSelectedIndex;
        navigationProvider.previousSelectedIndex = 3;

        // navigationProvider.selectedIndex = 4;
      },
      child: Text("Back", style: TextStyle(color: Colors.white)),
    );
  }

  Widget rangeForParametersTarget(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Range for Target Price"),
              Text(
                  "${_currencyConstantsProvider.currency}${((createLadderEasyProvider.tickerPrice * 1.2) + 1).toStringAsFixed(2)}  to  ${_currencyConstantsProvider.currency}${(createLadderEasyProvider.tickerPrice * 50).toStringAsFixed(2)}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget rangeForParametersInitialBuyQuantity() {
    return Consumer<CreateLadderEasyProvider>(builder: (context, value, child) {
      return value.isTargetPriceAvailable
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Range for Initial Buy Quantity"),
                    Text("20 to ${Utility().calculateInitialBuyQuantityMaxValue(
                      createLadderEasyProvider.targetValue,
                      createLadderEasyProvider.tickerPrice!,
                      createLadderEasyProvider.priorCashAllocation!,
                      createLadderEasyProvider.tickerPrice!,
                    )}"),
                  ],
                )
              ],
            )
          : SizedBox();
    });
  }

  Widget rangeForParameterNa() {
    return (createLadderEasyProvider.initialBuyQuantityValue != 0)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Range for Number of Steps Above"),
              Text(
                  "1 to ${(createLadderEasyProvider.initialBuyQuantityValue != 0) ? createLadderEasyProvider.initialBuyQuantityValue : 100}"),
            ],
          )
        : Container();
  }

  Widget buildLabelAndFieldSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "Target",
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                    textInputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller:
                        createLadderEasyProvider.targetTextEditingController,
                    borderRadius: 5,

                    currencyFormat: true,
                    isFilled: true,
                    elevation: 0,
                    isLabelEnabled: false,
                    borderWidth: 1,
                    // fillColor: Colors.transparent,
                    fillColor: (themeProvider.defaultTheme)
                        ? Color(0XFFF5F5F5)
                        : Color(0xFF15181F),
                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

                    onChanged: (value) {
                      print(value);
                      print(createLadderEasyProvider
                          .targetTextEditingController.text);
                      createLadderEasyProvider.validateNumberOfStepsAbove();

                      createLadderEasyProvider.validateTargetValue(
                          createLadderEasyProvider
                              .targetTextEditingController.text);
                      createLadderEasyProvider.validateInitialBuyQuantityValue(
                          createLadderEasyProvider
                              .initialBuyQuantityTextEditingController.text);
                    },
                    borderColor: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    labelText: "Enter Target",
                    hintText: "Enter Target",
                    maxLength: 9,
                    counterText: "",

                    overrideHintText: true,

                    focusedBorderColor: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    isPasswordField: false,
                    trailing: Icon(
                      Icons.check_circle,
                      color: (createLadderEasyProvider.enableTargetButton)
                          ? Colors.green
                          : (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                      size: 25,
                    ),
                    trailingFunction: () {
                      if (createLadderEasyProvider
                              .targetTextEditingController.text !=
                          "") {
                        createLadderEasyProvider.targetValue = double.parse(
                            createLadderEasyProvider
                                .targetTextEditingController.text);
                      }
                    },
                    isEnabled: true,
                    // showLeadingWidget: true,

                    keyboardType: TextInputType.number,
                    hintTextStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    labelStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    textStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    validator: (value) {
                      print("inside of validator");
                      if (value!.isNotEmpty && value != "") {
                        print("inside if of validator");
                        if (double.parse(value) <=
                            Utility().multiplyBy1Point2(
                                createLadderEasyProvider.tickerPrice ?? 0.0)) {
                          print("insdie this0");
                          createLadderEasyProvider.targetErrorText =
                              "Target can not be less then 1.2 times of current price";
                          // return "Can't be less then 1.2 times of current price";
                        }
                      }
                      return null;
                    },
                  ),
                  (createLadderEasyProvider.targetErrorText == "")
                      ? Container()
                      : Text(createLadderEasyProvider.targetErrorText,
                          style: TextStyle(color: Colors.red))
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        buildTargetPriceSlider(context),
        const SizedBox(
          height: 10,
        ),
        rangeForParametersTarget(context),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "Initial Buy Quantity",
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                    textInputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: createLadderEasyProvider
                        .initialBuyQuantityTextEditingController,
                    borderRadius: 5,
                    isFilled: true,
                    maxLength: 9,
                    counterText: "",
                    elevation: 0,
                    isLabelEnabled: false,
                    borderWidth: 1,
                    fillColor: (themeProvider.defaultTheme)
                                ? Color(0XFFF5F5F5)
                                : Color(0xFF15181F),
                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    onChanged: (value) {
                      createLadderEasyProvider.validateNumberOfStepsAbove();

                      createLadderEasyProvider.validateTargetValue(
                          createLadderEasyProvider
                              .targetTextEditingController.text);
                      createLadderEasyProvider.validateInitialBuyQuantityValue(
                          createLadderEasyProvider
                              .initialBuyQuantityTextEditingController.text);
                    },
                    borderColor: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    labelText: "Enter Initial Buy Quantity",
                    hintText: "Enter Initial Buy Quantity",
                    overrideHintText: true,
                    focusedBorderColor: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    isPasswordField: false,
                    trailing: Icon(
                      Icons.check_circle,
                      color: (createLadderEasyProvider
                              .enableInitialBuyQuantityButton)
                          ? Colors.green
                          : (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                      size: 25,
                    ),
                    isEnabled: true,
                    keyboardType: TextInputType.number,
                    hintTextStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    labelStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    textStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isNotEmpty && value != "") {
                        if (int.parse(value) >
                            Utility().calculateInitialBuyQuantityMaxValue(
                              createLadderEasyProvider.targetValue,
                              createLadderEasyProvider.tickerPrice!,
                              createLadderEasyProvider.priorCashAllocation!,
                              createLadderEasyProvider.tickerPrice!,
                            )) {
                          createLadderEasyProvider.initialBuyErrorText =
                              "Invalid Initial Buy Quantity";
                        }
                      }
                      return null;
                    },
                  ),
                  (createLadderEasyProvider.initialBuyErrorText == "")
                      ? Container()
                      : Text(
                          createLadderEasyProvider.initialBuyErrorText,
                          style: TextStyle(color: Colors.red),
                        )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        buildInitialBuyQuantitySlider(context),
        const SizedBox(
          height: 10,
        ),
        rangeForParametersInitialBuyQuantity(),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "Number of Steps Above",
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                    textInputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: createLadderEasyProvider
                        .numberOfStepsAboveTextEditingController,
                    borderRadius: 5,
                    isFilled: true,
                    maxLength: 4,
                    elevation: 0,
                    counterText: "",
                    isLabelEnabled: false,
                    borderWidth: 1,
                    // fillColor: Colors.transparent,
                    fillColor: (themeProvider.defaultTheme)
                        ? Color(0XFFF5F5F5)
                        : Color(0xFF15181F),
                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    onChanged: (value) {
                      createLadderEasyProvider.validateNumberOfStepsAbove();

                      createLadderEasyProvider.validateTargetValue(
                          createLadderEasyProvider
                              .targetTextEditingController.text);
                      createLadderEasyProvider.validateInitialBuyQuantityValue(
                          createLadderEasyProvider
                              .initialBuyQuantityTextEditingController.text);
                    },
                    borderColor: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    labelText: "Enter Number of Steps Above",
                    hintText: "Enter Number of Steps Above",
                    overrideHintText: true,
                    focusedBorderColor: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    isPasswordField: false,
                    hintTextStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    labelStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    textStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    trailing: Icon(
                      Icons.check_circle,
                      color: (createLadderEasyProvider
                              .enableNumberOfStepsAboveButton)
                          ? Colors.green
                          : (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                      size: 25,
                    ),
                    isEnabled: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return null;
                    },
                  ),
                  (createLadderEasyProvider.numberOfStepAboveErrorText == "")
                      ? Container()
                      : Text(
                          createLadderEasyProvider.numberOfStepAboveErrorText,
                          style: TextStyle(color: Colors.red),
                        )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        buildNumberOfStepsAboveSlider(context),
        SizedBox(
          height: 10,
        ),
        rangeForParameterNa(),
      ],
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
                value: createLadderEasyProvider.updateCheckbox,
                activeColor: Colors.blue,
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue),
                onChanged: (bool? newValue) {
                  createLadderEasyProvider.updateCheckbox = newValue ?? false;

                  if (createLadderEasyProvider.updateCheckbox) {
                    createLadderEasyProvider.calculateLadderParameter(context);
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
          height: (createLadderEasyProvider.updateCheckbox) ? 10 : 0,
        ),
        (createLadderEasyProvider.updateCheckbox &&
                createLadderEasyProvider.targetErrorText == "" &&
                createLadderEasyProvider.initialBuyErrorText == "" &&
                createLadderEasyProvider.numberOfStepAboveErrorText == "" &&
                createLadderEasyProvider.targetTextEditingController.text !=
                    "" &&
                createLadderEasyProvider
                        .initialBuyQuantityTextEditingController.text !=
                    "" &&
                createLadderEasyProvider
                        .numberOfStepsAboveTextEditingController.text !=
                    "")
            ? ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF0099CC),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: const BorderSide(
                    color: Color(0xFF0099CC),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ReviewLadderDialog(
                        stockName: createLadderEasyProvider.ticker,
                        tickerId:
                            int.tryParse(createLadderEasyProvider!.tickerId) ??
                                0,
                        initialyProvidedTargetPrice: (double.tryParse(
                                (createLadderEasyProvider
                                        .targetTextEditingController.text)
                                    .replaceAll(",", "")) ??
                            0.0),
                        initialPurchasePrice:
                            createLadderEasyProvider.initialBuyPrice.toString(),
                        currentStockPrice:
                            createLadderEasyProvider.initialBuyPrice.toString(),
                        allocatedCash: double.parse(createLadderEasyProvider
                            .priorCashAllocation
                            .toString()),
                        cashNeeded: createLadderEasyProvider!.cashNeeded,
                        isMarketOrder: true,
                        minimumPriceForUpdateLadder: 0.0,
                        setDefaultBuySellQty:
                            createLadderEasyProvider.buySellQuantityValue,
                        newLadder: true,
                        symSecurityCode:
                            int.tryParse(createLadderEasyProvider!.tickerId) ??
                                0,
                        stepSize: createLadderEasyProvider.stepSizeValue,
                        numberOfStepsAbove:
                            createLadderEasyProvider.numberOfStepsAboveValue,
                        numberOfStepsBelow:
                            createLadderEasyProvider.numberOfStepsBelow,
                        initialBuyQty:
                            createLadderEasyProvider.initialBuyQuantityValue,
                        actualCashAllocated:
                            createLadderEasyProvider!.finalCashAllocation,
                        actualInitialBuyCash:
                            createLadderEasyProvider.initialBuyCash,
                        ladTargetPriceMultiplier:
                            (createLadderEasyProvider.targetValue /
                                createLadderEasyProvider.initialBuyPrice),
                        // assignedCash: double.tryParse(stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0,
                        assignedCash: double.tryParse(stateProvider!.cashAllocatedControllerList[stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
                      );
                    },
                  ).then((dialogBoxResponse) async {
                    if (dialogBoxResponse == "ladderCreated") {
                      if (createLadderEasyProvider
                          .ladderDetailsList.isNotEmpty) {
                        createLadderEasyProvider.ladderDetailsList.removeAt(0);
                      }

                      stateProvider.index = stateProvider.index + 1;
                      createLadderEasyProvider.refreshLadderValues();
                      print("here is the result 0");
                      if (createLadderEasyProvider
                          .ladderDetailsList.isNotEmpty) {
                        // Navigator.pop(context);
                        print("here is the result 1");
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => LadderCreationOptionScreen(
                        //       indexOfLadder: stateProvider.index,
                        //       message: "Choose your ladder creation option",
                        //       navigationProvider: navigationProvider,
                        //       createLadderEasyProvider:
                        //           createLadderEasyProvider,
                        //       value:
                        //           stateProvider, // Replace with the correct value object
                        //     ),
                        //   ),
                        // );

                        CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                            LadderCreationOptionScreenNew(
                              indexOfLadder: stateProvider.index,
                              message: "Choose your ladder creation option",
                              navigationProvider: navigationProvider,
                              createLadderEasyProvider:
                              createLadderEasyProvider,
                              value:
                              stateProvider, // Replace with the correct value object
                            ),
                            context,
                            // height: 500
                            height: 580 // + 80
                        );
                      }

                      if (createLadderEasyProvider
                          .ladderDetailsList.isNotEmpty) {
                        createLadderEasyProvider.tickerId =
                            createLadderEasyProvider
                                .ladderDetailsList[0].ladTickerId!
                                .toString();
                        createLadderEasyProvider.ticker =
                            createLadderEasyProvider
                                .ladderDetailsList[0].ladTicker!;
                        createLadderEasyProvider.tickerPrice = double.parse(
                            createLadderEasyProvider
                                .ladderDetailsList[0].ladInitialBuyPrice!
                                .replaceAll(",", ""));
                        createLadderEasyProvider.initialBuyPrice = double.parse(
                            createLadderEasyProvider
                                .ladderDetailsList[0].ladInitialBuyPrice!
                                .replaceAll(",", ""));
                        createLadderEasyProvider.priorCashAllocation =
                            double.parse(createLadderEasyProvider
                                .ladderDetailsList[0].ladCashAllocated!
                                .replaceAll(",", ""));
                      } else {
                        print("here is the result 3");
                        tradeMainProvider.updateTabBarIndex = 0;
                        navigationProvider.selectedIndex = 1;
                      }
                    }
                  }).catchError((err) {
                    print(err);
                  });
                },
                child: const Text('Show Ladder',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              )
            : Container()
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
                "Target",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  (createLadderEasyProvider.targetValue == 0.0)
                      ? "0.0"
                      : Utility.amountFormat(
                          createLadderEasyProvider.targetValue),
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
                "Initial Buy Quantity",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  createLadderEasyProvider.initialBuyQuantityValue.toString(),
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
                "Initial Buy Cash",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  (createLadderEasyProvider.initialBuyCash == 0.0)
                      ? "0.0"
                      : Utility.amountFormat(
                          createLadderEasyProvider.initialBuyCash),
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
              flex: 2,
              child: Text(
                "Calculated Number of Steps Above",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  createLadderEasyProvider.numberOfStepsAboveValue
                      .toStringAsFixed(2),
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
              flex: 2,
              child: Text(
                "Calculated Number of Steps Below",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  createLadderEasyProvider.numberOfStepsBelow
                      .toStringAsFixed(2),
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
                "Step Size",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  createLadderEasyProvider.stepSizeValue.toStringAsFixed(2),
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
                "Default buy sell quantity",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  createLadderEasyProvider.buySellQuantityValue
                      .toStringAsFixed(2),
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
                "Cash Needed",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  (createLadderEasyProvider.cashNeeded == 0.0)
                      ? "0.0"
                      : Utility.amountFormat(
                          createLadderEasyProvider.cashNeeded),
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
                "Final Cash Allocation",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  (createLadderEasyProvider.finalCashAllocation == 0.0)
                      ? "0.0"
                      : Utility.amountFormat(
                          createLadderEasyProvider.finalCashAllocation),
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

  Widget saveLadderAlertDialog(String msg, BuildContext context) {
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
                20,
              ),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (createLadderEasyProvider.targetTextEditingController.text != "" &&
                            createLadderEasyProvider
                                    .initialBuyQuantityTextEditingController
                                    .text !=
                                "" &&
                            createLadderEasyProvider
                                    .numberOfStepsAboveTextEditingController
                                    .text !=
                                "") {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ReviewLadderDialog(
                                stockName: createLadderEasyProvider.ticker,
                                tickerId: int.tryParse(
                                        createLadderEasyProvider!.tickerId) ??
                                    0,
                                initialyProvidedTargetPrice: (double.tryParse(
                                        (createLadderEasyProvider
                                                .targetTextEditingController
                                                .text)
                                            .replaceAll(",", "")) ??
                                    0.0),
                                initialPurchasePrice: createLadderEasyProvider
                                    .initialBuyPrice
                                    .toString(),
                                currentStockPrice: createLadderEasyProvider
                                    .initialBuyPrice
                                    .toString(),
                                allocatedCash: double.parse(
                                    createLadderEasyProvider.priorCashAllocation
                                        .toString()),
                                cashNeeded:
                                    createLadderEasyProvider!.cashNeeded,
                                isMarketOrder: true,
                                minimumPriceForUpdateLadder: 0.0,
                                setDefaultBuySellQty: createLadderEasyProvider
                                    .buySellQuantityValue,
                                newLadder: true,
                                symSecurityCode: int.tryParse(
                                        createLadderEasyProvider!.tickerId) ??
                                    0,
                                stepSize:
                                    createLadderEasyProvider.stepSizeValue,
                                numberOfStepsAbove: createLadderEasyProvider
                                    .numberOfStepsAboveValue,
                                numberOfStepsBelow:
                                    createLadderEasyProvider.numberOfStepsBelow,
                                initialBuyQty: createLadderEasyProvider
                                    .initialBuyQuantityValue,
                                actualCashAllocated: createLadderEasyProvider!
                                    .finalCashAllocation,
                                actualInitialBuyCash:
                                    createLadderEasyProvider.initialBuyCash,
                                // assignedCash: double.tryParse(stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0,
                                assignedCash: double.tryParse(stateProvider!.cashAllocatedControllerList[stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
                              );
                            },
                          );
                        }
                      },
                      child: const Text(
                        "Save",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
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

  Widget buildTargetPriceSlider(BuildContext context) {
    return Slider(
      value: ((createLadderEasyProvider.targetValue <=
              ((createLadderEasyProvider.tickerPrice * 1.2) + 1)))
          ? ((createLadderEasyProvider.tickerPrice * 1.2) + 1)
          : (createLadderEasyProvider.targetValue >=
                  (createLadderEasyProvider.tickerPrice * 50))
              ? (createLadderEasyProvider.tickerPrice * 50)
              : (createLadderEasyProvider.targetValue == 0)
                  ? ((((createLadderEasyProvider.tickerPrice * 1.2) + 1) +
                          (createLadderEasyProvider.tickerPrice * 50)) /
                      2)
                  : createLadderEasyProvider.targetValue,
      max: (createLadderEasyProvider.tickerPrice * 50),
      divisions: (createLadderEasyProvider.tickerPrice * 50).toInt(),
      min: ((createLadderEasyProvider.tickerPrice * 1.2) + 1),
      label: _currencyConstantsProvider.currency +
          Utility.amountFormat(createLadderEasyProvider.targetValue),
      onChanged: (double value) {
        setState(() {
          createLadderEasyProvider.targetValue = value.floorToDouble();
          createLadderEasyProvider.targetTextEditingController.text =
              value.toStringAsFixed(0);

          createLadderEasyProvider.validateNumberOfStepsAbove();

          createLadderEasyProvider.validateTargetValue(
              createLadderEasyProvider.targetTextEditingController.text);
          createLadderEasyProvider.validateInitialBuyQuantityValue(
              createLadderEasyProvider
                  .initialBuyQuantityTextEditingController.text);
        });
      },
    );
  }

  double getInitialBuyQuantityValueSlider() {
    int calculateInitialBuyQuantityMaxValue =
        Utility().calculateInitialBuyQuantityMaxValue(
      createLadderEasyProvider.targetValue,
      createLadderEasyProvider.tickerPrice!,
      createLadderEasyProvider.priorCashAllocation!,
      createLadderEasyProvider.tickerPrice!,
    );

    print("calculateInitialBuyQuantityMaxValue");
    print(calculateInitialBuyQuantityMaxValue);

    if (calculateInitialBuyQuantityMaxValue <= 1) {
      print("1");
      return 1;
    } else if (calculateInitialBuyQuantityMaxValue <
        createLadderEasyProvider.initialBuyQuantityValue) {
      print("2");
      return calculateInitialBuyQuantityMaxValue.toDouble();
    } else if (createLadderEasyProvider.initialBuyQuantityValue < 1) {
      print("3");
      return calculateInitialBuyQuantityMaxValue.toDouble();
    } else if (createLadderEasyProvider.initialBuyQuantityValue < 20) {
      print("4");
      return calculateInitialBuyQuantityMaxValue.toDouble();
      // return 20;
    } else {
      print("5");
      return createLadderEasyProvider.initialBuyQuantityValue.toDouble();
    }
  }

  double getMinBuyQuantityValueSlider() {
    int calculateInitialBuyQuantityMaxValue =
        Utility().calculateInitialBuyQuantityMaxValue(
      createLadderEasyProvider.targetValue,
      createLadderEasyProvider.tickerPrice!,
      createLadderEasyProvider.priorCashAllocation!,
      createLadderEasyProvider.tickerPrice!,
    );

    if (calculateInitialBuyQuantityMaxValue <= 21 &&
        calculateInitialBuyQuantityMaxValue != 0) {
      print("11");
      return calculateInitialBuyQuantityMaxValue.toDouble();
    } else if (calculateInitialBuyQuantityMaxValue == 0) {
      print("22");
      return 1;
    } else {
      print("33");
      return 20;
    }
  }

  double getMaxBuyQuantityValueSlider() {
    int calculateInitialBuyQuantityMaxValue =
        Utility().calculateInitialBuyQuantityMaxValue(
      createLadderEasyProvider.targetValue,
      createLadderEasyProvider.tickerPrice!,
      createLadderEasyProvider.priorCashAllocation!,
      createLadderEasyProvider.tickerPrice!,
    );

    if (calculateInitialBuyQuantityMaxValue <= 21) {
      print("111");
      return 21;
    } else if (calculateInitialBuyQuantityMaxValue == 0) {
      print("222");
      return 40;
    } else {
      print("333");
      return calculateInitialBuyQuantityMaxValue.toDouble();
    }
  }

  int getDivisionValueSlider() {
    int calculateInitialBuyQuantityMaxValue =
        Utility().calculateInitialBuyQuantityMaxValue(
      createLadderEasyProvider.targetValue,
      createLadderEasyProvider.tickerPrice!,
      createLadderEasyProvider.priorCashAllocation!,
      createLadderEasyProvider.tickerPrice!,
    );

    if (calculateInitialBuyQuantityMaxValue <= 21) {
      print("1111");
      return 21;
    } else if (calculateInitialBuyQuantityMaxValue == 0) {
      print("2222");
      return 40;
    } else {
      print("3333");
      return calculateInitialBuyQuantityMaxValue;
    }

    // if (calculateInitialBuyQuantityMaxValue == 0) {
    //   print("1111");
    //   return 40;
    // } else {
    //   print("2222");
    //   return calculateInitialBuyQuantityMaxValue;
    // }
  }

  Widget buildInitialBuyQuantitySlider(BuildContext context) {
    return Slider(
      value: getInitialBuyQuantityValueSlider(),
      max: getMaxBuyQuantityValueSlider(),
      divisions: getDivisionValueSlider(),
      min: getMinBuyQuantityValueSlider(),
      label:
          createLadderEasyProvider.initialBuyQuantityValue.toStringAsFixed(0),
      onChanged: (double value) {
        setState(() {
          createLadderEasyProvider.initialBuyQuantityValue = value.toInt();
          createLadderEasyProvider.initialBuyQuantityTextEditingController
              .text = value.toStringAsFixed(0);

          createLadderEasyProvider.validateNumberOfStepsAbove();

          createLadderEasyProvider.validateTargetValue(
              createLadderEasyProvider.targetTextEditingController.text);
          createLadderEasyProvider.validateInitialBuyQuantityValue(
              createLadderEasyProvider
                  .initialBuyQuantityTextEditingController.text);
        });
      },
    );
  }

  Widget buildNumberOfStepsAboveSlider(BuildContext context) {
    return Slider(
      value: (createLadderEasyProvider.numberOfStepAboveForSlider == 0 ||
              createLadderEasyProvider.initialBuyQuantityValue == 0)
          ? 1
          : (createLadderEasyProvider.initialBuyQuantityValue <=
                  createLadderEasyProvider.numberOfStepAboveForSlider)
              ? createLadderEasyProvider.initialBuyQuantityValue.ceilToDouble()
              : createLadderEasyProvider.numberOfStepAboveForSlider
                  .ceilToDouble(),
      max: (createLadderEasyProvider.initialBuyQuantityValue != 0)
          ? createLadderEasyProvider.initialBuyQuantityValue.toDouble()
          : 100.00,
      divisions: (createLadderEasyProvider.initialBuyQuantityValue != 0)
          ? createLadderEasyProvider.initialBuyQuantityValue
          : 100,
      min: 1,
      label: createLadderEasyProvider.numberOfStepAboveForSlider
          .toStringAsFixed(0),
      onChanged: (double value) {
        setState(() {
          createLadderEasyProvider.numberOfStepAboveForSlider = value;
          createLadderEasyProvider.numberOfStepsAboveTextEditingController
              .text = value.toStringAsFixed(0);

          createLadderEasyProvider.validateNumberOfStepsAbove();

          createLadderEasyProvider.validateTargetValue(
              createLadderEasyProvider.targetTextEditingController.text);
          createLadderEasyProvider.validateInitialBuyQuantityValue(
              createLadderEasyProvider
                  .initialBuyQuantityTextEditingController.text);
        });
      },
    );
  }
}
