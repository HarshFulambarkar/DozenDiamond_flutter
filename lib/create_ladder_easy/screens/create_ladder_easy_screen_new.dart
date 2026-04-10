import 'dart:io';

import 'package:dozen_diamond/kyc/widgets/custom_bottom_sheets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../AB_Ladder/widgets/review_ladder_dialog_new.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../create_ladder/screens/show_ladder_creation_option_dialog_new.dart';
import '../../create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/stateManagement/progress_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/progress_bar.dart';
import '../../localization/translation_keys.dart';
import '../stateManagement/create_ladder_easy_provider.dart';
import '../utils/utility.dart';

class CreateLadderEasyScreenNew extends StatefulWidget {
  const CreateLadderEasyScreenNew({super.key});

  @override
  State<CreateLadderEasyScreenNew> createState() => _CreateLadderEasyScreenNewState();
}

class _CreateLadderEasyScreenNewState extends State<CreateLadderEasyScreenNew> {

  late CreateLadderEasyProvider createLadderEasyProvider;
  late NavigationProvider navigationProvider;
  late CurrencyConstants _currencyConstantsProvider;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late TradeMainProvider tradeMainProvider;
  late CreateLadderProvider stateProvider;
  late ThemeProvider themeProvider;
  late ProgressProvider progressProvider;

