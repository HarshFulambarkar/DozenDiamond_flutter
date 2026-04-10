import 'dart:async';
import 'dart:developer';
import 'package:dozen_diamond/AB_Ladder/models/toggle_laddder_activation_status_request.dart';
import 'package:dozen_diamond/AB_Ladder/services/ladder_rest_api_service.dart';
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/ZI_Search/stateManagement/search_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/kyc/widgets/custom_bottom_sheets.dart';
import 'package:dozen_diamond/socket_manager/model/ddstock_socket_data_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZI_Search/models/selected_stock_model.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/functions/timeConverter.dart';
import '../../global/services/num_formatting.dart';
import '../../global/stateManagement/one_click_ladder_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';
import '../models/searched_stock_data_response.dart';
import '../models/watch_list_data_response.dart';
import '../stateManagement/watchlist_provider.dart';

class WatchlistScreenNew extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  const WatchlistScreenNew({
    super.key,
    this.isAuthenticationPresent = false,
    required this.updateIndex,
  });

  @override
  State<WatchlistScreenNew> createState() => _WatchlistScreenNewState();
}

class _WatchlistScreenNewState extends State<WatchlistScreenNew>
    with WidgetsBindingObserver {
  late CustomHomeAppBarProvider customHomeAppBarProvider;
  late WatchlistProvider watchlistProvider;
  late WebSocketServiceProvider webSocketServiceProvider;
  late ThemeProvider themeProvider;
  late CurrencyConstants currencyConstants;
  late SearchProvider searchProvider;
  CurrencyConstants? _currencyConstantsProvider;
  late NavigationProvider _navigationProvider;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late CreateLadderProvider createLadderProvider;
  late OneClickLadderProvider oneClickLadderProvider;
  late Stream<String> _timeStream;
  late TradeMainProvider tradeMainProvider;
  // late FocusNode searchStockFocusNode;

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<WatchlistProvider>(context, listen: false).fetchWatchList();
    Provider.of<WatchlistProvider>(
      context,
      listen: false,
    ).searchedStockNameTextController.addListener(_onSearchChanged);
    searchProvider = Provider.of<SearchProvider>(context, listen: false);

    _timeStream = Stream.periodic(Duration(seconds: 1), (_) {
      return _formattedCurrentTime();
    });

    // searchStockFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currencyConstantsProvider = Provider.of<CurrencyConstants>(
        context,
        listen: false,
      );
      webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(
        context,
        listen: false,
      );
      log("fetching watchlist");
      if (webSocketServiceProvider.status == "Connected") {
        webSocketServiceProvider.startFetching();
      }
    });

    getSelectedStockList();
  }

  getSelectedStockList() async {
    _currencyConstantsProvider = Provider.of<CurrencyConstants>(
      context,
      listen: false,
    );
    await searchProvider.getSelectedStockList(_currencyConstantsProvider!);
  }

  String _formattedCurrentTime() {
    final now = DateTime.now();
    return DateFormat('hh:mm:ss a').format(now);
    // return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(
        context,
        listen: false,
      );
      log("fetching watchlist from AppLifecycleState.resumed");
      if (webSocketServiceProvider.status == "Connected") {
        webSocketServiceProvider.startFetching();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Provider.of<WatchlistProvider>(
      context,
      listen: false,
    ).searchedStockNameTextController.removeListener(_onSearchChanged);
    Provider.of<WatchlistProvider>(
      context,
      listen: false,
    ).searchedStockNameTextController.dispose();
    _debounce?.cancel();
    // searchStockFocusNode.dispose();
    super.dispose();
  }

  String oldStockName = '';

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Call your API here
      print(
        'Search query: ${Provider.of<WatchlistProvider>(context, listen: false).searchedStockNameTextController.text}',
      );
      if (Provider.of<WatchlistProvider>(
        context,
        listen: false,
      ).searchedStockNameTextController.text.length >
          1) {
        if (oldStockName !=
            Provider.of<WatchlistProvider>(
              context,
              listen: false,
            ).searchedStockNameTextController.text) {
          oldStockName = Provider.of<WatchlistProvider>(
            context,
            listen: false,
          ).searchedStockNameTextController.text;
          watchlistProvider.searchStock(
            Provider.of<WatchlistProvider>(
              context,
              listen: false,
            ).searchedStockNameTextController.text,
          );
        }
      } else {
        watchlistProvider.searchedStockList.clear();
        watchlistProvider.isSearchingStock = false;
      }
    });
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    _navigationProvider = Provider.of<NavigationProvider>(
      context,
      listen: false,
    );
    createLadderProvider = Provider.of<CreateLadderProvider>(
      context,
      listen: true,
    );
    customHomeAppBarProvider = Provider.of<CustomHomeAppBarProvider>(
      context,
      listen: true,
    );
    customHomeAppBarProvider.getFieldVisibilityOfAccountInfoBar();
    watchlistProvider = Provider.of<WatchlistProvider>(context, listen: true);
    webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(
      context,
      listen: true,
    );
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    currencyConstants = Provider.of<CurrencyConstants>(context, listen: true);
    oneClickLadderProvider = Provider.of<OneClickLadderProvider>(context, listen: true);
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);
    return SafeArea(
      child: Center(
        child: Stack(
          children: [
            Center(
              child: Container(
                color: (themeProvider.defaultTheme)
                    ? Color(0XFFF5F5F5)
                    : Colors.transparent,
                width: screenWidth,
                child: Scaffold(
                  // drawer: NavigationDrawerWidget(updateIndex: widget.updateIndex),
                  drawer: NavDrawerNew(updateIndex: widget.updateIndex),
                  key: _key,
                  // backgroundColor: Colors.red,
                  backgroundColor: (themeProvider.defaultTheme)
                      ? Color(0XFFF5F5F5)
                      : Color(0xFF15181F),
                  // appBar: PreferredSize(
                  //   preferredSize: Size.fromHeight((false) ? 280 + 45 : 45),
                  //   child: CustomHomeAppBarWithProviderNew(
                  //       backButton: false, leadingAction: _triggerDrawer),
                  // ),
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
                      Column(
                        children: [
                          SizedBox(height: 45),
                          SizedBox(height: 10),
                          buildTimeSection(context),
                          Expanded(
                            child: (watchlistProvider.showSearchPage)
                                ? buildSearchPageSection(context, screenWidth)
                                : Column(
                              children: [
                                buildTopNameSection(context, screenWidth),

                                Expanded(
                                  child:
                                  // (watchlistProvider.watchList.isEmpty)
                                  (webSocketServiceProvider
                                      .ddWatchlistStockList
                                      .isEmpty)
                                      ? buildEmptyWatchlistSection(
                                    context,
                                    screenWidth,
                                  )
                                      : buildWatchlistListSection(
                                    context,
                                    screenWidth,
                                  ),
                                ),

                                // buildStockCard(context, screenWidth)
                              ],
                            ),
                          ),
                        ],
                      ),
                      CustomHomeAppBarWithProviderNew(
                        backButton: false,
                        leadingAction: _triggerDrawer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: StreamBuilder<String>(
        stream: _timeStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(
              '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          }
          return Row(
            children: [
              Text(
                "Time : ",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              Text(
                snapshot.data ?? '',
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              Spacer(),
              if (!watchlistProvider.showSearchPage)
                InkWell(
                  onTap: () {
                    setState(() {
                      watchlistProvider.isEditingStockList =
                      !watchlistProvider.isEditingStockList;
                    });
                  },
                  child: Text(
                    watchlistProvider.isEditingStockList ? "Done" : "Edit",
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.blue,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // old code below

  // Widget buildTimeSection(BuildContext context) {
  //   return Padding(
  //       padding: const EdgeInsets.only(left: 16.0, right: 16),
  //       child: StreamBuilder<String>(
  //         stream: _timeStream,
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Text(
  //               '',
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             );
  //           }
  //           return Row(children: [
  //             Text(
  //               "Time : ",
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 // fontWeight: FontWeight.bold
  //                 color: (themeProvider.defaultTheme)
  //                     ? Colors.black
  //                     : Colors.white,
  //               ),
  //             ),
  //             Text(
  //               snapshot.data ?? '',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 // fontWeight: FontWeight.bold,
  //                 color: (themeProvider.defaultTheme)
  //                     ? Colors.black
  //                     : Colors.white,
  //               ),
  //             )
  //           ]);
  //         },
  //       ));
  // }

  Widget buildTopNameSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "My Watchlist",
            style: TextStyle(
              fontFamily: 'Britanica',
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Color(0xfff0f0f0),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  watchlistProvider.showSearchPage = true;
                  setState(() {});
                  print("below is watchlistProvider");
                  print(watchlistProvider.showSearchPage);
                },
                child: Icon(
                  Icons.search,
                  size: 24,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Color(0xfff0f0f0),
                ),
              ),

              // SizedBox(
              //   width: 8,
              // ),
              //
              // Icon(
              //   Icons.filter_list,
              //   size: 24,
              //   color: Color(0xfff0f0f0),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEmptyWatchlistSection(BuildContext context, double screenWidth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/watchlist/assets/empty_watchlist_icon_image.png',
            fit: BoxFit.fill,
            height: 180,
            width: 180,
          ),
          SizedBox(height: 20),
          Text(
            "Your watchlist is empty :(",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xfff0f0f0),
            ),
          ),
          SizedBox(height: 6),
          SizedBox(
            width: screenWidth - 100,
            child: Text(
              "Tap the search bar above to find, add and track stocks you're interested in.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Color(0xfff0f0f0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWatchlistListSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        // buildSortAndFilterSection(context, screenWidth),
        //
        // SizedBox(
        //   height: 10,
        // ),
        Expanded(child: buildWatchlistList(context, screenWidth)),
      ],
    );
  }

  void reorderData(int oldindex, int newindex) async {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = webSocketServiceProvider.ddWatchlistStockList.removeAt(
        oldindex,
      );
      webSocketServiceProvider.ddWatchlistStockList.insert(newindex, items);
    });

    await webSocketServiceProvider.saveStocksOrder();
  }

  int getIndexFromTickerList(DdStock stockData) {
    print(searchProvider.tickerList);
    for (int i = 0; i < searchProvider.tickerList.length; i++) {
      if (searchProvider.tickerList[i].tickerId == stockData.tickerId) {
        return i;
      }
    }
    return 0;
  }

  Widget buildWatchlistList(BuildContext context, double screenWidth) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: watchlistProvider.isEditingStockList
          ? ReorderableListView(
        buildDefaultDragHandles: false,
        onReorder: reorderData,
        children: [
          for (
          int index = 0;
          index < webSocketServiceProvider.ddWatchlistStockList.length;
          index++
          )
            Padding(
              key: ValueKey(
                webSocketServiceProvider
                    .ddWatchlistStockList[index]
                    .tickerId,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: buildStockCardFromWebSocket(
                context,
                screenWidth,
                index,
                    () {},
              ),
            ),
        ],
      )
          : ListView.separated(
        controller: _scrollController,
        // physics: BouncingScrollPhysics(),
        // shrinkWrap: true,
        // itemCount: watchlistProvider.watchList.length,
        itemCount: webSocketServiceProvider.ddWatchlistStockList.length,
        itemBuilder: (contextdata, index) {
          // WatchlistData stock =
          // watchlistProvider.watchList[index];
          return buildStockCardFromWebSocket(
            contextdata,
            screenWidth,
            index,
                () async {
              // await searchProvider.updateSelectedStockListNew(i, context);
              createLadderProvider.ladderCreationScreen1.clear();
              createLadderProvider.ladderCreationScreen2.clear();
              createLadderProvider.ladderCreationScreen3.clear();
              await searchProvider.updateSelectedStockListFromWatchList(
                webSocketServiceProvider.ddWatchlistStockList[index],
                context,
              );
              _navigationProvider.previousSelectedIndex =
                  _navigationProvider.selectedIndex;

              _navigationProvider.selectedIndex = 4;
              // createLadderProvider.stockRecommendationParameters(
              //   searchProvider.selectedStockList.data!,
              // );
            },
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
      ),
    );
  }

  // old widget below
  // Widget buildWatchlistList(BuildContext context, double screenWidth) {
  //   return Scrollbar(
  //     thumbVisibility: true,
  //     trackVisibility: true,
  //
  //     child: ListView.separated(
  //
  //       // physics: BouncingScrollPhysics(),
  //       // shrinkWrap: true,
  //       // itemCount: watchlistProvider.watchList.length,
  //       itemCount: webSocketServiceProvider.ddWatchlistStockList.length,
  //       itemBuilder: (context, index) {
  //         // WatchlistData stock =
  //         // watchlistProvider.watchList[index];
  //         return buildStockCardFromWebSocket(context, screenWidth, index);
  //       },
  //       separatorBuilder: (context, index) {
  //         return SizedBox(
  //           height: 10,
  //         );
  //       },
  //     ),
  //   );
  // }

  // second build time section
  // Widget buildTimeSection(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 16.0, right: 16),
  //     child: StreamBuilder<String>(
  //       stream: _timeStream,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Text(
  //             '',
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           );
  //         }
  //         return Row(
  //           children: [
  //             Text(
  //               "Time : ",
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 // fontWeight: FontWeight.bold
  //                 color: (themeProvider.defaultTheme)
  //                     ? Colors.black
  //                     : Colors.white,
  //               ),
  //             ),
  //             Text(
  //               snapshot.data ?? '',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 // fontWeight: FontWeight.bold,
  //                 color: (themeProvider.defaultTheme)
  //                     ? Colors.black
  //                     : Colors.white,
  //               ),
  //             ),
  //             Spacer(),
  //             InkWell(
  //               onTap: () {
  //                 setState(() {
  //                   watchlistProvider.isEditingStockList =
  //                   !watchlistProvider.isEditingStockList;
  //                 });
  //               },
  //               child: Text(
  //                 watchlistProvider.isEditingStockList ? "Done" : "Edit",
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   // fontWeight: FontWeight.bold
  //                   color: (themeProvider.defaultTheme)
  //                       ? Colors.black
  //                       : Colors.blue,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget buildSortAndFilterSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(Icons.sort, color: Color(0xff808083)),
                SizedBox(width: 5),
                Text(
                  "Filters",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Color(0xff808083),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                buildSortBySection(context, screenWidth),
                context,
                height: 300,
              );
            },
            child: Row(
              children: [
                Icon(Icons.filter_list, color: Color(0xff808083)),
                SizedBox(width: 5),
                Text(
                  "Sort by",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808083),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget buildStockCardFromWebSocket(
  BuildContext context,
  double screenWidth,
  int index,
  VoidCallback onLadderTap,
) {
  final stock = webSocketServiceProvider.ddWatchlistStockList[index];
  
  return CustomContainer(
    backgroundColor: (themeProvider.defaultTheme)
        ? Colors.white
        : const Color(0xff2c2c31).withOpacity(0.39),
    borderRadius: 0,
    padding: 0,
    margin: EdgeInsets.zero,
    paddingEdge: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use Flex with wrap to automatically handle space
          return Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Drag handle for editing mode
              if (watchlistProvider.isEditingStockList)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(
                      Icons.drag_handle,
                      size: 18,
                      color: Color(0xff808083),
                    ),
                  ),
                ),
              
              // Stock info section - expands to take available space
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Stock name and exchange - using Wrap for automatic wrapping
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          stock.tickerName ?? "",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : const Color(0xfff0f0f0),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff3a2d7f),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            stock.tickerExchange ?? "",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: const Color(0xfff0f0f0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Time info - only shows if available
                    if (stock.updatedAt != null && stock.updatedAt != "null")
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          TimeConverter().convertToISTTimeFormat(
                            stock.updatedAt ?? DateTime.now().toString(),
                          ),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black54
                                : Colors.white70,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Spacer to push price section to the right
              const Spacer(),
              
              // Price and actions section
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price information
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Current price
                      Text(
                        (stock.tickerPrice == null || stock.tickerPrice == "null")
                            ? "-"
                            : amountToInrFormat(
                                context,
                                double.tryParse(stock.tickerPrice ?? "0.0"),
                              ) ?? "-",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: (webSocketServiceProvider.isCurrentPriceUp[
                                      stock.tickerId.toString()] ??
                                  true)
                              ? const Color(0xff00ff89)
                              : Colors.redAccent,
                        ),
                      ),
                      
                      // Price change
                      Flexible(
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 2,
                          children: [
                            if ((double.tryParse(stock.upDownPercentage ?? "0.0") ?? 0) != 0)
                              Icon(
                                (double.tryParse(stock.upDownPercentage ?? "0.0") ?? 0) < 0
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_drop_up,
                                size: 16,
                                color: (double.tryParse(stock.upDownPercentage ?? "0.0") ?? 0) < 0
                                    ? Colors.redAccent
                                    : const Color(0xff00ff89),
                              ),
                            
                            Text(
                              (stock.upDownPrice == null ||
                                      stock.upDownPrice == "null" ||
                                      stock.previousClose == "null")
                                  ? "-"
                                  : ((double.tryParse(stock.upDownPrice ?? "0.0") ?? 0) == 0)
                                      ? "0.0"
                                      : amountToInrFormat(
                                          context,
                                          double.tryParse(stock.upDownPrice ?? "0.0"),
                                        ) ?? "-",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: (double.tryParse(stock.upDownPrice ?? "0.0") ?? 0) < 0
                                    ? Colors.redAccent
                                    : const Color(0xff00ff89),
                              ),
                            ),
                            
                            Text(
                              (stock.upDownPercentage == null ||
                                      stock.upDownPercentage == "null" ||
                                      stock.previousClose == "null")
                                  ? "-"
                                  : ((double.tryParse(stock.upDownPercentage ?? "0.0") ?? 0) == 0)
                                      ? "(0.0%)"
                                      : "(${(double.tryParse(stock.upDownPercentage ?? "") ?? 0).toStringAsFixed(2)}%)",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                                color: (double.tryParse(stock.upDownPercentage ?? "0.0") ?? 0) < 0
                                    ? Colors.redAccent
                                    : const Color(0xff00ff89),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Action icons with Wrap for automatic spacing
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Ladder icon
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: InkWell(
                          onTap: onLadderTap,
                          child: Image.asset(
                            "lib/DD_Navigation/assets/ladder_icon_image.png",
                            height: 24,
                            width: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      // One-click ladder icon (only if not real trading)
                      if (tradeMainProvider.tradingOptions != TradingOptions.tradingWithRealCash)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: InkWell(
                            onTap: () async {
                              if (false) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return allocateCashDialog(
                                      context,
                                      stock.tickerId ?? 0,
                                      stock.ticker ?? "",
                                      double.tryParse(stock.tickerPrice.toString()) ?? 0.0,
                                    );
                                  },
                                );
                              } else {
                                oneClickLadderProvider.isButtonLoading = true;
                                await oneClickLadderProvider.creteOneClickLadderCalculation(
                                  stock.tickerId ?? 0,
                                  stock.ticker ?? "",
                                  double.tryParse(stock.tickerPrice.toString()) ?? 0.0,
                                  context,
                                );
                                oneClickLadderProvider.isButtonLoading = false;
                                
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return oneClickOptionDialog(
                                      context,
                                      stock.tickerId ?? 0,
                                      stock.ticker ?? "",
                                      double.tryParse(stock.tickerPrice.toString()) ?? 0.0,
                                    );
                                  },
                                );
                              }
                            },
                            child: oneClickLadderProvider.isButtonLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  )
                                : Image.asset(
                                    "lib/global/assets/icons/ladder_one_click_icon_white.png",
                                    height: 30,
                                    width: 40,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      
                      // Remove icon (only in edit mode)
                      if (watchlistProvider.isEditingStockList)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            onTap: () {
                              Map<String, dynamic> messageData = {
                                "remove": true,
                                "tickerIds": [stock.tickerId],
                              };
                              webSocketServiceProvider.sendMessage(messageData);
                              webSocketServiceProvider.addToRemovedList(stock.tickerId ?? 0);
                              webSocketServiceProvider.ddWatchlistStockList.removeAt(index);
                            },
                            child: const Icon(
                              Icons.remove_circle_outline,
                              size: 18,
                              color: Color(0xff808083),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}

  Widget buildStockCard(
      BuildContext context,
      double screenWidth,
      WatchlistData stock,
      int index,
      ) {
    return CustomContainer(
      backgroundColor: Color(0xff2c2c31).withOpacity(0.39),
      borderRadius: 0,
      padding: 0,
      margin: EdgeInsets.zero,
      paddingEdge: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 9,
          bottom: 9.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      // "NTPC",
                      stock.wlTicker ?? "",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xfff0f0f0),
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
                          stock.wlExchange ?? "",
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
                SizedBox(height: 3),
                Container(
                  width: screenWidth * 0.35,
                  child: Text(
                    // "NTPC Limited",
                    '${stock.issuerName ?? ""}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xfff0f0f0),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        (webSocketServiceProvider.updatedAtList[(stock
                            .wlTickerId)] ==
                            null ||
                            webSocketServiceProvider.updatedAtList[(stock
                                .wlTickerId)] ==
                                "null")
                            ? Container()
                            : Text(
                          "${webSocketServiceProvider.updatedAtList[stock.wlTickerId]} ",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Color(0xfff0f0f0),
                          ),
                        ),
                        Text(
                          (webSocketServiceProvider
                              .lastTradedPriceResponseMap[(stock
                              .wlTickerId)] ==
                              null ||
                              webSocketServiceProvider
                                  .lastTradedPriceResponseMap[(stock
                                  .wlTickerId)] ==
                                  "null")
                              ? "-"
                              : "| ${amountToInrFormat(context, double.tryParse(webSocketServiceProvider.lastTradedPriceResponseMap[(stock.wlTickerId)] ?? "0.0"))}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xfff0f0f0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          // "+3.09 ",
                          (webSocketServiceProvider.upDownStockPrice[(stock
                              .wlTickerId)] ==
                              null ||
                              webSocketServiceProvider
                                  .upDownStockPrice[(stock
                                  .wlTickerId)] ==
                                  "null")
                              ? "-"
                              : ((double.tryParse(
                            webSocketServiceProvider
                                .upDownStockPrice[(stock
                                .wlTickerId)] ??
                                "0.0",
                          ) ??
                              0) ==
                              0)
                              ? "-"
                              : "${amountToInrFormat(context, double.tryParse(webSocketServiceProvider.upDownStockPrice[(stock.wlTickerId)] ?? "0.0"))}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color:
                            ((double.tryParse(
                              webSocketServiceProvider
                                  .upDownStockPrice[(stock
                                  .wlTickerId)] ??
                                  "0.0",
                            ) ??
                                0) <
                                0)
                                ? Colors
                                .redAccent //Color(0xffe21e00)
                                : Color(0xff00ff89),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          // "(1.03%)",
                          (webSocketServiceProvider.upDownStockPercentage[(stock
                              .wlTickerId)] ==
                              null ||
                              webSocketServiceProvider
                                  .upDownStockPercentage[(stock
                                  .wlTickerId)] ==
                                  "null")
                              ? "-"
                              : ((double.tryParse(
                            webSocketServiceProvider
                                .upDownStockPrice[(stock
                                .wlTickerId)] ??
                                "0.0",
                          ) ??
                              0) ==
                              0)
                              ? "-"
                              : "(${double.tryParse(webSocketServiceProvider.upDownStockPercentage[(stock.wlTickerId)] ?? "")}%)",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color:
                            ((double.tryParse(
                              webSocketServiceProvider
                                  .upDownStockPrice[(stock
                                  .wlTickerId)] ??
                                  "0.0",
                            ) ??
                                0) <
                                0)
                                ? Colors
                                .redAccent //Color(0xffe21e00)
                                : Color(0xff00ff89),
                          ),
                        ),
                        Icon(
                          // stock
                          //     .isPositive!
                          ((double.tryParse(
                            webSocketServiceProvider
                                .upDownStockPrice[(stock
                                .wlTickerId)] ??
                                "0.0",
                          ) ??
                              0) <
                              0)
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
                          color:
                          ((double.tryParse(
                            webSocketServiceProvider
                                .upDownStockPrice[(stock
                                .wlTickerId)] ??
                                "0.0",
                          ) ??
                              0) <
                              0)
                              ? Colors
                              .redAccent //Color(0xffe21e00)
                              : Color(0xff00ff89),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    setState(() {
                      watchlistProvider
                          .removeWatchList(
                        stock.wlId!.toString(),
                        stock.wlTickerId!.toString(),
                      )
                          .then((onValue) {
                        watchlistProvider.watchList.removeAt(index);
                      });
                    });
                  },
                  child: Icon(
                    // Icons.add_circle_outline,
                    Icons.remove_circle_outline,
                    size: 18,
                    color: Colors.grey, //Color(0xff1a94f2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchPageSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: buildSearchField(context, screenWidth),
        ),
        SizedBox(height: 12),
        (watchlistProvider.searchedStockNameTextController.text == "")
            ? Container()
            : Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${watchlistProvider.searchedStockList.length} results for ${watchlistProvider.searchedStockNameTextController.text}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Expanded(child: buildSearchList(context, screenWidth)),
      ],
    );
  }

  Widget buildSearchField(BuildContext context, double screenWidth) {
    return SizedBox(
      height: 40,
      child: MyTextField(
        maxLength: 40,
        elevation: 0,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        textStyle: TextStyle(
          color:
          (themeProvider.defaultTheme) // value.defaultTheme
              ? Colors.black54
              : Colors.white,
        ),
        borderColor: Color(0xff2c2c31),
        margin: EdgeInsets.zero,
        focusedBorderColor: Color(0xff5cbbff),
        showLeadingWidget: true,
        leading: Icon(
          Icons.search,
          color:
          (themeProvider.defaultTheme) // value.defaultTheme
              ? Colors.black
              : Colors.white,
        ),
        trailing: Icon(
          Icons.close,
          color:
          (themeProvider.defaultTheme) // value.defaultTheme
              ? Colors.black
              : Colors.white,
        ),
        trailingFunction: () {
          watchlistProvider.showSearchPage = false;
          watchlistProvider.searchedStockNameTextController.clear();
        },
        counterText: "",
        textInputFormatters: [],
        controller: watchlistProvider.searchedStockNameTextController,
        borderRadius: 12,
        labelText: '',
        onChanged: (String) {},
        isFilled: true,
        fillColor: (themeProvider.defaultTheme)
            ? Color(0xffDADDE6)
            : Colors.transparent,
      ),
    );
  }

  Widget buildSearchList(BuildContext context, double screenWidth) {
    return watchlistProvider.searchedStockList.isEmpty
        ? Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.25,
      ),
      child: Center(child: Text("No Stocks")),
    )
        : ListView.separated(
      // physics: BouncingScrollPhysics(),
      // shrinkWrap: true,
      itemCount: watchlistProvider.searchedStockList.length,
      itemBuilder: (context, index) {
        SearchedStockData stock =
        watchlistProvider.searchedStockList[index];
        return InkWell(
          onTap: () {},
          child: buildSearchStockCard(context, screenWidth, stock, index),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
    );
  }

  Widget buildSearchStockCard(
      BuildContext context,
      double screenWidth,
      SearchedStockData stock,
      int index,
      ) {
    return CustomContainer(
      backgroundColor: (themeProvider.defaultTheme)
          ? Colors.white
          : Color(0xff2c2c31).withOpacity(0.39),
      borderRadius: 0,
      padding: 0,
      margin: EdgeInsets.zero,
      paddingEdge: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 9,
          bottom: 9.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      // "NTPC",
                      stock.ticker ?? "",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Color(0xfff0f0f0),
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
                          stock.tickerExchange ?? "",
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
                SizedBox(height: 3),
                Text(
                  // "NTPC Limited",
                  '${stock.tickerIssuerName ?? ""}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Color(0xfff0f0f0),
                  ),
                ),
              ],
            ),

            // new code below
            Row(
              children: [
                Builder(
                  builder: (_) {
                    final tickerId =
                        watchlistProvider.searchedStockList[index].tickerId ??
                            0;

                    bool isInWatchlist = webSocketServiceProvider
                        .ddWatchlistStockList
                        .any((item) => item.tickerId == tickerId);

                    return InkWell(
                      onTap: () async {
                        if (watchlistProvider.isButtonClicked) return;

                        watchlistProvider.isButtonClicked = true;

                        if (isInWatchlist) {
                          // REMOVE
                          webSocketServiceProvider.ddWatchlistStockList
                              .removeWhere((item) => item.tickerId == tickerId);

                          webSocketServiceProvider.sendMessage({
                            "remove": true,
                            "tickerIds": [tickerId],
                          });

                          webSocketServiceProvider.addToRemovedList(tickerId);
                        } else {
                          // ADD
                          webSocketServiceProvider.ddWatchlistStockList.add(
                            DdStock(
                              tickerName: watchlistProvider
                                  .searchedStockList[index]
                                  .ticker,
                              tickerExchange: watchlistProvider
                                  .searchedStockList[index]
                                  .tickerExchange,
                              issuerName: watchlistProvider
                                  .searchedStockList[index]
                                  .tickerIssuerName,
                              tickerId: tickerId,
                            ),
                          );

                          webSocketServiceProvider.sendMessage({
                            "add": true,
                            "tickerIds": [tickerId],
                          });

                          webSocketServiceProvider.removeFromRemovedList(
                            tickerId,
                          );
                        }

                        watchlistProvider.isButtonClicked = false;
                      },
                      child: Icon(
                        isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                        size: 22,
                        color: isInWatchlist
                            ? Color(0xff1a94f2)
                            : Color(0xff808083),
                      ),
                    );
                  },
                ),
              ],
            ),

            //  Row(
            //     children: [
            //       (webSocketServiceProvider.ddWatchlistStockList.any(
            //                 (item) =>
            //                     item.tickerId ==
            //                     watchlistProvider
            //                         .searchedStockList[index]
            //                         .tickerId,
            //               ) ||
            //               watchlistProvider.searchedStockList[index].isSelected!)
            //           // (watchlistProvider.watchList.any((item) =>
            //           //             item.wlTickerId ==
            //           //             watchlistProvider
            //           //                 .searchedStockList[index].tickerId) ||
            //           //         watchlistProvider.searchedStockList[index].isSelected!)
            //           ? InkWell(
            //               onTap: () async {
            //                 print("tap");
            //                 print(watchlistProvider.isButtonClicked);
            //                 if (!watchlistProvider.isButtonClicked) {
            //                   watchlistProvider.isButtonClicked = true;
            //                   // await searchProvider
            //                   //     .updateSelectedStockListNew(
            //                   //     index, context);

            //                   webSocketServiceProvider.ddWatchlistStockList
            //                       .removeWhere(
            //                         (ddst) =>
            //                             ddst.tickerId ==
            //                             watchlistProvider
            //                                 .searchedStockList[index]
            //                                 .tickerId,
            //                       );
            //                   Map<String, dynamic> messageData = {
            //                     "add": false,
            //                     "tickerIds": [
            //                       watchlistProvider
            //                               .searchedStockList[index]
            //                               .tickerId ??
            //                           0,
            //                     ],
            //                   };

            //                   webSocketServiceProvider.sendMessage(messageData);
            //                   webSocketServiceProvider.addToRemovedList(
            //                     webSocketServiceProvider
            //                             .ddWatchlistStockList[index]
            //                             .tickerId ??
            //                         0,
            //                   );
            //                   watchlistProvider.isButtonClicked = false;
            //                   // watchlistProvider.showSearchPage = false;
            //                   // watchlistProvider.searchedStockNameTextController
            //                   //     .clear();
            //                   // List<SelectedTickerModel> selectedStock = [SelectedTickerModel(
            //                   //     ssTickerId: watchlistProvider
            //                   //         .searchedStockList[index].tickerId?? 0
            //                   // )];
            //                   // await watchlistProvider
            //                   //     .addToWatchlist(selectedStock);
            //                   // watchlistProvider.searchedStockList[index].isSelected = true;
            //                   // await watchlistProvider.fetchWatchList();
            //                   // await webSocketServiceProvider.disconnect();
            //                   // await webSocketServiceProvider.connect();
            //                 }
            //               },
            //               child: Icon(
            //                 // Icons.add_circle_outline,
            //                 // Icons.check_circle_outline,
            //                 Icons.bookmark,
            //                 size: 22,
            //                 color: Color(0xff1a94f2),
            //               ),
            //             )
            //           : InkWell(
            //               onTap: () async {
            //                 print("tap");
            //                 print(watchlistProvider.isButtonClicked);
            //                 if (!watchlistProvider.isButtonClicked) {
            //                   watchlistProvider.isButtonClicked = true;

            //                   webSocketServiceProvider.ddWatchlistStockList.add(
            //                     DdStock(
            //                       tickerName: watchlistProvider
            //                           .searchedStockList[index]
            //                           .ticker,
            //                       tickerExchange: watchlistProvider
            //                           .searchedStockList[index]
            //                           .tickerExchange,
            //                       issuerName: watchlistProvider
            //                           .searchedStockList[index]
            //                           .tickerIssuerName,
            //                       tickerId:
            //                           watchlistProvider
            //                               .searchedStockList[index]
            //                               .tickerId ??
            //                           0,
            //                     ),
            //                   );

            //                   // await searchProvider
            //                   //     .updateSelectedStockListNew(
            //                   //     index, context);
            //                   Map<String, dynamic> messageData = {
            //                     "add": true,
            //                     "tickerIds": [
            //                       watchlistProvider
            //                               .searchedStockList[index]
            //                               .tickerId ??
            //                           0,
            //                     ],
            //                   };

            //                   webSocketServiceProvider.sendMessage(messageData);
            //                   webSocketServiceProvider.removeFromRemovedList(
            //                     webSocketServiceProvider
            //                             .ddWatchlistStockList[index]
            //                             .tickerId ??
            //                         0,
            //                   );
            //                   watchlistProvider.isButtonClicked = false;

            //                   // watchlistProvider.showSearchPage = false;
            //                   // watchlistProvider.searchedStockNameTextController
            //                   //     .clear();

            //                   List<SelectedTickerModel> selectedStock = [
            //                     SelectedTickerModel(
            //                       ssTickerId:
            //                           watchlistProvider
            //                               .searchedStockList[index]
            //                               .tickerId ??
            //                           0,
            //                     ),
            //                   ];
            //                   // await watchlistProvider
            //                   //     .addToWatchlist(selectedStock, context);

            //                   // watchlistProvider.searchedStockList[index].isSelected = true;
            //                   // await watchlistProvider.fetchWatchList();
            //                   // await webSocketServiceProvider.disconnect();
            //                   // await webSocketServiceProvider.connect();
            //                 }
            //               },
            //               child: Icon(
            //                 // Icons.add_circle_outline,
            //                 // Icons.add_circle_outline,
            //                 Icons.bookmark_border,
            //                 size: 22,
            //                 color: Color(0xff808083), //Color(0xff1a94f2),
            //               ),
            //             ),
            //     ],
            //   ),

            // old code below
            // Row(
            //   children: [
            //     (webSocketServiceProvider.ddWatchlistStockList.any((item) =>
            //                 item.tickerId ==
            //                 watchlistProvider
            //                     .searchedStockList[index].tickerId) ||
            //             watchlistProvider.searchedStockList[index].isSelected!)
            //         // (watchlistProvider.watchList.any((item) =>
            //         //             item.wlTickerId ==
            //         //             watchlistProvider
            //         //                 .searchedStockList[index].tickerId) ||
            //         //         watchlistProvider.searchedStockList[index].isSelected!)
            //         ? InkWell(
            //             onTap: () async {
            //               print("tap");
            //               print(watchlistProvider.isButtonClicked);
            //               if (!watchlistProvider.isButtonClicked) {
            //                 watchlistProvider.isButtonClicked = true;
            //                 // await searchProvider
            //                 //     .updateSelectedStockListNew(
            //                 //     index, context);
            //                 Map<String, dynamic> messageData = {
            //                   "add": false,
            //                   "tickerIds": [
            //                     watchlistProvider
            //                             .searchedStockList[index].tickerId ??
            //                         0
            //                   ]
            //                 };
            //
            //                 webSocketServiceProvider.sendMessage(messageData);
            //                 watchlistProvider.isButtonClicked = false;
            //                 watchlistProvider.showSearchPage = false;
            //                 watchlistProvider.searchedStockNameTextController.clear();
            //                 // List<SelectedTickerModel> selectedStock = [SelectedTickerModel(
            //                 //     ssTickerId: watchlistProvider
            //                 //         .searchedStockList[index].tickerId?? 0
            //                 // )];
            //                 // await watchlistProvider
            //                 //     .addToWatchlist(selectedStock);
            //                 // watchlistProvider.searchedStockList[index].isSelected = true;
            //                 // await watchlistProvider.fetchWatchList();
            //                 // await webSocketServiceProvider.disconnect();
            //                 // await webSocketServiceProvider.connect();
            //               }
            //             },
            //             child: Icon(
            //               // Icons.add_circle_outline,
            //               // Icons.check_circle_outline,
            //               Icons.bookmark,
            //               size: 22,
            //               color: Color(0xff1a94f2),
            //             ),
            //           )
            //         : InkWell(
            //             onTap: () async {
            //               print("tap");
            //               print(watchlistProvider.isButtonClicked);
            //               if (!watchlistProvider.isButtonClicked) {
            //                 watchlistProvider.isButtonClicked = true;
            //
            //                 webSocketServiceProvider.ddWatchlistStockList.add(DdStock(
            //                   tickerName: watchlistProvider.searchedStockList[index].ticker,
            //                   tickerExchange: watchlistProvider.searchedStockList[index].tickerExchange,
            //                   issuerName: watchlistProvider.searchedStockList[index].tickerIssuerName,
            //                   tickerId: watchlistProvider.searchedStockList[index].tickerId,
            //                 ));
            //
            //                 // await searchProvider
            //                 //     .updateSelectedStockListNew(
            //                 //     index, context);
            //                 Map<String, dynamic> messageData = {
            //                   "add": true,
            //                   "tickerIds": [
            //                     watchlistProvider
            //                             .searchedStockList[index].tickerId ??
            //                         0
            //                   ]
            //                 };
            //
            //                 webSocketServiceProvider.sendMessage(messageData);
            //                 watchlistProvider.isButtonClicked = false;
            //
            //                 watchlistProvider.showSearchPage = false;
            //                 watchlistProvider.searchedStockNameTextController.clear();
            //
            //                 List<SelectedTickerModel> selectedStock = [SelectedTickerModel(
            //                     ssTickerId: watchlistProvider
            //                         .searchedStockList[index].tickerId?? 0
            //                 )];
            //                 // await watchlistProvider
            //                 //     .addToWatchlist(selectedStock, context);
            //
            //                 // watchlistProvider.searchedStockList[index].isSelected = true;
            //                 // await watchlistProvider.fetchWatchList();
            //                 // await webSocketServiceProvider.disconnect();
            //                 // await webSocketServiceProvider.connect();
            //               }
            //             },
            //             child: Icon(
            //               // Icons.add_circle_outline,
            //               // Icons.add_circle_outline,
            //               Icons.bookmark_border,
            //               size: 22,
            //               color: Color(0xff808083), //Color(0xff1a94f2),
            //             ),
            //           )
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget buildSortBySection(BuildContext context, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff2c2c31),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16.0),
        child: Column(
          children: [
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.filter_list),
                SizedBox(width: 10),
                Text(
                  "Sort By",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    fontFamily: "Britanica",
                    color: Color(0xfff0f0f0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(thickness: 1, color: Color(0xfff0f0f0)),
            SizedBox(height: 18),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle_outlined, color: Color(0xfff0f0f0)),
                    SizedBox(width: 6),
                    Text(
                      "Alphabetically",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xfff0f0f0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.radio_button_checked, color: Color(0xff1a94f2)),
                    SizedBox(width: 6),
                    Text(
                      "Last added",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xfff0f0f0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 22),
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
                      color: Color(0xfff0f0f0),
                    ),
                  ),
                ),
                SizedBox(width: 18),
                CustomContainer(
                  backgroundColor: Color(0xfff0f0f0),
                  borderRadius: 12,
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  padding: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                      right: 32,
                      top: 8,
                      bottom: 8.0,
                    ),
                    child: Text(
                      "Apply",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.5,
                        color: Color(0xff1a1a25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget allocateCashDialog(BuildContext context, int tickerId, String ticker, double tickerPrice) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return AlertDialog(
      backgroundColor: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xFF15181F),
      title: Text(
        "Allocate Cash",
        style: TextStyle(
          color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
        ),
      ),
      content: Text(
        '''You will be creating a ladder with one-click using the below parameters:
      - Allocated cash: ${_currencyConstantsProvider!.currency}${oneClickLadderProvider.cashAllocated}
      - Step size: ${oneClickLadderProvider.stepSize.toStringAsFixed(2)}
      - Order size: ${oneClickLadderProvider.buySellQty}
      - Target price: ${_currencyConstantsProvider!.currency}${oneClickLadderProvider.targetPrice.toStringAsFixed(2)}
      - Initial buy price/quantity: ${_currencyConstantsProvider!.currency}${oneClickLadderProvider.initialBuyPrice}/${oneClickLadderProvider.initialBuyQty}''',
        // "Enter otp you get from webinar and verify you webinar and then proceed",
        style: TextStyle(
          color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text(
            "Ok",
            style: TextStyle(
              color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
            ),
          ),
          onPressed: () async {

            oneClickLadderProvider.isButtonLoading = true;
            await oneClickLadderProvider.creteOneClickLadderCalculation(
                tickerId,
                ticker,
                tickerPrice,
                context
            );
            oneClickLadderProvider.isButtonLoading = false;

            showDialog(
              context: context,
              builder: (context) {
                return oneClickOptionDialog(
                    context,
                    tickerId,
                    ticker,
                    tickerPrice
                );
              },
            );

            Navigator.pop(context);

          },
        ),
        ElevatedButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget oneClickOptionDialog(BuildContext context, int tickerId, String ticker, double tickerPrice) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return AlertDialog(
      backgroundColor: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xFF15181F),
      title: Text(
        "One Click Ladder Creation",
        style: TextStyle(
          color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
        ),
      ),
      content: Text(
        '''You will be creating a ladder with one-click using the below parameters:
      - Allocated cash: ${_currencyConstantsProvider!.currency}${oneClickLadderProvider.cashAllocated}
      - Step size: ${oneClickLadderProvider.stepSize.toStringAsFixed(2)}
      - Order size: ${oneClickLadderProvider.buySellQty}
      - Target price: ${_currencyConstantsProvider!.currency}${oneClickLadderProvider.targetPrice.toStringAsFixed(2)}
      - Initial buy price/quantity: ${_currencyConstantsProvider!.currency}${oneClickLadderProvider.initialBuyPrice}/${oneClickLadderProvider.initialBuyQty}''',
        // "Enter otp you get from webinar and verify you webinar and then proceed",
        style: TextStyle(
          color: (themeProvider.defaultTheme)?Color(0xFF15181F):Color(0xFFf0f0f0),
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text(
            "Create",
            style: TextStyle(
              color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
            ),
          ),
          onPressed: () async {

            final value = await oneClickLadderProvider.creteOneClickLadder(
              tickerId,
              ticker,
              tickerPrice,
              context
            );

            Navigator.pop(context);

            print("after create ladder");
            print(value);

            if(value) {

              tradeMainProvider.updateTabBarIndex = 0;
              _navigationProvider.selectedIndex = 1;

              // await LadderRestApiService().toggleLadderActivationStatus(
              //   ToggleLadderActivationStatusRequest(
              //     ladId: ladderInfo.ladId,
              //     ladStatus: "ACTIVE",
              //     ladReinvestExtraCash: false,
              //   ),
              // );

            }



          },
        ),
        ElevatedButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}