import 'dart:io';

import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/F_Funds/stateManagement/funds_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/ladder_creation_screen1.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/ladder_details_request.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/ladder_details_response.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
// import 'package:dozen_diamond/prior_buy_create_ladder/stateManagement/create_ladder_provider.dart' as prior_buy;
import 'package:dozen_diamond/create_ladder_detailed/services/rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_easy/stateManagement/create_ladder_easy_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/services/num_formatting.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/global/services/stock_price_listener.dart';
import 'package:dozen_diamond/kyc/widgets/custom_bottom_sheets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZI_Search/stateManagement/search_provider.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../create_ladder/screens/show_ladder_creation_option_dialog_new.dart';
import '../../global/stateManagement/progress_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/progress_bar.dart';
import '../../localization/translation_keys.dart';

class CreateLadderSelectStockNew extends StatefulWidget {
  const CreateLadderSelectStockNew({super.key});

  @override
  State<CreateLadderSelectStockNew> createState() => _CreateLadderSelectStockNewState();
}

class _CreateLadderSelectStockNewState extends State<CreateLadderSelectStockNew> {

  double progressBarFillValue = 0;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CreateLadderProvider? stateProvider;
  // prior_buy.CreateLadderProvider? priorBuyStateProvider;
  SearchProvider? searchProvider;
  FundsProvider? _fundsProvider;
  late NavigationProvider _navigationProvider;
  late ThemeProvider themeProvider;
  late ProgressProvider progressProvider;
  late CurrencyConstants currencyConstants;
  late CreateLadderProvider createLadderProvider;
  // late prior_buy.CreateLadderProvider? priorBuyCreateLadderProvider;
  late TradeMainProvider tradeMainProvider;

  StockPriceListener? _stockPriceListener;
  RestApiService restApiService = RestApiService();
  bool isListReorderable = true;
  TextStyle normalHead = TextStyle(
    fontSize: 16,
  );
  bool _isBtnClicked = false;

  Map<String, LaddersDetail>? ladderDetails = {};

  double minFontSize = 14;

  late CreateLadderEasyProvider createLadderEasyProvider;