  @override
  void initState() {
    print("inside init state");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("inside add post frame callback");
      prepareScreen();

      progressProvider = Provider.of(context, listen: false);
      progressProvider.updateProgress(0.7);

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
      createLadderEasyProvider.tickerExchange = createLadderEasyProvider.ladderDetailsList[0].ladExchange ?? "-";
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

    if(createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate.containsKey(createLadderEasyProvider.ticker)) {
      createLadderEasyProvider.isRecommendedParametersEnabledTargetPriceMultiplier[createLadderEasyProvider.ticker] = true;
      createLadderEasyProvider.targetPriceMultiplierValue = double.parse(createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate[createLadderEasyProvider.ticker]?.targetPriceMultipler ?? "1.2");
    } else {
      createLadderEasyProvider.isRecommendedParametersEnabledTargetPriceMultiplier[createLadderEasyProvider.ticker] = false;
    }
    createLadderEasyProvider.targetValue = createLadderEasyProvider
        .tickerPrice * createLadderEasyProvider.targetPriceMultiplierValue;
        // 2; //((((createLadderEasyProvider.tickerPrice * 1.2) + 1)+(createLadderEasyProvider.tickerPrice * 50))/2).floorToDouble();

    createLadderEasyProvider.targetPriceMultiplierTextEditingController.text = createLadderEasyProvider.targetPriceMultiplierValue.toString();

    createLadderEasyProvider.targetTextEditingController.text =
        createLadderEasyProvider.targetValue.toStringAsFixed(2);

    createLadderEasyProvider.initialBuyQuantityValue =
        Utility().calculateInitialBuyQuantityMaxValue(
          createLadderEasyProvider.targetValue,
          createLadderEasyProvider.tickerPrice,
          createLadderEasyProvider.priorCashAllocation,
          createLadderEasyProvider.tickerPrice,
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

    if(createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate.containsKey(createLadderEasyProvider.ticker)) {

      createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = true;

      // double stepSize = (createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate[createLadderEasyProvider.ticker]?.stepsSize ?? 20).toDouble();
      double stepAbove = (createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate[createLadderEasyProvider.ticker]?.stepsAbove ?? 20).toDouble();

      createLadderEasyProvider.numberOfStepsAboveTextEditingController.text = stepAbove.toString();
      createLadderEasyProvider.numberOfStepsAboveValue = stepAbove;

      // createLadderEasyProvider.stepSizeTextEditingController.text = stepSize.toString();
      // createLadderEasyProvider.stepSizeValue = stepSize;

    } else {

      createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;

      double stepSize = ((createLadderEasyProvider.targetValue - createLadderEasyProvider.initialBuyPrice) / createLadderEasyProvider.numberOfStepsAboveValue);
      print("here is the stepsize $stepSize");
      stepSize = (stepSize * 100).floorToDouble() / 100;
      createLadderEasyProvider.stepSizeTextEditingController.text = stepSize.toString();
      createLadderEasyProvider.stepSizeValue = stepSize;
    }

  }

  double getInitialBuyQuantityValueSlider() {
    int calculateInitialBuyQuantityMaxValue =
    Utility().calculateInitialBuyQuantityMaxValue(
      createLadderEasyProvider.targetValue,
      createLadderEasyProvider.tickerPrice,
      createLadderEasyProvider.priorCashAllocation,
      createLadderEasyProvider.tickerPrice,
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
      createLadderEasyProvider.tickerPrice,
      createLadderEasyProvider.priorCashAllocation,
      createLadderEasyProvider.tickerPrice,
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
      createLadderEasyProvider.tickerPrice,
      createLadderEasyProvider.priorCashAllocation,
      createLadderEasyProvider.tickerPrice,
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
      createLadderEasyProvider.tickerPrice,
      createLadderEasyProvider.priorCashAllocation,
      createLadderEasyProvider.tickerPrice,
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

  @override
  Widget build(BuildContext context) {
    createLadderEasyProvider = Provider.of(context);
    navigationProvider = Provider.of(context);
    tradeMainProvider = Provider.of(context);
    _currencyConstantsProvider = Provider.of(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    progressProvider = Provider.of<ProgressProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);

    return PopScope(
        onPopInvokedWithResult: ((value, result) {
          navigationProvider.selectedIndex =
              navigationProvider.previousSelectedIndex;
          navigationProvider.previousSelectedIndex = 3;
          // return false;
        }),
        canPop: false,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: SafeArea(
            bottom: (kIsWeb)?true:(Platform.isIOS)?false:true,
            child: Stack(
              children: [
                Center(
                  child: Container(
                      width: screenWidth,
                      child: Scaffold(
                        drawer: const NavDrawerNew(),
                        key: _key,
                        backgroundColor: (themeProvider.defaultTheme)
                            ? Color(0XFFF5F5F5)
                            : Color(0xFF15181F),
                        body: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 45,
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16.0),
                                    child: ProgressBar(),
                                  ),

                                  SizedBox(height: 20),

                                  buildBackButtonSection(context, screenWidth),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  buildTopTickerDetailsSection(context, screenWidth),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  (createLadderEasyProvider.tickerPrice <= 0)?Container(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(),
                                  ) :buildConfigurationsSection(context, screenWidth),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16.0),
                                    child: Divider(
                                      color: Color(0xff2c2c31),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  buildCheckboxSection(context, screenWidth),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  buildBreakdownSection(context, screenWidth),

                                  SizedBox(
                                    height: 20,
                                  ),

                                ],
                              ),
                            ),

                            CustomHomeAppBarWithProviderNew(
                                backButton: false, leadingAction: _triggerDrawer),
                          ],
                        ),
                          bottomNavigationBar: buildCreateLadderButtonSection(context, screenWidth)
                      )
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

Widget buildBackButtonSection(BuildContext context, double screenWidth) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16.0),
    child: Row(
      children: [
        InkWell(
          onTap: () {
            navigationProvider.selectedIndex =
                navigationProvider.previousSelectedIndex;
            navigationProvider.previousSelectedIndex = 3;
          },
          child: Icon(
            Icons.arrow_back,
            color: (themeProvider.defaultTheme) 
                ? Colors.black 
                : const Color(0xfff0f0f0),
            size: 22,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          TranslationKeys.createLadder,
          style: TextStyle(
            fontFamily: "Britannica",
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: (themeProvider.defaultTheme) 
                ? Colors.black 
                : const Color(0xfff0f0f0),
          ),
        )
      ],
    ),
  );
}

Widget buildTopTickerDetailsSection(BuildContext context, double screenWidth) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16.0),
    child: CustomContainer(
      padding: 0,
      paddingEdge: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      borderColor: Color(0xff2c2c31),
      borderRadius: 10,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      createLadderEasyProvider.ticker,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: (themeProvider.defaultTheme) 
                            ? Colors.black 
                            : const Color(0xfff0f0f0),
                      ),
                    ),
                    CustomContainer(
                      backgroundColor: const Color(0xff3a2d7f),
                      borderRadius: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8.0,
                          top: 3,
                          bottom: 3,
                        ),
                        child: Text(
                          createLadderEasyProvider.tickerExchange,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: const Color(0xfff0f0f0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "${_currencyConstantsProvider.currency}${Utility.amountFormat(createLadderEasyProvider.currentPrice)}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.black 
                        : const Color(0xfff0f0f0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${TranslationKeys.initialBuyPrice}:",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.black
                        : const Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${_currencyConstantsProvider.currency}${Utility.amountFormat(createLadderEasyProvider.initialBuyPrice)}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.grey.shade700 
                        : const Color(0xffa2b0bc),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${TranslationKeys.cashAllocated}:",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.grey.shade700 
                        : const Color(0xffa2b0bc),
                  ),
                ),
                Text(
                  "${_currencyConstantsProvider.currency}${Utility.amountFormat(createLadderEasyProvider.priorCashAllocation)}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.black 
                        : const Color(0xfff0f0f0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.mode,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.grey.shade700 
                        : const Color(0xffa2b0bc),
                  ),
                ),
                Text(
                  TranslationKeys.easy,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.black 
                        : const Color(0xfff0f0f0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildConfigurationsSection(BuildContext context, double screenWidth) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16.0),
        child: Row(
          children: [
            Text(
              TranslationKeys.configurations,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: (themeProvider.defaultTheme) 
                    ? Colors.black 
                    : const Color(0xfff0f0f0),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.only(left: 22, right: 22.0),
        child: targetPriceMultiplierRecommendedParameters(),
      ),
      const SizedBox(height: 10),
      buildTargetPriceMultiplierSection(context, screenWidth),
      const SizedBox(height: 15),
      buildTargetFieldAndSliderSection(context, screenWidth),
      const SizedBox(height: 15),
      buildInitialBuyQuantityFieldAndSliderSection(context, screenWidth),
      const SizedBox(height: 15),
      buildNumberOfStepsAboveFieldAndSliderSection(context, screenWidth),
      const SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.only(left: 22, right: 22.0),
        child: stepSizeRecommendedParameters(),
      ),
      const SizedBox(height: 10),
      buildStepSizeFieldAndSliderSection(context, screenWidth),
    ],
  );
}

  Widget buildTargetFieldAndSliderSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${TranslationKeys.target}",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.black
                        : const Color(0xfff0f0f0),
                  ),
              ),

              SizedBox(
                height: 30,
                width: screenWidth * 0.3,
                child: MyTextField(
                  labelText: "",
                  maxLength: 14,
                  elevation: 0,
                  maxLine: 1,
                  textInputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9,\.]+$'),
                    ),
                  ],
                  controller:
                  createLadderEasyProvider.targetTextEditingController,
                  keyboardType: TextInputType.number,
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xfff0f0f0),
                  ),
                  borderColor: Color(0xff2c2c31),
                  margin: EdgeInsets.zero,
                  contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                  focusedBorderColor: (createLadderEasyProvider.targetErrorText == "")
                      ?Color(0xff5cbbff):Color(0xffd41f1f),
                  showLeadingWidget: false  ,
                  showTrailingWidget: createLadderEasyProvider.enableTargetButton,

                  prefixText: _currencyConstantsProvider.currency,

                  counterText: "",
                  borderRadius: 8,
                  hintText: '',
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

                    createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
                    createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider
                        .stepSizeTextEditingController.text);
                  },
                  validator: (value) {
                    print("inside of validator");
                    if (value!.isNotEmpty && value != "") {
                      print("inside if of validator");
                      if (double.parse(value) <=
                          Utility().multiplyBy1Point2(
                              createLadderEasyProvider.tickerPrice)) {
                        print("insdie this0");
                        createLadderEasyProvider.targetErrorText =
                        "Target can not be less then 1.2 times of current price";
                        // return "Can't be less then 1.2 times of current price";
                      }
                    }
                    return null;
                  },
                  trailing: Icon(
                    Icons.check,
                    color: (createLadderEasyProvider.enableTargetButton)
                        ? Color(0xff00ff89)
                        : (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    size: 15,
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
                ),
              )
            ],
          ),
        ),

        (createLadderEasyProvider.targetErrorText == "")
            ? Container()
            : SizedBox(
              height: 12,
            ),


        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (createLadderEasyProvider.targetErrorText == "")
                  ? Container()
                  : Text(
                    createLadderEasyProvider.targetErrorText,
                    style: GoogleFonts.poppins(
                        color: Colors.red, //Color(0xffa8a8a8),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    )
              )
            ],
          ),
        ),

        SizedBox(
          height: 12,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            children: [
              Text(
                "Selected Value: ${double.tryParse(createLadderEasyProvider.targetTextEditingController.text)?.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
            height: 5
        ),
        
        buildTargetPriceSlider(context, screenWidth),

        SizedBox(
          height: 5,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_currencyConstantsProvider.currency}${((createLadderEasyProvider.tickerPrice * 1.2) + 1).toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme) 
                        ? Colors.black 
                        : const Color(0xfff0f0f0),
                ),
              ),

              Text(
                "${_currencyConstantsProvider.currency}${(createLadderEasyProvider.tickerPrice * 50).toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme) 
                        ? Colors.black 
                        : const Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildTargetPriceSlider(BuildContext context, double screenWidth) {

    print("below is target price");
    print(createLadderEasyProvider.tickerPrice);

    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
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
        max: (createLadderEasyProvider.tickerPrice == 0)?2:(createLadderEasyProvider.tickerPrice * 50),
        divisions: (createLadderEasyProvider.tickerPrice == 0)?1:(createLadderEasyProvider.tickerPrice * 50).toInt(),
        min: (createLadderEasyProvider.tickerPrice == 0)?1:((createLadderEasyProvider.tickerPrice * 1.2) + 1),
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

            createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
            createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider
                .stepSizeTextEditingController.text);
          });
        },
      ),
    );
  }

  Widget buildInitialBuyQuantityFieldAndSliderSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${TranslationKeys.initialBuyQuantity}",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.black
                        : const Color(0xfff0f0f0),
                ),
              ),

              SizedBox(
                height: 30,
                width: screenWidth * 0.3,
                child: MyTextField(
                  labelText: "",
                  maxLength: 14,
                  elevation: 0,
                  textInputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: createLadderEasyProvider
                      .initialBuyQuantityTextEditingController,
                  keyboardType: TextInputType.number,
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xfff0f0f0),
                  ),
                  borderColor: Color(0xff2c2c31),
                  margin: EdgeInsets.zero,
                  contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                  focusedBorderColor: (createLadderEasyProvider.initialBuyErrorText == "")
                      ?Color(0xff5cbbff):Color(0xffd41f1f),
                  showLeadingWidget: false  ,
                  showTrailingWidget: createLadderEasyProvider.enableInitialBuyQuantityButton,

                  prefixText: "",

                  counterText: "",
                  borderRadius: 8,
                  hintText: '',
                  onChanged: (value) {
                    createLadderEasyProvider.validateNumberOfStepsAbove();

                    createLadderEasyProvider.validateTargetValue(
                        createLadderEasyProvider
                            .targetTextEditingController.text);
                    createLadderEasyProvider.validateInitialBuyQuantityValue(
                        createLadderEasyProvider
                            .initialBuyQuantityTextEditingController.text);

                    createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
                    createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider
                        .stepSizeTextEditingController.text);
                  },
                  validator: (value) {
                    if (value!.isNotEmpty && value != "") {
                      if (int.parse(value) >
                          Utility().calculateInitialBuyQuantityMaxValue(
                            createLadderEasyProvider.targetValue,
                            createLadderEasyProvider.tickerPrice,
                            createLadderEasyProvider.priorCashAllocation,
                            createLadderEasyProvider.tickerPrice,
                          )) {
                        createLadderEasyProvider.initialBuyErrorText =
                        "Invalid Initial Buy Quantity";
                      }
                    }
                    return null;
                  },
                  trailing: Icon(
                    Icons.check,
                    color: (createLadderEasyProvider.enableTargetButton)
                        ? Color(0xff00ff89)
                        : (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    size: 15,
                  ),
                  trailingFunction: () {

                  },
                ),
              )
            ],
          ),
        ),

        (createLadderEasyProvider.initialBuyErrorText == "")
            ? Container()
            : SizedBox(
          height: 12,
        ),


        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (createLadderEasyProvider.initialBuyErrorText == "")
                  ? Container()
                  : Text(
                  createLadderEasyProvider.initialBuyErrorText,
                  style: GoogleFonts.poppins(
                    color: Colors.red, //Color(0xffa8a8a8),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  )
              )
            ],
          ),
        ),

        SizedBox(
          height: 12,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            children: [
              Text(
                "Selected Value: ${createLadderEasyProvider.initialBuyQuantityTextEditingController.text}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
            height: 5
        ),

        buildInitialBuyQuantitySlider(context, screenWidth),

        SizedBox(
          height: 5,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "20",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme) 
                        ? Colors.black 
                        : const Color(0xfff0f0f0),
                ),
              ),

              Text(
                "${Utility().calculateInitialBuyQuantityMaxValue(
                  createLadderEasyProvider.targetValue,
                  createLadderEasyProvider.tickerPrice,
                  createLadderEasyProvider.priorCashAllocation,
                  createLadderEasyProvider.tickerPrice,
                )}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme) 
                        ? Colors.black 
                        : const Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildInitialBuyQuantitySlider(BuildContext context, double screenWidth) {
    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
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

            createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
            createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider
                .stepSizeTextEditingController.text);
          });
        },
      ),
    );
  }

  Widget buildNumberOfStepsAboveFieldAndSliderSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${TranslationKeys.numberOfStepsAbove}",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: (themeProvider.defaultTheme) 
                        ? Colors.black
                        : const Color(0xfff0f0f0),
                ),
              ),

              SizedBox(
                height: 30,
                width: screenWidth * 0.3,
                child: MyTextField(
                  labelText: "",
                  maxLength: 14,
                  elevation: 0,
                  textInputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: createLadderEasyProvider
                      .numberOfStepsAboveTextEditingController,
                  keyboardType: TextInputType.number,
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xfff0f0f0),
                  ),
                  borderColor: Color(0xff2c2c31),
                  margin: EdgeInsets.zero,
                  contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                  focusedBorderColor: (createLadderEasyProvider.numberOfStepAboveErrorText == "")
                      ?Color(0xff5cbbff):Color(0xffd41f1f),
                  showLeadingWidget: false  ,
                  showTrailingWidget: createLadderEasyProvider.enableNumberOfStepsAboveButton,

                  prefixText: "",

                  counterText: "",
                  borderRadius: 8,
                  hintText: '',
                  onChanged: (value) {
                    createLadderEasyProvider.validateNumberOfStepsAbove();

                    createLadderEasyProvider.validateTargetValue(
                        createLadderEasyProvider
                            .targetTextEditingController.text);
                    createLadderEasyProvider.validateInitialBuyQuantityValue(
                        createLadderEasyProvider
                            .initialBuyQuantityTextEditingController.text);

                    createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
                    createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider
                        .stepSizeTextEditingController.text);
                  },
                  validator: (value) {

                    return null;
                  },
                  trailing: Icon(
                    Icons.check,
                    color: (createLadderEasyProvider.enableTargetButton)
                        ? Color(0xff00ff89)
                        : (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    size: 15,
                  ),
                  trailingFunction: () {

                  },
                ),
              )
            ],
          ),
        ),

        (createLadderEasyProvider.numberOfStepAboveErrorText == "")
            ? Container()
            : SizedBox(
          height: 12,
        ),


        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (createLadderEasyProvider.numberOfStepAboveErrorText == "")
                  ? Container()
                  : Text(
                  createLadderEasyProvider.numberOfStepAboveErrorText,
                  style: GoogleFonts.poppins(
                    color: Colors.red, //Color(0xffa8a8a8),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  )
              )
            ],
          ),
        ),

        SizedBox(
          height: 12,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            children: [
              Text(
                "Selected Value: ${createLadderEasyProvider.numberOfStepsAboveTextEditingController.text}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
            height: 5
        ),

        buildNumberOfStepsAboveSlider(context, screenWidth),

        SizedBox(
          height: 5,
        ),

        (createLadderEasyProvider.initialBuyQuantityValue != 0)
            ? Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "1",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme) 
                      ? Colors.black 
                      : const Color(0xfff0f0f0),
                ),
              ),

              Text(
                "${(createLadderEasyProvider.initialBuyQuantityValue != 0) ? createLadderEasyProvider.initialBuyQuantityValue : 100}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme) 
                      ? Colors.black 
                      : const Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        ):Container()
      ],
    );
  }

  Widget buildNumberOfStepsAboveSlider(BuildContext context, double screenWidth) {
    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
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

            createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
            createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider
                .stepSizeTextEditingController.text);
          });
        },
      ),
    );
  }

