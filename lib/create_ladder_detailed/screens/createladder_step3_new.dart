import 'dart:io';

import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/terms_info_contant.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/widgets/info_icon_display.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/services/num_formatting.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/text_form_field_input_decoration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/stateManagement/progress_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/progress_bar.dart';
import '../../localization/translation_keys.dart';

class CreateLadder3New extends StatefulWidget {
  const CreateLadder3New({super.key});

  @override
  State<CreateLadder3New> createState() => _CreateLadder3NewState();
}

class _CreateLadder3NewState extends State<CreateLadder3New> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CreateLadderProvider? _stateProvider;
  ThemeProvider? _themeProvider;
  late NavigationProvider _navigationProvider;
  late ThemeProvider themeProvider;
  bool cashLessWarning = false;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _initialBuyQtyFocus = FocusNode();
  TermsInfoConstant termsInfoConstant = TermsInfoConstant();
  bool _isBtnClicked = false;
  Color valueFieldColor = Color.fromARGB(255, 21, 24, 31);
  Color textOfValueFieldColor = Colors.white;
  late ProgressProvider progressProvider;
  late CurrencyConstants currencyConstantsProvider;

  bool showInitialBuyCashFormula = false;
  bool showBuyQtyFormula = false;

  final GlobalKey<TooltipState> cashAssignedTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> estInitialBuyCashTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> actualInitialBuyCashTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> buyQuantityTooltipKey = GlobalKey<TooltipState>();

  @override
  void initState() {
    super.initState();
    _stateProvider = Provider.of(context, listen: false);
    _themeProvider = Provider.of(context, listen: false);
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    _initialBuyQtyFocus.addListener(() {
      if (!_initialBuyQtyFocus.hasFocus) {
        _stateProvider!.resetIbqToEstInitialBuyCashQty();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {

      progressProvider = Provider.of(context, listen: false);
      progressProvider.updateProgress(0.6);

    });

  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    currencyConstantsProvider = Provider.of<CurrencyConstants>(context, listen: true);
    progressProvider = Provider.of<ProgressProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _stateProvider = Provider.of<CreateLadderProvider>(context, listen: true);

    return PopScope(
      onPopInvokedWithResult: ((value, result) async {

        if(_stateProvider!.selectedMode == "Prior Buy") {
          _navigationProvider.selectedIndex = 27;
        } else {
          _navigationProvider.selectedIndex = 5;
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

                              SizedBox(height: 10,),

                              buildTopInitialBuyPriceCard(context, screenWidth),

                              SizedBox(height: 10,),

                              buildConfigurationSection(context, screenWidth),

                              SizedBox(height: 10,),

                              initialBuyQtyWarning(context, screenWidth),

                              SizedBox(height: 10,),

                            ],
                          ),
                        ),

                        CustomHomeAppBarWithProviderNew(
                            backButton: false, leadingAction: _triggerDrawer),
                      ],
                    ),
                      bottomNavigationBar: buildCreateLadderStep3ButtonSection(context, screenWidth)
                  )
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
                    _navigationProvider.selectedIndex = 27;
                  } else {
                    _navigationProvider.selectedIndex = 5;
                  }



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
                  "${TranslationKeys.selectInitialBuy} (${_stateProvider!.ladderCreationParametersScreen1.clpTicker} (${_stateProvider!.ladderCreationParametersScreen1.clpExchange}))",
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
                showInitialBuyCashFormula = !showInitialBuyCashFormula;
                showBuyQtyFormula = !showBuyQtyFormula;
              });
            },
            child: Row(
              children: [

                (showInitialBuyCashFormula)?CustomContainer(
                  onTap: () {
                    setState(() {
                      showInitialBuyCashFormula = !showInitialBuyCashFormula;
                      showBuyQtyFormula = !showBuyQtyFormula;
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
                      showInitialBuyCashFormula = !showInitialBuyCashFormula;
                      showBuyQtyFormula = !showBuyQtyFormula;
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

  Widget buildTopInitialBuyPriceCard(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: CustomContainer(
        borderColor: (themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff2c2c31),
        borderRadius: 10,
        backgroundColor: Colors.transparent,
        child: Column(
          children: [

            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Row(
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
            ),

            Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6.0),
              child: CustomContainer(
                backgroundColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):Color(0xff1b1b1b),
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
                                controller: TextEditingController(text: "${currencyConstantsProvider.currency}${amountToInrFormatCLP(double.tryParse(_stateProvider!.ladderCreationParametersScreen2.clpCashAllocated!.text.isNotEmpty ? _stateProvider!.ladderCreationParametersScreen2.clpCashAllocated!.text.replaceAll(",", "") : "2.0") ?? 1.0, decimalDigit: 2)}"),
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

                      // SizedBox(
                      //   height: 12,
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                            children: [
                              Text(
                                TranslationKeys.estInitialBuyCash,
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
                                  estInitialBuyCashTooltipKey.currentState?.ensureTooltipVisible();
                                },
                                child: Tooltip(
                                  message: TranslationKeys.estInitialBuyCashDescription,
                                  key: estInitialBuyCashTooltipKey,
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
                                controller: TextEditingController(text: "${currencyConstantsProvider.currency}${amountToInrFormatCLP(_stateProvider!.estInitialBuyCash, decimalDigit: 2)}"),
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

                      // SizedBox(
                      //   height: 12,
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                            children: [
                              Text(
                                TranslationKeys.actualInitialBuyCash,
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
                                  actualInitialBuyCashTooltipKey.currentState?.ensureTooltipVisible();
                                },
                                child: Tooltip(
                                  key: actualInitialBuyCashTooltipKey,
                                  message: TranslationKeys.actualInitialBuyCashDescription,
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
                                controller: TextEditingController(text: "${currencyConstantsProvider.currency}${amountToInrFormatCLP(_stateProvider!.actualInitialBuyCash, decimalDigit: 2)}"),
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
                      )
                    ],
                  ),
                ),
              ),
            ),

            // (showInitialBuyCashFormula)?SizedBox(
            //   height: 15,
            // ):Container(),

            (showInitialBuyCashFormula)
                ?buildInitialBuyCashFormulaSection(context, screenWidth)
                :Container(),

            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget buildInitialBuyCashFormulaSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Column(
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
            height: 130,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/create_ladder_detailed/assets/images/big_formula_complete_bg_image.png'
                ), // Local image
                fit: BoxFit.fill, // Adjust the fit
              ), // Optional: Add rounded corners
              borderRadius: BorderRadius.circular(6.17),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Initial buy cash ",
                          style: TextStyle(
                            fontSize: 16,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        "=",
                        style: TextStyle(
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                        ),
                      ),
                      Column(
                        children: [
                          Text(' Cash allocated', style: TextStyle(
                            fontSize: 16,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                          )),
                        ],
                      ),
                      Text(
                        ' x ',
                        style: TextStyle(
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '(',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w100,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                            ),
                          ),
                          Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '2 x K - 2',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: 80,
                                child: Divider(
                                  color: (themeProvider.defaultTheme)
                                      ?Colors.black:Colors.black,
                                  indent: 10,
                                  thickness: 1,
                                  endIndent: 10,
                                  height: 1,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                '2 x K - 1',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            ')',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w100,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "K",
                        style: TextStyle(
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                        ),
                      ),
                      Text(
                        " = ",
                        style: TextStyle(
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                        ),
                      ),
                      Text(
                        "${amountToInrFormatCLP(_stateProvider!.targetPrice / _stateProvider!.initialBuyPrice, decimalDigit: 2)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 35,
                      ),
                      Text(
                        '(',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w100,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "K",
                        style: TextStyle(
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                        ),
                      ),
                      Text(
                        " = ",
                        style: TextStyle(
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                        ),
                      ),
                      Column(
                        children: [
                          Text('Target price', style: TextStyle(
                            fontSize: 16,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                          )),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            width: 120,
                            child: Divider(
                              color: (themeProvider.defaultTheme)
                                  ?Colors.black:Colors.black,
                              indent: 10,
                              thickness: 1,
                              endIndent: 10,
                              height: 1,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text('Initial buy price', style: TextStyle(
                            fontSize: 16,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                          ))
                        ],
                      ),
                      Text(
                        ')',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w100,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget buildConfigurationSection(BuildContext context, double screenWidth) {
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
          height: 8,
        ),

        buildBuyQuantitySection(context, screenWidth),

        SizedBox(
          height: 15,
        ),

        (showBuyQtyFormula)
            ?buildBuyQtyFormulaSection(context, screenWidth)
            :SizedBox(
              height: 15
            ),

        (showBuyQtyFormula)
            ?SizedBox(
              height: 15,
            ):Container(),

      ],
    );
  }

  Widget buildBuyQuantitySection(BuildContext context, double screenWidth) {

    double initialBuyCash = double.tryParse(_stateProvider!
        .ladderCreationParametersScreen2.initialBuyCash!.text
        .replaceAll(",", "")) ??
        0.0;
    double initialBuyPrice = _stateProvider!.initialBuyPrice;

// Calculate the result without flooring
    double result = initialBuyCash / initialBuyPrice;

// Print the result with two decimal places
//     print("Result: ${result.toStringAsFixed(2)}");

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
                    "${TranslationKeys.buyQuantity}",
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
                      buyQuantityTooltipKey.currentState?.ensureTooltipVisible();
                    },
                    child: Tooltip(
                      message: TranslationKeys.buyQuantityDescription,
                      key: buyQuantityTooltipKey,
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

                    controller: (_stateProvider!.selectedMode == "Prior Buy")
                        ?TextEditingController(text: _stateProvider!.priorBuyInitialBuyQuantity.floor().toString())
                        :_stateProvider!.initialBuyQtyController,
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
                    focusNode: _initialBuyQtyFocus,
                    prefixText: '',
                
                    onTap: () {
                
                      setState((){
                
                      });
                    },
                    counterText: "",
                    borderRadius: 8,
                    hintText: '',
                    onChanged: (inputInitialBuyQty) {
                      _stateProvider!.updateInitialBuyQuantity(
                        inputInitialBuyQty.replaceAll(',', ''),
                        _stateProvider!
                            .initialBuyQtyController.selection.baseOffset,
                      );
                      setState((){
                
                      });
                    },
                    onFieldSubmitted: (value) {
                
                    },
                  ),
                ),
              )

            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        // Padding(
        //   padding: const EdgeInsets.only(left: 22, right: 22.0),
        //   child: Row(
        //     children: [
        //       Text(
        //         "Selected Value: ${_stateProvider!.initialBuyQtyController.text}",
        //         style: GoogleFonts.poppins(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w400,
        //           color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        //
        // SizedBox(
        //     height: 5
        // ),
        //
        // buildBuyQuantitySlider(context, screenWidth),

        // SizedBox(
        //   height: 5,
        // ),
        //
        // Padding(
        //   padding: const EdgeInsets.only(left: 22, right: 22.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         "1",
        //         style: GoogleFonts.poppins(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w400,
        //           color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
        //         ),
        //       ),
        //
        //       Text(
        //         "${(result).floor()}",
        //         style: GoogleFonts.poppins(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w400,
        //           color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
        //         ),
        //       )
        //     ],
        //   ),
        // )

      ]
    );
  }

  Widget buildBuyQuantitySlider(BuildContext context, double screenWidth) {
    double initialBuyCash = double.tryParse(_stateProvider!
        .ladderCreationParametersScreen2.initialBuyCash!.text
        .replaceAll(",", "")) ??
        0.0;
    double initialBuyPrice = _stateProvider!.initialBuyPrice;

// Calculate the result without flooring
    double result = (initialBuyPrice != 0) ? initialBuyCash / initialBuyPrice : 0.0;

    double min = 1;
    double max = result.floor().toDouble();
    double targetPrice = double.parse(
        _stateProvider!.initialBuyQtyController.text.replaceAll(",", ""));
    // _stateProvider!.ladderCreationParametersScreen2.clpInitialBuyQuantity!.text.replaceAll(",", ""));
    if(targetPrice == 0) {
      targetPrice = 1;
    }

    // print("below are values of buildBuyQtySlider");
    // print(targetPrice);
    // print((targetPrice > max));
    // print((targetPrice < min));
    // print("lllllllll");
    // print((_stateProvider!.initialBuyQtyController.text.isEmpty));
    // print(min);
    // print(max);
    // print('targetPrice');
    // print(targetPrice);
    // print(result);
    return SizedBox(
      height: 15,
      child: Slider(
        inactiveColor: Color(0xff2c2c31),
        activeColor: Color(0xff47b2ff),
        value: (_stateProvider!.initialBuyQtyController.text.isEmpty)
            ? min
            : (targetPrice > max)
            ? max <= 1 ? 2 : max
            : (targetPrice < min)
            ? min
            : targetPrice,
        max: max <= 1 ? 2 : max,
        divisions:
        ((max - min) <= 0) ? 1 : int.parse((max - min).toStringAsFixed(0)),
        min: min,
        label: _stateProvider!.initialBuyQtyController.text,
        onChanged: (double value) {
          print("inside on change");
          print(value);
          _stateProvider!.initialBuyQtyController.value = TextEditingValue(
            text: value.toString(),
            selection: TextSelection.fromPosition(TextPosition(
                offset: _stateProvider!
                    .initialBuyQtyController.selection.baseOffset)),
          );

          _stateProvider!.ladderCreationParametersScreen2.clpInitialBuyQuantity!.value = TextEditingValue(
            text: value.toString(),
            selection: TextSelection.fromPosition(TextPosition(
                offset: _stateProvider!
                    .initialBuyQtyController.selection.baseOffset)),
          );

          print("below is value of initialBuyQtyController");
          print(_stateProvider!.initialBuyQtyController.text);



          _stateProvider!.updateInitialBuyQuantity(
            _stateProvider!.initialBuyQtyController.text.replaceAll(',', ''),
            _stateProvider!.initialBuyQtyController.selection.baseOffset,
          );
        },
      ),
    );
  }

  Widget buildBuyQtyFormulaSection(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TranslationKeys.formula,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Color(0xffa2b0bc),
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
                    "Buy Qty",
                    style: TextStyle(color: Colors.black,fontSize: 16),
                  ),
                  Text(
                    " = ",
                    style: TextStyle(color: Colors.black,fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        "FLOOR ",
                        style: TextStyle(color: Colors.black,fontSize: 16),
                      ),
                      Text(
                        '(',
                        style: TextStyle(color: Colors.black,fontSize: 28, fontWeight: FontWeight.w100),
                      ),
                      Column(
                        children: [
                          Text('Initial buy cash', style: TextStyle(color: Colors.black,fontSize: 16)),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            width: 120,
                            child: Divider(
                              color: (themeProvider.defaultTheme)
                                  ?Colors.black:Colors.black,
                              indent: 10,
                              thickness: 1,
                              endIndent: 10,
                              height: 1,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text('Initial buy price', style: TextStyle(color: Colors.black,fontSize: 16))
                        ],
                      ),
                      Text(
                        ')',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget initialBuyQtyWarning(BuildContext context, double screenWidth) {
    return (_stateProvider!.initialBuyQtyWarning != "")?Container(
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
              _stateProvider!.initialBuyQtyWarning,
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

  Widget buildCreateLadderStep3ButtonSection(BuildContext context, double screenWidth) {
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
                //     ?Color(0xfff0f0f0):Color(0xffa8a8a8),
                onTap: () async {

                  double initialBuyQty = 0;
                  if (_stateProvider!.initialBuyQtyController.text != "") {
                    initialBuyQty = double.parse(_stateProvider!
                        .initialBuyQtyController.text
                        .replaceAll(",", "")
                        .replaceAll(" ", ""));
                  }

                  if (_stateProvider!.actualInitialBuyCash <= 0 || initialBuyQty <= 0) {
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
                      print("inside _isBtnClicked");
                      print(_stateProvider!.cashAllocatedWarning.length);
                      print(_stateProvider!.initialBuyQtyWarning.length);
                      if (_stateProvider!.cashAllocatedWarning.length == 0 &&
                          _stateProvider!.initialBuyQtyWarning.length == 0) {
                        _isBtnClicked = true;
                        _stateProvider!.updateInitialBuyQuantityEvenly();
                        _stateProvider!.calculateOptimalParameters();
                        // _stateProvider!.updateLimitCashNeeded(false);
                        // _stateProvider!.updateCeilingBuySellQtyBool = true;
                        _navigationProvider.selectedIndex = 7;
                        // Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                        //   _isBtnClicked = false;
                        //   _stateProvider!.updateLimitCashNeeded(false);
                        //   return CreateLadder4();
                        // })));
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