  InputDecoration cashAllocatedTextFormFieldDecoration = InputDecoration(
    prefixIcon: Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 0.0),
      child: CurrencyIcon(
        color: Colors.white,
        size: 15,
      ),
    ), // White icon
    hintText: 'Enter amount',

    hintStyle: TextStyle(color: Colors.white), // White hint text
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // White border when enabled
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // White border when focused
    ),
    border: OutlineInputBorder(),
  );
  void initState() {
    super.initState();
    stateProvider = Provider.of(context, listen: false);
    // priorBuyStateProvider = Provider.of(context, listen: false);
    _fundsProvider = Provider.of(context, listen: false);
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    _stockPriceListener = Provider.of(context, listen: false);
    stateProvider!.index = 0;
    // priorBuyStateProvider!.index = 0;
    callInitialApi();
    // callInitialApiPriorBuy();
    // progressProvider = Provider.of(context, listen: false);
    // progressProvider.updateProgress(0.2);
    WidgetsBinding.instance.addPostFrameCallback((_) {

      progressProvider = Provider.of(context, listen: false);
      progressProvider.updateProgress(0.2);

    });
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

Future<void> callInitialApi() async {
  try {
    searchProvider = Provider.of(context, listen: false);
    
    // First, get stock recommendations
    await stateProvider!.stockRecommendationParameters(searchProvider!.selectedStockList.data!);
    
    // Then fetch user stocks and ladders
    bool hasError = await stateProvider!.getUserStockAndLadder();
    
    // Don't navigate away - let the widget handle empty/error states
    if (hasError) {
      // The error is already set in the provider, just log it
      print("API returned error or empty state");
      // Don't navigate, stay on current page
      // The Consumer widget will show the error/empty state automatically
    } else {
      // Success case - update parameters
      stateProvider!.updateRecommendedParameter();
      // stateProvider!.updateRecommendedParameterScreen3();
    }
  } on HttpApiException catch (err) {
    print("something gone wrong: ${err.errorSuggestion}");
    // Set the error in the provider so the UI can display it
    if (stateProvider != null) {
      stateProvider!.apiErrorMessage = err.errorSuggestion;
    }
    // Don't navigate - stay on current page
  } catch (e) {
    print("Unexpected error: $e");
    if (stateProvider != null) {
      stateProvider!.apiErrorMessage = e.toString();
    }
    // Don't navigate - stay on current page
  }
}

  // Future<void> callInitialApiPriorBuy() async {
  //   try {
  //
  //     searchProvider = Provider.of(context, listen: false);
  //     await priorBuyStateProvider!.stockRecommendationParameters(searchProvider!.selectedStockList.data!);
  //
  //     bool stockListEmpty = await priorBuyStateProvider!.getUserStockAndLadder();
  //
  //     if (stockListEmpty) {
  //       print("inside shtiss");
  //
  //       _navigationProvider.selectedIndex = 3;
  //       Fluttertoast.showToast(msg: "Empty selected stock");
  //       Navigator.canPop(context);
  //
  //     } else {
  //       priorBuyStateProvider!.updateRecommendedParameter();
  //       // stateProvider!.updateRecommendedParameterScreen3();
  //     }
  //   } on HttpApiException catch (err) {
  //     print("something gone wrong");
  //     print(err.errorTitle);
  //   }
  // }

  void updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<LadderDetailsResponse> _getLadderDetails(
      LadderDetailsRequest ladderDetailsRequest) async {
    try {
      LadderDetailsResponse value =
      await RestApiService().getLadderDetails(ladderDetailsRequest);
      ladderDetails![ladderDetailsRequest.ladId!.toString()] = value!.laddersDetail!;
      createLadderProvider.existingLadderExpandedBool[ladderDetailsRequest.ladId!.toString()] = false;
      return value!; // ladderDetails = value!.laddersDetail;
    } on HttpApiException catch (err) {
      print(err.errorTitle);
      return LadderDetailsResponse();
    }
  }

  Future<void> _deleteUserStockFromCreationStockList(int? userClipID) async {
    restApiService
        .deleteUserStockFromCreationStockList(userClipID)
        .then((value) {
      Fluttertoast.showToast(
          msg: "Stock excluded from ladder creation process");
      callInitialApi();
    }).catchError((err) {
      print(err);
      if (kDebugMode || kIsWeb) {
        print(userClipID);

        stateProvider!.ladderCreationScreen1.removeWhere((value) {
          return (value.clpStockId == userClipID);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = screenWidthRecognizer(context);
    stateProvider = Provider.of<CreateLadderProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    createLadderProvider =
        Provider.of<CreateLadderProvider>(context, listen: true);
    createLadderEasyProvider =
        Provider.of<CreateLadderEasyProvider>(context, listen: true);
    progressProvider = Provider.of<ProgressProvider>(context, listen: true);
    currencyConstants = Provider.of<CurrencyConstants>(context, listen: true);
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);

    return PopScope(
      onPopInvokedWithResult: ((value, result) {
        _navigationProvider.selectedIndex = 3;
        // _navigationProvider.selectedIndex =
        //     _navigationProvider.previousSelectedIndex;
        // return false;
      }),
      canPop: false,
      // onWillPop: () async {
      //   _navigationProvider.selectedIndex =
      //       _navigationProvider.previousSelectedIndex;
      //   return false;
      // },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          bottom: (kIsWeb)?true:(Platform.isIOS)?false:true,
            child: Center(
                child: Stack(
                  children: [
                    Center(
                        child: Container(
                          width: screenWidth,
                          child: Scaffold(
                            drawer: const NavDrawerNew(),
                            key: _key,
                            // backgroundColor: Colors.red,
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
                                        height: 20,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 16.0),
                                        child: ProgressBar(),
                                      ),

                                      SizedBox(height: 20),

                                      buildTopHeadingSection(context, screenWidth),

                                      SizedBox(height: 10),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 16.0),
                                        child: Divider(
                                          color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc), // Color(0xff2c2c31),
                                        ),
                                      ),

                                      SizedBox(height: 10),

                                      buildCashValuesSection(context, screenWidth),

                                      buildStockListSection(context, screenWidth),

                                      SizedBox(height: 20),

                                      InkWell(
                                        onTap: () {
                                          _navigationProvider.selectedIndex = 3;
                                          // _navigationProvider.selectedIndex = _navigationProvider.previousSelectedIndex;
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            Icon(
                                              Icons.add,
                                              color: Color(0xff1a94f2),
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),

                                            Text(
                                              TranslationKeys.addMoreStocks,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.5,
                                                color: Color(0xff1a94f2)
                                              ),
                                            ),
                                          ],
                                        ),
                                      )


                                    ],
                                  ),
                                ),

                                CustomHomeAppBarWithProviderNew(
                                    backButton: false, leadingAction: _triggerDrawer),
                              ],
                            ),
                            bottomNavigationBar: Container(
                              height: 60,
                                color: Colors.transparent,
                                child: buildSelectModeBottomSection(context, screenWidth)
                            ),

                          ),
                        )
                    ),
                  ],
                )
            )
        ),
      ),
    );
  }

  Widget buildTopHeadingSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  print("below is previouse index");
                  print(_navigationProvider.previousSelectedIndex);
                  // _navigationProvider.selectedIndex = _navigationProvider.previousSelectedIndex;
                  _navigationProvider.selectedIndex = 3; //_navigationProvider.previousSelectedIndex;
                },
                child: Icon(
                  Icons.arrow_back,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  size: 24,
                ),
              ),

              SizedBox(
                width: 10,
              ),

              Container(
                width: screenWidth * 0.8,
                child: Text(
                  TranslationKeys.reviewAndCustomizeYourLadderSetup.tr,
                  style: TextStyle(
                    fontFamily: 'Britanica',
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 8,
          ),

          Text(
            TranslationKeys.setYourStockOrderAndCashAllocationBeforeFinalizingYourLadder,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
            ),
          )
        ],
      ),
    );
  }

  Widget buildCashValuesSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationKeys.unallocatedCashForNewLadders,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                ),
              ),

              Text(
                amountToInrFormat(
                    context, stateProvider!.accountCashForNewLadders) ??
                    "N/A",
                  // amountToInrFormat(
                  //     context, stateProvider!.accountUnallocatedCash) ??
                  //     "N/A",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 5
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationKeys.extraCashGeneratedLeft.tr,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                ),
              ),

              Text(
                "${amountToInrFormat(context, stateProvider?.accountExtraCashGenerated ?? 0.0)}/${amountToInrFormat(context, stateProvider?.accountExtraCashLeft ?? 0.0)}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 8,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationKeys.unassignedCash.tr,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),

              Consumer<CreateLadderProvider>(builder: (context, value, child) {
                double cashForNewLadders = value.accountCashForNewLadders ?? 0.0;
                double assignedCash = value.sumOfAssignedCashForLadder ?? 0.0;

                double result = cashForNewLadders - assignedCash;
                  return Text(
                    "${amountToInrFormat(context, result)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    ),
                  );
                }
              ),
            ],
          ),

          SizedBox(
            height: 8,
          ),

        ],
      ),
    );
  }

  Widget buildSelectModeBottomSection(BuildContext context, double screenWidth) {
    return Consumer<CreateLadderProvider>(
        builder: (_, value, __) {
          if (value.ladderCreationScreen1.isEmpty) {
            return Center(child: Container(
              height: 1,
            ));
          }
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
                  padding: const EdgeInsets.only(top: 10, bottom: 13.0),
                  child: CustomContainer(
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    borderRadius: 12,
                    backgroundColor: (themeProvider.defaultTheme)
                        ?Colors.black:Color(0xfff0f0f0),
                    onTap: () async {

                      // ----------------------------
                      // double sum = 0;
                      // for (int i = 0;
                      // i < stateProvider!.cashAllocatedControllerList.length;
                      // i++) {
                      //   String textValue =
                      //       stateProvider?.cashAllocatedControllerList[i].text ??
                      //           "0.0";
                      //   print("Text value at index $i: ${textValue.runtimeType}");
                      //
                      //   double parsedValue =
                      //       double.tryParse(textValue.replaceAll(",", "")) ?? 0.0;
                      //
                      //   sum += parsedValue;
                      //   stateProvider?.updateSumOfAssignedCashForLadder = sum;
                      //   print("Parsed value: $parsedValue");
                      //   print(sum);
                      //   print(stateProvider!.accountUnallocatedCash);
                      //   if (sum >
                      //       (stateProvider!.accountUnallocatedCash ?? 0.0)) {
                      //     print("inside if");
                      //     stateProvider!.insufficientCashAllocated = true;
                      //   } else {
                      //     print("inside else");
                      //
                      //     stateProvider!.insufficientCashAllocated = false;
                      //   }
                      // }
                      //
                      // // Check if the sum exceeds the limit
                      // if (stateProvider!.sumOfAssignedCashForLadder! >
                      //     (stateProvider?.accountCashForNewLadders ?? 0.0)) {
                      //   stateProvider!.isLimitExceeding = true;
                      // } else {
                      //   stateProvider!.isLimitExceeding = false;
                      // }

                      // -------------------------------------------

                      double cashForNewLadders =
                          stateProvider!.accountCashForNewLadders ?? 0.0;
                      double assignedCash =
                          stateProvider!.sumOfAssignedCashForLadder ?? 0.0;

                      double unAssignedCash = cashForNewLadders - assignedCash;
                      if (stateProvider!.insufficientCashAllocated) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return warningMessageDialog(
                                "You have allocated more cash than available. Please adjust the allocation to fit within your available cash",
                                context);
                          },
                        );
                      } else if (unAssignedCash < 0) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return warningMessageDialog(
                                "In Sufficient Cash", context);
                          },
                        );
                      } else {
                        print("help is here ${value.ladderCreationScreen1.length}");

                        await stateProvider!.changeCashAllocated();

                      // String ladderCreationType =
                      //     await SharedPreferenceManager.getLadderCreationType() ??
                      //         "";

                      // if (ladderCreationType == 'beginner') {
                      //   createLadderEasyProvider.ladderDetailsList.clear();

                      //   for (int i = 0;
                      //       i < value.ladderCreationScreen1.length;
                      //       i++) {
                      //     createLadderEasyProvider.ladderDetailsList
                      //         .add(LadderDetails(
                      //       ladTickerId: value.ladderCreationScreen1[i].clpTickerId,
                      //       ladTicker: value.ladderCreationScreen1[i].clpTicker,
                      //       ladInitialBuyPrice: value.ladderCreationScreen1[i]
                      //           .clpInitialPurchasePrice!.text,
                      //       ladCashAllocated:
                      //           value.cashAllocatedControllerList[i].text,
                      //     ));
                      //   }

                      //   _navigationProvider.previousSelectedIndex =
                      //       _navigationProvider.selectedIndex;
                      //   _navigationProvider.selectedIndex = 8;
                      // } else if (ladderCreationType == 'custom') {

                        // below is code that i commented

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => LadderCreationOptionScreen(
                      //       indexOfLadder: value.index,
                      //       message: "Choose your ladder creation option",
                      //       navigationProvider: _navigationProvider,
                      //       createLadderEasyProvider: createLadderEasyProvider,
                      //       value: value, // Replace with the correct value object
                      //     ),
                      //   ),
                      // );

                        CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                            LadderCreationOptionScreenNew(
                              indexOfLadder: value.index,
                              message: "Choose your ladder creation option",
                              navigationProvider: _navigationProvider,
                              createLadderEasyProvider: createLadderEasyProvider,
                              value: value, // Replace with the correct value object
                            ),
                            context,
                            height: 580 // + 80,
                            // height: (createLadderProvider.priorBuyAvailable[createLadderProvider.ladderCreationScreen1[value.index].clpTicker] == true)?580:500
                        );

                      // above is the code that i commented
                      // } else {
                      //   _navigationProvider.previousSelectedIndex =
                      //       _navigationProvider.selectedIndex;
                      //   _navigationProvider.selectedIndex = 5;
                      // }
                    }

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
                      child: Text(
                          TranslationKeys.selectMode,
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: (themeProvider.defaultTheme)
                                ?Color(0xfff0f0f0)
                                :Color(0xff000000),
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
    );
  }

  List<bool> showEditPriceField = List<bool>.generate(12, (index) => false);

  Widget itemIsBeingDraggedStyle(
      Widget child, int index, Animation<double> animation) {
    return Material(
      color: Color(0xFF0099CC).withOpacity(0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        color: Colors.transparent,
        child: child,
      ),
      elevation: 0, // Elevation for shadow effect
    );
  }

  Widget buildStockListSection(BuildContext context, double screenWidth) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Consumer<CreateLadderProvider>(
        builder: (context, value, child) {
                  if (value.apiErrorMessage != null && value.apiErrorMessage!.isNotEmpty) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Error Title
                  Text(
                    "Unable to Load Stocks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
                  // Error Message (from API)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      value.apiErrorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        
          if (value.ladderCreationScreen1.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    ),
                  ),
                ),
              ],
            );
          }
          return isListReorderable
              ? Container(
            height: MediaQuery.of(context).size.height * 0.45,
            margin: EdgeInsets.all(18),
            child: ReorderableListView(
              onReorder: value.reorderStocksInList,
              proxyDecorator: itemIsBeingDraggedStyle,

              children: [
                for (int stockListIndex = 0;
                stockListIndex < value.ladderCreationScreen1.length;
                stockListIndex++)
                  buildCashAllocationCard(
                    context,
                    screenWidth,
                    value.ladderCreationScreen1,
                    value.ladderCreationScreen1[stockListIndex],
                    value.index,
                    stockListIndex,
                  ),
              ],
            ),
          )
              : Container(
            // height: MediaQuery.of(context).size.height * 0.6,
            margin: EdgeInsets.all(18),
            child: ListView(
              children: [
                for (int stockListIndex = 0;
                stockListIndex < value.ladderCreationScreen1.length;
                stockListIndex++)
                  buildCashAllocationCard(
                      context,
                      screenWidth,
                      value.ladderCreationScreen1,
                      value.ladderCreationScreen1[stockListIndex],
                      value.index,
                      stockListIndex),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCashAllocationCard(
      BuildContext context,
      double screenWidth,
      List<LadderCreationScreen1> listofData,
      LadderCreationScreen1 stockLadderProvData,
      int valueIndex,
      int stockListIndex) {
    return Padding(
      key: Key("$stockListIndex"),
      padding: const EdgeInsets.only(top: 10.0),
      child: CustomContainer(
        paddingEdge: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        padding: 0,
        backgroundColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):Color(0xff1d1d1f),
        borderColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):Color(0xff2c2c31),
        borderRadius: 10,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: screenWidth * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${stockLadderProvData.clpTicker ?? "Stock name NA"}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                                  ),
                                ),

                                CustomContainer(
                                  backgroundColor: Color(0xff3a2d7f),
                                  borderRadius: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8.0,
                                      top: 3,
                                      bottom: 3,
                                    ),
                                    child: Text(
                                      // "BSE",
                                      stockLadderProvData.clpExchange ?? "",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xfff0f0f0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            (showEditPriceField[stockListIndex])
                                ? Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width:
                                    130, // Adjust the width of the TextFormField here
                                    child: TextFormField(
                                      controller:
                                      stockLadderProvData.clpInitialPurchasePrice,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          // RegExp(r'^[0-9,\.]+$'),
                                          RegExp(r'^\d{1,9}(,\d{9})*(\.\d*)?$'),
                                        ),
                                        // NumberToCurrencyFormatter()
                                      ],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: (themeProvider.defaultTheme)
                                              ? Colors.black
                                              : Colors.white), // Text color is white
                                      decoration:
                                      cashAllocatedTextFormFieldDecoration.copyWith(
                                        fillColor: (themeProvider.defaultTheme)
                                            ? Colors.white
                                            : Colors.transparent,
                                        filled: true,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 0.0),
                                          child: CurrencyIcon(
                                            color: (themeProvider.defaultTheme)
                                                ? Colors.black
                                                : Colors.white,
                                            size: 15,
                                          ),
                                        ), // White icon
                                        hintText: 'Enter price',

                                        hintStyle: TextStyle(
                                            color: (themeProvider.defaultTheme)
                                                ? Colors.black
                                                : Colors.white), // White hint text
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (themeProvider.defaultTheme)
                                                  ? Colors.white
                                                  : Colors
                                                  .white), // White border when enabled
                                        ),

                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (themeProvider.defaultTheme)
                                                  ? Colors.white
                                                  : Colors
                                                  .white), // White border when focused
                                        ),
                                        contentPadding: EdgeInsets
                                            .zero, // Remove padding inside the TextFormField
                                      ),
                                      onChanged: (value) {
                                        stateProvider!.updateTargetPriceMultiplier(
                                          stateProvider!.ladderCreationParametersScreen1
                                              .targetPriceMultiplier[stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
                                          stateProvider!.ladderCreationParametersScreen1
                                              .targetPriceMultiplier[stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text.length,
                                        );
                                      },
                                      onFieldSubmitted: (value) {},
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          showEditPriceField[stockListIndex] = false;
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                      ))
                                ])
                                : Row(
                              children: [
                                Text(
                                  stockLadderProvData.clpInitialPurchasePrice!.text,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                                  ),
                                ),
                                SizedBox(width: 5),
                                (tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)?Container():InkWell(
                                    onTap: () {
                                      setState(() {
                                        showEditPriceField[stockListIndex] = true;
                                      });
                                    },
                                    child: Icon(
                                        Icons.edit,
                                        size: 16,
                                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                                    ))
                              ],
                            )
                          ]
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        width: screenWidth * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${TranslationKeys.cashAllocated}:",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                              )
                            ),

                            SizedBox(
                              height: 30,
                              width: screenWidth * 0.3,
                              child: MyTextField(
                                isFilled: true,
                                fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Colors.transparent,
                                labelText: "",
                                maxLength: 14,
                                elevation: 0,
                                controller: stateProvider
                                    ?.cashAllocatedControllerList[listofData[stockListIndex].clpTickerId],
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
                                borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                                margin: EdgeInsets.zero,
                                contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                                focusedBorderColor: Color(0xff5cbbff),
                                showLeadingWidget: false  ,
                                showTrailingWidget: false,

                                prefixText: currencyConstants.currency,

                                counterText: "",
                                borderRadius: 8,
                                hintText: '',
                                onChanged: (value) {
                                  double sum = 0;

                                  // Loop through all the controllers and sum the values
                                  for (int i = 0;
                                  i < stateProvider!.cashAllocatedControllerList.length;
                                  i++) {
                                    String textValue =
                                        stateProvider?.cashAllocatedControllerList[listofData[i].clpTickerId]!.text ??
                                            "0.0";
                                    print("Text value at index $i: ${textValue.runtimeType}");

                                    double parsedValue =
                                        double.tryParse(textValue.replaceAll(",", "")) ?? 0.0;

                                    sum += parsedValue;
                                    stateProvider?.updateSumOfAssignedCashForLadder = sum;
                                    print("Parsed value: $parsedValue");
                                    if (sum >
                                        (stateProvider!.accountCashForNewLadders ?? 0.0)) {
                                      stateProvider!.insufficientCashAllocated = true;
                                    } else {
                                      stateProvider!.insufficientCashAllocated = false;
                                    }
                                  }

                                  // Check if the sum exceeds the limit
                                  if (stateProvider!.sumOfAssignedCashForLadder! >
                                      (stateProvider?.accountCashForNewLadders ?? 0.0)) {
                                    stateProvider!.isLimitExceeding = true;
                                  } else {
                                    stateProvider!.isLimitExceeding = false;
                                  }
                                },
                                onFieldSubmitted: (value) {
                                  if (!value.contains('.')) {
                                    // Add .00 if the number doesn't have decimal points
                                    stateProvider?.cashAllocatedControllerList[stockLadderProvData.clpTickerId]!
                                        .text = value + ".00";
                                  } else if (RegExp(r'^\d+(\.\d{1})$').hasMatch(value)) {
                                    // Add one zero if the number has only one decimal digit
                                    stateProvider?.cashAllocatedControllerList[stockLadderProvData.clpTickerId]!
                                        .text = value + "0";
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ] // Icon(
                    //   Icons.drag_indicator,
                    //   size: 18,
                    //   color: Color(0xffa2b0bc),
                    // ),
                  ),

                  (kIsWeb == false)?Icon(
                    Icons.drag_indicator,
                    size: 18,
                    color: Color(0xffa2b0bc),
                  ):Container(),



                  Padding(
                    padding: (kIsWeb)
                        ?EdgeInsets.only(right: 25.0, bottom: 5)
                        :EdgeInsets.only(right: 0.0),
                    child: InkWell(
                      onTap: () {
                        if (listofData.length == 1) {
                          stateProvider!
                              .removeSingleStockAndLadders(stockListIndex);
                          _navigationProvider.selectedIndex = 3;
                        } else {
                          stateProvider!
                              .removeSingleStockAndLadders(stockListIndex);
                        }
                      },
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xffa2b0bc),
                      ),
                    ),
                  )
                ],
              ),

              (stockLadderProvData.ladderDetails == null)
                  ?Container()
                  :(stockLadderProvData.ladderDetails!.length > 0)
                  ?Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: buildReviewLadderTextSection(context, screenWidth, stockLadderProvData,),
                  )
                  :Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReviewLadderTextSection(BuildContext context, double screenWidth, LadderCreationScreen1 stockLadderProvData,) {
    if(ladderDetails!.isEmpty) {

      for(int i=0; i<stockLadderProvData.ladderDetails!.length; i++) {
        ladderDetails!.clear();
        print("before calling _getLadderDetails");
        _getLadderDetails(LadderDetailsRequest(
            ladId: stockLadderProvData
                .ladderDetails?[i].ladId));
      }

    }



    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "${stockLadderProvData.ladderDetails!.length} ${TranslationKeys.laddersAlreadyCreated} ",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              fontSize: 12,
              color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
          ),
        ),

        InkWell(
          onTap: () {
            CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                buildReviewLadderBottomSheet(
                  context, screenWidth, stockLadderProvData,
                ),
                context,
                height: 400
            );
          },
          child: Text(
            " ${TranslationKeys.view}",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xff47b2ff)
            ),
          ),
        )
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

  Widget buildReviewLadderBottomSheet(BuildContext context, double screenWidth, LadderCreationScreen1 stockLadderProvData) {

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: (themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: StatefulBuilder(
          builder: (context, setState) {
          return Column(
            children: [

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "${TranslationKeys.existingLadders} (${stockLadderProvData.ladderDetails!.length})",
                      style: TextStyle(
                        fontFamily: 'Britanica',
                        fontSize: 18,
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

              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10.0),
                child: Divider(
                  thickness: 1,
                  color: Color(0xff808083),
                ),
              ),

              SizedBox(
                height: 8,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "${TranslationKeys.stock}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        "${stockLadderProvData.clpTicker}-${stockLadderProvData.clpTickerId}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16.0),
                child: Container(
                  height: 200,
                  width: screenWidth,
                  child: ListView.separated(
                    itemCount: stockLadderProvData.ladderDetails!.length, // Number of items in the list
                    itemBuilder: (context, index) {

                      // ladderDetails = value!.laddersDetail;
                      // _getLadderDetails(LadderDetailsRequest(
                      //     ladId: stockLadderProvData
                      //         .ladderDetails?[index].ladId));

                      return buildExistingLaddersCard(
                          context,
                          screenWidth,
                          index,
                          ladderDetails![stockLadderProvData.ladderDetails?[index].ladId!.toString()]!,
                          stockLadderProvData.ladderDetails?[index].ladId!.toString() ?? ""
                      ); //ladderDetails!);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomContainer(
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      borderRadius: 12,
                      backgroundColor: (themeProvider.defaultTheme)
                          ?Colors.black:Color(0xfff0f0f0),
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8.0),
                        child: Text(
                            TranslationKeys.okay,
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              color: (themeProvider.defaultTheme)
                                  ?Color(0xfff0f0f0)
                                  :Color(0xff000000),
                            )
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }

  Widget buildExistingLaddersCard(
      BuildContext context,
      double screenWidth,
      int index,
      LaddersDetail ladderDetailss,
      String ladId
      ) {
    return Consumer<CreateLadderProvider>(
        builder: (context, createLadderProviderConsumer, child) {
        return CustomContainer(
          paddingEdge: EdgeInsets.zero,
          padding: 0,
          margin: EdgeInsets.zero,
          backgroundColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):Color(0xff1d1d1f),
          borderRadius: 10,
          borderWidth: 0,
          onTap: () {
            print("below is after on click");
            print(ladId);
            print(createLadderProviderConsumer.existingLadderExpandedBool[ladId]);

            if(createLadderProviderConsumer.existingLadderExpandedBool[ladId] == false) {
              print("inside if");
              setState(() {
                createLadderProviderConsumer.existingLadderExpandedBool[ladId] = true;
              });

            } else {
              print("inside else");
              setState(() {
                createLadderProviderConsumer.existingLadderExpandedBool[ladId] = false;
              });

            }

            print("after changing value");
            print(createLadderProviderConsumer.existingLadderExpandedBool[ladId]);

          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12.0),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${TranslationKeys.ladder} 00${index+1} ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                                    ),
                                  ),
                                  Text(
                                    "(${ladderDetailss.ladStatus ?? ""})",
                                    // " (${TranslationKeys.active})",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                                    ),
                                  )
                                ],
                              ),

                              Text(
                                "${TranslationKeys.currentPrice}: ${amountToInrFormat(context, double.parse(ladderDetailss.ladInitialPurchasePrice ?? "0.0"))}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xff47b2ff),
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          width: screenWidth * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${TranslationKeys.cashAllocated}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                                ),
                              ),

                              Text(
                                "${amountToInrFormat(context, double.parse(ladderDetailss.ladCashInitialAllocated ?? "0.0"))}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),

                    (createLadderProviderConsumer.existingLadderExpandedBool[ladId] == true)?Icon(
                      Icons.keyboard_arrow_up_outlined
                    ):Icon(
                        Icons.keyboard_arrow_down_outlined
                    )
                  ],
                ),

                (createLadderProviderConsumer.existingLadderExpandedBool[ladId] == true)?SizedBox(
                  height: 10,
                ):Container(),

                (createLadderProviderConsumer.existingLadderExpandedBool[ladId] == true)?Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${TranslationKeys.initialBuyQuantity}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                                ),
                              ),

                              Text(
                                "${ladderDetailss.ladInitialBuyQuantity ?? "0.0"}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${TranslationKeys.targetPrice}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                                ),
                              ),

                              Text(
                                "${amountToInrFormat(context, double.parse(ladderDetailss.ladTargetPrice ?? "0.0"))}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                                ),
                              )
                            ],
                          ),
                        ),


                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${TranslationKeys.minimumPrice}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                                ),
                              ),

                              Text(
                                "${amountToInrFormat(context, double.parse(ladderDetailss.ladMinimumPrice ?? "0.0"))}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${TranslationKeys.stepSize}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                                ),
                              ),

                              Text(
                                "${amountToInrFormat(context, double.parse(ladderDetailss.ladStepSize ?? "0.0"))}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                                ),
                              )
                            ],
                          ),
                        ),


                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${TranslationKeys.defaultBuySellQuantity}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                                ),
                              ),

                              Text(
                                "${ladderDetailss.ladDefaultBuySellQuantity ?? "0"}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                                ),
                              )
                            ],
                          ),
                        ),


                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                  ],
                ):Container(),




              ],
            ),
          )
        );
      }
    );
  }
}
