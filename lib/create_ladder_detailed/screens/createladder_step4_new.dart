import 'dart:io';
import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/terms_info_contant.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/create_ladder_easy/services/rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_easy/stateManagement/create_ladder_easy_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/global/services/num_formatting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../AB_Ladder/widgets/review_ladder_dialog_new.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../create_ladder/screens/show_ladder_creation_option_dialog_new.dart';
import '../../global/stateManagement/progress_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/progress_bar.dart';
import '../../kyc/widgets/custom_bottom_sheets.dart';
import '../../localization/translation_keys.dart';

class CreateLadder4New extends StatefulWidget {
  const CreateLadder4New({super.key});

  @override
  State<CreateLadder4New> createState() => _CreateLadder4NewState();
}

class _CreateLadder4NewState extends State<CreateLadder4New> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  RestApiService restApiService = RestApiService();
  CreateLadderProvider? _stateProvider;
  late ThemeProvider themeProvider;
  TradeMainProvider? _tradeMainProvider;
  LadderProvider? _ladderProvider;
  late NavigationProvider _navigationProvider;
  bool _isBtnClicked = false;

  late CurrencyConstants currencyConstantsProvider;

  late CreateLadderEasyProvider createLadderEasyProvider;
  late ProgressProvider progressProvider;

  TermsInfoConstant termsInfoConstant = TermsInfoConstant();

  bool showFormula = false;

  final GlobalKey<TooltipState> cashNeededTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> actualCashAllocatedTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> calculatedStepsAboveTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> stepBelowTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> calculatedStepSizeTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> orderSizeTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> stepAboveTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> stepSizeTooltipKey = GlobalKey<TooltipState>();


  void initState() {
    super.initState();
    _stateProvider = Provider.of(context, listen: false);
    _tradeMainProvider = Provider.of(context, listen: false);
    _ladderProvider = Provider.of(context, listen: false);
    currencyConstantsProvider = Provider.of(context, listen: false);
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      progressProvider = Provider.of(context, listen: false);
      progressProvider.updateProgress(0.8);



      _stateProvider!.updateRecommendedParameterScreen3();



    });
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
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

  @override
  Widget build(BuildContext context) {

    double screenWidth = screenWidthRecognizer(context);
    createLadderEasyProvider =
        Provider.of<CreateLadderEasyProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    progressProvider = Provider.of<ProgressProvider>(context, listen: true);
    return PopScope(
        onPopInvokedWithResult: ((value, result) async {
          _navigationProvider.selectedIndex = 6;
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

                              SizedBox(height: 10),

                              buildTopValuesSection(context, screenWidth),

                              SizedBox(
                                height: 10,
                              ),

                              buildTopBoxValuesSection(context, screenWidth),

                              SizedBox(
                                height: 10,
                              ),

                              buildConfigurationsSection(context, screenWidth),

                              SizedBox(
                                height: 10
                              ),

                              // stepSizeWarning(context, screenWidth),
                              //
                              // SizedBox(
                              //   height: 15,
                              // ),

                            ],
                          ),
                        ),

                        CustomHomeAppBarWithProviderNew(
                            backButton: false, leadingAction: _triggerDrawer),

                      ],
                    ),
                    bottomNavigationBar: buildCreateLadderStep4ButtonSection(context, screenWidth),
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

                  _navigationProvider.selectedIndex = 6;

                },
                child: Icon(
                  Icons.arrow_back,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  size: 22,
                ),
              ),

              SizedBox(
                width: 8,
              ),

              SizedBox(
                width: screenWidth * 0.5,
                child: Text(
                  "${TranslationKeys.selectLadderStepSize} (${_stateProvider!.ladderCreationParametersScreen1.clpTicker} (${_stateProvider!.ladderCreationParametersScreen1.clpExchange}))",
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

  Widget buildTopValuesSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationKeys.targetPrice,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),

              Text(
                "${currencyConstantsProvider.currency} ${_stateProvider!.targetPrice}",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                ),
              )
            ],
          ),

          SizedBox(
              height: 10
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationKeys.initialBuyPrice,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),

              Text(
                "${currencyConstantsProvider.currency} ${_stateProvider!.initialBuyPrice}",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                ),
              )
            ],
          ),

          SizedBox(
            height: 10
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationKeys.calculatedInitialBuyQuantity,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color:(themeProvider.defaultTheme)?Colors.black: Color(0xfff0f0f0),
                ),
              ),

              Text(
                (_stateProvider!.selectedMode == "Prior Buy")?"${_stateProvider!.priorBuyInitialBuyQuantity.floor().toString()}":"${_stateProvider!.ladderCreationParametersScreen3.clpInitialBuyQuantity.text}",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                ),
              )
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    TranslationKeys.cashNeeded,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    ),
                  ),

                  SizedBox(
                    width: 3,
                  ),

                  InkWell(
                    onTap: () {
                      cashNeededTooltipKey.currentState?.ensureTooltipVisible();
                    },
                    child: Tooltip(
                      key: cashNeededTooltipKey,
                      message: TranslationKeys.cashNeededDescription,
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

              Text(
                "${currencyConstantsProvider.currency} ${numToComma(_stateProvider!.cashNeeded)}",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                ),
              )
            ],
          ),

          (showFormula)?SizedBox(
            height: 10,
          ):Container(),

          (showFormula)?buildCashNeedFormulaSection(context, screenWidth):Container(),

          SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    TranslationKeys.actualCashAllocated,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    ),
                  ),

                  SizedBox(
                    width: 3,
                  ),

                  InkWell(
                    onTap: () {
                      actualCashAllocatedTooltipKey.currentState?.ensureTooltipVisible();
                    },
                    child: Tooltip(
                      key: actualCashAllocatedTooltipKey,
                      message: TranslationKeys.actualCashAllocatedDescription,
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

              Text(
                "${currencyConstantsProvider.currency} ${numToComma(_stateProvider!.actualCashAllocated)}",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTopBoxValuesSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: CustomContainer(
        backgroundColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):Color(0xff1b1b1b),
        borderRadius: 10,
        paddingEdge: EdgeInsets.zero,
        padding: 0,
        margin: EdgeInsets.zero,
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
                        TranslationKeys.calculatedStepsAbove,
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
                          calculatedStepsAboveTooltipKey.currentState?.ensureTooltipVisible();
                        },
                        child: Tooltip(
                          key: calculatedStepsAboveTooltipKey,
                          message: TranslationKeys.calculatedStepsAboveDescription,
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
                        controller: TextEditingController(text: "${_stateProvider!.calculatedNumberOfStepsAbove}"),
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
                        isFilled: true,
                        // fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                        borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                        // borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
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

              SizedBox(
                height: 5,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      Text(
                        TranslationKeys.stepsBelow,
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
                          stepBelowTooltipKey.currentState?.ensureTooltipVisible();
                        },
                        child: Tooltip(
                          key: stepBelowTooltipKey,
                          message: TranslationKeys.stepsBelowDescription,
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
                        controller: TextEditingController(text: "${_stateProvider!.numberOfStepsBelow}"),
                        labelText : "",
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
                        isFilled: true,
                        // fillColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                        borderColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                        // borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
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

              SizedBox(
                height: 5,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      Text(
                        TranslationKeys.calculatedStepSize,
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
                          calculatedStepSizeTooltipKey.currentState?.ensureTooltipVisible();
                        },
                        child: Tooltip(
                          key: calculatedStepSizeTooltipKey,
                          message: TranslationKeys.calculatedStepSizeDescription,
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
                        controller: TextEditingController(text: "${currencyConstantsProvider.currency} ${numToComma(_stateProvider!.calculatedStepSize)}"),
                        labelText : "",
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
                        isFilled: true,
                        // fillColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                        borderColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                        // borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
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

              SizedBox(
                height: 5,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      Text(
                        TranslationKeys.orderSize,
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
                          orderSizeTooltipKey.currentState?.ensureTooltipVisible();
                        },
                        child: Tooltip(
                          key: orderSizeTooltipKey,
                          message: TranslationKeys.orderSizeDescription,
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
                        controller: TextEditingController(text: "${_stateProvider!.buySellQtyController.text}"),
                        labelText : "",
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
                        isFilled: true,
                        // fillColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                        borderColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                        // borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1b1b1b),
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

              (showFormula)?SizedBox(
                height: 12,
              ):Container(),

              (showFormula)
                  ?buildOrderSizeFormulaSection(context, screenWidth, _stateProvider!.ceilBuySellQty)
                  :Container(),
            ],
          ),
        ),
      ),
      // child: CustomContainer(
      //   borderColor: Color(0xff2c2c31),
      //   borderRadius: 10,
      //   backgroundColor: Colors.transparent,
      //   padding: 0,
      //   paddingEdge: EdgeInsets.zero,
      //   margin: EdgeInsets.zero,
      //   child: Padding(
      //     padding: const EdgeInsets.only(left: 6, right: 6, top: 8, bottom: 8.0),
      //     child: ,
      //   ),
      // ),
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
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        ),

        SizedBox(
          height: 5,
        ),

        stepSizeWarning(context, screenWidth),

        SizedBox(
          height: 5,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: recommendedParameters(),
        ),

        SizedBox(height: 10),

        buildStepsAboveSection(context, screenWidth),

        SizedBox(
          height: 8,
        ),

        buildStepSizeSection(context, screenWidth),


      ],
    );
  }

  Widget buildStepsAboveSection(BuildContext context, double screenWidth) {
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
                      "${TranslationKeys.stepsAbove}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                      ),
                    ),
                    Text(
                      " (${TranslationKeys.suggestedByUser})",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                      ),
                    ),

                    SizedBox(
                      width: 3,
                    ),

                    InkWell(
                      onTap: () {
                        stepAboveTooltipKey.currentState?.ensureTooltipVisible();
                      },
                      child: Tooltip(
                        key: stepAboveTooltipKey,
                        message: TranslationKeys.stepsAboveDescription,
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
                    controller: _stateProvider!.numberOfStepsAboveController,
                    labelText: "",
                    isEnabled: true,
                    maxLength: 8,
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
                    isFilled: true,
                    fillColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                    borderColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                    margin: EdgeInsets.zero,
                    contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                    focusedBorderColor: Color(0xff5cbbff),
                    showLeadingWidget: false  ,
                    showTrailingWidget: false,
                    prefixText: '',

                    onTap: () {

                      setState((){

                      });
                    },
                    counterText: "",
                    borderRadius: 8,
                    hintText: '',
                    onChanged: (inputNumberOfStepsAbove) async {

                      if(_stateProvider!.selectedMode == "Prior Buy") {
                        await _stateProvider!.calculatePriorBuyStepSize(targetPrice: _stateProvider!.targetPrice, stepAbove: double.tryParse(inputNumberOfStepsAbove) ?? 40);
                        _stateProvider!.calculatePriorBuyOrderSize(stepAbove: double.tryParse(inputNumberOfStepsAbove) ?? 40);

                        _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;

                      } else {

                        _stateProvider!.updateNumberOfStepsAbove(
                          inputNumberOfStepsAbove,
                          _stateProvider!
                              .numberOfStepsAboveController.selection.baseOffset,
                        );

                        // if(_stateProvider!.selectedMode == "Prior Buy") {
                        //   final result = _stateProvider!.priorBuyCalculation(
                        //     R: double.tryParse(_stateProvider!.ladderCreationScreen3[_stateProvider!.index].clpStepSize!.text) ?? 0, // 1.324,
                        //     P1: double.tryParse(_stateProvider!.priorBuyStockPriceTextController.text) ?? 0,
                        //     P2: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
                        //     T: _stateProvider!.targetPrice, // double.tryParse(_stateProvider!.targetPriceController.text) ?? 0,
                        //     C: _stateProvider!.actualCashAllocated, // double.tryParse(cashAllocatedControllerList[ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
                        //     S1: double.tryParse(_stateProvider!.priorBuyStockQuantityTextController.text) ?? 0,
                        //   );
                        //
                        //   print('x (Stocks to buy at P2): ${result['x']}');
                        //   print('P (Average Price): ${result['P']}');
                        //   print('R (Rate of sell): ${result['R']}');
                        //   print('Final Value: ${result['finalValue']}');
                        //
                        // }

                        if (_stateProvider!.numberOfStepsAboveController.text != "" &&
                            _stateProvider!.numberOfStepsAboveController.text !=
                                "0") {
                          _stateProvider!.stepSizeController.text = (_stateProvider!
                              .calculateFieldStepSize(double.parse(_stateProvider!
                              .numberOfStepsAboveController.text)))
                              .toStringAsFixed(2);

                          _stateProvider!.calculateStepSize(
                            stepAbove: double.parse(_stateProvider!.numberOfStepsAboveController.text),
                            initialPurchasePrice: _stateProvider!.initialBuyPrice,
                          );
                        }

                        _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;


                      }



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
            height: 5,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22.0),
            child: Row(
              children: [
                Text(
                  "Selected Value: ${(double.tryParse(_stateProvider!.numberOfStepsAboveController.text) ?? 1).toStringAsFixed(2)}",
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

          ((_stateProvider!.maxStepAbove - _stateProvider!.minStepAbove) < 1)?Container():buildStepsAboveSlider(context, screenWidth),

          ((_stateProvider!.maxStepAbove - _stateProvider!.minStepAbove) < 1)?Container():SizedBox(
            height: 5,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_stateProvider!.minStepAbove.toStringAsFixed(2)}",
                  // "1",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),

                Text(
                  "${_stateProvider!.maxStepAbove.toStringAsFixed(2)}",
                  // "${_stateProvider!.ladderCreationParametersScreen3.clpInitialBuyQuantity.text}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
          )

        ]
    );
  }

  Widget buildStepsAboveSlider(BuildContext context, double screenWidth) {
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

    min = _stateProvider!.minStepAbove;
    max = _stateProvider!.maxStepAbove;

    // print("below are values of buildBuyQtySliderbuildStepAboveSuggestedSlider");
    // print(min);
    // print(max);
    // print(stepsAbove);
    // print(_stateProvider!.numberOfStepsAboveController.text);

    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
        value: (_stateProvider!.numberOfStepsAboveController.text == "")
            ? min
            : (stepsAbove > max)
            ? max
            : (stepsAbove < min)
            ? min
            : stepsAbove,
        max: max <= 1 ? 2 : max,
        divisions:
        ((max - min) <= 1) ? 1 : int.parse((max - min).toStringAsFixed(0)),
        min: min,
        label: _stateProvider!.numberOfStepsAboveController.text,
        onChanged: (double value) async {

          _stateProvider!.numberOfStepsAboveController.value = TextEditingValue(
            text: value.toString(),
            selection: TextSelection.fromPosition(TextPosition(
                offset: _stateProvider!
                    .numberOfStepsAboveController.selection.baseOffset)),
          );

          if(_stateProvider!.selectedMode == "Prior Buy") {
            await _stateProvider!.calculatePriorBuyStepSize(targetPrice: _stateProvider!.targetPrice, stepAbove: double.tryParse(_stateProvider!.numberOfStepsAboveController.text) ?? 40);
            _stateProvider!.calculatePriorBuyOrderSize(stepAbove: double.tryParse(_stateProvider!.numberOfStepsAboveController.text) ?? 40);
          } else {
            _stateProvider!.updateNumberOfStepsAbove(
              _stateProvider!.numberOfStepsAboveController.text,
              _stateProvider!.numberOfStepsAboveController.selection.baseOffset,
            );

            // if(_stateProvider!.selectedMode == "Prior Buy") {
            //   final result = _stateProvider!.priorBuyCalculation(
            //     R: double.tryParse(_stateProvider!.ladderCreationScreen3[_stateProvider!.index].clpStepSize!.text) ?? 0, // 1.324,
            //     P1: double.tryParse(_stateProvider!.priorBuyStockPriceTextController.text) ?? 0,
            //     P2: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
            //     T: _stateProvider!.targetPrice, // double.tryParse(_stateProvider!.targetPriceController.text) ?? 0,
            //     C: _stateProvider!.actualCashAllocated, // double.tryParse(cashAllocatedControllerList[ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
            //     S1: double.tryParse(_stateProvider!.priorBuyStockQuantityTextController.text) ?? 0,
            //   );
            //
            //   print('x (Stocks to buy at P2): ${result['x']}');
            //   print('P (Average Price): ${result['P']}');
            //   print('R (Rate of sell): ${result['R']}');
            //   print('Final Value: ${result['finalValue']}');
            //
            // }

            if (_stateProvider!.numberOfStepsAboveController.text != "" &&
                _stateProvider!.numberOfStepsAboveController.text != "0") {
              _stateProvider!.stepSizeController.text = (_stateProvider!
                  .calculateFieldStepSize(double.parse(
                  _stateProvider!.numberOfStepsAboveController.text)))
                  .toStringAsFixed(2);

              _stateProvider!.calculateStepSize(
                  stepAbove: double.parse(_stateProvider!.numberOfStepsAboveController.text),
                  initialPurchasePrice: _stateProvider!.initialBuyPrice,
              );
            }
          }




          _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;



          setState((){

          });
        },
      ),
    );
  }

  Widget buildStepSizeSection(BuildContext context, double screenWidth) {
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
                      "${TranslationKeys.stepSize}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                      ),
                    ),
                    Text(
                      " (${TranslationKeys.suggestedByUser})",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                      ),
                    ),

                    SizedBox(
                      width: 3,
                    ),

                    InkWell(
                      onTap: () {
                        stepSizeTooltipKey.currentState?.ensureTooltipVisible();
                      },
                      child: Tooltip(
                        key: stepSizeTooltipKey,
                        message: TranslationKeys.stepSizeDescription,
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
                    controller: _stateProvider!.stepSizeController,
                    labelText: "",
                    isEnabled: true,
                    maxLength: 8,
                    elevation: 0,
                    textInputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[0-9,\.]+$'),
                      ),
                      // NumberToCurrencyFormatter()
                    ],
                    keyboardType: TextInputType.number,
                    textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    ),
                    isFilled: true,
                    fillColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                    borderColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
                    margin: EdgeInsets.zero,
                    contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                    focusedBorderColor: Color(0xff5cbbff),
                    showLeadingWidget: false  ,
                    showTrailingWidget: false,
                    prefixText: '',

                    counterText: "",
                    borderRadius: 8,
                    hintText: '',
                    onTap: () async {

                      if(_stateProvider!.selectedMode == "Prior Buy") {

                        final stepAbove = await _stateProvider!.calculatePriorBuyStepAbove(targetPrice: _stateProvider!.targetPrice, stepSize: (double.tryParse(_stateProvider!.stepSizeController.text) ?? 0));
                        _stateProvider!.calculatePriorBuyOrderSize(stepAbove: stepAbove);

                        _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;
                      } else {
                        List<String> splittedValues = doublValueSplitterBydot(
                            _stateProvider!
                                .ladderCreationParametersScreen3.clpStepSize!.text);
                        _stateProvider!.updateStepSize(
                          splittedValues[0],
                          splittedValues[1],
                          _stateProvider!.ladderCreationParametersScreen3.clpStepSize!
                              .text.length,
                        );

                        // if(_stateProvider!.selectedMode == "Prior Buy") {
                        //   final result = _stateProvider!.priorBuyCalculation(
                        //     R: double.tryParse(_stateProvider!.ladderCreationScreen3[_stateProvider!.index].clpStepSize!.text) ?? 0, // 1.324,
                        //     P1: double.tryParse(_stateProvider!.priorBuyStockPriceTextController.text) ?? 0,
                        //     P2: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
                        //     T: _stateProvider!.targetPrice, // double.tryParse(_stateProvider!.targetPriceController.text) ?? 0,
                        //     C: _stateProvider!.actualCashAllocated, // double.tryParse(cashAllocatedControllerList[ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
                        //     S1: double.tryParse(_stateProvider!.priorBuyStockQuantityTextController.text) ?? 0,
                        //   );
                        //
                        //   print('x (Stocks to buy at P2): ${result['x']}');
                        //   print('P (Average Price): ${result['P']}');
                        //   print('R (Rate of sell): ${result['R']}');
                        //   print('Final Value: ${result['finalValue']}');
                        //
                        // }
                        _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;

                        if (_stateProvider!.stepSizeController.text != "" &&
                            _stateProvider!.stepSizeController.text != "0") {
                          _stateProvider!.numberOfStepsAboveController.text = (_stateProvider!
                              .calculateFieldNumberOfStepAbove(
                              double.parse(_stateProvider!.stepSizeController.text.replaceAll(",", ""))))
                              .toString();

                          _stateProvider!.calculateStepAbove(
                            stepSize: double.tryParse(_stateProvider!.stepSizeController.text) ?? 0,
                            initialPurchasePrice: _stateProvider!.initialBuyPrice,
                          );

                        }
                      }



                    },
                    onChanged: (inputStepSize) async {
                      if(_stateProvider!.selectedMode == "Prior Buy") {
                        _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;

                        final stepAbove = await _stateProvider!.calculatePriorBuyStepAbove(targetPrice: _stateProvider!.targetPrice, stepSize: (double.tryParse(_stateProvider!.stepSizeController.text) ?? 0));
                        _stateProvider!.calculatePriorBuyOrderSize(stepAbove: stepAbove);
                      } else {
                        List<String> splittedValues =
                        doublValueSplitterBydot(inputStepSize);
                        _stateProvider!.updateStepSize(
                          splittedValues[0],
                          splittedValues[1],
                          _stateProvider!.stepSizeController.selection.baseOffset,
                        );

                        // if(_stateProvider!.selectedMode == "Prior Buy") {
                        //   final result = _stateProvider!.priorBuyCalculation(
                        //     R: double.tryParse(_stateProvider!.ladderCreationScreen3[_stateProvider!.index].clpStepSize!.text) ?? 0, // 1.324,
                        //     P1: double.tryParse(_stateProvider!.priorBuyStockPriceTextController.text) ?? 0,
                        //     P2: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
                        //     T: _stateProvider!.targetPrice, // double.tryParse(_stateProvider!.targetPriceController.text) ?? 0,
                        //     C: _stateProvider!.actualCashAllocated, // double.tryParse(cashAllocatedControllerList[ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
                        //     S1: double.tryParse(_stateProvider!.priorBuyStockQuantityTextController.text) ?? 0,
                        //   );
                        //
                        //   print('x (Stocks to buy at P2): ${result['x']}');
                        //   print('P (Average Price): ${result['P']}');
                        //   print('R (Rate of sell): ${result['R']}');
                        //   print('Final Value: ${result['finalValue']}');
                        //
                        // }

                        _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;

                        if (_stateProvider!.stepSizeController.text != "" &&
                            _stateProvider!.stepSizeController.text != "0") {
                          _stateProvider!.numberOfStepsAboveController.text = (_stateProvider!
                              .calculateFieldNumberOfStepAbove(
                              double.parse(_stateProvider!.stepSizeController.text.replaceAll(",", ""))))
                              .toString();

                          _stateProvider!.calculateStepAbove(
                            stepSize: double.tryParse(_stateProvider!.stepSizeController.text) ?? 0,
                            initialPurchasePrice: _stateProvider!.initialBuyPrice,
                          );

                        }

                      }


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
            height: 5,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22.0),
            child: Row(
              children: [
                Text(
                  "Selected Value: ${_stateProvider!.stepSizeController.text}",
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

          ((_stateProvider!.maxStepSize - _stateProvider!.minStepSize) < 1)?Container():buildStepSizeSlider(context, screenWidth),

          ((_stateProvider!.maxStepSize - _stateProvider!.minStepSize) < 1)?Container():SizedBox(
            height: 5,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_stateProvider!.minStepSize.toStringAsFixed(2)}",
                  // "${(((double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpTargetPrice!.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0)) / (double.tryParse(_stateProvider!.ladderCreationParametersScreen3.clpInitialBuyQuantity.text.replaceAll(",", "")) ?? 0.0)).toStringAsFixed(2)}",
                  // "${(sqrt((200 * ((double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpTargetPrice!.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0))) / (double.tryParse(_stateProvider!.ladderCreationParametersScreen3.clpInitialBuyQuantity.text.replaceAll(",", "")) ?? 0.0))).toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),

                Text(
                  "${_stateProvider!.maxStepSize.toStringAsFixed(2)}",
                  // "${((double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpTargetPrice!.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0)).toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
          )

        ]
    );
  }

  Widget buildStepSizeSlider(BuildContext context, double screenWidth) {


    // double min = double.parse(
    //     (((double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpTargetPrice!.text.replaceAll(",", "")) ??
    //         0.0) -
    //         (double.tryParse(_stateProvider!
    //             .ladderCreationParametersScreen1
    //             .clpInitialPurchasePrice!
    //             .text
    //             .replaceAll(",", "")) ??
    //             0.0)) /
    //         (double.tryParse(_stateProvider!.ladderCreationParametersScreen3
    //             .clpInitialBuyQuantity.text
    //             .replaceAll(",", "")) ??
    //             0.0))
    //         .toStringAsFixed(2));
    // double max = double.parse(((double.tryParse(_stateProvider!
    //     .ladderCreationParametersScreen1.clpTargetPrice!.text
    //     .replaceAll(",", "")) ??
    //     0.0) -
    //     (double.tryParse(_stateProvider!.ladderCreationParametersScreen1
    //         .clpInitialPurchasePrice!.text
    //         .replaceAll(",", "")) ??
    //         0.0))
    //     .toStringAsFixed(2));
    double min = _stateProvider!.minStepSize;
    double max = _stateProvider!.maxStepSize;
    double stepsAbove = (_stateProvider!.stepSizeController.text == "")
        ? min
        : double.parse(
        _stateProvider!.stepSizeController.text.replaceAll(",", ""));

    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
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
        onChanged: (double value) async {

          _stateProvider!.stepSizeController.value = TextEditingValue(
            text: value.toString(),
            selection: TextSelection.fromPosition(TextPosition(
                offset: _stateProvider!.stepSizeController.selection.baseOffset)),
          );

          if(_stateProvider!.selectedMode == "Prior Buy") {
            _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;

            final stepAbove = await _stateProvider!.calculatePriorBuyStepAbove(targetPrice: _stateProvider!.targetPrice, stepSize: (double.tryParse(_stateProvider!.stepSizeController.text) ?? 0));
            _stateProvider!.calculatePriorBuyOrderSize(stepAbove: stepAbove);
          } else {
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

            // if(_stateProvider!.selectedMode == "Prior Buy") {
            //   final result = _stateProvider!.priorBuyCalculation(
            //     R: double.tryParse(_stateProvider!.ladderCreationScreen3[_stateProvider!.index].clpStepSize!.text) ?? 0, // 1.324,
            //     P1: double.tryParse(_stateProvider!.priorBuyStockPriceTextController.text) ?? 0,
            //     P2: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
            //     T: _stateProvider!.targetPrice, // double.tryParse(_stateProvider!.targetPriceController.text) ?? 0,
            //     C: _stateProvider!.actualCashAllocated, // double.tryParse(cashAllocatedControllerList[ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
            //     S1: double.tryParse(_stateProvider!.priorBuyStockQuantityTextController.text) ?? 0,
            //   );
            //
            //   print('x (Stocks to buy at P2): ${result['x']}');
            //   print('P (Average Price): ${result['P']}');
            //   print('R (Rate of sell): ${result['R']}');
            //   print('Final Value: ${result['finalValue']}');
            //
            // }

            if (_stateProvider!.stepSizeController.text != "" &&
                _stateProvider!.stepSizeController.text != "0") {
              _stateProvider!.numberOfStepsAboveController.text = (_stateProvider!
                  .calculateFieldNumberOfStepAbove(
                  double.parse(_stateProvider!.stepSizeController.text.replaceAll(",", ""))))
                  .toString();

              _stateProvider!.calculateStepAbove(
                stepSize: double.tryParse(_stateProvider!.stepSizeController.text) ?? 0,
                initialPurchasePrice: _stateProvider!.initialBuyPrice,
              );

            }
          }




          _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = false;
          setState((){

          });
        },
      ),
    );
  }

  Widget stepSizeWarning(BuildContext context, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   children: [
          //     Icon(
          //       Icons.warning,
          //       color: Color(0xffffb300),
          //       size: 15,
          //     ),
          //     SizedBox(
          //       width: 5,
          //     ),
          //     Text(
          //       TranslationKeys.warning,
          //       style: GoogleFonts.poppins(
          //         fontWeight: FontWeight.w500,
          //         fontSize: 12,
          //         color: Color(0xffffb300),
          //       ),
          //     )
          //   ],
          // ),

          (_stateProvider!.numberOfStepsAboveWarning == "")?Container():SizedBox(
            height: 8,
          ),

          (_stateProvider!.numberOfStepsAboveWarning == "")?Container():Container(
            width: screenWidth - 32,
            child: Text(
              "${TranslationKeys.warning}: ${_stateProvider!.numberOfStepsAboveWarning}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xffffb300),
              ),
            ),
          ),

          (_stateProvider!.buySellQtyWarning == "")?Container():SizedBox(
            height: 8,
          ),

          (_stateProvider!.buySellQtyWarning == "")?Container():Container(
            width: screenWidth - 32,
            child: Text(
              "${TranslationKeys.warning}: ${_stateProvider!.buySellQtyWarning}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Color(0xffffb300),
              ),
            ),
          ),


          (_stateProvider!.stepSizeWarning == "")?Container():SizedBox(
            height: 8,
          ),

          (_stateProvider!.stepSizeWarning == "")?Container():Container(
            width: screenWidth - 32,
            child: Text(
              "${TranslationKeys.warning}: ${_stateProvider!.stepSizeWarning}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Color(0xffffb300),
              ),
            ),
          ),

          SizedBox(
            height: 8,
          ),

          Container(
            width: screenWidth - 32,
            child: Text(
              "${TranslationKeys.warning}: ${TranslationKeys.stepSizeWarning}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Color(0xffffb300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCreateLadderStep4ButtonSection(BuildContext context, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: (themeProvider.defaultTheme)?Color(0xfff5f5f5):Color(0xff454545),
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
                    // ?Color(0xfff0f0f0):Color(0xffa8a8a8),
                onTap: () async {

                  print(_stateProvider!
                      .ladderCreationParametersScreen3.clpInitialBuyQuantity.text);

                  print("below are values");
                  print(_stateProvider!.numberOfStepsAboveController.text);
                  print(_stateProvider!.minStepAbove);
                  print(_stateProvider!.maxStepAbove);

                  print(_stateProvider!.calculatedStepSize);
                  print(_stateProvider!.minStepSize);
                  print(_stateProvider!.maxStepSize);

                  if(((double.tryParse(_stateProvider!.numberOfStepsAboveController.text) ?? 0) < (double.tryParse(_stateProvider!.minStepAbove.toStringAsFixed(2)) ?? 0)) || ((double.tryParse(_stateProvider!.numberOfStepsAboveController.text) ?? 0) > (double.tryParse(_stateProvider!.maxStepAbove.toStringAsFixed(2)) ?? 0))) {

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return warningMessageDialog(
                            "Invalid step above please enter step above in below range \nMin Step Above = ${_stateProvider!.minStepAbove.toStringAsFixed(2)} \nMax Step Above = ${_stateProvider!.maxStepAbove.toStringAsFixed(2)}",
                            context);
                      },
                    );
                    return;
                  }

                  if(((double.tryParse(_stateProvider!.calculatedStepSize.toStringAsFixed(2)) ?? 0) < (double.tryParse(_stateProvider!.minStepSize.toStringAsFixed(2)) ?? 0)) || ((double.tryParse(_stateProvider!.calculatedStepSize.toStringAsFixed(2)) ?? 0) > (double.tryParse(_stateProvider!.maxStepSize.toStringAsFixed(2)) ?? 0))) {

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return warningMessageDialog(
                            "Invalid step size please enter step size in below range \nMin Step Size = ${_stateProvider!.minStepSize.toStringAsFixed(2)} \nMax Step Size = ${_stateProvider!.maxStepSize.toStringAsFixed(2)}",
                            context);
                      },
                    );
                    return;
                  }

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

                      bool showBrokeragePopUp = await _stateProvider!.checkforBrokerkerage();
                      if(showBrokeragePopUp) {
                        _isBtnClicked = false;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return brokeragePopup("You have set you ladder parameters in such that you that brokerage is more then 40% of your extra cash!");
                          },
                        );
                      } else {
                        print("calling show ladder bottom sheet");
                        print(_stateProvider!.buySellQty);
                        print(_stateProvider!.buySellQtyController.text);
                        print(double.tryParse(_stateProvider!.buySellQtyController.text));

                        CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                          ReviewLadderDialogNew(
                            stockName: _stateProvider!
                                .ladderCreationParametersScreen1.clpTicker!,
                            stockExchange: _stateProvider!
                                .ladderCreationParametersScreen1
                                .clpExchange!,
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
                            setDefaultBuySellQty:  (double.tryParse(_stateProvider!.buySellQtyController.text) ?? _stateProvider!.buySellQty).toInt(), //_stateProvider!.buySellQty,
                            newLadder: true,
                            symSecurityCode: _stateProvider!
                                .ladderCreationParametersScreen1.clpTickerId,
                            stepSize: _stateProvider!.calculatedStepSize,
                            numberOfStepsAbove:
                            _stateProvider!.calculatedNumberOfStepsAbove,
                            numberOfStepsBelow: _stateProvider!.numberOfStepsBelow,
                            initialBuyQty: (_stateProvider!.selectedMode == "Prior Buy")
                                ?_stateProvider!.priorBuyInitialBuyQuantity.ceil():int.tryParse((_stateProvider!
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
                          ),
                          context,
                          height: 850,

                        ).then((dialogBoxResponse) async {
                          _isBtnClicked = false;
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
                                  height: 580 // + 80
                                  // height: (_stateProvider!.priorBuyAvailable[_stateProvider!.ladderCreationScreen1[_stateProvider!.index].clpTicker] == true)?580:500
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
                          _isBtnClicked = false;
                          print(err);
                        });
                      }


                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     _isBtnClicked = false;
                      //     print(
                      //         "here is the cashNeeded for you ${_stateProvider!.cashNeeded}");
                      //     return ReviewLadderDialog(
                      //       stockName: _stateProvider!
                      //           .ladderCreationParametersScreen1.clpTicker!,
                      //       tickerId: _stateProvider!
                      //           .ladderCreationParametersScreen1.clpTickerId!,
                      //       initialyProvidedTargetPrice:
                      //       _stateProvider?.targetPrice ?? 0.0,
                      //       initialPurchasePrice:
                      //       _stateProvider!.initialBuyPrice.toString(),
                      //       currentStockPrice:
                      //       _stateProvider!.initialBuyPrice.toString(),
                      //       allocatedCash: double.parse(
                      //           _stateProvider!.actualCashAllocated.toString()),
                      //       cashNeeded: _stateProvider!.cashNeeded,
                      //       isMarketOrder: true,
                      //       minimumPriceForUpdateLadder: _stateProvider!.minimumPrice,
                      //       setDefaultBuySellQty: _stateProvider!.buySellQty,
                      //       newLadder: true,
                      //       symSecurityCode: _stateProvider!
                      //           .ladderCreationParametersScreen1.clpTickerId,
                      //       stepSize: _stateProvider!.calculatedStepSize,
                      //       numberOfStepsAbove:
                      //       _stateProvider!.calculatedNumberOfStepsAbove,
                      //       numberOfStepsBelow: _stateProvider!.numberOfStepsBelow,
                      //       initialBuyQty: int.tryParse((_stateProvider!
                      //           .ladderCreationParametersScreen3
                      //           .clpInitialBuyQuantity
                      //           .text
                      //           .replaceAll(",", "")
                      //           .split(".")[0])) ??
                      //           0,
                      //       actualCashAllocated: _stateProvider!.actualCashAllocated,
                      //       actualInitialBuyCash: _stateProvider!.actualInitialBuyCash,
                      //       ladTargetPriceMultiplier:
                      //       _stateProvider!.targetPriceMultiplier,
                      //       // assignedCash: double.tryParse(_stateProvider!.ladderCreationParametersScreen1.clpInitialPurchasePrice!.text.replaceAll(",", "")) ?? 0.0,
                      //       assignedCash: double.tryParse(_stateProvider!.cashAllocatedControllerList[_stateProvider!.ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
                      //     );
                      //   },
                      // ).then((dialogBoxResponse) async {
                      //   refreshLadderActivities(currencyConstantsProvider);
                      //   print("Dialog $dialogBoxResponse");
                      //
                      //   if (dialogBoxResponse == "ladderCreated") {
                      //     if (_stateProvider!.index ==
                      //         _stateProvider!.ladderCreationScreen3.length - 1) {
                      //       if (_stateProvider!.index == 0) {
                      //         _tradeMainProvider!.updateTabBarIndex = 0;
                      //         print("hello from the if statement");
                      //         _navigationProvider.selectedIndex = 1;
                      //       }
                      //       _tradeMainProvider!.updateTabBarIndex = 0;
                      //       _navigationProvider.selectedIndex = 1;
                      //     } else {
                      //       // if (_stateProvider!.index == 0) {
                      //       //   Navigator.pop(context);
                      //       // }
                      //       _stateProvider!.index = _stateProvider!.index + 1;
                      //       // Navigator.push(
                      //       //   context,
                      //       //   MaterialPageRoute(
                      //       //     builder: (context) => LadderCreationOptionScreen(
                      //       //       indexOfLadder: _stateProvider!.index,
                      //       //       message: "Choose your ladder creation option",
                      //       //       navigationProvider: _navigationProvider,
                      //       //       createLadderEasyProvider: createLadderEasyProvider,
                      //       //       value:
                      //       //           _stateProvider, // Replace with the correct value object
                      //       //     ),
                      //       //   ),
                      //       // );
                      //
                      //       CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                      //           LadderCreationOptionScreenNew(
                      //             indexOfLadder: _stateProvider!.index,
                      //             message: "Choose your ladder creation option",
                      //             navigationProvider: _navigationProvider,
                      //             createLadderEasyProvider: createLadderEasyProvider,
                      //             value:
                      //             _stateProvider, // Replace with the correct value object
                      //           ),
                      //           context,
                      //           height: 500
                      //       );
                      //
                      //       _navigationProvider.selectedIndex = 5;
                      //       // showDialog(
                      //       //     context: context,
                      //       //     barrierDismissible: false,
                      //       //     builder: (context) {
                      //       //       return showLadderCreationOptionDialog(
                      //       //         _stateProvider!.index,
                      //       //           "Select Ladder creation option",
                      //       //           context,
                      //       //           value,
                      //       //           _navigationProvider,
                      //       //           createLadderEasyProvider);
                      //       //     },
                      //       //   );
                      //
                      //       // Navigator.of(context).pushReplacement(
                      //       //   MaterialPageRoute(
                      //       //     builder: (context) => CreateLadder4(),
                      //       //   ),
                      //       // );
                      //     }
                      //   }
                      // }).catchError((err) {
                      //   print(err);
                      // });
                    }
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
                        color: (themeProvider.defaultTheme)?Colors.white:Colors.black
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

  Widget buildCashNeedFormulaSection(BuildContext context, double screenWidth) {
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Cash Needed ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      "=  ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      "Order Size * Nb ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      '(',
                      style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w100),
                    ),
                    Column(
                      children: [
                        Text('Recent buy price', style: TextStyle(color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          width: 201,
                          child: Divider(
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
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
                        Text('2', style: TextStyle(color: Colors.black, fontSize: 16))
                      ],
                    ),
                    Text(
                      ')',
                      style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOrderSizeFormulaSection(BuildContext context, double screenWidth, bool ceilValue) {
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Order Size",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                        (themeProvider.defaultTheme) ? Colors.black : Colors.black,
                      ),
                    ),
                    Text(
                      "=  ",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                        (themeProvider.defaultTheme) ? Colors.black : Colors.black,
                      ),
                    ),
                    Text(
                      ceilValue ? "Ceil" : "FLOOR ",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                        (themeProvider.defaultTheme) ? Colors.black : Colors.black,
                      ),
                    ),
                    Text(
                      '(',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w100,
                        color:
                        (themeProvider.defaultTheme) ? Colors.black : Colors.black,
                      ),
                    ),
                    Column(
                      children: [
                        Text('Initial buy qty',
                            style: TextStyle(
                              fontSize: 16,
                              color: (themeProvider.defaultTheme)
                                  ? Colors.black
                                  : Colors.black,
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          width: 201,
                          child: Divider(
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
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
                                  ? Colors.black
                                  : Colors.black,
                            ))
                      ],
                    ),
                    Text(
                      ')',
                      style: TextStyle(
                          fontSize: 28,
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.black,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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

  Widget recommendedParameters() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              // "Recommended Parameters",
              (_stateProvider!.recommendedParametersNotAvailable[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] ?? true)
                  ?"Recommended Parameters (Not Available)"
                  :"Recommended Parameters",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Switch(
            value: _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] ?? false,
            onChanged: (bool value) {
              // Fluttertoast.showToast(msg: "These feature is currently locked");
              _stateProvider!.isRecommendedParametersEnabledScreen3[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] = value;

              print(_stateProvider!.isRecommendedParametersEnabledScreen3);

              if (_stateProvider!.recommendedParametersNotAvailable[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""] ?? true) {
                print("hello in the onChanged of the switch 1");
                Fluttertoast.showToast(
                  timeInSecForIosWeb: 3,
                    msg: "No Recommended Parameters available");
              } else {

                _stateProvider!.updateRecommendedParameterScreen3();
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
                        _navigationProvider.previousSelectedIndex = 3;
                        _navigationProvider.selectedIndex = 4;
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
