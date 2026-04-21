import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/constants/custom_colors_light.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/services/num_formatting.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/info_icon_display.dart';
import '../../global/widgets/my_text_field.dart';
import '../../kyc/widgets/custom_bottom_sheets.dart';
import '../models/add_funds_to_user_account_request.dart';
import '../services/funds_rest_api_service.dart';
import '../stateManagement/funds_provider.dart';
import '../widgets/withdrawal_option.dart';
import '../widgets/withdrawal_option_new.dart';

class AddFundsNewNew extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  const AddFundsNewNew(
      {super.key,
        this.isAuthenticationPresent = false,
        required this.updateIndex});

  @override
  State<AddFundsNewNew> createState() => _AddFundsNewNewState();
}

class _AddFundsNewNewState extends State<AddFundsNewNew> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late ThemeProvider themeProvider;
  late FundsProvider _fundsProvider;

  late CustomHomeAppBarProvider customHomeAppBarProvider;
  late NavigationProvider navigationProvider;
  late CurrencyConstants currencyConstants;
  late AppConfigProvider appConfigProvider;
  late TradeMainProvider tradeMainProvider;

  CustomHomeAppBarProvider? _customHomeAppBarProvider;
  TextEditingController paperFundsAmount = TextEditingController();

  bool _isBtnClicked = false;

  bool showFloatingActionBtn = false;

  FocusNode _paperAmountFocus = FocusNode();
  bool _paperAmountError = false;

  String addCashFieldError = "";

  bool showAddCashFieldError = false;

  final GlobalKey<FormState> _paperAmount = GlobalKey<FormState>();

  bool isNAVExpanded = false;

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  String username = "";

  void initState() {
    super.initState();
    _fundsProvider = Provider.of<FundsProvider>(context, listen: false);
    _fundsProvider.callInitialApi();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _fundsProvider = Provider.of<FundsProvider>(context, listen: false);

    // });

    _paperAmountFocus.addListener(_handlePaperAmountFocus);
    paperFundsAmount.addListener(_updateButtonState);

    SharedPreferences.getInstance().then((value) {
      setState(() {
        username = value.getString("reg_user") ?? "";
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      customHomeAppBarProvider =
          Provider.of<CustomHomeAppBarProvider>(context, listen: false);
      customHomeAppBarProvider.callInitialApi();

      TradeMainProvider tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: false);
      tradeMainProvider.getTradeMenuButtonsVisibilityStatus();
    });
  }

  void _handlePaperAmountFocus() {
    showFloatingActionBtn = _paperAmountFocus.hasFocus;
    _updateState();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _updateButtonState() {
    setState(() {
      // Update button state based on the text field value
    });
  }

  Future<void> addPaperFunds() async {
    try {
      await FundsRestApiService().addFundsToUserPaperAccount(
          AddFundsToUserAccountRequest(
              amount: paperFundsAmount.text.replaceAll(',', '')));

      await Provider.of<CustomHomeAppBarProvider>(context, listen: false)
          .fetchUserAccountDetails();
      await _fundsProvider.callInitialApi();

      // await _fundsProvider!.getAccountDetail();

      _isBtnClicked = false;
      Fluttertoast.showToast(msg: "Paper cash added successfully");
      _paperAmountError = true;
      _paperAmountFocus.unfocus();
      paperFundsAmount.clear();
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    customHomeAppBarProvider =
        Provider.of<CustomHomeAppBarProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    currencyConstants = Provider.of<CurrencyConstants>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);
    _fundsProvider = Provider.of<FundsProvider>(context, listen: true);

    return SafeArea(
      child: Center(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: screenWidth,
                child: Scaffold(
                  drawer:
                  // NavigationDrawerWidget(updateIndex: widget.updateIndex),
                  NavDrawerNew(updateIndex: widget.updateIndex),
                  key: _key,
                  // backgroundColor: Colors.red,
                  backgroundColor: (themeProvider.defaultTheme)
                      ? Color(0xfff0f0f0) //Color(0XFFF5F5F5)
                      : Color(0xFF15181F),
                  // appBar: PreferredSize(
                  //   preferredSize: Size.fromHeight(42),
                  //   child: AppBar(
                  //     backgroundColor: Color(0xff2C2C31),
                  //     leading: InkWell(
                  //       onTap: () {
                  //         _key.currentState!.openDrawer();
                  //       },
                  //       child: Icon(
                  //         Icons.menu,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     actions: [
                  //       // Icon(
                  //       //   Icons.lightbulb_outline,
                  //       //   color: Colors.white,
                  //       // ),
                  //
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  body: Stack(
                    children: [
                      Container(
                        color: (tradeMainProvider.tradingOptions == TradingOptions.simulationTradingWithSimulatedPrices)
                            ?Color(0xFF0066C0) // Colors.green
                            :(tradeMainProvider.tradingOptions == TradingOptions.simulationTradingWithRealValues)
                            ?Colors.yellow[800]
                            :(tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)
                            ?Colors.red
                            :Color(0xFF0066C0),
                        // color: Color(0xFF0066C0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 45,
                            ),
                            SizedBox(
                              height: 20, //65,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 10, right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi, ${username}",
                                    style: TextStyle(
                                      fontFamily: 'Britanica',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                      color: (themeProvider.defaultTheme)
                                          ?Color(0xfff0f0f0):Color(0xfff0f0f0),
                                    ),
                                  ),
                                  Text(
                                    "Welcome back",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xfff0f0f0)
                                      // color: (themeProvider.defaultTheme)
                                      //     ?Colors.black:Color(0x99f0f0f0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            // Stack(
                            //   children: [
                            //     Column(
                            //       children: [
                            //         // SizedBox(
                            //         //   height: 100,
                            //         // ),
                            //         SizedBox(
                            //           height: 10,
                            //         ),
                            //         buildMiddleValuesSection(context),
                            //         SizedBox(
                            //           height: 25,
                            //         ),
                            //         buildAddCashSection(context, screenWidth)
                            //       ],
                            //     ),
                            //     // buildNAVSection(context, screenWidth),
                            //   ],
                            // ),
                            SizedBox(
                              height: 40, //65,
                            ),

                            SizedBox(
                              height: 30, //65,
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [

                          SizedBox(
                            height: 45,
                          ),
                          SizedBox(
                            height: 20, //65,
                          ),

                          SizedBox(
                            height: 45,
                          ),
                          SizedBox(
                            height: 25, //65,
                          ),

                          buildCashSummarySection(context),
                        ],
                      ),

                      CustomHomeAppBarWithProviderNew(
                          backButton: false, leadingAction: _triggerDrawer),
                    ],
                  ),
                ),
              ),
            ),

            // CustomHomeAppBarWithProvider(
            //     backButton: false, leadingAction: _triggerDrawer),
          ],
        ),
      ),
    );
  }

  Widget buildAddCashSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add cash to your account",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: "Britanica",
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   "Enter amount",
          //   style: GoogleFonts.poppins(
          //     fontWeight: FontWeight.w300,
          //     fontSize: 13,
          //     // color: Color(0xfff8f8f9),
          //   ),
          // ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _paperAmount,
                child: SizedBox(
                  width: screenWidth - 130,
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
                    maxLength: 14,
                    elevation: 0,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    // textStyle: (themeProvider.defaultTheme)
                    //     ? TextStyle(color: Colors.black)
                    //     : kBodyText,
                    // borderColor: Color(0xff2c2c31),
                    margin: EdgeInsets.zero,
                    focusNode: _paperAmountFocus,
                    focusedBorderColor: (showAddCashFieldError)
                        ? Color(0xffd41f1f)
                        : Color(0xff5cbbff),
                    // validator: (value2) {
                    //   if (value2!.isEmpty) {
                    //     // return "* Required";
                    //     addCashFieldError = "* Required";
                    //     showAddCashFieldError = true;
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       setState(() {});
                    //     });
                    //     return null;
                    //   } else if (!RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$')
                    //       .hasMatch(value2)) {
                    //     emailFieldError = "Enter Correct Email Address";
                    //     showEmailFieldError = true;
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       setState(() {});
                    //     });
                    //     // return "Enter Correct Email Address";
                    //     return null;
                    //   } else {
                    //     emailFieldError = "";
                    //     showEmailFieldError = false;
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       setState(() {});
                    //     });
                    //     return null;
                    //   }
                    // },
                    counterText: "",
                    textInputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[0-9,\.]+$'),
                      ),
                      NumberToCurrencyFormatter()
                    ],
                    controller: paperFundsAmount,
                    borderRadius: 12,
                    labelText: '',
                    onChanged: (String) {},
                  ),
                ),
              ),
              CustomContainer(
                padding: 0,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                width: 100,
                height: 40,
                backgroundColor: (themeProvider.defaultTheme)
                    ?Colors.black
                    :Colors.white,
                borderRadius: 12,
                onTap:
                paperFundsAmount.text == "" && paperFundsAmount.text.isEmpty
                    ? null
                    : () {
                  if (!_isBtnClicked) {
                    _isBtnClicked = true;
                    if (paperFundsAmount.text != "" &&
                        paperFundsAmount.text.isNotEmpty &&
                        _paperAmount.currentState!.validate()) {
                      addPaperFunds();
                    }
                  }
                },
                child: Center(
                  child: Text("Add",
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: (themeProvider.defaultTheme)?Colors.white:Color(0xff141414),
                      )),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildCashSummarySection(BuildContext context) {

    double parseAndTrim(String? value) {
      if (value == null || value.isEmpty) return 0.0;
      return double.tryParse(value.trim()) ?? 0.0;
    }

    double totalCash = parseAndTrim(
        _fundsProvider.accountCashDetails?.data?.accountUnallocatedCash) +
        parseAndTrim(
            _fundsProvider.accountCashDetails?.data?.accountExtraCashLeft) +
        parseAndTrim(_fundsProvider
            .accountCashDetails?.data?.accountCashNeededForActiveLadders);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: CustomContainer(
        // borderColor: (themeProvider.defaultTheme)?Color(0xFF0066C0):Color(0xff2c2c31),
        borderColor: (themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31),
        backgroundColor: Colors.transparent,
        borderRadius: 16,
        paddingEdge: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        padding: 0,
        borderWidth: 2,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                // color: (themeProvider.defaultTheme)?Color(0xFF0066C0):Color(0xff2c2c31),
                color: (themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), // Top-left radius
                  topRight: Radius.circular(16), // Top-right radius
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 5.0, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Cash Summary",
                      style: TextStyle(
                        fontFamily: 'Britanica',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                      ),
                    )

                    // VerticalDivider(
                    //   color: Color(0xFF15181F),
                    //   thickness: 1,
                    // ),
                    //
                    // Column(
                    //   children: [
                    //     Text(
                    //         "Total Cash available",
                    //       style: GoogleFonts.poppins(
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w400,
                    //         color: Color(0xff8d8d8d),
                    //       ),
                    //     ),
                    //
                    //     Text(
                    //       "${amountToInrFormat(context, totalCash)}",
                    //       // amountToInrFormat(
                    //       //     context,
                    //       //     double.tryParse("500000" ??
                    //       //         "0.0")) ??
                    //       //     "N/A",
                    //       style: GoogleFonts.poppins(
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 16,
                    //         color: Color(0xfff0f0f0),
                    //       ),
                    //     ),
                    //
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
            Container(
              color: (themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16.0, bottom: 15),
                child: accountDetailsWidget(context),
              ),
            ),
            (tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)?Container():Divider(
              height: 1,
              // color: Color(0xff2c2c31),
              color: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xff474747),
              thickness: 1,
            ),
            (tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)?Container():Container(
              color: (themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10.0, bottom: 0, top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {

                        double screenWidth = screenWidthRecognizer(context);
                        CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                            buildAddCashBottomSheet(context, screenWidth),
                            context,
                            height: 260
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            size: 20,
                            color: Color(0xff0090FF),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Add cash",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff0090FF),
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      height: 50,
                      width: 1,
                      color: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xff474747),
                    ),

                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          // builder: (context) => const WithdrawalOptionDialogBox(),
                          builder: (context) => const WithdrawalOptionNew(),
                        ).then((onValue) {
                          print("after closing popup");
                          setState(() {

                          });
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 20,
                            color: Color(0xff0090FF),
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          Text(
                            "Withdraw",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff0090FF),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMiddleValuesSection(BuildContext context) {
    double parseAndTrim(String? value) {
      if (value == null || value.isEmpty) return 0.0;
      return double.tryParse(value.trim()) ?? 0.0;
    }

    double totalCash = parseAndTrim(
        _fundsProvider.accountCashDetails?.data?.accountUnallocatedCash) +
        parseAndTrim(
            _fundsProvider.accountCashDetails?.data?.accountExtraCashLeft) +
        parseAndTrim(_fundsProvider
            .accountCashDetails?.data?.accountCashNeededForActiveLadders);

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cash summary",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Britanica",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const WithdrawalOptionDialogBox(),
                    );
                  },
                  child: Text(
                    "Withdraw",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Britanica",
                        color: Color(0xff1a94f2)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          CustomContainer(
            borderColor: (themeProvider.defaultTheme)?Color(0xFF0066C0):Color(0xff2c2c31),
            backgroundColor: Colors.transparent,
            borderRadius: 16,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            padding: 0,
            borderWidth: 2,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: (themeProvider.defaultTheme)?Color(0xFF0066C0):Color(0xff2c2c31),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16), // Top-left radius
                      topRight: Radius.circular(16), // Top-right radius
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Total Cash left",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: (themeProvider.defaultTheme)?Colors.white:Color(0xff8d8d8d),
                              ),
                            ),
                            Text(
                              amountToInrFormat(
                                  context,
                                  double.tryParse(_fundsProvider
                                      .accountCashDetails
                                      ?.data
                                      ?.accountCashLeft ??
                                      "0.0")) ??
                                  "N/A",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xfff0f0f0),
                              ),
                            ),
                          ],
                        ),

                        // VerticalDivider(
                        //   color: Color(0xFF15181F),
                        //   thickness: 1,
                        // ),
                        //
                        // Column(
                        //   children: [
                        //     Text(
                        //         "Total Cash available",
                        //       style: GoogleFonts.poppins(
                        //         fontSize: 12,
                        //         fontWeight: FontWeight.w400,
                        //         color: Color(0xff8d8d8d),
                        //       ),
                        //     ),
                        //
                        //     Text(
                        //       "${amountToInrFormat(context, totalCash)}",
                        //       // amountToInrFormat(
                        //       //     context,
                        //       //     double.tryParse("500000" ??
                        //       //         "0.0")) ??
                        //       //     "N/A",
                        //       style: GoogleFonts.poppins(
                        //         fontWeight: FontWeight.w500,
                        //         fontSize: 16,
                        //         color: Color(0xfff0f0f0),
                        //       ),
                        //     ),
                        //
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: accountDetailsWidget(context),
                ),
                // Divider(
                //   color: Color(0xff2c2c31),
                //   thickness: 1,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 10, right: 10.0, bottom: 15, top: 5),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Row(
                //         children: [
                //           Icon(
                //             Icons.info_outline,
                //             size: 18,
                //             color: Color(0xffa2b0bc),
                //           ),
                //           SizedBox(
                //             width: 3,
                //           ),
                //           Text(
                //             "More info",
                //             style: GoogleFonts.poppins(
                //               fontSize: 14,
                //               fontWeight: FontWeight.w400,
                //               color: Color(0xff8d8d8d),
                //             ),
                //           )
                //         ],
                //       ),
                //
                //       // Row(
                //       //   children: [
                //       //     Icon(
                //       //       Icons.add,
                //       //       size: 12,
                //       //       color: Color(0xffa2b0bc),
                //       //     ),
                //       //
                //       //     SizedBox(
                //       //       width: 1,
                //       //     ),
                //       //
                //       //     Text(
                //       //       "add cash",
                //       //       style: GoogleFonts.poppins(
                //       //         fontSize: 12,
                //       //         fontWeight: FontWeight.w400,
                //       //         color: Color(0xff8d8d8d),
                //       //       ),
                //       //     )
                //       //   ],
                //       // ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget accountDetailsWidget(BuildContext context) {
    _customHomeAppBarProvider =
        Provider.of<CustomHomeAppBarProvider>(context, listen: true);

    double parseAndTrim(String? value) {
      if (value == null || value.isEmpty) return 0.0;
      return double.tryParse(value.trim()) ?? 0.0;
    }

    double totalCash = parseAndTrim(
        _fundsProvider.accountCashDetails?.data?.accountUnallocatedCash) +
        parseAndTrim(
            _fundsProvider.accountCashDetails?.data?.accountExtraCashLeft) +
        parseAndTrim(_fundsProvider
            .accountCashDetails?.data?.accountCashNeededForActiveLadders);
    List<List<dynamic>> totalCashItems = [
      [
        "(a)Un-alloc Cash",
        amountToInrFormat(
            context,
            double.tryParse(_fundsProvider
                .accountCashDetails?.data?.accountUnallocatedCash ??
                "0.0")),
        _customHomeAppBarProvider?.accountInfoBarFieldVisibility
            .showUnallocatedCashLeftForTrading ??
            false,
        'showUnallocatedCashLeftForTrading',
        "Cash not yet used in any ladder; available for creating new ladders or withdrawal.",
      ],
      [
        // "(b)Cash Needed for ladders",
        "(b)Cash Need for lad",
        amountToInrFormat(
            context,
            double.tryParse(_fundsProvider.accountCashDetails?.data
                ?.accountCashNeededForActiveLadders ??
                "0.0")),
        _customHomeAppBarProvider?.accountInfoBarFieldVisibility
            .showCashNeededForActiveLadders ??
            false,
        'showCashNeededForActiveLadders',
        "Funds reserved for upcoming buy trades in your ladders, ensuring future purchases are funded.",
      ],
      [
        "Extra cash(c)left/(d)generated",
        "${amountToInrFormat(context, double.tryParse(_fundsProvider.accountCashDetails?.data?.accountExtraCashLeft ?? "0.0")) ?? "N/A"}/${amountToInrFormat(context, double.tryParse(_fundsProvider.accountCashDetails?.data?.accountExtraCashGenerated ?? "0.0")) ?? "N/A"}",
        _customHomeAppBarProvider
            ?.accountInfoBarFieldVisibility.showExtraCash ??
            false,
        'showExtraCash',
        "Extra Cash Left: Cash generated from executed trades, available for new ladders or withdrawal. \n Extra Cash Generated: Total extra cash generated by the account to date",
      ],
      [
        "Extra cash equivalent gold",
        "0.0g",
        true,
        'showExtraCashEquivalentGod',
        "Extra cash equivalent gold",
      ],
    ];
    List<List<dynamic>> accountDetailsStrings = [
      [
        // "Cash for new ladders(a+c)",
        "Cash for new lad(a+c)",
        amountToInrFormat(
            context,
            double.tryParse(_fundsProvider
                .accountCashDetails?.data?.accountCashForNewLadders ??
                "0.0")) ??
            "N/A",
        _customHomeAppBarProvider
            ?.accountInfoBarFieldVisibility.showCashForNewLadders ??
            false,
        'showCashForNewLadders',
        "Cash for New Ladder refers to the total cash in your account that can be used to create new ladders. It is the sum of Unallocated Cash, which is yet to be utilized, and Extra Cash Left from the ladders.",
      ],
      [
        "Funds in play",
        amountToInrFormat(
            context,
            double.tryParse(_fundsProvider
                .accountCashDetails?.data?.accountFundsInPlay ??
                "0.0")) ??
            "N/A",
        _customHomeAppBarProvider
            ?.accountInfoBarFieldVisibility.showFundsInPlay ??
            false,
        'showFundsInPlay',
        "The total amount of money currently allocated to active ladders. It represents the portion of your capital that is presently being utilized in your trading strategy."
      ]
    ];

    return Column(
      children: [
        for (var details in accountDetailsStrings) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 34,
                    width: 24,
                    child: Checkbox(
                      value: details[2],
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          // setState(() {
                          // Update the respective visibility field dynamically
                          if (details[3] ==
                              'showUnallocatedCashLeftForTrading') {
                            _customHomeAppBarProvider
                                ?.accountInfoBarFieldVisibility
                                .showUnallocatedCashLeftForTrading = checked;
                          } else if (details[3] ==
                              'showCashNeededForActiveLadders') {
                            _customHomeAppBarProvider
                                ?.accountInfoBarFieldVisibility
                                .showCashNeededForActiveLadders = checked;
                          } else if (details[3] == 'showExtraCash') {
                            _customHomeAppBarProvider
                                ?.accountInfoBarFieldVisibility
                                .showExtraCash = checked;
                          } else if (details[3] == 'showCashForNewLadders') {
                            _customHomeAppBarProvider
                                ?.accountInfoBarFieldVisibility
                                .showCashForNewLadders = checked;
                          } else if (details[3] == 'showFundsInPlay') {
                            _customHomeAppBarProvider
                                ?.accountInfoBarFieldVisibility
                                .showFundsInPlay = checked;
                          }
                          _customHomeAppBarProvider!
                              .updateAccountInfoBarFieldVisibility(
                              _customHomeAppBarProvider!
                                  .accountInfoBarFieldVisibility);
                          // });
                        }
                      },
                      checkColor: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Color(0xff2c2c31), //Colors.black,
                      fillColor: WidgetStateColor.resolveWith((states) {
                        return states.contains(WidgetState.selected)
                            ? (themeProvider.defaultTheme)?Colors.blue:Colors.white // Selected color
                            : (themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31); //Colors.black; // Transparent when unselected
                      }),
                    ),
                  ),
                  SizedBox(width: 5),
                  Row(
                    children: [
                      Text(
                        details[0],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: (details[2])
                              ? (themeProvider.defaultTheme)
                              ?Colors.black:Color(0xfff0f0f0)
                              : Color(0xff8d8d8d),
                        ),
                        // style: fundsPageFontSize
                      ),
                      SizedBox(
                        width: 27,
                        height: 15,
                        child: InfoIconDisplay().infoIconDisplay(
                          context,
                          details[0],
                          details[4],
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),

              // Expanded(
              //   flex: 2,
              //   child:
              // ),
              Text(
                details[1],
                textAlign: TextAlign.end,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  // color: Color(0xfff0f0f0)
                  color:
                  (details[2])
                      ? (themeProvider.defaultTheme)
                      ?Colors.black:Color(0xfff0f0f0)
                      : Color(0xff8d8d8d),
                ),
              ),
              // Expanded(
              //   child: ,
              // ),
              // SizedBox(width: 5),
            ],
          ),
        ],
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // "Total cash available",
              "Cash available",
              style: GoogleFonts.poppins(
                // fontFamily: 'Britanica',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
              ),
            ),
            Text(
              "${amountToInrFormat(context, totalCash)}",
              // amountToInrFormat(
              //     context,
              //     double.tryParse("500000" ??
              //         "0.0")) ??
              //     "N/A",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14, //16,
                color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        IntrinsicHeight(
            child: Padding(
                // padding: const EdgeInsets.only(left: 15.0),
                padding: const EdgeInsets.only(left: 5.0),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.5),
                    child: Container(
                      width: 1, // Thickness of the vertical line
                      // height: double.infinity, // Make it stretch to fit the Column
                      color: (themeProvider.defaultTheme)?Colors.black:Colors.white, // Line color
                    ),
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var details in totalCashItems) ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            height: 1,
                                            width: 10,
                                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
                                        SizedBox(
                                          height: 34,
                                          width: 24,
                                          child: Checkbox(
                                            checkColor: (themeProvider.defaultTheme)
                                                ? Colors.white
                                                : Colors.black,
                                            value: details[2],
                                            onChanged: (bool? checked) {
                                              if (checked != null) {
                                                // setState(() {
                                                // Update the respective visibility field dynamically
                                                if (details[3] ==
                                                    'showUnallocatedCashLeftForTrading') {
                                                  _customHomeAppBarProvider
                                                      ?.accountInfoBarFieldVisibility
                                                      .showUnallocatedCashLeftForTrading =
                                                      checked;
                                                } else if (details[3] ==
                                                    'showCashNeededForActiveLadders') {
                                                  _customHomeAppBarProvider
                                                      ?.accountInfoBarFieldVisibility
                                                      .showCashNeededForActiveLadders =
                                                      checked;
                                                } else if (details[3] ==
                                                    'showExtraCash') {
                                                  _customHomeAppBarProvider
                                                      ?.accountInfoBarFieldVisibility
                                                      .showExtraCash = checked;
                                                } else if (details[3] ==
                                                    'showCashForNewLadders') {
                                                  _customHomeAppBarProvider
                                                      ?.accountInfoBarFieldVisibility
                                                      .showCashForNewLadders = checked;
                                                } else if (details[3] ==
                                                    'showFundsInPlay') {
                                                  _customHomeAppBarProvider
                                                      ?.accountInfoBarFieldVisibility
                                                      .showFundsInPlay = checked;
                                                }
                                                _customHomeAppBarProvider!
                                                    .updateAccountInfoBarFieldVisibility(
                                                    _customHomeAppBarProvider!
                                                        .accountInfoBarFieldVisibility);
                                                // });
                                              }
                                            },
                                            fillColor: WidgetStateColor.resolveWith(
                                                    (states) {
                                                  return states.contains(
                                                      WidgetState.selected)
                                                      ? (themeProvider.defaultTheme)?Colors.blue:Colors.white // Selected color
                                                      : (themeProvider.defaultTheme)?Colors.white:Colors
                                                      .black; // Transparent when unselected
                                                }),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Row(
                                          children: [
                                            Text(
                                              details[0].toString().replaceAll("/", "\n/ "),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                // color: Color(0xfff0f0f0),
                                                color: (details[2])
                                                    ? (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                                                    : Color(0xff8d8d8d),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 27,
                                              height: 27,
                                              child: InfoIconDisplay()
                                                  .infoIconDisplay(context,
                                                  details[0], details[4],
                                                  color: (themeProvider
                                                      .defaultTheme)
                                                      ? Colors.black
                                                      : Colors.white),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),

                                    // Expanded(
                                    //   flex: 2,
                                    //   child:
                                    // ),
                                    Text(
                                      (details[1].length < 16)
                                          ? details[1]
                                          .toString()
                                          .replaceAll("/", "\n/ ")
                                          : details[1]
                                          .toString()
                                          .replaceAll("/", "\n/ "),
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        // color: Color(0xfff0f0f0)
                                        color: (details[2])
                                            ? (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                                            : Color(0xff8d8d8d),
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: ,
                                    // ),
                                    // SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            ]
                          ]))
                ])))
      ],
    );
  }

  Widget buildNAVSection(BuildContext context, double screenWidth) {
    double positionValues =
        customHomeAppBarProvider.getUserAccountDetails?.data?.positionValues ??
            0.0;
    double unsoldStockCost = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountUnsoldStocksCost ??
        0.0);
    double cashNeededForActiveLadder = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountCashNeededForActiveLadders ??
        0.0);
    double cashNeededForInactiveLadder = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountCashNeededForInactiveLadders ??
        0.0);

    double cashForNewLadder = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountCashForNewLadders ??
        0.0);

    double netAssetValue =
        positionValues + cashForNewLadder + cashNeededForActiveLadder;

    if(tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash) {
      netAssetValue = positionValues + (customHomeAppBarProvider.getUserAccountDetails?.data?.accountTransactionCashLeft ?? 0.0);
    }

    double accountUnrealizedProfit = positionValues - unsoldStockCost;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: CustomContainer(
          paddingEdge: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          padding: 0,
          backgroundColor:
          Color(0xff163c5b), //Color(0xff1a94f2).withOpacity(0.3),
          borderRadius: 16,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isNAVExpanded = !isNAVExpanded;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "xxxxxx",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xffffffff),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "${amountToInrFormat(context, netAssetValue)}",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Color(0xfff0f0f0),
                                fontFamily: "Britanica"),
                          ),
                          Text(
                            "Primary (INR)",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: Color(0xffffffff).withOpacity(0.6)),
                          )
                        ],
                      ),
                      (isNAVExpanded)
                          ? Icon(Icons.keyboard_arrow_up)
                          : Icon(
                        Icons.keyboard_arrow_down,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                (isNAVExpanded)
                    ? Column(
                  children: [
                    _currencyFieldsWidget(
                        "Position Value", positionValues),

                    _currencyFieldsWidget(
                        "Unsold stocks cost",
                        customHomeAppBarProvider.getUserAccountDetails
                            ?.data?.accountUnsoldStocksCost),

                    _currencyFieldsWidget(
                      "Unrealized Profit",
                      accountUnrealizedProfit,
                    ),

                    _currencyFieldsWidget(
                        "Realized Profit",
                        customHomeAppBarProvider.getUserAccountDetails
                            ?.data?.accountRealizedProfit),

                    _currencyFieldsWidget("NAV", netAssetValue),

                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        children: [
                          if (Provider.of<CustomHomeAppBarProvider>(
                              context)
                              .accountInfoBarFieldVisibility
                              .showUnallocatedCashLeftForTrading)
                            _currencyFieldsWidget(
                                "(a)Unallocated cash",
                                customHomeAppBarProvider
                                    .getUserAccountDetails
                                    ?.data
                                    ?.accountUnallocatedCash),
                          if (Provider.of<CustomHomeAppBarProvider>(
                              context)
                              .accountInfoBarFieldVisibility
                              .showCashNeededForActiveLadders)
                            _currencyFieldsWidget(
                                "(b)Cash needed for ladders",
                                customHomeAppBarProvider
                                    .getUserAccountDetails
                                    ?.data
                                    ?.accountCashNeededForActiveLadders),
                          if (Provider.of<CustomHomeAppBarProvider>(
                              context)
                              .accountInfoBarFieldVisibility
                              .showExtraCash)
                            _extraCashWidget(
                                "Extra cash (c)left/(d)generated",
                                customHomeAppBarProvider
                                    .getUserAccountDetails
                                    ?.data
                                    ?.accountExtraCashLeft,
                                customHomeAppBarProvider
                                    .getUserAccountDetails
                                    ?.data
                                    ?.accountExtraCashGenerated),
                        ],
                      ),
                    ),

                    if (Provider.of<CustomHomeAppBarProvider>(context)
                        .accountInfoBarFieldVisibility
                        .showCashForNewLadders)
                      _currencyFieldsWidget(
                          "Cash for new ladders(a+c)",
                          customHomeAppBarProvider.getUserAccountDetails
                              ?.data?.accountCashForNewLadders),

                    if (Provider.of<CustomHomeAppBarProvider>(context)
                        .accountInfoBarFieldVisibility
                        .showFundsInPlay)
                      _currencyFieldsWidget(
                          "Funds in play",
                          customHomeAppBarProvider.getUserAccountDetails
                              ?.data?.accountFundsInPlay),

                    Divider(
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.white,
                      thickness: 2,
                      height: 13,
                      endIndent: 5,
                      indent: 5,
                    ),

                    // Divider(
                    //   color: Color(0xff2c2c31),
                    //   thickness: 1,
                    // ),

                    _unitsFieldWidget(
                        "Number of tickers",
                        customHomeAppBarProvider.getUserAccountDetails
                            ?.data?.accountSelectedTickersCount),

                    _unitsFieldWidget(
                        "Active ladders",
                        customHomeAppBarProvider.getUserAccountDetails
                            ?.data?.accountActiveLaddersCount),

                    _unitsFieldWidget(
                        "Inactive ladders",
                        customHomeAppBarProvider.getUserAccountDetails
                            ?.data?.accountInactiveLaddersCount),

                    _unitsFieldWidget(
                        "Cash Empty ladders",
                        customHomeAppBarProvider.getUserAccountDetails
                            ?.data?.accountCashEmptyCount),

                    _unitsFieldWidget(
                        "Trades",
                        customHomeAppBarProvider.getUserAccountDetails
                            ?.data?.accountUnsettledTradesCount),

                    _unitsFieldWidget(
                        "Orders",
                        customHomeAppBarProvider.getUserAccountDetails
                            ?.data?.accountOpenOrdersCount),
                  ],
                )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _currencyFieldsWidget(String title, double? value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
          Text(
            amountToInrFormat(context, value) ?? "N/A",
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _extraCashWidget(
      String title, double? extraCashGenerated, double? extraCashLeft) {
    String extraCash =
        "${amountToInrFormat(context, extraCashGenerated)}/${amountToInrFormat(context, extraCashLeft)}";
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
          Text(
            extraCash,
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _unitsFieldWidget(String title, int? value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
          Text(
            value != null ? intToUnits(value) : "N/A",
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddCashBottomSheet(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: (themeProvider.defaultTheme)
            ?Color(0xfff0f0f0)
            :Color(0xff1d1d1f),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: 22,
              ),

              Icon(
                Icons.money_outlined,
                color: Color(0xff0090ff),
                size: 35,
              ),

              SizedBox(
                height: 12,
              ),

              Text(
                "Add Cash",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Form(
                key: _paperAmount,
                child: SizedBox(
                  width: screenWidth - 32,
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
                    maxLength: 14,
                    elevation: 0,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    // textStyle: (themeProvider.defaultTheme)
                    //     ? TextStyle(color: Colors.black)
                    //     : kBodyText,
                    // borderColor: Color(0xff2c2c31),
                    margin: EdgeInsets.zero,
                    focusNode: _paperAmountFocus,
                    focusedBorderColor: (showAddCashFieldError)
                        ? Color(0xffd41f1f)
                        : Color(0xff5cbbff),
                    // validator: (value2) {
                    //   if (value2!.isEmpty) {
                    //     // return "* Required";
                    //     addCashFieldError = "* Required";
                    //     showAddCashFieldError = true;
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       setState(() {});
                    //     });
                    //     return null;
                    //   } else if (!RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$')
                    //       .hasMatch(value2)) {
                    //     emailFieldError = "Enter Correct Email Address";
                    //     showEmailFieldError = true;
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       setState(() {});
                    //     });
                    //     // return "Enter Correct Email Address";
                    //     return null;
                    //   } else {
                    //     emailFieldError = "";
                    //     showEmailFieldError = false;
                    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //       setState(() {});
                    //     });
                    //     return null;
                    //   }
                    // },
                    counterText: "",
                    textInputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[0-9,\.]+$'),
                      ),
                      NumberToCurrencyFormatter()
                    ],
                    controller: paperFundsAmount,
                    borderRadius: 8,
                    labelText: '',
                    onChanged: (String) {},
                  ),
                ),
              ),

              SizedBox(
                height: 22,
              ),



              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.5,
                          // color: Color(0xfff0f0f0)
                          color: Color(0xff0090ff)
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 22,
                  ),
                  //
                  CustomContainer(
                    // backgroundColor: (themeProvider.defaultTheme)
                    //     ?Colors.black
                    //     :Color(0xfff0f0f0),
                    backgroundColor: Color(0xff0090ff),
                    borderRadius: 12,
                    paddingEdge: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    padding: 0,
                    onTap: () {
                      Navigator.pop(context);
                      if (paperFundsAmount.text == "" && paperFundsAmount.text.isEmpty) {

                      } else {
                        if (!_isBtnClicked) {
                          _isBtnClicked = true;
                          if (paperFundsAmount.text != "" &&
                              paperFundsAmount.text.isNotEmpty &&
                              _paperAmount.currentState!.validate()) {
                            addPaperFunds();
                          }
                        }
                      }

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8.0),
                      child: Text(
                        "Confirm",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.5,
                            color: Color(0xfff0f0f0)
                            // color: (themeProvider.defaultTheme)
                            //     ?Color(0xfff0f0f0)
                            //     :Color(0xff1a1a25)
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 18,
                  ),
                ],
              ),


            ]
        ),
      ),
    );
  }
}
