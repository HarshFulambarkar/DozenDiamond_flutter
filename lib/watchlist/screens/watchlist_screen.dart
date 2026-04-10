import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZI_Search/models/selected_stock_model.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/constants/custom_colors_light.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_container.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';
import '../models/watch_list_data_response.dart';
import '../stateManagement/watchlist_provider.dart';
import 'package:intl/intl.dart';

class WatchlistScreen extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  const WatchlistScreen(
      {super.key,
      this.isAuthenticationPresent = false,
      required this.updateIndex});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late CustomHomeAppBarProvider customHomeAppBarProvider;
  late WatchlistProvider watchlistProvider;
  late WebSocketServiceProvider webSocketServiceProvider;
  late ThemeProvider themeProvider;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late Stream<String> _timeStream;
  // late FocusNode searchStockFocusNode;

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Provider.of<WatchlistProvider>(context, listen: false).fetchWatchList();
    Provider.of<WatchlistProvider>(context, listen: false).searchedStockNameTextController.addListener(_onSearchChanged);

    _timeStream = Stream.periodic(Duration(seconds: 1), (_) {
      return _formattedCurrentTime();
    });
    // searchStockFocusNode = FocusNode();

  }

  String _formattedCurrentTime() {
    final now = DateTime.now();
    return DateFormat('hh:mm:ss a').format(now);
    // return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    Provider.of<WatchlistProvider>(context, listen: false).searchedStockNameTextController.removeListener(_onSearchChanged);
    Provider.of<WatchlistProvider>(context, listen: false).searchedStockNameTextController.dispose();
    _debounce?.cancel();
    // searchStockFocusNode.dispose();
    super.dispose();
  }

  String oldStockName = '';

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Call your API here
      print('Search query: ${Provider.of<WatchlistProvider>(context, listen: false).searchedStockNameTextController.text}');
      if(Provider.of<WatchlistProvider>(context, listen: false).searchedStockNameTextController.text.length > 1) {
        if(oldStockName != Provider.of<WatchlistProvider>(context, listen: false).searchedStockNameTextController.text) {
          oldStockName = Provider.of<WatchlistProvider>(context, listen: false).searchedStockNameTextController.text;
          watchlistProvider.searchStock(Provider.of<WatchlistProvider>(context, listen: false).searchedStockNameTextController.text);
        }

      } else {
        watchlistProvider.searchedStockList.clear();
        watchlistProvider.isSearchingStock = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    CurrencyConstants currencyConstantsProvider = Provider.of(context);
    customHomeAppBarProvider =
        Provider.of<CustomHomeAppBarProvider>(context, listen: true);
    customHomeAppBarProvider.getFieldVisibilityOfAccountInfoBar();
    watchlistProvider = Provider.of<WatchlistProvider>(context, listen: true);
    webSocketServiceProvider =
        Provider.of<WebSocketServiceProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    // print(
    //     "here is the price ${webSocketServiceProvider.lastTradedPriceResponseMap}");
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: NavDrawerNew(updateIndex: widget.updateIndex),
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
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    color: (themeProvider.defaultTheme)
                        ? Color(0XFFF5F5F5)
                        : Colors.transparent,
                    width: screenWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),

                        buildTimeSection(context),


                        (watchlistProvider.showSearchPage)?buildSearchStockSection(context, screenWidth):Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),

                            // remove this code

                            // ListView.builder(
                            //     physics: NeverScrollableScrollPhysics(),
                            //     itemCount: webSocketServiceProvider.testWebSocketData.length,
                            //     shrinkWrap: true,
                            //     itemBuilder: (context, index) {
                            //       return Padding(
                            //         padding: const EdgeInsets.only(bottom: 10, left: 8.0, right: 8),
                            //         child: Column(
                            //           children: [
                            //
                            //             Row(
                            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 Text(
                            //                     "Symbol"
                            //                 ),
                            //
                            //                 Text(
                            //                   "${webSocketServiceProvider.testWebSocketData[index].s}",
                            //                   style: TextStyle(
                            //                       color: Colors.orange
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //
                            //             SizedBox(
                            //               height: 5,
                            //             ),
                            //
                            //             Row(
                            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 Text(
                            //                     "Last price"
                            //                 ),
                            //
                            //                 Text(
                            //                   "${currencyConstantsProvider.currency} ${webSocketServiceProvider.testWebSocketData[index].p}",
                            //                   style: TextStyle(
                            //                       color: Colors.green
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //
                            //             SizedBox(
                            //               height: 5,
                            //             ),
                            //
                            //             Row(
                            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 Text(
                            //                     "Volume"
                            //                 ),
                            //
                            //                 Text(
                            //                   "${webSocketServiceProvider.testWebSocketData[index].v}",
                            //                   style: TextStyle(
                            //                       color: Colors.blue
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //
                            //             Divider(),
                            //
                            //             SizedBox(
                            //               height: 5,
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     }),

                            // (webSocketServiceProvider.testWebSocketData.isNotEmpty)
                            //     ?:Container(),

                            // remove above code

                            // buildTopWatchlistSectionOptions(context, screenWidth),
                            //
                            // SizedBox(
                            //   height: 10,
                            // ),

                            InkWell(
                              onTap: () {
                                print("on tap tap");
                                watchlistProvider.showSearchPage = true;

                                // FocusScope.of(context).requestFocus(searchStockFocusNode);
                                // searchStockFocusNode.requestFocus();
                              },
                              child: IgnorePointer(
                                  ignoring: true,
                                  child: buildWatchListSearch(context)
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            (watchlistProvider.watchList.isEmpty)
                                ? Center(
                                    child: Text(
                                      "No Stock to Show",
                                    ),
                                  )
                                : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: watchlistProvider.watchList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      WatchlistData stock =
                                          watchlistProvider.watchList[index];
                                      return Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 4),
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 6,
                                                bottom: 6),
                                            // decoration: BoxDecoration(
                                            //   color: Colors.black,
                                            //   borderRadius: BorderRadius.circular(8),
                                            //   boxShadow: [
                                            //     BoxShadow(
                                            //       color: Colors.grey.withOpacity(0.2),
                                            //       blurRadius: 6,
                                            //       spreadRadius: 1,
                                            //       offset: Offset(0, 2),
                                            //     ),
                                            //   ],
                                            // ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                // Stock Icon and Name
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              stock.wlTicker ?? "",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                            Text(
                                                                "${stock.wlExchange ?? '-'}",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color:
                                                                        Colors.grey[
                                                                            600])),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          // '${currencyConstantsProvider.currency}${stock['price'].toStringAsFixed(2)}',
                                                          '${stock.issuerName ?? ""}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                // Stock Change and Remove Button
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            (webSocketServiceProvider.lastTradedPriceResponseMap[(stock.wlTickerId)] == null || webSocketServiceProvider.lastTradedPriceResponseMap[(stock.wlTickerId)] == "null")
                                                                ?
                                                            // SizedBox(
                                                            //   height: 20,
                                                            //   width: 20,
                                                            //   child: CircularProgressIndicator(),
                                                            // )
                                                            Text(
                                                              "-",
                                                              style: TextStyle(
                                                                  color: stock
                                                                      .isPositive!
                                                                      ? Colors.green
                                                                      : Colors.red,
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 18),
                                                            )
                                                                :Text(
                                                              "${amountToInrFormat(context, double.tryParse(webSocketServiceProvider.lastTradedPriceResponseMap[(stock.wlTickerId)] ?? ""))}",
                                                              style: TextStyle(
                                                                  color: stock
                                                                          .isPositive!
                                                                      ? Colors.green
                                                                      : Colors.red,
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 18),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            (webSocketServiceProvider.updatedAtList[(stock.wlTickerId)] == null || webSocketServiceProvider.updatedAtList[(stock.wlTickerId)] == "null")
                                                                ?Container():Text(
                                                              "${webSocketServiceProvider.updatedAtList[stock.wlTickerId]}",
                                                              style: TextStyle(
                                                                  color:
                                                                      Colors.grey),
                                                            ),
                                                            // Text(
                                                            //   (stock.change == null)
                                                            //       ? ""
                                                            //       : '${stock.change!.replaceAll("-", "")}%',
                                                            //   // '${currencyConstantsProvider.currency}${stock['price'].toStringAsFixed(2)}',
                                                            //   // '${stock['exchange']}',
                                                            //   style: TextStyle(
                                                            //     fontSize: 14,
                                                            //     color: Colors
                                                            //         .grey[600],
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                        Icon(
                                                          stock.isPositive!
                                                              ? Icons.arrow_drop_up
                                                              : Icons
                                                                  .arrow_drop_down,
                                                          color: stock.isPositive!
                                                              ? Colors.green
                                                              : Colors.red,
                                                          size: 25,
                                                        ),
                                                        SizedBox(height: 4),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  watchlistProvider
                                                                      .removeWatchList(
                                                                          stock
                                                                              .wlId!
                                                                              .toString(),
                                                                          stock
                                                                              .wlTickerId!
                                                                              .toString())
                                                                      .then(
                                                                          (onValue) {
                                                                    watchlistProvider
                                                                        .watchList
                                                                        .removeAt(
                                                                            index);
                                                                  });
                                                                });
                                                              },
                                                              child: Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  color:
                                                                      Colors.grey,
                                                                  size: 20),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8.0),
                                            child: Divider(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomHomeAppBarWithProvider(
                backButton: false, leadingAction: _triggerDrawer),
          ],
        ),
      ),
    );
  }

  Widget buildTimeSection(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6),
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
                    color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                  ),

                ),

                Text(
                  snapshot.data ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                    color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                  ),
                )
              ]
          );
        },
      )
    );
  }

  Widget buildTopWatchlistSectionOptions(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 10, // Adjust the item count
          itemBuilder: (context, index) {
            return buildWatchlistSectionChip(context, index);
          },
        ),
      ),
    );
  }

  Widget buildWatchlistSectionChip(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: CustomContainer(
        onTap: () {
          watchlistProvider.selectedWatchListSection = index.toString();
        },
        backgroundColor: (watchlistProvider.selectedWatchListSection == index.toString())
            ?Color(0xFF0066C0):Colors.transparent,
        borderColor: (themeProvider.defaultTheme) ? Colors.black : Colors.white,
        borderRadius: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Center(
            child: Text(
              "Nifty-50",
              style: TextStyle(
                color: (themeProvider.defaultTheme) ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWatchListSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8.0),
      child: TextField(
        // focusNode: searchStockFocusNode,
        onChanged: (value) {


        },
        textInputAction: TextInputAction.search,
        controller: watchlistProvider.searchedStockNameTextController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.7,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: 'Search Stock',
          hintStyle: TextStyle(
              color: false // value.defaultTheme
                  ? Colors.black54
                  : Colors.white),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              Icons.search,
              color: false // value.defaultTheme
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
        style: kBodyText,
      ),
    );
  }

  Widget buildSearchStockSection(BuildContext context, double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          height: 10,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  watchlistProvider.showSearchPage = false;
                  watchlistProvider.searchedStockNameTextController.clear();
                },
                child: Icon(
                  Icons.arrow_back,
                ),
              ),
              Container(
                width: screenWidth - 50,
                  child: buildWatchListSearch(context)
              ),
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        searchStockList(context),
      ],
    );
  }

  Widget searchStockList(BuildContext context) {
    return watchlistProvider.searchedStockList.isEmpty
        ? Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.25),
      child: Center(
        child: Text(
          "No Stocks",
        ),
      ),
    )
        : Padding(

      padding: const EdgeInsets.only(
          left: 20.0, right: 20, top: 5, bottom: 5),
      child: watchlistProvider.isSearchingStock
          ? Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.25),
            child: const Center(
                    child: CircularProgressIndicator(
            color: Colors.white,
                    ),
                  ),
          )
          : ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Color.fromARGB(90, 4, 7, 170),
                        // color: Colors.white
                      ),
                      child: Text(
                        watchlistProvider
                            .searchedStockList[index].tickerExchange ?? "-",
                        style: const TextStyle(
                          color: Colors.white
                            // color:
                            // Color.fromARGB(255, 20, 24, 228)
                          ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      watchlistProvider.searchedStockList[index].ticker ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        watchlistProvider
                            .searchedStockList[index].tickerIssuerName ?? "-",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Theme(
                  data: ThemeData(
                      unselectedWidgetColor: Colors.white),
                  child:
                  (watchlistProvider.watchList.any((item) => item.wlTickerId == watchlistProvider.searchedStockList[index].tickerId) || watchlistProvider.searchedStockList[index].isSelected!)
                  // (watchlistProvider.watchList.contains(watchlistProvider.searchedStockList[index].tickerId))
          // watchlistProvider
          //             .searchedStockList[index].isSelected!)
                      ? SizedBox(height: 45)
                      : IconButton(
                    onPressed: () async {
                      print("tap");
                      print(watchlistProvider.isButtonClicked);
                      if (!watchlistProvider.isButtonClicked) {
                        watchlistProvider.isButtonClicked = true;
                        // await searchProvider
                        //     .updateSelectedStockListNew(
                        //     index, context);

                        List<SelectedTickerModel> selectedStock = [SelectedTickerModel(
                            ssTickerId: watchlistProvider
                                .searchedStockList[index].tickerId?? 0
                        )];
                        await watchlistProvider
                            .addToWatchlist(selectedStock, context);
                        watchlistProvider.searchedStockList[index].isSelected = true;
                        await watchlistProvider.fetchWatchList();
                        await webSocketServiceProvider.disconnect();
                        await webSocketServiceProvider.connect();
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      color: Color.fromARGB(216, 0, 255, 8),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: watchlistProvider.searchedStockList.length,
        separatorBuilder: (context, index) => Divider(
          color: (themeProvider.defaultTheme)
              ? Colors.grey
              : Colors.white24,
          height: 0,
        ),
      ),
    );
  }
}
