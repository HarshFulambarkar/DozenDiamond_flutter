import 'dart:io';
import 'package:dozen_diamond/global/widgets/selected_stock_warning_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/my_text_field.dart';
import '../../kyc/widgets/custom_bottom_sheets.dart';
import '../../watchlist/stateManagement/watchlist_provider.dart';
import '../models/selected_stock_model.dart';
import '../stateManagement/search_provider.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';
import '../../socket_manager/model/ddstock_socket_data_response.dart';

class SearchPageNew extends StatefulWidget {
  final Function updateIndex;
  final bool refreshProviderState;

  const SearchPageNew({
    super.key,
    required this.updateIndex,
    required this.refreshProviderState
  });

  @override
  State<SearchPageNew> createState() => _SearchPageNewState();
}

class _SearchPageNewState extends State<SearchPageNew> {
  late ThemeProvider themeProvider;
  late SearchProvider searchProvider;
  late NavigationProvider _navigationProvider;
  late WatchlistProvider watchlistProvider;
  late WebSocketServiceProvider webSocketServiceProvider;
  CurrencyConstants? _currencyConstantsProvider;
  late CreateLadderProvider createDetailedLadderProvider;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();

  bool showSearchField = false;
  bool showSelectedStockSection = false;

  final GlobalKey _firstShowcaseWidget = GlobalKey();
  final GlobalKey _lastShowcaseWidget = GlobalKey();

  List<Map<String, dynamic>> ladderStepInfoList = [
    {
      'icon': Icons.add_circle_outline,
      'title': "Select stocks",
      'message': "Choose the stock and mode you want to trade using a ladder strategy."
    },
    {
      'icon': Icons.money,
      'title': "Set Price Levels",
      'message': "Define price points where you want to place buy and sell orders and the step size."
    },
    {
      'icon': Icons.analytics_outlined,
      'title': "Configure Order Details",
      'message': "Specify the order quantity and execution preferences."
    },
    {
      'icon': Icons.check,
      'title': "Review & Confirm",
      'message': "Double-check your ladder setup, adjust if needed, and place the orders."
    },
  ];

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  bool showSelectedStock = true;

