import 'package:dozen_diamond/ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import '../../global/constants/custom_colors_light.dart';
import '../../global/widgets/selected_stock_warning_dialog.dart';
import '../../watchlist/stateManagement/watchlist_provider.dart';
import '../stateManagement/search_provider.dart';

class SearchPage extends StatefulWidget {
  final Function updateIndex;
  final bool refreshProviderState;

  const SearchPage(
      {super.key,
      required this.updateIndex,
      required this.refreshProviderState});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late SearchProvider searchProvider;
  late NavigationProvider _navigationProvider;
  late WatchlistProvider watchlistProvider;
  CurrencyConstants? _currencyConstantsProvider;
  late ThemeProvider themeProvider;
  late CreateLadderProvider createDetailedLadderProvider;

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _currencyConstantsProvider =
          Provider.of<CurrencyConstants>(context, listen: false);
      prepareScreen();
    });
  }

  Future<void> prepareScreen() async {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    await searchProvider.getSelectedStockList(_currencyConstantsProvider!);
    searchProvider.searchingStockByNameNew(searchProvider.currentPage);
    searchProvider.getSectorList();
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);

    Future.delayed(Duration.zero).then((value) async {
      await showDialog(
          context: context,
          builder: (ctx) => filterDialogbox(context),
          barrierDismissible: false);
    });
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
    createDetailedLadderProvider = Provider.of<CreateLadderProvider>(context, listen: true);
    createDetailedLadderProvider.ladderCreationScreen1.clear();
    createDetailedLadderProvider.ladderCreationScreen2.clear();
    createDetailedLadderProvider.ladderCreationScreen3.clear();
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return Scaffold(
      key: _key,
      backgroundColor: Color(0xFF15181F),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawerNew(),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                color: (themeProvider.defaultTheme)
                    ? Color(0XFFF5F5F5)
                    : Color(0xFF15181F),
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(
                      height: AppBar().preferredSize.height * 1.2,
                    ),
                    Row(
                      children: [
                        searchBar(),
                        stockFilterDialogBoxBtn(),
                      ],
                    ),
                    searchedStockListing(),
                    (!searchProvider.isLoading)
                        ? searchedStockPaginationBtns()
                        : Container(),
                    if (searchProvider.selectedStockList.data != null &&
                        searchProvider.selectedStockList.data!.isNotEmpty)
                      ...selectedStockListing(),
                  ],
                ),
              ),
            ),
            CustomHomeAppBarWithProvider(
              backButton: false,
              leadingAction:
                  _triggerDrawer, //these leadingAction button is not working, I have tired making it work, but it isn't.
            ),
          ],
        ),
      ),
    );
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
                                  // color: themeProvider.defaultTheme
                                  //     ? e != 'Select stocks by Sector'
                                  //         ? Colors.grey
                                  //         : Colors.black
                                  //     : e == 'Select stocks by Sector' ||
                                  //             e ==
                                  //                 "Select stocks by Name/Ticker"
                                  //         ? Colors.white
                                  //         : Colors.grey,
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
              ? const Color(0xff1c1c1c)
              : const Color(0xff1c1c1c),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: (themeProvider.defaultTheme)
                  ? const Color(0xff1c1c1c)
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
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      child: const InkWell(
                        focusColor: Colors.amber,
                        hoverColor: Colors.green,
                        highlightColor: Colors.blue,
                        child: Text(
                          "Select Sector To Continue",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
                                                      ? Colors.white
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

  List<Widget> _selectedStockTag() {
    return searchProvider.selectedStockList.data!.map((selectedStock) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
        // padding: EdgeInsets.only(
        //   right: 5,
        //   left: 5,
        // ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: themeProvider.defaultTheme ? Colors.black : Colors.transparent,
          border: Border.all(
              color: themeProvider.defaultTheme ? Colors.black : Colors.white),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 8,
            ),



            Text(selectedStock.ssTicker,
                style: TextStyle(
                    color: themeProvider.defaultTheme
                        ? Colors.white
                        : Colors.white)),

            SizedBox(
              width: 2,
            ),

            Text(
                "(${selectedStock.ssExchange})",
                style: TextStyle(
                    fontSize: 10,
                    color: themeProvider.defaultTheme
                        ? Colors.white
                        : Colors.white)),
            SizedBox(
              width: 2,
            ),
            IconButton(
                // constraints: BoxConstraints(
                //     maxHeight: 35, minHeight: 35, minWidth: 30, maxWidth: 30),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  // bool _stockInListExist = false;
                  // int? indexIfExist;
                  //
                  // List<TickerModel> stockList =
                  //     searchProvider.tickerList;
                  //
                  // for (int i = 0; i < stockList.length; i++) {
                  //   if (stockList[i].tickerId == selectedStock.ssTickerId) {
                  //     _stockInListExist = true;
                  //     indexIfExist = i;
                  //   }
                  // }
                  // if (_stockInListExist) {
                  //   await searchProvider.deleteStockDraftList(selectedStock.ssTickerId,
                  //       selectedStock.ssTicker, indexIfExist!, context);
                  // } else {
                  //   searchProvider.removeSelectedStock(
                  //       selectedStock.ssTickerId, selectedStock.ssTicker, context);
                  // }

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
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Color.fromARGB(255, 255, 0, 0),
                  size: 16,
                ))
          ],
        ),
      );
    }).toList();
  }

  Widget searchedStockPaginationBtns() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
            color: (themeProvider.defaultTheme) ? Colors.black : Colors.white),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (searchProvider.currentPage > 0)
            Container(
              margin: const EdgeInsets.only(left: 40, bottom: 0),
              child: InkWell(
                child: const Icon(
                  Icons.keyboard_double_arrow_left_outlined,
                  textDirection: TextDirection.rtl,
                  color: Colors.blue,
                  size: 40,
                ),
                onTap: () async {
                  if (searchProvider.currentPage > 0) {
                    searchProvider.isLoading = true;

                    searchProvider.currentPage -= 1;

                    searchProvider.searchingStockByNameNew(
                        searchProvider.currentPage,
                        query: searchProvider.textEditingController.text);
                  }
                },
              ),
            )
          else
            const SizedBox(),
          if (searchProvider.tickerList.length >= 50)
            Container(
              margin: const EdgeInsets.only(right: 40, bottom: 0),
              child: InkWell(
                child: const Icon(
                  Icons.keyboard_double_arrow_right_outlined,
                  color: Colors.blue,
                  size: 40,
                ),
                onTap: () async {
                  searchProvider.isLoading = true;
                  searchProvider.currentPage += 1;

                  searchProvider.searchingStockByNameNew(
                      searchProvider.currentPage,
                      query: searchProvider.textEditingController.text);
                },
              ),
            )
          else
            const SizedBox()
        ],
      ),
    );
  }

  Widget searchBar() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(3),
          ),
          child: TextField(
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
            textInputAction: TextInputAction.search,
            controller: searchProvider.textEditingController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color:
                      themeProvider.defaultTheme ? Colors.black : Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.7,
                  color: themeProvider.defaultTheme
                      ? Colors.black54
                      : Colors.white,
                ),
              ),
              hintText: 'Search Stocks',
              hintStyle: TextStyle(
                  color: themeProvider.defaultTheme
                      ? Colors.black54
                      : Colors.white),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.search,
                  color:
                      themeProvider.defaultTheme ? Colors.black : Colors.white,
                ),
              ),
            ),
            style: kBodyText.copyWith(
                color:
                    themeProvider.defaultTheme ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget stockFilterDialogBoxBtn() {
    return InkWell(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (ctx) => filterDialogbox(context),
            barrierDismissible: false);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Container(
            //   height: 22,
            //   width: 22,
            //   color: Colors.red,
            // ),
            Image.asset(
              "lib/global/assets/icons/filter.png",
              height: 22,
              width: 22,
              color: themeProvider.defaultTheme ? Colors.black : Colors.white,
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget searchedStockListing() {
    return Expanded(
      child: searchProvider.tickerList.isEmpty
          ? Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25),
              child: Text(
                "Does not match any result",
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 20, bottom: 5),
              child: searchProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : ListView.separated(
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
                                    ),
                                    child: Text(
                                      searchProvider
                                          .tickerList[index].tickerExchange,
                                      style: const TextStyle(
                                          color: Colors.white
                                              // Color.fromARGB(255, 20, 24, 228)
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    searchProvider.tickerList[index].ticker,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      searchProvider
                                          .tickerList[index].tickerIssuerName,
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
                                child: searchProvider
                                        .tickerList[index].isSelected
                                    ? SizedBox(height: 45)
                                    : IconButton(
                                        onPressed: () async {
                                          print("tap");
                                          print(searchProvider.isBtnClicked);
                                          if (!searchProvider.isBtnClicked) {
                                            searchProvider.isBtnClicked = true;
                                            await searchProvider
                                                .updateSelectedStockListNew(
                                                    index, context);
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
                      itemCount: searchProvider.tickerList.length,
                      separatorBuilder: (context, index) => Divider(
                        color: (themeProvider.defaultTheme)
                            ? Colors.grey
                            : Colors.white24,
                        height: 0,
                      ),
                    ),
            ),
    );
  }

  List<Widget> selectedStockListing() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 7, top: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Selected stocks',
              style: TextStyle(
                  color: false // value.defaultTheme
                      ? Colors.blue
                      : Color(0xFF0099CC),
                  fontSize: 17),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.11),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10, top: 10, bottom: 5),
            height: 27,
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
                onPressed: () async {
                  watchlistProvider
                      .addToWatchlist(searchProvider.selectedStockList.data!, context);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.green,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(5),
                  // ),
                  // side: const BorderSide(
                  //   color: Color(0xFF0099CC),
                  // ),
                ),
                // style: ElevatedButton.styleFrom().copyWith(
                //   backgroundColor: MaterialStateProperty<Color?>?.green,
                // ),
                child: Text('Add to Watchlist',
                    style: TextStyle(color: Colors.white)
                    // style: TextStyle(fontSize: 17)
                    )),
          ),
          // Container(
          //   margin: EdgeInsets.only(right: 10, top: 10, bottom: 5),
          //   height: 27,
          //   alignment: Alignment.centerLeft,
          //   child: OutlinedButton(
          //     style: OutlinedButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       side: const BorderSide(
          //         color: Color(0xFF0099CC),
          //       ),
          //     ),
          //     onPressed: () async {
          //       watchlistProvider
          //           .addToWatchlist(searchProvider.selectedStockList.data!);
          //     },
          //     child: Text(
          //       "Add to Watchlist",
          //       style: TextStyle(
          //           color: (themeProvider.defaultTheme)
          //               ?Colors.black:Colors.white
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(right: 10, top: 10, bottom: 5),
            height: 27,
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
                onPressed: () async {
                  if (!searchProvider.isBtnClicked) {
                    createDetailedLadderProvider.cashAllocatedControllerList.clear();
                    watchlistProvider
                        .addToWatchlist(searchProvider.selectedStockList.data!, context);
                    searchProvider.isBtnClicked = true;
                    searchProvider.searchBarFocus.unfocus();
                    searchProvider.textEditingController.clear();
                    searchProvider.isBtnClicked = false;
                    _navigationProvider.previousSelectedIndex =
                        _navigationProvider.selectedIndex;

                    _navigationProvider.selectedIndex = 4;
                    createDetailedLadderProvider.stockRecommendationParameters(searchProvider.selectedStockList.data!);

                    print(
                        "the next button in search ${_navigationProvider.selectedIndex}");
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.green,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(5),
                  // ),
                  // side: const BorderSide(
                  //   color: Color(0xFF0099CC),
                  // ),
                ),
                // style: ElevatedButton.styleFrom().copyWith(
                //   backgroundColor: MaterialStateProperty<Color?>?.green,
                // ),
                child: Text('Assign cash', style: TextStyle(color: Colors.white)
                    // style: TextStyle(fontSize: 17)
                    )),
          ),
        ],
      ),
    ];
  }
}
