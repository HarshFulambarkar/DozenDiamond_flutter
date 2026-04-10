import 'dart:developer';
import 'dart:io';

import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/terms_info_contant.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/ladder_creation_parameter_values.dart';
import 'package:dozen_diamond/create_ladder_detailed/services/rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/create_ladder_easy/stateManagement/create_ladder_easy_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/helper.dart';
import 'package:dozen_diamond/global/services/num_formatting.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../create_ladder/screens/show_ladder_creation_option_dialog_new.dart';
import '../../global/stateManagement/progress_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/progress_bar.dart';
import '../../kyc/widgets/custom_bottom_sheets.dart';
import '../../localization/translation_keys.dart';

class CreateLadder2New extends StatefulWidget {
  const CreateLadder2New({super.key});

  @override
  State<CreateLadder2New> createState() => _CreateLadder2NewState();
}

class _CreateLadder2NewState extends State<CreateLadder2New> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CreateLadderProvider? _stateProvider;

  late NavigationProvider _navigationProvider;
  late CreateLadderEasyProvider createLadderEasyProvider;
  late CurrencyConstants currencyConstantsProvider;
  RestApiService restApiService = RestApiService();
  TermsInfoConstant termsInfoConstant = TermsInfoConstant();
  bool properPricingCheck = false;
  String warningMessage = "";
  Data? ladderCreationParametersValues;
  bool minimumPriceCheck = true;
  bool targetPriceCheck = true;
  bool _isBtnClicked = false;
  Color valueFieldColor = Color.fromARGB(255, 21, 24, 31);
  Color textOfValueFieldColor = Colors.white;
  late ProgressProvider progressProvider;

  late ThemeProvider themeProvider;
  late TradeMainProvider tradeMainProvider;

  bool showFormula = false;

  final GlobalKey<TooltipState> initialBuyPriceTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> minimumPriceTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> currentPriceKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> targetPriceMultiplierTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> targetPriceTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> cashAssignedTooltipKey = GlobalKey<TooltipState>();

  void initState() {
    super.initState();
    _stateProvider = Provider.of(context, listen: false);
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    // _stateProvider!.assignValueInRecommendedParameters();
    // _stateProvider!.listenLtpOfStock(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {

      progressProvider = Provider.of(context, listen: false);
      progressProvider.updateProgress(0.4);

      print("below is getUserStockAndLadder");
      print(_stateProvider!.recommendedParametersNotAvailable);
      print(_stateProvider!.recommendedParametersNotAvailable[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]);

      // _stateProvider!.updateRecommendedParameter();

      // calculateMinAndMaxStepSizeAndMinK();

      calculateTargetPrice();

    });
  }
  
  calculateTargetPrice() {

    _stateProvider!.calculateMinimumK(double.tryParse(_stateProvider!.cashAllocatedControllerList[_stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0);

    _stateProvider!.ladderCreationParametersScreen1.targetPriceMultiplier[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text = _stateProvider!.minK.toStringAsFixed(2);
    _stateProvider!.updateTargetPriceMultiplier(
      _stateProvider!.ladderCreationParametersScreen1
          .targetPriceMultiplier[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
      _stateProvider!.ladderCreationParametersScreen1
          .targetPriceMultiplier[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text.length,
    );

    calculateMinAndMaxStepSizeAndMinK();
  }

  calculateMinAndMaxStepSizeAndMinK() async {

    // _stateProvider!.calculateMinimumK(double.tryParse(_stateProvider!.cashAllocatedControllerList[_stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0);

    await _stateProvider!.calculateMinStepSize(
      currentPrice: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
      capital: double.tryParse(_stateProvider!.cashAllocatedControllerList[_stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
      targetPrice: _stateProvider!.targetPrice,
    );

    await _stateProvider!.calculateMaxStepSize(
      currentPrice: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
      capital: double.tryParse(_stateProvider!.cashAllocatedControllerList[_stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
      targetPrice: _stateProvider!.targetPrice,
    );

    await _stateProvider!.calculateMaxStepAbove(
      currentPrice: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
      targetPrice: _stateProvider!.targetPrice,
      minStepSize: _stateProvider!.minStepSize,
    );

    await _stateProvider!.calculateMinStepAbove(
      currentPrice: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
      targetPrice: _stateProvider!.targetPrice,
      maxStepSize: _stateProvider!.maxStepSize,
    );
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  Widget recommendedParameters() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (_stateProvider!.recommendedParametersNotAvailable[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] ?? true)
                ?"Recommended Parameters (Not Available)"
                :"Recommended Parameters",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: _stateProvider!.isRecommendedParametersEnabledScreen1[_stateProvider!.ladderCreationParametersScreen1.clpTicker] ?? false,
            // _stateProvider!.recommendedParametersNotAvailable ?
            // false
            // : _stateProvider!.isRecommendedParametersEnabledScreen1,
            onChanged: (bool value) async {
              // Fluttertoast.showToast(msg: "Feature Locked");
              print(_stateProvider!.recommendedParametersNotAvailable[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]);
              if (_stateProvider!.recommendedParametersNotAvailable[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] ?? true) {
                print("hello in the onChanged of the switch 1");
                Fluttertoast.showToast(
                  timeInSecForIosWeb: 3,
                    msg: "No Recommended Parameters available");
              } else {
                print("is recommended stock else part");
                print(value);
                print(_stateProvider!.isRecommendedParametersEnabledScreen1);
                _stateProvider!.isRecommendedParametersEnabledScreen1[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = value;
                await _stateProvider!.updateRecommendedParameter();
                print("after changing value");
                print(_stateProvider!.isRecommendedParametersEnabledScreen1);

                calculateMinAndMaxStepSizeAndMinK();
                setState(() {

                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    progressProvider = Provider.of<ProgressProvider>(context, listen: true);
    currencyConstantsProvider = Provider.of(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _stateProvider = Provider.of<CreateLadderProvider>(context, listen: true);
    createLadderEasyProvider =
        Provider.of<CreateLadderEasyProvider>(context, listen: true);
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);

    return PopScope(
      onPopInvokedWithResult: ((value, result) async {

        if(_stateProvider!.selectedMode == "Prior Buy") {

          // _navigationProvider.selectedIndex = 27;

          await _stateProvider!.changeCashAllocated();

          CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
              LadderCreationOptionScreenNew(
                indexOfLadder: _stateProvider!.index,
                message: "Choose your ladder creation option",
                navigationProvider: _navigationProvider,
                createLadderEasyProvider: createLadderEasyProvider,
                value: _stateProvider, // Replace with the correct value object
              ),
              context,
              height: 580 // + 80
              // height: (_stateProvider!.priorBuyAvailable[_stateProvider!.ladderCreationScreen1[_stateProvider!.index].clpTicker] == true)?580:500
          );

          _navigationProvider.selectedIndex = 4;

        } else {

          await _stateProvider!.changeCashAllocated();

          CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
              LadderCreationOptionScreenNew(
                indexOfLadder: _stateProvider!.index,
                message: "Choose your ladder creation option",
                navigationProvider: _navigationProvider,
                createLadderEasyProvider: createLadderEasyProvider,
                value: _stateProvider, // Replace with the correct value object
              ),
              context,
              height: 580 // + 80
              // height: (_stateProvider!.priorBuyAvailable[_stateProvider!.ladderCreationScreen1[_stateProvider!.index].clpTicker] == true)?580:500
          );

          _navigationProvider.selectedIndex = 4;

        }


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
                    // drawer: const NavigationDrawerWidget(),
                    drawer: NavDrawerNew(),
                    key: _key,
                    backgroundColor: (themeProvider.defaultTheme)
                        ? Color(0XFFF0F0F0)
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
                                height: 15,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16.0),
                                child: ProgressBar(),
                              ),

                              SizedBox(height: 10),

                              buildBackButtonSection(context, screenWidth),

                              SizedBox(
                                height: 10,
                              ),

                              buildTopInitialBuyPriceAndMinimumPriceCard(context, screenWidth),

                              SizedBox(
                                height: 10,
                              ),

                              buildConfigurationSection(context, screenWidth),

                              SizedBox(
                                height: 10,
                              ),

                              targetPriceWarningUi(screenWidth),


                            ],
                          ),
                        ),

                        CustomHomeAppBarWithProviderNew(
                            backButton: false, leadingAction: _triggerDrawer),
                      ],
                    ),
                      bottomNavigationBar: buildCreateLadderStep2ButtonSection(context, screenWidth)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBackButtonSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {

                  if(_stateProvider!.selectedMode == "Prior Buy") {

                    // _navigationProvider.selectedIndex = 27;

                    await _stateProvider!.changeCashAllocated();

                    CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                        LadderCreationOptionScreenNew(
                          indexOfLadder: _stateProvider!.index,
                          message: "Choose your ladder creation option",
                          navigationProvider: _navigationProvider,
                          createLadderEasyProvider: createLadderEasyProvider,
                          value: _stateProvider, // Replace with the correct value object
                        ),
                        context,
                        height: 580 // + 80
                        // height: (_stateProvider!.priorBuyAvailable[_stateProvider!.ladderCreationScreen1[_stateProvider!.index].clpTicker] == true)?580:500
                    );

                    _navigationProvider.selectedIndex = 4;

                  } else {

                    await _stateProvider!.changeCashAllocated();

                    CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                        LadderCreationOptionScreenNew(
                          indexOfLadder: _stateProvider!.index,
                          message: "Choose your ladder creation option",
                          navigationProvider: _navigationProvider,
                          createLadderEasyProvider: createLadderEasyProvider,
                          value: _stateProvider, // Replace with the correct value object
                        ),
                        context,
                        height: 580 // + 80
                        // height: (_stateProvider!.priorBuyAvailable[_stateProvider!.ladderCreationScreen1[_stateProvider!.index].clpTicker] == true)?580:500
                    );

                    _navigationProvider.selectedIndex = 4;

                  }



                },
                child: Icon(
                  Icons.arrow_back,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  size: 24,
                ),
              ),

              SizedBox(
                width: 8,
              ),

              SizedBox(
                width: screenWidth * 0.5,
                child: Text(
                  "Select target price (${_stateProvider!.ladderCreationParametersScreen1.clpTicker} (${_stateProvider!.ladderCreationParametersScreen1.clpExchange}))",
                  style: TextStyle(
                    fontFamily: "Britannica",
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
              )
            ],
          ),

          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              setState(() {
                showFormula = !showFormula;
              });
            },
            child: Row(
              children: [

                (showFormula)?CustomContainer(
                  onTap: () {
                    setState(() {
                      showFormula = !showFormula;
                    });
                  },
                  borderRadius: 50,
                  borderColor: Color(0xff1a94f2),
                  padding: 0,
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  borderWidth: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: Color(0xff1a94f2),
                    ),
                  ),
                ):CustomContainer(
                  onTap: () {
                    setState(() {
                      showFormula = !showFormula;
                    });
                  },
                  borderRadius: 50,
                  borderColor: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0), // Color(0xff1a94f2),
                  padding: 0,
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  borderWidth: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.transparent, // Color(0xff1a94f2),
                    ),
                  ),
                ),

                SizedBox(
                  width: 5,
                ),

                Text(
                  TranslationKeys.viewFormulas,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTopInitialBuyPriceAndMinimumPriceCard(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: CustomContainer(
        borderColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):Color(0xff2c2c31),
        borderRadius: 10,
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6.0),
          child: CustomContainer(
            backgroundColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
            borderRadius: 10,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6, right: 10, left: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Text(
                            TranslationKeys.initialBuyPrice,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                            ),
                          ),

                          SizedBox(
                            width: 3,
                          ),

                          InkWell(
                            onTap: () {
                              initialBuyPriceTooltipKey.currentState?.ensureTooltipVisible();
                            },
                            child: Tooltip(
                              key: initialBuyPriceTooltipKey,
                              message: TranslationKeys.thePriceAtWhichTheStocksAreBoughtTheyAreSetToBeAsTheCurrentMarketPriceByDefault,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              preferBelow: false,
                              child: Icon(
                                Icons.info_outline,
                                size: 15,
                                color: (themeProvider.defaultTheme)?Color(0xff6e6e6e):Color(0xffa2b0bc),
                              ),
                            ),
                          )
                        ],
                      ),


                      // IgnorePointer(
                      //   child:
                        SizedBox(
                          height: 30,
                          width: screenWidth * 0.3,
                          child: IgnorePointer(
                            ignoring: (tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash),
                            child: MyTextField(
                              // controller: TextEditingController(text: "${currencyConstantsProvider.currency}${_stateProvider!.initialBuyPrice}"),
                              controller: _stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!,
                              labelText: "",
                              isEnabled: true,
                              maxLength: 14,
                              elevation: 0,
                              textInputFormatters: <TextInputFormatter>[
                                // FilteringTextInputFormatter.allow(
                                //   RegExp(r'^[0-9,\.]+$'),
                                // ),
                                // NumberToCurrencyFormatter()

                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$'),
                                ),
                                NumberToCurrencyFormatter(),
                              ],
                              keyboardType: TextInputType.number,
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                              ),
                              borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                              fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                              isFilled: true,
                              margin: EdgeInsets.zero,
                              contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                              focusedBorderColor: Color(0xff5cbbff),
                              showLeadingWidget: false,
                              showTrailingWidget: false,
                              // prefixText: currencyConstantsProvider.currency,

                              counterText: "",
                              borderRadius: 8,
                              hintText: '',
                              onChanged: (value) {

                                if (value.isEmpty || value == '.') {
                                  _stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text = '1';
                                  _stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.selection = TextSelection.fromPosition(
                                    TextPosition(offset: _stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.length),
                                  );
                                }

                                _stateProvider!.updateTargetPriceMultiplier(
                                  _stateProvider!.ladderCreationParametersScreen1
                                      .targetPriceMultiplier[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
                                  _stateProvider!.ladderCreationParametersScreen1
                                      .targetPriceMultiplier[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text.length,
                                );
                              },
                              onFieldSubmitted: (value) {

                              },
                            ),
                          ),
                        ),
                      // )

                    ],
                  ),

                  // SizedBox(
                  //   height: 5,
                  // ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //
                  //     Row(
                  //       children: [
                  //         Text(
                  //           TranslationKeys.currentPrice,
                  //           style: GoogleFonts.poppins(
                  //             fontWeight: FontWeight.w300,
                  //             fontSize: 14,
                  //             color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                  //           ),
                  //         ),
                  //
                  //         SizedBox(
                  //           width: 3,
                  //         ),
                  //
                  //         InkWell(
                  //           onTap: () {
                  //             currentPriceKey.currentState?.ensureTooltipVisible();
                  //           },
                  //           child: Tooltip(
                  //             key: currentPriceKey,
                  //             message: TranslationKeys.stockCurrentPrice,
                  //             margin: EdgeInsets.only(left: 20, right: 20),
                  //             preferBelow: false,
                  //             child: Icon(
                  //               Icons.info_outline,
                  //               size: 15,
                  //               color: (themeProvider.defaultTheme)?Color(0xff6e6e6e):Color(0xffa2b0bc),
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //
                  //
                  //     IgnorePointer(
                  //       child: SizedBox(
                  //         height: 30,
                  //         width: screenWidth * 0.3,
                  //         child: MyTextField(
                  //           controller: TextEditingController(text: "${currencyConstantsProvider.currency}${_stateProvider!.ladderCreationParametersScreen1.currentPrice}"),
                  //           labelText : "",
                  //           isEnabled: true,
                  //           maxLength: 14,
                  //           elevation: 0,
                  //           textInputFormatters: <TextInputFormatter>[
                  //             FilteringTextInputFormatter.allow(
                  //               RegExp(r'^[0-9,\.]+$'),
                  //             ),
                  //             NumberToCurrencyFormatter()
                  //           ],
                  //           keyboardType: TextInputType.number,
                  //           textStyle: GoogleFonts.poppins(
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: 14,
                  //             color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  //           ),
                  //           // borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                  //           // fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                  //           borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                  //           fillColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                  //           isFilled: true,
                  //           margin: EdgeInsets.zero,
                  //           contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                  //           focusedBorderColor: Color(0xff5cbbff),
                  //           showLeadingWidget: false  ,
                  //           showTrailingWidget: false,
                  //           // prefixText: currencyConstantsProvider.currency,
                  //
                  //           counterText: "",
                  //           borderRadius: 8,
                  //           hintText: '',
                  //           onChanged: (value) {
                  //
                  //           },
                  //           onFieldSubmitted: (value) {
                  //
                  //           },
                  //         ),
                  //       ),
                  //     )
                  //
                  //   ],
                  // ),

                  // SizedBox(
                  //   height: 5,
                  // ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //
                  //     Row(
                  //       children: [
                  //         Text(
                  //           TranslationKeys.minimumPrice,
                  //           style: GoogleFonts.poppins(
                  //             fontWeight: FontWeight.w300,
                  //             fontSize: 14,
                  //             color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                  //           ),
                  //         ),
                  //
                  //         SizedBox(
                  //           width: 3,
                  //         ),
                  //
                  //         InkWell(
                  //           onTap: () {
                  //             minimumPriceTooltipKey.currentState?.ensureTooltipVisible();
                  //           },
                  //           child: Tooltip(
                  //             key: minimumPriceTooltipKey,
                  //             message: TranslationKeys.itIsTheLowestPriceAtWhichAStockCanBeBoughtInTheLadder,
                  //             margin: EdgeInsets.only(left: 20, right: 20),
                  //             preferBelow: false,
                  //             child: Icon(
                  //               Icons.info_outline,
                  //               size: 15,
                  //               color: (themeProvider.defaultTheme)?Color(0xff6e6e6e):Color(0xffa2b0bc),
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //
                  //
                  //     IgnorePointer(
                  //       child: SizedBox(
                  //         height: 30,
                  //         width: screenWidth * 0.3,
                  //         child: MyTextField(
                  //           controller: TextEditingController(text: "${currencyConstantsProvider.currency}${_stateProvider!.minimumPrice}"),
                  //           labelText : "",
                  //           isEnabled: true,
                  //           maxLength: 14,
                  //           elevation: 0,
                  //           textInputFormatters: <TextInputFormatter>[
                  //             FilteringTextInputFormatter.allow(
                  //               RegExp(r'^[0-9,\.]+$'),
                  //             ),
                  //             NumberToCurrencyFormatter()
                  //           ],
                  //           keyboardType: TextInputType.number,
                  //           textStyle: GoogleFonts.poppins(
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: 14,
                  //             color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  //           ),
                  //           // borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                  //           // fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                  //           borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                  //           fillColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                  //           isFilled: true,
                  //           margin: EdgeInsets.zero,
                  //           contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                  //           focusedBorderColor: Color(0xff5cbbff),
                  //           showLeadingWidget: false  ,
                  //           showTrailingWidget: false,
                  //           // prefixText: currencyConstantsProvider.currency,
                  //
                  //           counterText: "",
                  //           borderRadius: 8,
                  //           hintText: '',
                  //           onChanged: (value) {
                  //
                  //           },
                  //           onFieldSubmitted: (value) {
                  //
                  //           },
                  //         ),
                  //       ),
                  //     )
                  //
                  //   ],
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Text(
                            TranslationKeys.cashAssigned,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                            ),
                          ),

                          SizedBox(
                            width: 3,
                          ),

                          InkWell(
                            onTap: () {
                              cashAssignedTooltipKey.currentState?.ensureTooltipVisible();
                            },
                            child: Tooltip(
                              key: cashAssignedTooltipKey,
                              message: TranslationKeys.cashAssignedDescription,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              preferBelow: false,
                              child: Icon(
                                Icons.info_outline,
                                size: 15,
                                color: (themeProvider.defaultTheme)?Color(0xff6e6e6e):Color(0xffa2b0bc),
                              ),
                            ),
                          )
                        ],
                      ),


                      IgnorePointer(
                        child: SizedBox(
                          height: 30,
                          width: screenWidth * 0.3,
                          child: MyTextField(
                            controller: TextEditingController(text: "${currencyConstantsProvider.currency}${amountToInrFormatCLP(double.tryParse(_stateProvider!.ladderCreationParametersScreen2.clpCashAllocated!.text.isNotEmpty ? _stateProvider!.ladderCreationParametersScreen2.clpCashAllocated!.text.replaceAll(",", "") : "1.18") ?? 1.0, decimalDigit: 2)}"),
                            labelText: "",
                            isEnabled: true,
                            maxLength: 14,
                            elevation: 0,
                            textInputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9,\.]+$'),
                              ),
                              NumberToCurrencyFormatter()
                            ],
                            keyboardType: TextInputType.number,
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                            ),
                            isFilled: false,
                            // fillColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                            // borderColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                            borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                            fillColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                            margin: EdgeInsets.zero,
                            contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                            focusedBorderColor: Color(0xff5cbbff),
                            showLeadingWidget: false  ,
                            showTrailingWidget: false,
                            // prefixText: currencyConstantsProvider.currency,

                            counterText: "",
                            borderRadius: 8,
                            hintText: '',
                            onChanged: (value) {

                            },
                            onFieldSubmitted: (value) {

                            },
                          ),
                        ),
                      )

                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Text(
                            "Min Steps Above",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                            ),
                          ),

                          SizedBox(
                            width: 3,
                          ),

                        ],
                      ),


                      IgnorePointer(
                        child: SizedBox(
                          height: 30,
                          width: screenWidth * 0.3,
                          child: MyTextField(
                            controller: TextEditingController(text: _stateProvider!.minStepAbove.toStringAsFixed(2)),
                            labelText: "",
                            isEnabled: true,
                            maxLength: 14,
                            elevation: 0,
                            textInputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9,\.]+$'),
                              ),
                              NumberToCurrencyFormatter()
                            ],
                            keyboardType: TextInputType.number,
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                            ),
                            isFilled: false,
                            // fillColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                            // borderColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                            borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                            fillColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                            margin: EdgeInsets.zero,
                            contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                            focusedBorderColor: Color(0xff5cbbff),
                            showLeadingWidget: false  ,
                            showTrailingWidget: false,
                            // prefixText: currencyConstantsProvider.currency,

                            counterText: "",
                            borderRadius: 8,
                            hintText: '',
                            onChanged: (value) {

                            },
                            onFieldSubmitted: (value) {

                            },
                          ),
                        ),
                      )

                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Text(
                            "Min Extra Cash",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                            ),
                          ),

                          SizedBox(
                            width: 3,
                          ),

                        ],
                      ),


                      IgnorePointer(
                        child: SizedBox(
                          height: 30,
                          width: screenWidth * 0.3,
                          child: MyTextField(
                            controller: TextEditingController(text: "100"),
                            labelText: "",
                            isEnabled: true,
                            maxLength: 14,
                            elevation: 0,
                            textInputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9,\.]+$'),
                              ),
                              NumberToCurrencyFormatter()
                            ],
                            keyboardType: TextInputType.number,
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                            ),
                            isFilled: false,
                            // fillColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                            // borderColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                            borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                            fillColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
                            margin: EdgeInsets.zero,
                            contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                            focusedBorderColor: Color(0xff5cbbff),
                            showLeadingWidget: false  ,
                            showTrailingWidget: false,
                            // prefixText: currencyConstantsProvider.currency,

                            counterText: "",
                            borderRadius: 8,
                            hintText: '',
                            onChanged: (value) {

                            },
                            onFieldSubmitted: (value) {

                            },
                          ),
                        ),
                      )

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildConfigurationSection(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        ),

        SizedBox(height: 5),

        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: recommendedParameters(),
        ),

        SizedBox(
          height: 8,
        ),

        buildTargetPriceMultiplierSection(context, screenWidth),

        (showFormula)?SizedBox(
          height: 15,
        ):Container(),

        (showFormula)
            ?buildFormulaSection(context, screenWidth)
            :Container(),

        SizedBox(
          height: 10,
        ),

        buildTargetPriceSection(context, screenWidth),

        SizedBox(
          height: 10,
        ),

        buildNoteSection(context),
      ],
    );
  }

  Widget buildNoteSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note: According to target price \nMin Step Size = ${_stateProvider!.minStepSize.toStringAsFixed(2)} \nMax Step Size = ${_stateProvider!.maxStepSize.toStringAsFixed(2)}", // \nMin Step Above: ${_stateProvider!.minStepAbove.toStringAsFixed(2)} \nMAX Step Above: ${_stateProvider!.maxStepAbove.toStringAsFixed(2)}",
            // "${TranslationKeys.weSentYourA6DigitVerificationCodeAt} your registered email",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.yellow,
              fontFamily: "Britanica",
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

              Row(
                children: [
                  Text(
                    "${TranslationKeys.targetPriceMultiplier} (k)",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                    ),
                  ),

                  SizedBox(
                    width: 3,
                  ),

                  InkWell(
                    onTap: () {
                      targetPriceMultiplierTooltipKey.currentState?.ensureTooltipVisible();
                    },
                    child: Tooltip(
                      key: targetPriceMultiplierTooltipKey,
                      message: TranslationKeys.theMultiplierOfTheInitialPriceThatWillLeadToTargetPrice,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      preferBelow: false,
                      child: Icon(
                        Icons.info_outline,
                        size: 15,
                        color: (themeProvider.defaultTheme)?Color(0xff6e6e6e):Color(0xffa2b0bc),
                      ),
                    ),
                  )
                ],
              ),


              SizedBox(
                height: 30,
                width: screenWidth * 0.3,
                child: MyTextField(
                  controller:
                  _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""],
                  labelText: "",
                  isEnabled: true,
                  maxLength: 6,
                  elevation: 0,
                  textInputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9,\.]+$'),
                    ),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                  borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                  isFilled: true,
                  fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                  margin: EdgeInsets.zero,
                  contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                  focusedBorderColor: Color(0xff5cbbff),
                  showLeadingWidget: false  ,
                  showTrailingWidget: false,
                  prefixText: 'x',

                  onTap: () {
                    _stateProvider!.updateTargetPriceMultiplier(
                      _stateProvider!.ladderCreationParametersScreen1
                          .targetPriceMultiplier[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
                      _stateProvider!.ladderCreationParametersScreen1
                          .targetPriceMultiplier[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text.length,
                    );
                    _stateProvider!.isRecommendedParametersEnabledScreen1[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;

                    calculateMinAndMaxStepSizeAndMinK();
                    setState((){

                    });
                  },
                  counterText: "",
                  borderRadius: 8,
                  hintText: '',
                  onChanged: (onChangeValue) {

                    print("sindie on change");

                    if(onChangeValue.endsWith(".") == false) {
                      // _stateProvider!.targetPriceMultiplierController = onChangeValue;
                      _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.value =
                          TextEditingValue(
                            text: onChangeValue,
                            selection: TextSelection.fromPosition(TextPosition(
                                offset: _stateProvider!
                                    .targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!
                                    .selection
                                    .baseOffset)),
                          );
                      _stateProvider!.updateTargetPriceMultiplier(
                        onChangeValue,
                        _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!
                            .selection.baseOffset,
                      );
                      _stateProvider!.isRecommendedParametersEnabledScreen1[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;

                      calculateMinAndMaxStepSizeAndMinK();

                      setState((){

                      });
                    }

                  },
                  onFieldSubmitted: (value) {

                  },
                ),
              )

            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            children: [
              Text(
                "Selected Value: ${_stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text}",
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
          height: 5,
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
                _stateProvider!.minK.toStringAsFixed(2),
                // "1.2",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),

              // Text(
              //   "Selected Value ${_stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text}",
              //   style: GoogleFonts.poppins(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w400,
              //     color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
              //   ),
              // ),

              Text(
                "20",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildTargetPriceMultiplierSlider(BuildContext context, double screenWidth) {

    double min = double.parse(_stateProvider!.minK.toStringAsFixed(2));
    double max = 20;

    if(min > max) {
      max = min + 20;
    }
    double range = max - min;
    int divisions = (range * 20).toInt(); 
    if (divisions < 10) divisions = 10; 
    if (divisions > 200) divisions = 200;
  
    print("below is min and max");
    print(min.toString());
    print(max.toString());
    print(_stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text);

    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
        value: (_stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text == "" || _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text == ".")
            ? min // 2
            : ((double.tryParse(_stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text) ?? 0) > max) // 50)
            ? max // 50
            : ((double.tryParse(_stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text) ?? 0) < min) // 2)
            ? min // 2
            : double.tryParse(_stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text) ?? 2,
        max: max, //50,
        divisions: (max - min).toInt(), // 50 - 2,
        min: min, // 2,

        label: _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
               onChanged: (double value) {
          String ticker = _stateProvider!.ladderCreationParametersScreen1.clpTicker ?? "";
          
          double roundedValue = double.parse(value.toStringAsFixed(2));
          
          _stateProvider!.targetPriceMultiplierController[ticker]!.value =
              TextEditingValue(
                text: roundedValue.toString(),
                selection: TextSelection.fromPosition(TextPosition(
                    offset: _stateProvider!.targetPriceMultiplierController[ticker]!.selection.baseOffset)),
              );

          _stateProvider!.updateTargetPriceMultiplier(
            _stateProvider!.targetPriceMultiplierController[ticker]!.text,
            _stateProvider!.targetPriceMultiplierController[ticker]!.selection.baseOffset,
          );
          _stateProvider!.isRecommendedParametersEnabledScreen1[ticker] = false;

          calculateMinAndMaxStepSizeAndMinK();

          setState((){});
        },
      ),
    );
  }

  Widget buildFormulaSection(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TranslationKeys.formula,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
          ),
        ),

        SizedBox(
          height: 5,
        ),

        Container(
          width: screenWidth - 32,
          height: 75,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'lib/create_ladder_detailed/assets/images/formula_complete_bg_image_2.png'
              ), // Local image
              fit: BoxFit.fill, // Adjust the fit
            ), // Optional: Add rounded corners
            borderRadius: BorderRadius.circular(6.17),
          ),
          child: Center(
            child: Container(
              height: 50,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "K = ",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(0xff484848),
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Target price',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Color(0xff484848),
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        width: 120,
                        child: Divider(
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff484848)
                              : Color(0xff484848),
                          indent: 10,
                          thickness: 1,
                          endIndent: 10,
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Expanded(
                          flex: 3,
                          child: Container(
                              child: Text(
                                'Initial buy price',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Color(0xff484848),
                                    fontWeight: FontWeight.w500
                                ),)
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    // return Container(
    //   width: screenWidth - 32,
    //   color: Colors.transparent,
    //   child: Stack(
    //     children: [
    //       Container(
    //         width: screenWidth - 32,
    //         color: Colors.transparent,
    //         child: Image.asset(
    //           "lib/create_ladder_detailed/assets/images/formula_complete_bg_image_2.png",
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         mainAxisSize: MainAxisSize.max,
    //         children: [
    //           Center(
    //             child: Container(
    //               height: 50,
    //               color: Colors.transparent,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     "K = ",
    //                     style: GoogleFonts.poppins(
    //                         fontSize: 16,
    //                       color: Color(0xff484848),
    //                       fontWeight: FontWeight.w500
    //                     ),
    //                   ),
    //                   Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       Text(
    //                           'Target price',
    //                         style: GoogleFonts.poppins(
    //                             fontSize: 16,
    //                             color: Color(0xff484848),
    //                             fontWeight: FontWeight.w500
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 2,
    //                       ),
    //                       Container(
    //                         width: 120,
    //                         child: Divider(
    //                           color: (themeProvider.defaultTheme)
    //                               ? Color(0xff484848)
    //                               : Color(0xff484848),
    //                           indent: 10,
    //                           thickness: 1,
    //                           endIndent: 10,
    //                           height: 1,
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 2,
    //                       ),
    //                       Expanded(
    //                           flex: 3,
    //                           child: Container(
    //                               child: Text(
    //                                   'Initial buy price',
    //                                 style: GoogleFonts.poppins(
    //                                     fontSize: 16,
    //                                     color: Color(0xff484848),
    //                                     fontWeight: FontWeight.w500
    //                                 ),)
    //                           ))
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }

  Widget buildTargetPriceSection(BuildContext context, double screenWidth) {


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  Text(
                    "${TranslationKeys.targetPrice}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                    ),
                  ),

                  SizedBox(
                    width: 3,
                  ),

                  InkWell(
                    onTap: () {
                      targetPriceTooltipKey.currentState?.ensureTooltipVisible();
                    },
                    child: Tooltip(
                      key: targetPriceTooltipKey,
                      message: TranslationKeys.targetPriceDescription,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      preferBelow: false,
                      child: Icon(
                        Icons.info_outline,
                        size: 15,
                        color: (themeProvider.defaultTheme)?Color(0xff6e6e6e):Color(0xffa2b0bc),
                      ),
                    ),
                  )
                ],
              ),


              SizedBox(
                height: 30,
                width: screenWidth * 0.3,
                child: MyTextField(
                  controller: _stateProvider!.targetPriceController,
                  labelText: "",
                  isEnabled: true,
                  maxLength: 14,
                  elevation: 0,
                  textInputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9,\.]+$'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                  borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                  isFilled: true,
                  fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                  margin: EdgeInsets.zero,
                  contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                  focusedBorderColor: Color(0xff5cbbff),
                  showLeadingWidget: false  ,
                  showTrailingWidget: false,
                  prefixText: '',
                  // prefixText: 'x',

                  onTap: () {
                    List<String> splittedValues = doublValueSplitterBydot(
                        _stateProvider!.ladderCreationParametersScreen1
                            .clpTargetPrice!.text);
                    _stateProvider!.updateTargetPrice(
                      splittedValues[0],
                      splittedValues[1],
                      _stateProvider!.ladderCreationParametersScreen1
                          .clpTargetPrice!.text.length,
                    );

                    calculateMinAndMaxStepSizeAndMinK();

                    setState((){

                    });
                  },
                  counterText: "",
                  borderRadius: 8,
                  hintText: '',
                  onChanged: (onChangeValue) {
                    List<String> splittedValues =
                    doublValueSplitterBydot(onChangeValue);
                    _stateProvider!.updateTargetPrice(
                      splittedValues[0],
                      splittedValues[1],
                      _stateProvider!
                          .targetPriceController.selection.baseOffset,
                    );

                    calculateMinAndMaxStepSizeAndMinK();
                    setState((){

                    });
                  },
                  onFieldSubmitted: (value) {

                  },
                ),
              )

            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22.0),
          child: Row(
            children: [
              Text(
                "Selected Value: ${_stateProvider!.targetPriceController.text}",
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
                "${amountToInrFormat(context, _stateProvider!.initialBuyPrice * _stateProvider!.minK.roundTo2())}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),

              Text(
                "${amountToInrFormat(context, _stateProvider!.initialBuyPrice * 50)}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildTargetPriceSlider(BuildContext context, double screenWidth){
    double min = _stateProvider!.initialBuyPrice * _stateProvider!.minK;
    double max = _stateProvider!.initialBuyPrice * 20;
    double targetPrice = double.parse(
        _stateProvider!.targetPriceController.text.replaceAll(",", ""));

    if(min > max) {
      max = min * 2;
    }
    log("below are min and max");
    log(min.toString());
    log(max.toString());
    log(targetPrice.toString());
    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
        value: (_stateProvider!.targetPriceController.text == "")
            ? min
            : (targetPrice > max)
            ? max
            : (targetPrice < min)
            ? min
            : targetPrice,
        max: max,
        divisions: int.parse((max - min).toStringAsFixed(0)),
        min: min,
        label: currencyConstantsProvider.currency +
            _stateProvider!.targetPriceController.text,
        onChanged: (double value) {
          _stateProvider!.targetPriceController.value = TextEditingValue(
            text: value.toString(),
            selection: TextSelection.fromPosition(TextPosition(
                offset:
                _stateProvider!.targetPriceController.selection.baseOffset)),
          );

          List<String> splittedValues = doublValueSplitterBydot(value.toString());
          _stateProvider!.updateTargetPrice(
            splittedValues[0],
            splittedValues[1],
            _stateProvider!.targetPriceController.selection.baseOffset,
          );

          calculateMinAndMaxStepSizeAndMinK();

          setState((){

          });
        },
      ),
    );
  }

  Widget buildCreateLadderStep2ButtonSection(BuildContext context, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: (themeProvider.defaultTheme)?Color(0xfff5f5f5f5):Color(0xff454545),
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
              padding: const EdgeInsets.only(top: 10, bottom: 5.0),
              child: CustomContainer(
                padding: 0,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                borderRadius: 12,
                backgroundColor: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                // backgroundColor: (true)
                //     ?Color(0xfff0f0f0):Color(0xffa8a8a8),
                onTap: () async {

                  double minK = await _stateProvider!.calculateMinimumK(double.tryParse(_stateProvider!.cashAllocatedControllerList[_stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0);
                  double k = (double.tryParse(_stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text) ?? 0);
                  print("below is k and min k");
                  print(minK);
                  print(k);

                  if(_stateProvider!.selectedMode == "Prior Buy") {

                    if(k.roundTo2() < minK.roundTo2()) {

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return warningMessageDialog(
                              "Your current target price is infeasible, Please increase your target price",
                              context);
                        },
                      );
                    } else {

                      print(
                          "here is the value of the following ${_stateProvider!.targetPriceController.text}");
                      if (_stateProvider!.targetPrice <= 0 || _stateProvider!.k <= 0) {
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
                          if (_stateProvider!.minimumPriceWarning.length == 0 &&
                              _stateProvider!.targetPriceWarning.length == 0) {
                            _isBtnClicked = true;
                            // _navigationProvider.previousSelectedIndex =
                            //     _navigationProvider.selectedIndex;
                            _navigationProvider.selectedIndex = 27;
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            //   _isBtnClicked = false;
                            //   return CreateLadder3();
                            // }));
                          }
                        }
                      }

                    }

                  } else {

                    // _isBtnClicked = true;
                    // _navigationProvider.selectedIndex = 6;

                    if(k.roundTo2() < minK.roundTo2()) {
                    // if(false) {

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return warningMessageDialog(
                              "Your current target price is infeasible, Please increase your target price",
                              context);
                        },
                      );
                    } else {

                      print("here is the value of the following ${_stateProvider!.targetPriceController.text}");



                      if (_stateProvider!.targetPrice <= 0 || _stateProvider!.k <= 0) {
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
                          if (_stateProvider!.minimumPriceWarning.length == 0 && _stateProvider!.targetPriceWarning.length == 0) {
                          // if (true) {
                            _isBtnClicked = true;
                            // _navigationProvider.previousSelectedIndex =
                            //     _navigationProvider.selectedIndex;
                            _navigationProvider.selectedIndex = 6;
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            //   _isBtnClicked = false;
                            //   return CreateLadder3();
                            // }));
                          }
                        }
                      }

                    }

                  }


                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
                  child: Text(
                    // TranslationKeys.createLadder,
                      TranslationKeys.nextStep,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                        // color: (true)
                        //     ?Color(0xff000000):Color(0xfff0f0f0),
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

  Widget targetPriceWarningUi(double screenWidth) {
    return (_stateProvider!.targetPriceWarning != "")?Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning,
                color: Color(0xffffb300),
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                TranslationKeys.warning,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xffffb300),
                ),
              )
            ],
          ),

          SizedBox(
            height: 8,
          ),

          Container(
            width: screenWidth - 32,
            child: Text(
              _stateProvider!.targetPriceWarning,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Color(0xffffb300),
              ),
            ),
          ),
        ],
      ),
    ):Container();
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

}