  // FIXED: Method specifically for SelectedTickerModel
// FIXED: Method that works with your actual stock model
Future<void> addToWatchlistViaWebSocket(List<dynamic> stocks) async {
  if (stocks.isEmpty) return;
  
  List<int> tickerIds = [];
  
  for (var stock in stocks) {
    Map<dynamic, dynamic> stockMap;
    
    if (stock is Map) {
      stockMap = stock;
    } else {
      // Try to convert to JSON map if it has toJson method
      try {
        final jsonResult = stock.toJson();
        if (jsonResult is Map) {
          stockMap = jsonResult;
        } else {
          print("toJson did not return a Map");
          continue;
        }
      } catch (e) {
        print("Error converting stock to JSON: $e");
        continue;
      }
    }
    
    // Try all possible property names based on your actual data
    int? tickerId = stockMap['ss_ticker_id'] ??      // From your log: ss_ticker_id: 5820
                    stockMap['tickerId'] ?? 
                    stockMap['wlTickerId'] ?? 
                    stockMap['ticker_id'];
    
    String? tickerName = stockMap['ss_ticker']?.toString() ??      // From your log: ss_ticker: 7NR
                         stockMap['ticker']?.toString() ?? 
                         stockMap['wlTicker']?.toString() ?? 
                         stockMap['ticker_name']?.toString();
    
    String? tickerExchange = stockMap['ss_exchange']?.toString() ??   // From your log: ss_exchange: BSE
                             stockMap['tickerExchange']?.toString() ?? 
                             stockMap['wlExchange']?.toString() ?? 
                             stockMap['ticker_exchange']?.toString();
    
    String? issuerName = stockMap['ss_issuer_name']?.toString() ?? 
                         stockMap['tickerIssuerName']?.toString() ?? 
                         stockMap['issuerName']?.toString() ?? 
                         stockMap['ticker_issuer_name']?.toString();
    
    if (tickerId == null) {
      print("Could not find tickerId in stock: $stockMap");
      print("Available keys: ${stockMap.keys}");
      continue;
    }
    
    print("Found stock - ID: $tickerId, Name: $tickerName, Exchange: $tickerExchange");
    
    // Check if stock already exists in watchlist
    bool exists = webSocketServiceProvider.ddWatchlistStockList
        .any((item) => item.tickerId == tickerId);
    
    if (!exists) {
      tickerIds.add(tickerId);
      
      // Add to local list immediately for UI update
      final newStock = DdStock(
        tickerName: tickerName ?? '',
        tickerExchange: tickerExchange ?? '',
        issuerName: issuerName ?? '',
        tickerId: tickerId,
      );
      
      webSocketServiceProvider.ddWatchlistStockList.add(newStock);
      print("Added stock to local watchlist: ${newStock.tickerName}");
    } else {
      print("Stock already exists in watchlist: $tickerId");
    }
  }
  
  if (tickerIds.isNotEmpty) {
    print("Sending WebSocket message to add tickerIds: $tickerIds");
    
    // Send WebSocket message to add stocks
    webSocketServiceProvider.sendMessage({
      "add": true,
      "tickerIds": tickerIds,
    });
    
    // Remove from removed list if they were previously removed
    for (var tickerId in tickerIds) {
      webSocketServiceProvider.removeFromRemovedList(tickerId);
    }
    
    if (mounted) {
      Fluttertoast.showToast(
        msg: '${tickerIds.length} stock(s) added to watchlist',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  } else {
    print("No new stocks to add - all already in watchlist");
    if (mounted) {
      Fluttertoast.showToast(
        msg: 'Stocks already in watchlist',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }
}

    // Method to remove stocks from watchlist
  // Future<void> removeFromWatchlistViaWebSocket(List<SelectedTickerModel> stocks) async {
  //   if (stocks.isEmpty) return;
    
  //   List<int> tickerIds = [];
    
  //   for (var stock in stocks) {
  //     tickerIds.add(stock.tickerId!);
      
  //     // Remove from local list immediately for UI update
  //     webSocketServiceProvider.ddWatchlistStockList
  //         .removeWhere((item) => item.tickerId == stock.tickerId);
  //   }
    
  //   if (tickerIds.isNotEmpty) {
  //     // Send WebSocket message to remove stocks
  //     webSocketServiceProvider.sendMessage({
  //       "remove": true,
  //       "tickerIds": tickerIds,
  //     });
      
  //     // Add to removed list
  //     for (var tickerId in tickerIds) {
  //       webSocketServiceProvider.addToRemovedList(tickerId);
  //     }
      
  //     if (mounted) {
  //       Fluttertoast.showToast(
  //         msg: '${tickerIds.length} stock(s) removed from watchlist',
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //       );
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _currencyConstantsProvider = Provider.of<CurrencyConstants>(context, listen: false);
      createDetailedLadderProvider = Provider.of<CreateLadderProvider>(context, listen: false);
      
      // Initialize WebSocket provider
      webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(context, listen: false);
      
      prepareScreen();
    });
  }



 Future<void> prepareScreen() async {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.fetchWatchList();
    await searchProvider.getSelectedStockList(_currencyConstantsProvider!);
    searchProvider.searchingStockByNameNew(searchProvider.currentPage);
    searchProvider.getSectorList();
    double screenWidth = screenWidthRecognizer(context);

    _navigationProvider = Provider.of<NavigationProvider>(context, listen: false);

    print("inside prepareScreen");
    print(createDetailedLadderProvider.showLadderIntroToolTip);
    if(createDetailedLadderProvider.showLadderIntroToolTip) {
      createDetailedLadderProvider.showLadderIntroToolTip = false;
      Future.delayed(const Duration(milliseconds: 1000), () {
        print("before calling tooltips");
        ShowCaseWidget.of(_key.currentContext!).startShowCase([_one, _two, _three, _four, _five]);
      });
    }

    final value = false;
    
    if(value == false) {
      setState(() {
        searchProvider.showStockListSection = true;
        showSelectedStockSection = true;
      });
    } else {
      setState(() {
        searchProvider.showStockListSection = false;
        showSelectedStockSection = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

 @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    searchProvider = Provider.of<SearchProvider>(context, listen: true);
    watchlistProvider = Provider.of<WatchlistProvider>(context, listen: true);
    
    // IMPORTANT: Listen to WebSocket provider for real-time updates
    webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(context, listen: true);
    
    createDetailedLadderProvider = Provider.of<CreateLadderProvider>(context, listen: true);
    createDetailedLadderProvider.ladderCreationScreen1.clear();
    createDetailedLadderProvider.ladderCreationScreen2.clear();
    createDetailedLadderProvider.ladderCreationScreen3.clear();
    _navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return SafeArea(
      bottom: (kIsWeb) ? true : (Platform.isIOS) ? false : true,
      child: Center(
        child: Stack(
          children: [
            Center(
              child: Container(
                color: (themeProvider.defaultTheme)
                    ? Color(0XFFF5F5F5)
                    : Colors.transparent,
                width: screenWidth,
                child: ShowCaseWidget(
                  hideFloatingActionWidgetForShowcase: [_lastShowcaseWidget],
                  onStart: (index, key) {
                    print('onStart: $index, $key');
                  },
                  onComplete: (index, key) {
                    print('onComplete: $index, $key');
                    if(index == 1) {
                      setState(() {
                        showSearchField = true;
                      });
                    } else {
                      setState(() {
                        showSearchField = false;
                      });
                    }
                    if(index == 2) {
                      setState(() {
                        showSelectedStockSection = true;
                      });
                    } else {
                      setState(() {
                        showSelectedStockSection = false;
                      });
                    }
                    if (index == 5) {
                      SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle.light.copyWith(
                          statusBarIconBrightness: Brightness.dark,
                          statusBarColor: Colors.white,
                        ),
                      );
                    }
                  },
                  blurValue: 1,
                  autoPlayDelay: const Duration(seconds: 3),
                  globalTooltipActionConfig: const TooltipActionConfig(
                    position: TooltipActionPosition.inside,
                    alignment: MainAxisAlignment.spaceBetween,
                    actionGap: 20,
                  ),
                  builder: (context) {
                    return Scaffold(
                      drawer: NavDrawerNew(updateIndex: widget.updateIndex),
                      key: _key,
                      backgroundColor: (themeProvider.defaultTheme)
                          ? Color(0xfff0f0f0)
                          : Color(0xFF15181F),
                      body: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 45),
                              SizedBox(height: 10),
                              (showSearchField)
                                  ? Showcase(
                                      titleAlignment: Alignment.topLeft,
                                      descriptionAlignment: Alignment.bottomLeft,
                                      titleTextStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xff484848)
                                      ),
                                      descTextStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xff333333)
                                      ),
                                      key: _three,
                                      title: 'Search for stocks',
                                      description: "Type the name of the stock you want. You can also add multiple stocks at a time.",
                                      child: buildSearchField(context, screenWidth)
                                  ) : buildTopSection(context, screenWidth),
                              SizedBox(height: 15),
                              (searchProvider.showStockListSection)
                                  ? Expanded(child: buildStockListSection(context, screenWidth))
                                  : SingleChildScrollView(child: buildLadderStepInfoSection(context, screenWidth)),
                            ],
                          ),
                          CustomHomeAppBarWithProviderNew(
                            backButton: false, 
                            leadingAction: _triggerDrawer
                          ),
                        ],
                      ),
                      bottomNavigationBar: (showSelectedStockSection)
                          ? buildBottomSheetSection(context, screenWidth)
                          : Container(height: 0),
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildTopSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Create Ladders",
            style: TextStyle(
              fontFamily: 'Britanica',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
            ),
          ),

          Row(
            children: [
              Showcase(

                titleAlignment: Alignment.topLeft,
                descriptionAlignment: Alignment.bottomLeft,
                titleTextStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff484848)
                ),
                descTextStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xff333333)
                ),
                key: _one,
                title: 'Search for stocks',
                description: 'Click the search icon here and add the stocks you want to create ladders for.',
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showSearchField = true;
                    });