Widget buildCheckboxSection(BuildContext context, double screenWidth) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 25,
        height: 25,
        child: Checkbox(
          tristate: true,
          value: createLadderEasyProvider.updateCheckbox,
          activeColor: Colors.blue,
          onChanged: (bool? newValue) {
            createLadderEasyProvider.updateCheckbox = newValue ?? false;

            if (createLadderEasyProvider.updateCheckbox) {
              createLadderEasyProvider.calculateLadderParameter(context);
            }
          },
        ),
      ),
      const SizedBox(width: 5),
      Text(
        "${TranslationKeys.updateValueByClickingOnTheCheckbox}*",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: (themeProvider.defaultTheme) 
              ? Colors.black 
              : const Color(0xfff0f0f0),
        ),
      ),
    ],
  );
}

Widget buildBreakdownSection(BuildContext context, double screenWidth) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16.0),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              TranslationKeys.breakdown,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                                       color: (themeProvider.defaultTheme) 
                        ? Colors.grey.shade700 
                        : const Color(0xffa2b0bc),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildBreakdownRow(
          label: TranslationKeys.target,
          value: createLadderEasyProvider.targetValue == 0.0
              ? "0.0"
              : Utility.amountFormat(createLadderEasyProvider.targetValue),
        ),
        const SizedBox(height: 10),
        _buildBreakdownRow(
          label: TranslationKeys.initialBuyQuantity,
          value: createLadderEasyProvider.initialBuyQuantityValue.toString(),
        ),
        const SizedBox(height: 10),
        _buildBreakdownRow(
          label: TranslationKeys.initialBuyCash,
          value: createLadderEasyProvider.initialBuyCash == 0.0
              ? "0.0"
              : Utility.amountFormat(createLadderEasyProvider.initialBuyCash),
        ),
        const SizedBox(height: 10),
        _buildBreakdownRow(
          label: TranslationKeys.calculatedNumberOfStepsAbove,
          value: createLadderEasyProvider.numberOfStepsAboveValue.toStringAsFixed(2),
        ),
        const SizedBox(height: 10),
        _buildBreakdownRow(
          label: TranslationKeys.calculatedNumberOfStepsBelow,
          value: createLadderEasyProvider.numberOfStepsBelow.toStringAsFixed(2),
        ),
        const SizedBox(height: 10),
        _buildBreakdownRow(
          label: TranslationKeys.stepSize,
          value: createLadderEasyProvider.stepSizeValue.toStringAsFixed(2),
        ),
        const SizedBox(height: 10),
        _buildBreakdownRow(
          label: TranslationKeys.defaultBuySellQuantity,
          value: createLadderEasyProvider.buySellQuantityValue.toStringAsFixed(2),
        ),
        const SizedBox(height: 10),
        _buildBreakdownRow(
          label: TranslationKeys.cashNeeded,
          value: createLadderEasyProvider.cashNeeded == 0.0
              ? "0.0"
              : Utility.amountFormat(createLadderEasyProvider.cashNeeded),
        ),
        const SizedBox(height: 10),
        _buildBreakdownRow(
          label: TranslationKeys.finalCashAllocation,
          value: createLadderEasyProvider.finalCashAllocation == 0.0
              ? "0.0"
              : Utility.amountFormat(createLadderEasyProvider.finalCashAllocation),
        ),
      ],
    ),
  );
}

