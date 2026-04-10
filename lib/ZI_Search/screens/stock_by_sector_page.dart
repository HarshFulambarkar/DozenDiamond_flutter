import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/constants/custom_colors_light.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global/widgets/selected_stock_warning_dialog.dart';
import '../../watchlist/stateManagement/watchlist_provider.dart';
import '../models/ticker_model.dart';
import '../stateManagement/search_provider.dart';

class StockBySectorPage extends StatefulWidget {
  // final String selectedSector;
  final bool refreshProviderState;

  const StockBySectorPage(
      {Key? key,
      // required this.selectedSector,
      required this.refreshProviderState})
      : super(key: key);

  @override
  State<StockBySectorPage> createState() => _SelectedStockPageState();
}

class _SelectedStockPageState extends State<StockBySectorPage> {
  late SearchProvider searchProvider;
  late WatchlistProvider watchlistProvider;
  late ThemeProvider themeProvider;
  CurrencyConstants? _currencyConstantsProvider;
  late NavigationProvider _navigationProvider;
  late CreateLadderProvider createDetailedLadderProvider;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      searchProvider = Provider.of<SearchProvider>(context, listen: false);
      _currencyConstantsProvider =
          Provider.of<CurrencyConstants>(context, listen: false);
      _navigationProvider =
          Provider.of<NavigationProvider>(context, listen: false);
      searchProvider.callInitialApi(
          searchProvider.selectedSector, _currencyConstantsProvider!);
    });
  }

  @override
  Widget build(BuildContext context) {
    searchProvider = Provider.of<SearchProvider>(context, listen: true);
    watchlistProvider = Provider.of<WatchlistProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    createDetailedLadderProvider = Provider.of<CreateLadderProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return WillPopScope(
      onWillPop: () async {
        if (widget.refreshProviderState == true) {
          await searchProvider.searchingStockByNameNew(
              searchProvider.currentSectorPage,
              sectorName: searchProvider.selectedSector);
        }
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        // drawer: const NavigationDrawerWidget(),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(children: [
                            _selectStockTitle(),
                            const SizedBox(
                              height: 10,
                            ),
                            _stocksSearchBar(),
                            searchProvider.sectorTickerList.isEmpty
                                ? _noStockAvailableUI()
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: searchProvider.isLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : searchProvider
                                                  .sectorTickerList.isEmpty
                                              ? _noStockAvailableUI()
                                              : ListView.separated(
                                                  itemBuilder:
                                                      (context, index) {
                                                    return _stockUI(
                                                        searchProvider
                                                                .sectorTickerList[
                                                            index],
                                                        index);
                                                  },
                                                  itemCount: searchProvider
                                                      .sectorTickerList.length,
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          const Divider(
                                                    color: Colors.white24,
                                                    height: 0,
                                                  ),
                                                ),
                                    ),
                                  )
                          ]),
                        ),
                        if (!searchProvider.isLoading)
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: false // value.defaultTheme
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ),
                            child: Column(
                              children: [
                                _paginationBtns(),
                                if (searchProvider
                                    .selectedStockList.data!.isNotEmpty) ...[
                                  _selectedStocksTitle(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.11),
                                    width: MediaQuery.of(context).size.width *
                                        0.97,
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      child:
                                          Wrap(children: _selectedStockTag()),
                                    ),
                                  ),
                                  _createLadderProcessBtn(),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomHomeAppBarWithProvider(
                backButton: true,
                backIndex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _selectedStockTag() {
    return searchProvider.selectedStockList.data!.map((selectedStock) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: false // value.defaultTheme
              ? Colors.white
              : Color(0xFF15181F),
          border: Border.all(
            color: false // value.defaultTheme
                ? Colors.black
                : Colors.white,
          ),
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
            // Text(selectedStock.ssTicker),
            // SizedBox(
            //   width: 10,
            // ),
            IconButton(
                constraints: BoxConstraints(
                    maxHeight: 35, minHeight: 35, minWidth: 30, maxWidth: 30),
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
                  //   await searchProvider.deleteStockDraftList(selectedStock.ssTickerId ?? 0,
                  //       selectedStock.ssTicker ?? "", indexIfExist ?? 0, context);
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
                  color: Colors.red,
                ))
          ],
        ),
      );
    }).toList();
  }

  Widget _selectStockTitle() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 0, 10),
        child: Text(
          'Select Stocks (${searchProvider.selectedSector})',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _stocksSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8.0),
      child: TextField(
        onChanged: (value) {
          searchProvider.sectorDebouncer.run(() {
            searchProvider.currentSectorPage = 0;
            searchProvider.searchingStockByNameNew(
                searchProvider.currentSectorPage,
                query: searchProvider.sectorTextEditingController.text,
                sectorName: searchProvider.selectedSector);
          });
        },
        focusNode: searchProvider.sectorSearchBarFocus,
        textInputAction: TextInputAction.search,
        controller: searchProvider.sectorTextEditingController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.7,
              color: Colors.white,
            ),
          ),
          hintText: 'Search Stocks',
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

  Widget _noStockAvailableUI() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("No Stocks Available"),
          ),
        ],
      ),
    );
  }

  Widget _stockUI(TickerModel stockData, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Color.fromARGB(90, 4, 7, 170)),
                child: Text(
                  stockData.tickerExchange,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 20, 24, 228)),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                stockData.ticker,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                stockData.tickerIssuerName,
                style: TextStyle(overflow: TextOverflow.ellipsis),
              )),
            ],
          ),
        ),
        Flexible(
          child: Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: stockData.isSelected
                ? SizedBox(height: 45)
                : IconButton(
                    onPressed: () async {
                      if (!searchProvider.isBtnClicked) {
                        searchProvider.isBtnClicked = true;
                        // await searchProvider.updateSelectedStockList(index, context);
                        // searchProvider.getSelectedStockList();
                        await searchProvider.updateSelectedStockListNew(
                            index, context,
                            isSectorPage: true);
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
  }

  Widget _paginationBtns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (searchProvider.currentSectorPage >= 1)
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
                if (searchProvider.currentSectorPage >= 1) {
                  searchProvider.currentSectorPage -= 1;

                  searchProvider.searchingStockByNameNew(
                      searchProvider.currentSectorPage,
                      query: searchProvider.sectorTextEditingController.text,
                      sectorName: searchProvider.selectedSector);

                  // searchProvider.getSelectedStockList();
                }
              },
            ),
          )
        else
          const SizedBox(),
        if (searchProvider.sectorTickerList.length >= 10)
          Container(
            margin: const EdgeInsets.only(right: 40, bottom: 0),
            child: InkWell(
              child: const Icon(
                Icons.keyboard_double_arrow_right_outlined,
                color: Colors.blue,
                size: 40,
              ),
              onTap: () async {
                searchProvider.currentSectorPage += 1;

                searchProvider.searchingStockByNameNew(
                    searchProvider.currentSectorPage,
                    query: searchProvider.sectorTextEditingController.text,
                    sectorName: searchProvider.selectedSector);

                // searchProvider.getSelectedStockList();
              },
            ),
          )
        else
          const SizedBox()
      ],
    );
  }

  Widget _selectedStocksTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: 7, top: 1),
          alignment: Alignment.centerLeft,
          child: Text(
            'Selected stocks',
            style: TextStyle(color: Color(0xFF0099CC), fontSize: 17),
          ),
        ),
      ],
    );
  }

  Widget _createLadderProcessBtn() {
    return Row(
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
                print("hello world");
                searchProvider.sectorSearchBarFocus.unfocus();
                searchProvider.sectorTextEditingController.clear();
                if (!searchProvider.isBtnClicked) {
                  createDetailedLadderProvider.cashAllocatedControllerList.clear();
                  createDetailedLadderProvider.ladderCreationScreen1.clear();
                  createDetailedLadderProvider.ladderCreationScreen2.clear();
                  createDetailedLadderProvider.ladderCreationScreen3.clear();
                  watchlistProvider
                      .addToWatchlist(searchProvider.selectedStockList.data!, context);
                  searchProvider.isBtnClicked = true;
                  searchProvider.isBtnClicked = true;
                  searchProvider.searchBarFocus.unfocus();
                  searchProvider.textEditingController.clear();
                  searchProvider.isBtnClicked = false;
                  _navigationProvider.previousSelectedIndex =
                      _navigationProvider.selectedIndex;

                  _navigationProvider.selectedIndex = 4;

                  searchProvider.searchBarFocus.unfocus();

                  searchProvider.textEditingController.clear();

                  searchProvider.isBtnClicked = false;

                  _navigationProvider.previousSelectedIndex =
                      _navigationProvider.selectedIndex;

                  _navigationProvider.selectedIndex = 4;
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
    );
    // return Container(
    //   margin: EdgeInsets.only(right: 10, top: 5, bottom: 10),
    //   alignment: Alignment.centerRight,
    //   child: ElevatedButton(
    //       onPressed: () async {
    //         print("hello world");
    //         searchProvider.sectorSearchBarFocus.unfocus();
    //         searchProvider.sectorTextEditingController.clear();
    //         if (!searchProvider.isBtnClicked) {
    //           searchProvider.isBtnClicked = true;
    //           searchProvider.isBtnClicked = true;
    //           searchProvider.searchBarFocus.unfocus();
    //           searchProvider.textEditingController.clear();
    //           searchProvider.isBtnClicked = false;
    //           _navigationProvider.previousSelectedIndex =
    //               _navigationProvider.selectedIndex;
    //
    //           _navigationProvider.selectedIndex = 4;
    //
    //           searchProvider.searchBarFocus.unfocus();
    //
    //           searchProvider.textEditingController.clear();
    //
    //           searchProvider.isBtnClicked = false;
    //
    //           _navigationProvider.previousSelectedIndex =
    //               _navigationProvider.selectedIndex;
    //
    //           _navigationProvider.selectedIndex = 4;
    //         }
    //       },
    //       style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
    //       child: Text('Assign Cash',
    //           style: TextStyle(color: Colors.white, fontSize: 17))),
    // );
  }
}
