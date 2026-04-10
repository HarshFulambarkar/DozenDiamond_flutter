import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/custom_bottom_sheets.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/selected_stock_warning_dialog.dart';
import '../../watchlist/stateManagement/watchlist_provider.dart';
import '../models/selected_stock_model.dart';
import '../stateManagement/search_provider.dart';

class StockBySectorPageNew extends StatefulWidget {
  final bool refreshProviderState;

  const StockBySectorPageNew(
      {Key? key,
        // required this.selectedSector,
        required this.refreshProviderState})
      : super(key: key);

  @override
  State<StockBySectorPageNew> createState() => _StockBySectorPageNewState();
}

class _StockBySectorPageNewState extends State<StockBySectorPageNew> {

  late SearchProvider searchProvider;
  late WatchlistProvider watchlistProvider;
  late ThemeProvider themeProvider;
  CurrencyConstants? _currencyConstantsProvider;
  late NavigationProvider _navigationProvider;
  late CreateLadderProvider createDetailedLadderProvider;

  bool showSearchField = false;
  bool showSelectedStock = true;

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

                  // backgroundColor: Colors.red,
                  backgroundColor: (themeProvider.defaultTheme)
                      ? Color(0XFFF5F5F5)
                      : Color(0xFF15181F),
                  body: Stack(
                    children: [
                      Column(
                        children: [

                          SizedBox(
                            height: 45,
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          (showSearchField)
                              ?buildSearchField(context, screenWidth)
                              :buildTopSection(context, screenWidth),

                          SizedBox(
                            height: 15,
                          ),

                          Expanded(child: buildSectorStockListSection(context, screenWidth))

                        ],
                      ),

                      CustomHomeAppBarWithProviderNew(
                        backButton: true,
                        backIndex: 3,
                      ),
                    ],
                  ),
                    bottomNavigationBar: buildBottomSheetSection(context, screenWidth)
                ),
              ),
            )
          ],
        ),
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
          maxLength: 14,
          elevation: 0,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.text,
          textStyle: TextStyle(
              color: themeProvider.defaultTheme // value.defaultTheme
                  ? Colors.black54
                  : Colors.white
              // color: false // value.defaultTheme
              //     ? Colors.black54
              //     : Colors.white
          ),
          borderColor: Color(0xff2c2c31),
          margin: EdgeInsets.zero,
          focusedBorderColor: Color(0xff5cbbff),
          isFilled: true,
          fillColor: themeProvider.defaultTheme // value.defaultTheme
              ? Color(0xfff0f0f0)
              : Colors.black54,
          showLeadingWidget: true,
          leading: Icon(
            Icons.search,
            color: themeProvider.defaultTheme // value.defaultTheme
                ? Colors.black
                : Colors.white,
            // color: false // value.defaultTheme
            //     ? Colors.black
            //     : Colors.white,
          ),
          trailing: Icon(
            Icons.close,
            color: themeProvider.defaultTheme // value.defaultTheme
                ? Colors.black
                : Colors.white,
            // color: false // value.defaultTheme
            //     ? Colors.black
            //     : Colors.white,
          ),
          trailingFunction: () {

            setState(() {
              showSearchField = false;
              searchProvider.sectorTextEditingController.clear();
            });
            searchProvider.currentPage = 0;
            // searchProvider.searchingStocKByName(searchProvider.currentPage,
            //     query: searchProvider.textEditingController.text);
            searchProvider.searchingStockByNameNew(
                searchProvider.currentSectorPage,
                query: searchProvider.sectorTextEditingController.text,
                sectorName: searchProvider.selectedSector);

          },
          counterText: "",
          textInputFormatters: [

          ],
          borderRadius: 12,
          hintText: 'Search and add stocks',
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
          controller: searchProvider.sectorTextEditingController,
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
            "Select Stocks (${searchProvider.selectedSector})",
            style: TextStyle(
              fontFamily: 'Britanica',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
            ),
          ),

          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    showSearchField = true;
                  });

                },
                child: Icon(
                  Icons.search,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  size: 24,
                ),
              ),

              SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSectorStockListSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "All Sector Stocks",
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
            child: buildSectorStockList(context, screenWidth)
        ),

        (!searchProvider.isLoading)
            ? searchedSectorStockPaginationBtns(screenWidth)
            : Container(),

      ],
    );
  }

  Widget buildSectorStockList(BuildContext context, double screenWidth) {

    return (searchProvider.isLoading)
        ? const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    )
        : searchProvider.sectorTickerList.isEmpty
        ? _noStockAvailableUI()
        : ListView.separated(
      // physics: BouncingScrollPhysics(),
      // shrinkWrap: true,
      itemCount: searchProvider.sectorTickerList.length, // 10, //watchlistProvider.searchedStockList.length,
      itemBuilder: (context, index) {

        return buildSectorStockCard(context, screenWidth, index);
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10,
        );
      },
    );
  }

  Widget buildSectorStockCard(BuildContext context, double screenWidth, int index) {
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
                Row(
                  children: [
                    Text(
                      searchProvider
                          .sectorTickerList[index].ticker,
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
                                .sectorTickerList[index].tickerExchange,
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

                SizedBox(
                  height: 3,
                ),

                Text(
                  searchProvider
                      .sectorTickerList[index].tickerIssuerName,
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

                // (searchProvider
                //     .sectorTickerList[index].isAddedToWatchList)
                //     ? InkWell(
                //   onTap: () async {
                //     searchProvider.updateSectorTickerWatchlist(index, false, searchProvider.sectorTickerList[index].wlId);
                //
                //     await watchlistProvider.removeWatchList(searchProvider
                //         .sectorTickerList[index].wlId, searchProvider
                //         .sectorTickerList[index].tickerId.toString());
                //     await searchProvider.fetchWatchList();
                //
                //     searchProvider.sectorTickerList = await searchProvider.determineSelectedAndUnselectedTickers(
                //         searchProvider.sectorTickerList, searchProvider.selectedStockList.data ?? []);
                //
                //   },
                //   child: Icon(
                //     // Icons.add_circle_outline,
                //     // Icons.check_circle_outline,
                //     Icons.bookmark,
                //     size: 22,
                //     color: (themeProvider.defaultTheme)
                //         ?Color(0xff808083):Color(0xfff0f0f0), //Color(0xfff0f0f0), //Color(0xff1a94f2),
                //   ),
                // ) : InkWell(
                //   onTap: () async {
                //
                //     searchProvider.updateTickerWatchlist(index, true, searchProvider.tickerList[index].wlId);
                //     List<SelectedTickerModel>? data = [
                //       SelectedTickerModel(
                //         ssTickerId: searchProvider
                //             .sectorTickerList[index].tickerId,
                //       )
                //     ];
                //     await watchlistProvider.addToWatchlist(data, context);
                //     await searchProvider.fetchWatchList();
                //     searchProvider.sectorTickerList = await searchProvider.determineSelectedAndUnselectedTickers(
                //         searchProvider.sectorTickerList, searchProvider.selectedStockList.data ?? []);
                //   },
                //   child: Icon(
                //     // Icons.add_circle_outline,
                //     // Icons.add_circle_outline,
                //     Icons.bookmark_border,
                //     size: 22,
                //     color: (themeProvider.defaultTheme)
                //         ?Colors.black:Color(0xfff0f0f0), // Color(0xfff0f0f0), // Color(0xff808083), //Color(0xff1a94f2),
                //   ),
                // ),
                //
                // SizedBox(
                //   width: 10,
                // ),

                searchProvider
                    .sectorTickerList[index].isSelected
                    ?Icon(
                  Icons.check_circle,
                  color: Color(0xff1a94f2),
                  size: 18,
                ):InkWell(
                  onTap: () async {
                    print("tap");
                    print(searchProvider.isBtnClicked);
                    if (!searchProvider.isBtnClicked) {
                      searchProvider.isBtnClicked = true;
                      await searchProvider.updateSelectedStockListNew(
                          index, context,
                          isSectorPage: true);
                    }
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xff1a94f2),
                    size: 18,
                  ),
                )


              ],
            )
          ],
        ),
      ),
    );
  }

  Widget searchedSectorStockPaginationBtns(double screenWidth) {
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
            if (searchProvider.currentSectorPage > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12.0),
                child: CustomContainer(
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  padding: 0,
                  backgroundColor: Colors.transparent,
                  borderColor: Color(0xfff0f0f0),
                  borderRadius: 50,
                  onTap: () {
                    if (searchProvider.currentSectorPage > 0) {
                      searchProvider.isLoading = true;

                      searchProvider.currentSectorPage -= 1;

                      searchProvider.searchingStockByNameNew(
                          searchProvider.currentSectorPage,
                          query: searchProvider.sectorTextEditingController.text,
                          sectorName: searchProvider.selectedSector);
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
            // Container(
            //   margin: const EdgeInsets.only(left: 40, bottom: 0),
            //   child: InkWell(
            //     child: const Icon(
            //       Icons.keyboard_double_arrow_left_outlined,
            //       textDirection: TextDirection.rtl,
            //       color: Colors.blue,
            //       size: 40,
            //     ),
            //     onTap: () async {
            //       if (searchProvider.currentPage > 0) {
            //         searchProvider.isLoading = true;
            //
            //         searchProvider.currentPage -= 1;
            //
            //         searchProvider.searchingStockByNameNew(
            //             searchProvider.currentPage,
            //             query: searchProvider.textEditingController.text);
            //       }
            //     },
            //   ),
            // )
            // else
            //   const SizedBox(),

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

            if (searchProvider.sectorTickerList.length >= 50)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 12.0),
                child: CustomContainer(
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  padding: 0,
                  backgroundColor: Colors.transparent,
                  borderColor: Color(0xfff0f0f0),
                  borderRadius: 50,
                  onTap: () {
                    searchProvider.isLoading = true;
                    searchProvider.currentSectorPage += 1;

                    searchProvider.searchingStockByNameNew(
                        searchProvider.currentSectorPage,
                        query: searchProvider.sectorTextEditingController.text,
                        sectorName: searchProvider.selectedSector
                    );
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
            // Container(
            //   margin: const EdgeInsets.only(right: 40, bottom: 0),
            //   child: InkWell(
            //     child: const Icon(
            //       Icons.keyboard_double_arrow_right_outlined,
            //       color: Colors.blue,
            //       size: 40,
            //     ),
            //     onTap: () async {
            //       searchProvider.isLoading = true;
            //       searchProvider.currentPage += 1;
            //
            //       searchProvider.searchingStockByNameNew(
            //           searchProvider.currentPage,
            //           query: searchProvider.textEditingController.text);
            //     },
            //   ),
            // )
            else
              const SizedBox()
          ],
        ),
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

  Widget buildBottomSheetSection(BuildContext context , double screenWidth) {
    return Container(
        decoration: BoxDecoration(
          color: (themeProvider.defaultTheme)
              ?Color(0xfff5f5f5)
              :Color(0xff454545),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), // Apply radius only to top-left
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
                  (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)?Text(
                    "No stocks selected",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ?Colors.black
                          :Color(0xfff0f0f0),
                    ),
                  ):InkWell(
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
                                ?Colors.black
                                :Color(0xfff0f0f0),
                          ),
                        ),

                        Text(
                          "(${searchProvider.selectedStockList.data!.length}) ",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: (themeProvider.defaultTheme)
                                ?Colors.black
                                :Color(0xfff0f0f0),
                          ),
                        ),

                        Icon(
                          (showSelectedStock == true)
                              ?Icons.keyboard_arrow_up_outlined
                              :Icons.keyboard_arrow_down_outlined,
                          size: 24,
                          color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Color(0xfff0f0f0),
                        )
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      // Container(
                      //   margin: EdgeInsets.only(right: 10, top: 10, bottom: 5),
                      //   height: 27,
                      //   alignment: Alignment.centerLeft,
                      //   child: ElevatedButton(
                      //       onPressed: () async {
                      //         watchlistProvider
                      //             .addToWatchlist(searchProvider.selectedStockList.data!, context);
                      //       },
                      //       style: OutlinedButton.styleFrom(
                      //         backgroundColor: Colors.green,
                      //         // shape: RoundedRectangleBorder(
                      //         //   borderRadius: BorderRadius.circular(5),
                      //         // ),
                      //         // side: const BorderSide(
                      //         //   color: Color(0xFF0099CC),
                      //         // ),
                      //       ),
                      //       // style: ElevatedButton.styleFrom().copyWith(
                      //       //   backgroundColor: MaterialStateProperty<Color?>?.green,
                      //       // ),
                      //       child: Text('Add to Watchlist',
                      //           style: TextStyle(color: Colors.white)
                      //         // style: TextStyle(fontSize: 17)
                      //       )),
                      // ),

                      CustomContainer(
                        padding: 0,
                        paddingEdge: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        borderRadius: 12,
                        backgroundColor: (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                            ?Color(0xffa8a8a8):(themeProvider.defaultTheme)
                            ?Colors.black
                            :Color(0xfff0f0f0),
                        onTap: () {

                          if(searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty){

                            Fluttertoast.showToast(
                                msg: 'Select Ticker');

                          } else {

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
                                    ?Color(0xfff0f0f0)
                                    :(themeProvider.defaultTheme)
                                    ?Color(0xfff0f0f0)
                                    :Color(0xff000000),
                              )
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      CustomContainer(
                        padding: 0,
                        paddingEdge: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        borderRadius: 12,
                        backgroundColor: (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                            ?Color(0xffa8a8a8):(themeProvider.defaultTheme)
                            ?Colors.black
                            :Color(0xfff0f0f0),
                        onTap: () {

                          watchlistProvider
                              .addToWatchlist(searchProvider.selectedStockList.data!, context);


                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
                          child: Text(
                              "Add To Watchlist",
                              style: GoogleFonts.poppins(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                                    ?Color(0xfff0f0f0)
                                    :(themeProvider.defaultTheme)
                                    ?Color(0xfff0f0f0)
                                    :Color(0xff000000),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                  ?Container():(showSelectedStock == false)?Container():SizedBox(
                height: 10,
              ),

              (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                  ?Container()
                  :(showSelectedStock == false)
                  ?Container():Container(
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

              (searchProvider.selectedStockList.data == null || searchProvider.selectedStockList.data!.isEmpty)
                  ?Container():SizedBox(
                height: 10,
              ),


            ],
          ),
        )
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
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Text(
                  //     "Close",
                  //     style: GoogleFonts.poppins(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 16.5,
                  //         color: Color(0xfff0f0f0)
                  //     ),
                  //   ),
                  // ),
                  //
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
                                        color: (themeProvider.defaultTheme)
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
                                    searchProvider.callInitialApi(
                                        searchProvider.selectedSector, _currencyConstantsProvider!);
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
}