                    SharedPreferenceManager.saveIsFirstTimeOnLadderPage(false);

                    setState(() {
                      searchProvider.showStockListSection = true;
                      showSelectedStockSection = true;
                    });

                    searchProvider.searchBarFocus.requestFocus();
                  },
                  child: Icon(
                    Icons.search,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    size: 24,
                  ),
                ),
              ),

              SizedBox(
                width: 10,
              ),

              InkWell(
                onTap: () async {
                  setState(() {
                    searchProvider.showStockListSection = !searchProvider.showStockListSection;
                    showSelectedStockSection = !showSelectedStockSection;
                  });

                },
                child: Icon(
                  Icons.info_outline,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  size: 22,
                ),
              ),

              SizedBox(
                width: 10,
              ),

              InkWell(
                onTap: () async {
                  // await showDialog(
                  //   context: context,
                  //   builder: (ctx) => filterDialogbox(context),
                  //   barrierDismissible: false);

                  CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                      buildFilterBottomSheet(context, screenWidth),
                      context,
                      height: 350
                  );

                },
                child: Icon(
                  Icons.filter_list,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  size: 24,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildStockListSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "All stocks",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 12,
        ),

        // Expanded(
        //     child:
        // )

        Expanded(
            child: buildStockList(context, screenWidth)
        ),

        (!searchProvider.isLoading)
            ? searchedStockPaginationBtns(screenWidth)
            : Container(),

      ],
    );
  }

  Widget buildStockList(BuildContext context, double screenWidth) {

    return (searchProvider.isLoading)
        ? const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    )
        : ListView.separated(
      // physics: BouncingScrollPhysics(),
      // shrinkWrap: true,
      itemCount: searchProvider.tickerList.length, // 10, //watchlistProvider.searchedStockList.length,
      itemBuilder: (context, index) {

        return buildStockCard(context, screenWidth, index);
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10,
        );
      },
    );
  }

  Widget buildStockCard(BuildContext context, double screenWidth, int index) {
    return CustomContainer(
      backgroundColor: (themeProvider.defaultTheme)
          ?Colors.white
          :Color(0xff2c2c31).withOpacity(0.39),
      borderRadius: 0,
      padding: 0,
      margin: EdgeInsets.zero,
      paddingEdge: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    if(searchProvider
                        .tickerList[index].isSelected == false) {
                      print("tap");
                      print(searchProvider.isBtnClicked);
                      if (!searchProvider.isBtnClicked) {
                        searchProvider.isBtnClicked = true;
                        await searchProvider
                            .updateSelectedStockListNew(
                            index, context);
                      }
                    }

                  },
                  child: Row(
                    children: [
                      Text(
                        searchProvider
                            .tickerList[index].ticker,
                        // "NTPC",
                        // stock.ticker ?? "",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)
                              ?Colors.black:Color(0xfff0f0f0),
                        ),
                      ),

                      CustomContainer(
                        backgroundColor: Color(0xff3a2d7f),
                        borderRadius: 20,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8.0, top: 3, bottom: 3),
                          child: Text(
                            searchProvider
                                .tickerList[index].tickerExchange,
                            // "BSE",
                              // stock.tickerExchange ?? "",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color(0xfff0f0f0),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 3,
                ),

                Text(
                  searchProvider
                      .tickerList[index].tickerIssuerName,
                  // "NTPC Limited",
                  // '${stock.tickerIssuerName ?? ""}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)
                        ?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),

            Row(
              children: [
                searchProvider
                    .tickerList[index].isSelected
                    ?Icon(
                  Icons.check_circle,
                  color: Color(0xff1a94f2),
                  size: 22,
                ):InkWell(
                  onTap: () async {
                    print("tap");
                    print(searchProvider.isBtnClicked);
                    if (!searchProvider.isBtnClicked) {
                      searchProvider.isBtnClicked = true;
                      await searchProvider
                          .updateSelectedStockListNew(
                          index, context);
                    }
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xff1a94f2),
                    size: 22,
                  ),
                )


              ],
            )
          ],
        ),
      ),
    );
  }

  // UPDATED: Bottom sheet with corrected Add to Watchlist button
  Widget buildBottomSheetSection(BuildContext context, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: (themeProvider.defaultTheme)
            ? Color(0xfff5f5f5)
            : Color(0xff454545),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                    ? Text(
                        "No stocks selected",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Color(0xfff0f0f0),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            showSelectedStock = !showSelectedStock;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              "Selected stocks ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.black
                                    : Color(0xfff0f0f0),
                              ),
                            ),
                            Text(
                              "(${searchProvider.selectedStockList.data!.length}) ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.black
                                    : Color(0xfff0f0f0),
                              ),
                            ),
                            Icon(
                              (showSelectedStock == true)
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_outlined,
                              size: 24,
                              color: (themeProvider.defaultTheme)
                                  ? Colors.black
                                  : Color(0xfff0f0f0),
                            )
                          ],
                        ),
                      ),
                Column(
                  children: [
                    Showcase(
                      titleAlignment: Alignment.topLeft,
                      descriptionAlignment: Alignment.bottomLeft,
                      titleTextStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff484848)
                      ),
                      descTextStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff333333)
                      ),
                      key: _four,
                      title: 'Assign Cash',
                      description: "Click here to continue to assign cash",
                      child: CustomContainer(
                        padding: 0,
                        paddingEdge: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        borderRadius: 12,
                        backgroundColor: (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                            ? Color(0xffa8a8a8)
                            : (themeProvider.defaultTheme)
                                ? Colors.black
                                : Color(0xfff0f0f0),
                        onTap: () {
                          if (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Select Ticker',
                              backgroundColor: Colors.red,
                            );
                          } else {
                            if (!searchProvider.isBtnClicked) {
                              createDetailedLadderProvider.cashAllocatedControllerList.clear();
                              watchlistProvider.addToWatchlist(searchProvider.selectedStockList.data!, context);
                              searchProvider.isBtnClicked = true;
                              searchProvider.searchBarFocus.unfocus();
                              searchProvider.textEditingController.clear();
                              searchProvider.isBtnClicked = false;
                              _navigationProvider.previousSelectedIndex = _navigationProvider.selectedIndex;
                              _navigationProvider.selectedIndex = 4;
                              createDetailedLadderProvider.stockRecommendationParameters(searchProvider.selectedStockList.data!);
                              print("the next button in search ${_navigationProvider.selectedIndex}");
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
                          child: Text(
                            "Assign cash",
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              color: (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                                  ? Color(0xfff0f0f0)
                                  : (themeProvider.defaultTheme)
                                      ? Color(0xfff0f0f0)
                                      : Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    // FIXED: This is the corrected Add To Watchlist button for SelectedTickerModel
                   // In buildBottomSheetSection, update the Add To Watchlist button:
CustomContainer(
  padding: 0,
  paddingEdge: EdgeInsets.zero,
  margin: EdgeInsets.zero,
  borderRadius: 12,
  backgroundColor: (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
      ? Color(0xffa8a8a8)
      : (themeProvider.defaultTheme)
          ? Colors.black
          : Color(0xfff0f0f0),
  onTap: () async {
    if (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Please select stocks first',
          backgroundColor: Colors.red,
        );
      }
      return;
    }
    
    // Use WebSocket-based add to watchlist
    await addToWatchlistViaWebSocket(searchProvider.selectedStockList.data!);
    
    // Don't show SnackBar here - the toast message from the method is enough
    // The method already shows Fluttertoast messages
  },
  child: Padding(
    padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
    child: Text(
      "Add To Watchlist",
      style: GoogleFonts.poppins(
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
        color: (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
            ? Color(0xfff0f0f0)
            : (themeProvider.defaultTheme)
                ? Color(0xfff0f0f0)
                : Color(0xff000000),
      ),
    ),
  ),
),
                  ],
                )
              ],
            ),
            (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                ? Container()
                : (showSelectedStock == false)
                    ? Container()
                    : SizedBox(height: 10),
            (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                ? Container()
                : (showSelectedStock == false)
                    ? Container()
                    : Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.11
                        ),
                        width: MediaQuery.of(context).size.width * 0.97,
                        child: RawScrollbar(
                          thumbColor: Colors.blue,
                          controller: searchProvider.selectedStockScrollController,
                          radius: Radius.circular(10),
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: searchProvider.selectedStockScrollController,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            child: Wrap(children: _selectedStockTag()),
                          ),
                        ),
                      ),
            (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                ? Container()
                : SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  List<Widget> _selectedStockTag() {
    return searchProvider.selectedStockList.data!.map((selectedStock) {
      return Container(
        // margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        margin: EdgeInsets.only(top: 3, bottom: 3, right: 5),
        // padding: EdgeInsets.only(
        //   right: 5,
        //   left: 5,
        // ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: themeProvider.defaultTheme ? Color(0xff000000).withOpacity(0.15) : Color(0xffffffff).withOpacity(0.15),
          // border: Border.all(
          //     color: themeProvider.defaultTheme ? Color(0xffffffff).withOpacity(0.15) : Color(0xffffffff).withOpacity(0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12,
              ),

              Text(
                  selectedStock.ssTicker,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: themeProvider.defaultTheme
                          ? Colors.black
                          : Colors.white)
              ),

              SizedBox(
                width: 2,
              ),

              Text(
                  " (${selectedStock.ssExchange})",
                  style: TextStyle(
                      fontSize: 14,
                      color: themeProvider.defaultTheme
                          ? Colors.black
                          : Colors.white)),
              SizedBox(
                width: 8,
              ),

              InkWell(
                onTap: () async {
                  final value = await searchProvider.removeSelectedStockNew(
                      selectedStock.ssTickerId,
                      selectedStock.ssTicker,
                      context,
                      selectedStock);

                  if (value != "") {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SelectedStockWarningDialog(
                              warningMessage: value,
                              ladderName: [], //value.data?.ladders,
                              stockName: selectedStock.ssTicker,
                              isForWarning: true,
                              tickerId: selectedStock.ssTickerId);
                        });
                  }
                },
                child: Icon(
                  Icons.close,
                  color: (themeProvider.defaultTheme)
                      ?Colors.black
                      :Color(0xffa8a8a8),
                  size: 24,
                ),
              ),

              SizedBox(
                width: 8,
              ),

            ],
          ),
        ),
      );
    }).toList();
  }

  Widget filterDialogbox(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        width: screenWidth,
        decoration: BoxDecoration(
          color: themeProvider.defaultTheme
              ? Color(0XFFF5F5F5)
              : Color(
              0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white54,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  iconSize: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: const Text(
                    "Filters",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: searchProvider.filterList
                  .map(
                    (e) => Column(
                  children: [
                    Container(
                      margin: EdgeInsets.zero,
                      color: Colors.transparent,
                      child: ListTile(
                        dense: true,
                        trailing: Icon(
                          e == 'Select stocks by Sector' ||
                              e == "Select stocks by Name/Ticker"
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.lock,
                          size: 18,
                          color: themeProvider.defaultTheme
                              ? Colors.black
                              : Colors.white,
                        ),
                        title: Text(
                          e,
                          style: TextStyle(
                              color: e == 'Select stocks by Sector' ||
                                  e == "Select stocks by Name/Ticker"
                                  ? (themeProvider.defaultTheme)
                                  ? Colors.black
                                  : Colors.white
                                  : Colors.grey,

                              fontSize: 16),
                        ),
                        onTap: () async {
                          switch (e) {
                            case "Select stocks by Sector":
                              {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (ctx) =>
                                        sectorListDialogBox());
                                break;
                              }

                            case "Select stocks by Name/Ticker":
                              {
                                Navigator.pop(context);
                                _navigationProvider.selectedIndex = 3;
                                break;
                              }
                            default:
                              {
                                Fluttertoast.showToast(
                                    msg: 'This feature will unlock soon!');
                              }
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectorListDialogBox() {
    double screenWidth = screenWidthRecognizer(context);
    return StatefulBuilder(
      builder: (context, _localState) {
        if (searchProvider.sectorList.isEmpty) {
          searchProvider.getSectorList().then((value) {
            _localState(() {});
          });
        }

        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: (themeProvider.defaultTheme)
              ? Colors.white
              : const Color(0xff1c1c1c),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: (themeProvider.defaultTheme)
                  ? Colors.white
                  : const Color(0xff1c1c1c),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white54,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back, color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      child: InkWell(
                        focusColor: Colors.amber,
                        hoverColor: Colors.green,
                        highlightColor: Colors.blue,
                        child: Text(
                          "Select Sector To Continue",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: searchProvider.sectorList.isEmpty
                      ? Center(
                      child:
                      const Text("N/A", style: TextStyle(fontSize: 20)))
                      : ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: searchProvider.sectorList
                            .map(
                              (e) => Column(
                            children: [
                              Container(
                                margin: EdgeInsets.zero,
                                color: Colors.transparent,
                                child: ListTile(
                                  dense: true,
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                  ),
                                  title: Text(
                                    e.stockName,
                                    style: TextStyle(
                                        color: (themeProvider
                                            .defaultTheme)
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 16),
                                  ),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    searchProvider.currentPage = 0;
                                    searchProvider.isLoading = true;
                                    searchProvider.selectedSector =
                                        e.stockName;
                                    _navigationProvider
                                        .selectedIndex = 9;
                                    // await Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (_) {
                                    //       return StockBySectorPage(
                                    //         refreshProviderState:
                                    //             true,
                                    //       );
                                    //     },
                                    //   ),
                                    // );
                                    // searchProvider.getSelectedStockList().then((value) {
                                    //   searchProvider.searchingStocKByName(
                                    //       searchProvider.currentPage);
                                    // });
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildLadderStepInfoSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Divider(
          thickness: 1,
          color: Color(0xff2c2c31),
        ),
    
        SizedBox(
          height: 15,
        ),
    
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ladderStepInfoList.length, //3, //watchlistProvider.searchedStockList.length,
          itemBuilder: (context, index) {
    
            return buildLadderStepInfoCard(context, screenWidth, ladderStepInfoList[index]['icon'], ladderStepInfoList[index]['title'], ladderStepInfoList[index]['message']);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 20,
            );
          },
        ),
    
        SizedBox(
          height: 30,
        ),

        Showcase(
          titleAlignment: Alignment.topLeft,
          descriptionAlignment: Alignment.bottomLeft,
          titleTextStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xff484848)
          ),
          descTextStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff333333)
          ),
          key: _five,
          title: 'Re-play this tutorial',
          description: "We're always here to help you out. Tap here to watch the walkthrough again.",
          child: InkWell(
            onTap: () {
              ShowCaseWidget.of(context).startShowCase([_one, _two, _three, _four, _five]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Learn more",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.5,
                    color: Color(0xfff0f0f0)
                  ),
                ),

                SizedBox(
                  width: 10,
                ),

                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Color(0xfff0f0f0),
                )
              ],
            ),
          ),
        ),
    
        SizedBox(
          height: 15,
        ),
    
        Divider(
          thickness: 1,
          color: Color(0xff2c2c31),
        ),
    
        SizedBox(
          height: 15,
        ),
    
        buildLadderStepInfoBottomButtonSection(context, screenWidth),
    
      ],
    );
  }

  Widget buildLadderStepInfoCard(BuildContext context, double screenWidth, IconData icon, String title, String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Row(
        children: [
          CustomContainer(
            height: 62,
            width: 62,
            padding: 0,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            borderRadius: 50,
            borderColor: Color(0xff1a94f2),
            child: Center(
              child: Icon(
                  icon,
                color: Color(0xff1a94f2),
                size: 18,
              ),
            ),
          ),

          SizedBox(
            width: 10,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: screenWidth - 32 - 65 -10,
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.5,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
              ),

              SizedBox(
                width: screenWidth - 32 - 65 - 10,
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildLadderStepInfoBottomButtonSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Showcase(
              titleAlignment: Alignment.topLeft,
              descriptionAlignment: Alignment.bottomLeft,
              key: _two,
              titleTextStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff484848)
              ),
              descTextStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xff333333)
              ),
              title: 'Ladder Create',
              description: 'Tap here to start creating your ladder',
              child: CustomContainer(
                height: 48,
                padding: 0,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                borderRadius: 12,
                backgroundColor: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                onTap: () {

                  SharedPreferenceManager.saveIsFirstTimeOnLadderPage(false);

                  setState(() {
                    searchProvider.showStockListSection = true;
                    showSelectedStockSection = true;
                  });

                  Future.delayed(Duration.zero).then((value) async {
                    // await showDialog(
                    //     context: context,
                    //     builder: (ctx) => filterDialogbox(context),
                    //     barrierDismissible: false);
                    CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                        buildFilterBottomSheet(context, screenWidth),
                        context,
                        height: 350
                    );
                  });

                },
                child: Center(
                  child: Text(
                      "Create a ladder",
                      style: GoogleFonts.poppins(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w500,
                        color: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xff000000),
                      )
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            width: 12,
          ),

          Expanded(
            child: CustomContainer(
              height: 48,
              padding: 0,
              paddingEdge: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              borderRadius: 12,
              backgroundColor: Colors.transparent,
              borderColor: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
              onTap: () {
                SharedPreferenceManager.saveIsFirstTimeOnLadderPage(false);
                _navigationProvider.selectedIndex = 1;
              },
              child: Center(
                child: Text(
                    "Go to my ladders",
                    style: GoogleFonts.poppins(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w500,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    )
                ),
              ),
            ),
          )
        ]
      ),
    );
  }

  Widget buildSearchField(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: SizedBox(
        height: 40,
        child: MyTextField(
          labelText: "",
          maxLength: 40,
          elevation: 0,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.text,
          isFilled: true,
          fillColor: themeProvider.defaultTheme // value.defaultTheme
              ? Color(0xfff0f0f0)
              : Colors.black54,
          textStyle: TextStyle(
              color: themeProvider.defaultTheme // value.defaultTheme
                  ? Colors.black54
                  : Colors.white),
          borderColor: Color(0xff2c2c31),
          margin: EdgeInsets.zero,
          focusedBorderColor: Color(0xff5cbbff),

          showLeadingWidget: true,
          leading: Icon(
            Icons.search,
            color: themeProvider.defaultTheme // value.defaultTheme
                ? Colors.black
                : Colors.white,
          ),
          trailing: Icon(
            Icons.close,
            color: themeProvider.defaultTheme // value.defaultTheme
                ? Colors.black
                : Colors.white,
          ),
          trailingFunction: () {

            setState(() {
              showSearchField = false;
              searchProvider.textEditingController.clear();
            });
          searchProvider.currentPage = 0;
          // searchProvider.searchingStocKByName(searchProvider.currentPage,
          //     query: searchProvider.textEditingController.text);
          searchProvider.searchingStockByNameNew(
            searchProvider.currentPage,
            query: searchProvider.textEditingController.text);

          },
          counterText: "",
          textInputFormatters: [

          ],
          borderRadius: 12,
          hintText: 'Search and add stocks',
          onChanged: (value) {
            searchProvider.debouncer.run(() {
              searchProvider.currentPage = 0;
              // searchProvider.searchingStocKByName(searchProvider.currentPage,
              //     query: searchProvider.textEditingController.text);
              searchProvider.searchingStockByNameNew(
                  searchProvider.currentPage,
                  query: searchProvider.textEditingController.text);
            });
          },
          focusNode: searchProvider.searchBarFocus,
          controller: searchProvider.textEditingController,
        ),
      ),
    );
  }

  Widget searchedStockPaginationBtns(double screenWidth) {
    return Container(
      decoration: BoxDecoration(
          // border: Border(
          //   top: BorderSide(
          //       color: (themeProvider.defaultTheme) ? Colors.black : Colors.white),
          // )
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (searchProvider.currentPage > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12.0),
                child: CustomContainer(
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  padding: 0,
                  backgroundColor: Colors.transparent,
                  borderColor: (themeProvider.defaultTheme)
                      ?Color(0xff1a94f2)
                      :Color(0xfff0f0f0),
                  borderRadius: 50,
                  onTap: () {
                    if (searchProvider.currentPage > 0) {
                      searchProvider.isLoading = true;

                      searchProvider.currentPage -= 1;

                      searchProvider.searchingStockByNameNew(
                          searchProvider.currentPage,
                          query: searchProvider.textEditingController.text);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xff1a94f2),
                      size: 12,
                    ),
                  ),
                ),
              ),
             
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
              child: CustomContainer(
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                padding: 0,
                backgroundColor: Colors.transparent,
                // borderColor: (themeProvider.defaultTheme)
                //     ?Color(0xff1a94f2)
                //     :Color(0xfff0f0f0),
                borderColor: Colors.transparent,
                borderRadius: 50,
                onTap: () {
                  CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                      buildFilterBottomSheet(context, screenWidth),
                      context,
                      height: 350
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(
                    Icons.filter_list,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0), // Color(0xff1a94f2),
                    size: 24,
                  ),
                ),
              ),
            ),

            if (searchProvider.tickerList.length >= 50)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 12.0),
                child: CustomContainer(
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  padding: 0,
                  backgroundColor: Colors.transparent,
                  borderColor: (themeProvider.defaultTheme)
                      ?Color(0xff1a94f2)
                      :Color(0xfff0f0f0),
                  borderRadius: 50,
                  onTap: () {
                    searchProvider.isLoading = true;
                    searchProvider.currentPage += 1;

                    searchProvider.searchingStockByNameNew(
                        searchProvider.currentPage,
                        query: searchProvider.textEditingController.text);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xff1a94f2),
                      size: 12,
                    ),
                  ),
                ),
              )
            
            else
              const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget buildFilterBottomSheet(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: (themeProvider.defaultTheme)
            ?Color(0xfff0f0f0)
            :Color(0xff2c2c31),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16.0),
        child: Column(
            children: [

              SizedBox(
                height: 15,
              ),

              Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                    ),

                    SizedBox(
                      width: 10,
                    ),

                    Text(
                      "Filters",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          fontFamily: "Britanica",
                          color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Color(0xfff0f0f0)
                      ),
                    )
                  ]
              ),

              SizedBox(
                height: 12,
              ),

              Divider(
                thickness: 1,
                color: (themeProvider.defaultTheme)
                    ?Colors.black
                    :Color(0xfff0f0f0),
              ),

              SizedBox(
                height: 18,
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: searchProvider.filterList
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          switch (e) {
                            case "Select stocks by Sector":
                              {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (ctx) =>
                                        sectorListDialogBox());
                                break;
                              }

                            case "Select stocks by Name/Ticker":
                              {
                                Navigator.pop(context);
                                _navigationProvider.selectedIndex = 3;
                                break;
                              }
                            default:
                              {
                                Fluttertoast.showToast(
                                    msg: 'This feature will unlock soon!');
                              }
                          }
                        },
                        child: Column(
                                            children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.circle_outlined,
                            //   color: Color(0xfff0f0f0),
                            // ),
                            Icon(
                              e == 'Select stocks by Sector' ||
                                  e == "Select stocks by Name/Ticker"
                                  ? Icons.arrow_forward_ios_rounded
                                  : Icons.lock,
                              size: 18,
                              color: themeProvider.defaultTheme
                                  ? Colors.black
                                  : Colors.white,
                            ),

                            SizedBox(
                              width: 6,
                            ),

                            Container(
                              width: screenWidth * 0.85,
                              child: Text(
                                "$e",
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  color: e == 'Select stocks by Sector' ||
                                      e == "Select stocks by Name/Ticker"
                                      ? (themeProvider.defaultTheme)
                                      ? Colors.black
                                      : Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                                            ],
                                          ),
                      ),
                )
                    .toList(),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 18,
                  ),
                  //
                  CustomContainer(
                    backgroundColor: (themeProvider.defaultTheme)
                        ?Colors.black
                        :Color(0xfff0f0f0),
                    borderRadius: 12,
                    paddingEdge: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    padding: 0,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8.0),
                      child: Text(
                        "Close",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.5,
                            color: (themeProvider.defaultTheme)
                                ?Color(0xfff0f0f0)
                                :Color(0xff1a1a25)
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