// Helper method to build each breakdown row
Widget _buildBreakdownRow({
  required String label,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, right: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
                       color: (themeProvider.defaultTheme) 
                        ? Colors.grey.shade700 
                        : const Color(0xffa2b0bc),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
                                   color: (themeProvider.defaultTheme) 
                        ? Colors.grey.shade700 
                        : const Color(0xffa2b0bc),
          ),
        ),
      ],
    ),
  );
}

  Widget buildCreateLadderButtonSection(BuildContext context, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff454545),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12), // Apply radius only to top-left
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 13.0),
              child: CustomContainer(
                padding: 0,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                borderRadius: 12,
                backgroundColor: (createLadderEasyProvider.updateCheckbox &&
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
                    ?Color(0xfff0f0f0):Color(0xffa8a8a8),
                onTap: () async {

                  if(createLadderEasyProvider.updateCheckbox &&
                      createLadderEasyProvider.targetErrorText == "" &&
                      createLadderEasyProvider.initialBuyErrorText == "" &&
                      createLadderEasyProvider.numberOfStepAboveErrorText == "" &&
                      createLadderEasyProvider.targetTextEditingController.text != "" &&
                      createLadderEasyProvider.initialBuyQuantityTextEditingController.text != "" &&
                      createLadderEasyProvider.numberOfStepsAboveTextEditingController.text != "") {

                    bool showBrokeragePopUp = await createLadderEasyProvider.checkforBrokerkerage();
                    if(showBrokeragePopUp) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return brokeragePopup("You have set you ladder parameters in such that you that brokerage is more then 40% of your extra cash!");
                        },
                      );
                    } else {
                      CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                        ReviewLadderDialogNew(
                          stockExchange: createLadderEasyProvider.tickerExchange,
                          stockName: createLadderEasyProvider.ticker,
                          tickerId:
                          int.tryParse(createLadderEasyProvider.tickerId) ??
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
                          cashNeeded: createLadderEasyProvider.cashNeeded,
                          isMarketOrder: true,
                          minimumPriceForUpdateLadder: 0.0,
                          setDefaultBuySellQty:
                          createLadderEasyProvider.buySellQuantityValue,
                          newLadder: true,
                          symSecurityCode:
                          int.tryParse(createLadderEasyProvider.tickerId) ??
                              0,
                          stepSize: createLadderEasyProvider.stepSizeValue,
                          numberOfStepsAbove:
                          createLadderEasyProvider.numberOfStepsAboveValue,
                          numberOfStepsBelow:
                          createLadderEasyProvider.numberOfStepsBelow,
                          initialBuyQty:
                          createLadderEasyProvider.initialBuyQuantityValue,
                          actualCashAllocated:
                          createLadderEasyProvider.finalCashAllocation,
                          actualInitialBuyCash:
                          createLadderEasyProvider.initialBuyCash,
                          ladTargetPriceMultiplier:
                          (createLadderEasyProvider.targetValue /
                              createLadderEasyProvider.initialBuyPrice),
                          // assignedCash: double.tryParse(stateProvider.ladderCreationParametersScreen1.clpInitialPurchasePrice.text.replaceAll(",", "")) ?? 0.0,
                          assignedCash: double.tryParse(stateProvider.cashAllocatedControllerList[stateProvider.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
                        ),
                        context,
                        height: 850,

                      ).then((dialogBoxResponse) async {
                        print("after close");
                        print(dialogBoxResponse);
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
                                height: 580 // + 80
                                // height: (stateProvider.priorBuyAvailable[stateProvider.ladderCreationScreen1[stateProvider.index].clpTicker] == true)?580:500
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
                      });
                    }



                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return ReviewLadderDialog(
                    //       stockName: createLadderEasyProvider.ticker,
                    //       tickerId:
                    //       int.tryParse(createLadderEasyProvider!.tickerId) ??
                    //           0,
                    //       initialyProvidedTargetPrice: (double.tryParse(
                    //           (createLadderEasyProvider
                    //               .targetTextEditingController.text)
                    //               .replaceAll(",", "")) ??
                    //           0.0),
                    //       initialPurchasePrice:
                    //       createLadderEasyProvider.initialBuyPrice.toString(),
                    //       currentStockPrice:
                    //       createLadderEasyProvider.initialBuyPrice.toString(),
                    //       allocatedCash: double.parse(createLadderEasyProvider
                    //           .priorCashAllocation
                    //           .toString()),
                    //       cashNeeded: createLadderEasyProvider!.cashNeeded,
                    //       isMarketOrder: true,
                    //       minimumPriceForUpdateLadder: 0.0,
                    //       setDefaultBuySellQty:
                    //       createLadderEasyProvider.buySellQuantityValue,
                    //       newLadder: true,
                    //       symSecurityCode:
                    //       int.tryParse(createLadderEasyProvider!.tickerId) ??
                    //           0,
                    //       stepSize: createLadderEasyProvider.stepSizeValue,
                    //       numberOfStepsAbove:
                    //       createLadderEasyProvider.numberOfStepsAboveValue,
                    //       numberOfStepsBelow:
                    //       createLadderEasyProvider.numberOfStepsBelow,
                    //       initialBuyQty:
                    //       createLadderEasyProvider.initialBuyQuantityValue,
                    //       actualCashAllocated:
                    //       createLadderEasyProvider!.finalCashAllocation,
                    //       actualInitialBuyCash:
                    //       createLadderEasyProvider.initialBuyCash,
                    //       ladTargetPriceMultiplier:
                    //       (createLadderEasyProvider.targetValue /
                    //           createLadderEasyProvider.initialBuyPrice),
                    //       // assignedCash: double.tryParse(stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0,
                    //       assignedCash: double.tryParse(stateProvider!.cashAllocatedControllerList[stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
                    //     );
                    //   },
                    // ).then((dialogBoxResponse) async {
                    //   if (dialogBoxResponse == "ladderCreated") {
                    //     if (createLadderEasyProvider
                    //         .ladderDetailsList.isNotEmpty) {
                    //       createLadderEasyProvider.ladderDetailsList.removeAt(0);
                    //     }
                    //
                    //     stateProvider.index = stateProvider.index + 1;
                    //     createLadderEasyProvider.refreshLadderValues();
                    //     print("here is the result 0");
                    //     if (createLadderEasyProvider
                    //         .ladderDetailsList.isNotEmpty) {
                    //       // Navigator.pop(context);
                    //       print("here is the result 1");
                    //       // Navigator.push(
                    //       //   context,
                    //       //   MaterialPageRoute(
                    //       //     builder: (context) => LadderCreationOptionScreen(
                    //       //       indexOfLadder: stateProvider.index,
                    //       //       message: "Choose your ladder creation option",
                    //       //       navigationProvider: navigationProvider,
                    //       //       createLadderEasyProvider:
                    //       //           createLadderEasyProvider,
                    //       //       value:
                    //       //           stateProvider, // Replace with the correct value object
                    //       //     ),
                    //       //   ),
                    //       // );
                    //
                    //       CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                    //           LadderCreationOptionScreenNew(
                    //             indexOfLadder: stateProvider.index,
                    //             message: "Choose your ladder creation option",
                    //             navigationProvider: navigationProvider,
                    //             createLadderEasyProvider:
                    //             createLadderEasyProvider,
                    //             value:
                    //             stateProvider, // Replace with the correct value object
                    //           ),
                    //           context,
                    //           height: 500
                    //       );
                    //     }
                    //
                    //     if (createLadderEasyProvider
                    //         .ladderDetailsList.isNotEmpty) {
                    //       createLadderEasyProvider.tickerId =
                    //           createLadderEasyProvider
                    //               .ladderDetailsList[0].ladTickerId!
                    //               .toString();
                    //       createLadderEasyProvider.ticker =
                    //       createLadderEasyProvider
                    //           .ladderDetailsList[0].ladTicker!;
                    //       createLadderEasyProvider.tickerPrice = double.parse(
                    //           createLadderEasyProvider
                    //               .ladderDetailsList[0].ladInitialBuyPrice!
                    //               .replaceAll(",", ""));
                    //       createLadderEasyProvider.initialBuyPrice = double.parse(
                    //           createLadderEasyProvider
                    //               .ladderDetailsList[0].ladInitialBuyPrice!
                    //               .replaceAll(",", ""));
                    //       createLadderEasyProvider.priorCashAllocation =
                    //           double.parse(createLadderEasyProvider
                    //               .ladderDetailsList[0].ladCashAllocated!
                    //               .replaceAll(",", ""));
                    //     } else {
                    //       print("here is the result 3");
                    //       tradeMainProvider.updateTabBarIndex = 0;
                    //       navigationProvider.selectedIndex = 1;
                    //     }
                    //   }
                    // }).catchError((err) {
                    //   print(err);
                    // });
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return warningMessageDialog(
                            "${TranslationKeys.selectCheckboxBelow}", context);
                      },
                    );
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
                  child: Text(
                      // TranslationKeys.createLadder,
                      TranslationKeys.showLadder,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: (createLadderEasyProvider.updateCheckbox &&
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
                            ?Color(0xff000000):Color(0xfff0f0f0),
                      )
                  ),
                ),
              ),
            )
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
                  "${TranslationKeys.warning}",
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

  Widget buildTargetPriceMultiplierSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${TranslationKeys.targetPriceMultiplier}",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                                        color: (themeProvider.defaultTheme) 
                        ? Colors.black
                        : const Color(0xfff0f0f0),
                ),
              ),

              SizedBox(
                height: 30,
                width: screenWidth * 0.3,
                child: MyTextField(
                  labelText: "",
                  maxLength: 14,
                  elevation: 0,
                  textInputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9,\.]+$'),
                    ),
                    // FilteringTextInputFormatter.digitsOnly
                  ],
                  controller:
                  createLadderEasyProvider.targetPriceMultiplierTextEditingController,
                  keyboardType: TextInputType.number,
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xfff0f0f0),
                  ),
                  borderColor: Color(0xff2c2c31),
                  margin: EdgeInsets.zero,
                  contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                  focusedBorderColor: (createLadderEasyProvider.targetPriceMultiplierErrorText == "")
                      ?Color(0xff5cbbff):Color(0xffd41f1f),
                  showLeadingWidget: false  ,
                  showTrailingWidget: createLadderEasyProvider.enableTargetPriceMultiplierButton,

                  prefixText: "", // _currencyConstantsProvider.currency,

                  counterText: "",
                  borderRadius: 8,
                  hintText: '',
                  onChanged: (value) {


                    createLadderEasyProvider.isRecommendedParametersEnabledTargetPriceMultiplier[createLadderEasyProvider.ticker] = false;
                    createLadderEasyProvider.validateTargetPriceMultiplierValue(value);
                    // createLadderEasyProvider.targetValue = createLadderEasyProvider.targetValue * double.parse(createLadderEasyProvider.targetPriceMultiplierTextEditingController.text);
                    // createLadderEasyProvider.targetValue = createLadderEasyProvider.targetValue * createLadderEasyProvider.targetPriceMultiplierValue;
                    createLadderEasyProvider.targetValue = createLadderEasyProvider.tickerPrice * createLadderEasyProvider.targetPriceMultiplierValue;
                    createLadderEasyProvider.targetTextEditingController.text = createLadderEasyProvider.targetValue.toStringAsFixed(2);

                    createLadderEasyProvider.validateNumberOfStepsAbove();

                    createLadderEasyProvider.validateTargetValue(
                        createLadderEasyProvider.targetTextEditingController.text);
                    createLadderEasyProvider.validateInitialBuyQuantityValue(
                        createLadderEasyProvider
                            .initialBuyQuantityTextEditingController.text);

                    createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
                    createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider.stepSizeTextEditingController.text);
                  },
                  validator: (value) {
                    // print("inside of validator");
                    // if (value!.isNotEmpty && value != "") {
                    //   print("inside if of validator");
                    //   if (double.parse(value) <=
                    //       Utility().multiplyBy1Point2(
                    //           createLadderEasyProvider.tickerPrice ?? 0.0)) {
                    //     print("insdie this0");
                    //     createLadderEasyProvider.targetErrorText =
                    //     "Target can not be less then 1.2 times of current price";
                    //     // return "Can't be less then 1.2 times of current price";
                    //   }
                    // }
                    return null;
                  },
                  trailing: Icon(
                    Icons.check,
                    color: (createLadderEasyProvider.enableTargetPriceMultiplierButton)
                        ? Color(0xff00ff89)
                        : (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    size: 15,
                  ),
                  trailingFunction: () {
                    if (createLadderEasyProvider
                        .targetPriceMultiplierTextEditingController.text !=
                        "") {
                      createLadderEasyProvider.targetPriceMultiplierValue = double.parse(
                          createLadderEasyProvider
                              .targetTextEditingController.text);
                    }
                  },
                ),
              )
            ],
          ),
        ),

        (createLadderEasyProvider.targetPriceMultiplierErrorText == "")
            ? Container()
            : SizedBox(
          height: 12,
        ),


        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (createLadderEasyProvider.targetPriceMultiplierErrorText == "")
                  ? Container()
                  : Text(
                  createLadderEasyProvider.targetPriceMultiplierErrorText,
                  style: GoogleFonts.poppins(
                    color: Colors.red, //Color(0xffa8a8a8),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  )
              )
            ],
          ),
        ),

        SizedBox(
          height: 12,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            children: [
              Text(
                "Selected Value: ${createLadderEasyProvider.targetPriceMultiplierTextEditingController.text}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
            height: 5
        ),

        buildTargetPriceMultiplierSlider(context, screenWidth),

        SizedBox(
          height: 5,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "1.2",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme) 
                        ? Colors.black 
                        : const Color(0xfff0f0f0),
                ),
              ),

              Text(
                "50",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildTargetPriceMultiplierSlider(BuildContext context, double screenWidth) {
    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
        value: (createLadderEasyProvider.targetPriceMultiplierTextEditingController.text == "")
            ? 2
            : (double.parse(
            createLadderEasyProvider.targetPriceMultiplierTextEditingController.text) >
            50)
            ? 50
            : (double.parse(createLadderEasyProvider
            .targetPriceMultiplierTextEditingController.text) <
            2)
            ? 2
            : double.parse(
            createLadderEasyProvider.targetPriceMultiplierTextEditingController.text),
        max: 50,
        divisions: 50 - 2,
        min: 2,
        label: createLadderEasyProvider.targetPriceMultiplierTextEditingController.text,
        onChanged: (double value) {

          createLadderEasyProvider.targetPriceMultiplierTextEditingController.text = value.toString();

          createLadderEasyProvider.isRecommendedParametersEnabledTargetPriceMultiplier[createLadderEasyProvider.ticker] = false;
          createLadderEasyProvider.validateTargetPriceMultiplierValue(value.toString());
          // createLadderEasyProvider.targetValue = createLadderEasyProvider.targetValue * double.parse(createLadderEasyProvider.targetPriceMultiplierTextEditingController.text);
          // createLadderEasyProvider.targetValue = createLadderEasyProvider.targetValue * createLadderEasyProvider.targetPriceMultiplierValue;
          createLadderEasyProvider.targetValue = createLadderEasyProvider.tickerPrice * createLadderEasyProvider.targetPriceMultiplierValue;
          createLadderEasyProvider.targetTextEditingController.text = createLadderEasyProvider.targetValue.toString();

          createLadderEasyProvider.validateNumberOfStepsAbove();

          createLadderEasyProvider.validateTargetValue(
              createLadderEasyProvider.targetTextEditingController.text);
          createLadderEasyProvider.validateInitialBuyQuantityValue(
              createLadderEasyProvider
                  .initialBuyQuantityTextEditingController.text);
          createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
          createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider.stepSizeTextEditingController.text);
          setState((){

          });
        },
      ),
    );
  }

  Widget buildStepSizeFieldAndSliderSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${TranslationKeys.stepSize}",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Color(0xffa2b0bc)
                ),
              ),

              SizedBox(
                height: 30,
                width: screenWidth * 0.3,
                child: MyTextField(
                  labelText: "",
                  maxLength: 14,
                  elevation: 0,
                  textInputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller:
                  createLadderEasyProvider.stepSizeTextEditingController,
                  keyboardType: TextInputType.number,
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xfff0f0f0),
                  ),
                  borderColor: Color(0xff2c2c31),
                  margin: EdgeInsets.zero,
                  contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                  focusedBorderColor: (createLadderEasyProvider.targetErrorText == "")
                      ?Color(0xff5cbbff):Color(0xffd41f1f),
                  showLeadingWidget: false  ,
                  showTrailingWidget: createLadderEasyProvider.enableTargetButton,

                  // prefixText: _currencyConstantsProvider.currency,
                  prefixText: "",

                  counterText: "",
                  borderRadius: 8,
                  hintText: '',
                  onChanged: (value) {

                    createLadderEasyProvider.validateNumberOfStepsAbove();

                    createLadderEasyProvider.validateTargetValue(
                        createLadderEasyProvider.targetTextEditingController.text);
                    createLadderEasyProvider.validateInitialBuyQuantityValue(
                        createLadderEasyProvider
                            .initialBuyQuantityTextEditingController.text);

                    createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
                    createLadderEasyProvider.validateStepSizeValue(value);
                  },
                  validator: (value) {

                    return null;
                  },
                  trailing: Icon(
                    Icons.check,
                    color: (createLadderEasyProvider.enableStepSizeButton)
                        ? Color(0xff00ff89)
                        : (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    size: 15,
                  ),
                  trailingFunction: () {
                    if (createLadderEasyProvider
                        .stepSizeTextEditingController.text !=
                        "") {
                      createLadderEasyProvider.stepSizeValue = double.parse(
                          createLadderEasyProvider
                              .stepSizeTextEditingController.text);
                    }
                  },
                ),
              )
            ],
          ),
        ),

        (createLadderEasyProvider.stepSizeErrorText == "")
            ? Container()
            : SizedBox(
          height: 12,
        ),


        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (createLadderEasyProvider.stepSizeErrorText == "")
                  ? Container()
                  : Text(
                  createLadderEasyProvider.stepSizeErrorText,
                  style: GoogleFonts.poppins(
                    color: Colors.red, //Color(0xffa8a8a8),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  )
              )
            ],
          ),
        ),

        SizedBox(
          height: 12,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            children: [
              Text(
                "Selected Value: ${createLadderEasyProvider.stepSizeTextEditingController.text}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
            height: 5
        ),

        buildStepSizeSlider(context, screenWidth),

        SizedBox(
          height: 5,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(((double.tryParse(createLadderEasyProvider.targetTextEditingController.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(createLadderEasyProvider.initialBuyPrice.toString().replaceAll(",", "")) ?? 0.0)) / (double.tryParse(createLadderEasyProvider.initialBuyQuantityTextEditingController.text.replaceAll(",", "")) ?? 0.0)).toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme) 
                        ? Colors.black 
                        : const Color(0xfff0f0f0),
                ),
              ),

              Text(
                "${((double.tryParse(createLadderEasyProvider.targetTextEditingController.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(createLadderEasyProvider.initialBuyPrice.toString().replaceAll(",", "")) ?? 0.0)).toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildStepSizeSlider(BuildContext context, double screenWidth) {

    double min = double.parse(
        (((double.tryParse(createLadderEasyProvider.targetTextEditingController.text.replaceAll(",", "")) ??
            0.0) -
            (double.tryParse(createLadderEasyProvider
                .initialBuyPrice
                .toString()
                .replaceAll(",", "")) ??
                0.0)) /
            (double.tryParse(createLadderEasyProvider
                .initialBuyQuantityTextEditingController.text
                .replaceAll(",", "")) ??
                0.0))
            .toStringAsFixed(2));
    double max = double.parse(((double.tryParse(createLadderEasyProvider
        .targetTextEditingController.text
        .replaceAll(",", "")) ??
        0.0) -
        (double.tryParse(createLadderEasyProvider
            .initialBuyPrice.toString()
            .replaceAll(",", "")) ??
            0.0))
        .toStringAsFixed(2));
    double stepsAbove = (createLadderEasyProvider.stepSizeTextEditingController.text == "")
        ? min
        : double.parse(
        createLadderEasyProvider.stepSizeTextEditingController.text.replaceAll(",", ""));
    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
        value: (createLadderEasyProvider.stepSizeTextEditingController.text == "")
            ? min
            : (stepsAbove > max)
            ? max
            : (stepsAbove < min)
            ? min
            : stepsAbove,
        max: max <= 1 ? 2 : max,
        divisions: ((max - min) <= 0) ? 1 : int.tryParse((max - min).toStringAsFixed(0)),
        min: min,
        label: createLadderEasyProvider.stepSizeTextEditingController.text,
        onChanged: (double value) {
          setState(() {
            createLadderEasyProvider.stepSizeValue = value.floorToDouble();
            createLadderEasyProvider.stepSizeTextEditingController.text =
                value.toStringAsFixed(0);

            createLadderEasyProvider.validateNumberOfStepsAbove();

            createLadderEasyProvider.validateTargetValue(
                createLadderEasyProvider.targetTextEditingController.text);
            createLadderEasyProvider.validateInitialBuyQuantityValue(
                createLadderEasyProvider
                    .initialBuyQuantityTextEditingController.text);

            createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
            createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider
                .stepSizeTextEditingController.text);
          });
        },
      ),
    );
  }

  Widget targetPriceMultiplierRecommendedParameters() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate.containsKey(createLadderEasyProvider.ticker) == false)
                ?"Recommended Parameters (Not Available)"
                :"Recommended Parameters",
            // TranslationKeys.recommended,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: (themeProvider.defaultTheme) 
                    ? Colors.black 
                    : const Color(0xfff0f0f0),
            ),
          ),
          Switch(
            value: createLadderEasyProvider.isRecommendedParametersEnabledTargetPriceMultiplier[createLadderEasyProvider.ticker] ?? false,
            // _stateProvider!.recommendedParametersNotAvailable ?
            // false
            // : _stateProvider!.isRecommendedParametersEnabledScreen1,
            onChanged: (bool value) {
              // Fluttertoast.showToast(msg: "Feature Locked");
              print(createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate[createLadderEasyProvider.ticker]);
              if (createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate.containsKey(createLadderEasyProvider.ticker) == false) {
                print("hello in the onChanged of the switch 1");
                Fluttertoast.showToast(
                    msg: "No Recommended Parameters available");
              } else {
                print("is recommended stock else part");
                print(value);
                createLadderEasyProvider.isRecommendedParametersEnabledTargetPriceMultiplier[createLadderEasyProvider.ticker] = value;
                print("after changing value");

                String targetPriceMultiplier = "1.3";
                if(value) {
                  targetPriceMultiplier = createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate[createLadderEasyProvider.ticker]?.targetPriceMultipler ?? "1.2";
                }

                createLadderEasyProvider.targetPriceMultiplierTextEditingController.text = targetPriceMultiplier;

                createLadderEasyProvider.validateTargetPriceMultiplierValue(targetPriceMultiplier);
                // createLadderEasyProvider.targetValue = createLadderEasyProvider.targetValue * double.parse(createLadderEasyProvider.targetPriceMultiplierTextEditingController.text);
                // createLadderEasyProvider.targetValue = createLadderEasyProvider.targetValue * createLadderEasyProvider.targetPriceMultiplierValue;
                createLadderEasyProvider.targetValue = createLadderEasyProvider.tickerPrice * createLadderEasyProvider.targetPriceMultiplierValue;
                createLadderEasyProvider.targetTextEditingController.text = createLadderEasyProvider.targetValue.toStringAsFixed(2);

                createLadderEasyProvider.validateNumberOfStepsAbove();

                createLadderEasyProvider.validateTargetValue(
                    createLadderEasyProvider.targetTextEditingController.text);
                createLadderEasyProvider.validateInitialBuyQuantityValue(
                    createLadderEasyProvider
                        .initialBuyQuantityTextEditingController.text);
                createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider.stepSizeTextEditingController.text);
                setState(() {

                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget stepSizeRecommendedParameters() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate.containsKey(createLadderEasyProvider.ticker) == false)
                ?"Recommended Parameters (Not Available)"
                :"Recommended Parameters",
            // TranslationKeys.recommended,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: (themeProvider.defaultTheme) 
                    ? Colors.black 
                    : const Color(0xfff0f0f0),
            ),
          ),
          Switch(
            value: createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] ?? false,
            // _stateProvider!.recommendedParametersNotAvailable ?
            // false
            // : _stateProvider!.isRecommendedParametersEnabledScreen1,
            onChanged: (bool value) {
              // Fluttertoast.showToast(msg: "Feature Locked");
              print(createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate[createLadderEasyProvider.ticker]);
              if (createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate.containsKey(createLadderEasyProvider.ticker) == false) {
                print("hello in the onChanged of the switch 1");
                Fluttertoast.showToast(
                    msg: "No Recommended Parameters available");
              } else {
                print("is recommended stock else part");
                print(value);
                createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = value;
                print("after changing value");

                // double stepSize = ((createLadderEasyProvider.targetValue - createLadderEasyProvider.initialBuyPrice) / createLadderEasyProvider.numberOfStepsAboveValue);
                // print("here is the stepsize $stepSize");
                // stepSize = (stepSize * 100).floorToDouble() / 100;


                // if(value) {
                //   stepSize = (createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate[createLadderEasyProvider.ticker]?.stepsSize ?? 20).toDouble();
                //   createLadderEasyProvider.stepSizeTextEditingController.text = stepSize.toString();
                //   createLadderEasyProvider.stepSizeValue = stepSize;
                //
                // } else {
                //   createLadderEasyProvider.stepSizeTextEditingController.text = stepSize.toString();
                //   createLadderEasyProvider.stepSizeValue = stepSize;
                // }
                //
                // createLadderEasyProvider.validateNumberOfStepsAbove();
                //
                // createLadderEasyProvider.validateTargetValue(
                //     createLadderEasyProvider.targetTextEditingController.text);
                // createLadderEasyProvider.validateInitialBuyQuantityValue(
                //     createLadderEasyProvider
                //         .initialBuyQuantityTextEditingController.text);
                //
                // createLadderEasyProvider.validateStepSizeValue(stepSize.toString());


                if(value) {
                  double stepAbove = (createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate[createLadderEasyProvider.ticker]?.stepsAbove ?? 20).toDouble();
                  createLadderEasyProvider.numberOfStepsAboveTextEditingController.text = stepAbove.toString();
                  createLadderEasyProvider.numberOfStepsAboveValue = stepAbove;

                } else {
                  // createLadderEasyProvider.stepSizeTextEditingController.text = stepSize.toString();
                  // createLadderEasyProvider.stepSizeValue = stepSize;
                }

                createLadderEasyProvider.validateNumberOfStepsAbove();

                createLadderEasyProvider.validateTargetValue(
                    createLadderEasyProvider
                        .targetTextEditingController.text);
                createLadderEasyProvider.validateInitialBuyQuantityValue(
                    createLadderEasyProvider
                        .initialBuyQuantityTextEditingController.text);

                createLadderEasyProvider.isRecommendedParametersEnabledStepSize[createLadderEasyProvider.ticker] = false;
                createLadderEasyProvider.validateStepSizeValue(createLadderEasyProvider
                    .stepSizeTextEditingController.text);
                setState(() {

                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget brokeragePopup(String msg) {
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
              color: (themeProvider.defaultTheme)
                  ?Color(0XFFF5F5F5)
                  :Colors.black,
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: (themeProvider.defaultTheme)
                    ?Colors.black
                    :Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                  style: TextStyle(
                    color: (themeProvider.defaultTheme)
                        ?Colors.black
                        :Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        // createLadderRequest();
                      },
                      child: Text(
                        "Change Parameter",
                        style: TextStyle(
                          color: Colors.blue,
                          // color: (themeProvider.defaultTheme)
                          //     ?Colors.black
                          //     :Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        navigationProvider.previousSelectedIndex = 3;
                        navigationProvider.selectedIndex = 4;
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
}

