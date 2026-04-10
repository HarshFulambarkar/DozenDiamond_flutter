import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_response.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/buy_sell_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/constants/currency_constants.dart';
import '../../global/functions/debouncer.dart';
import '../../global/models/http_api_exception.dart';
import '../../socket_manager/model/ddstock_socket_data_response.dart';
import '../../watchlist/models/watch_list_data_response.dart';
import '../../watchlist/services/watch_list_api_service.dart';
import '../models/add_sector_wise_stock_list.dart';
import '../models/add_stocks_to_selected_stock_list_request.dart';
import '../models/delete_user_stocks_draft_request.dart';
import '../models/delete_user_stocks_draft_response.dart';
import '../models/get_searching_stocks_by_name_request.dart';
import '../models/sector_response.dart';
import '../models/selected_stock_list_request.dart';
import '../models/selected_stock_list_respone.dart';
import '../models/selected_stock_model.dart';
import '../models/ticker_model.dart';
import '../services/search_rest_api_service.dart';
import '../utility/utils.dart';
import '../widgets/stock_add_query_dialog.dart';
import '../../global/functions/utils.dart' as global;

class SearchProvider extends ChangeNotifier {
  SearchProvider(this.navigatorKey);
  final GlobalKey<NavigatorState> navigatorKey;

  bool _showStockListSection = true;

  bool get showStockListSection => _showStockListSection;

  set showStockListSection(bool value) {
    _showStockListSection = value;
    notifyListeners();
  }

  List<TickerModel> _tickerList = [];

  List<TickerModel> get tickerList => _tickerList;

  List<WatchlistData> _watchList = [];

  List<WatchlistData> get watchList => _watchList;

  set watchList(List<WatchlistData> value) {
    _watchList = value;
    notifyListeners();
  }

  set tickerList(List<TickerModel> value) {
    print("here is the value of the ticker ${value[0].tickerId}");
    _tickerList = value;
    notifyListeners();
  }

  List<TickerModel> _sectorTickerList = [];

  List<TickerModel> get sectorTickerList => _sectorTickerList;

  set sectorTickerList(List<TickerModel> value) {
    _sectorTickerList = value;
    notifyListeners();
  }

  Debouncer _debouncer = Debouncer(milliSeconds: 500);

  Debouncer get debouncer => _debouncer;

  set debouncer(Debouncer value) {
    _debouncer = value;
    notifyListeners();
  }

  Debouncer _sectorDebouncer = Debouncer(milliSeconds: 500);

  Debouncer get sectorDebouncer => _sectorDebouncer;

  set sectorDebouncer(Debouncer value) {
    _sectorDebouncer = value;
    notifyListeners();
  }

  ScrollController _selectedStockScrollController = ScrollController();

  ScrollController get selectedStockScrollController =>
      _selectedStockScrollController;

  set selectedStockScrollController(ScrollController value) {
    _selectedStockScrollController = value;
    notifyListeners();
  }

  int _currentPage = 0;

  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  FocusNode _searchBarFocus = FocusNode();

  FocusNode get searchBarFocus => _searchBarFocus;

  set searchBarFocus(FocusNode value) {
    _searchBarFocus = value;
    notifyListeners();
  }

  FocusNode _sectorSearchBarFocus = FocusNode();

  FocusNode get sectorSearchBarFocus => _sectorSearchBarFocus;

  set sectorSearchBarFocus(FocusNode value) {
    _sectorSearchBarFocus = value;
    notifyListeners();
  }

  final _textEditingController = TextEditingController();

  get textEditingController => _textEditingController;

  set textEditingController(value) {
    _textEditingController.text = value;
    notifyListeners();
  }

  final _sectorTextEditingController = TextEditingController();

  get sectorTextEditingController => _sectorTextEditingController;

  set sectorTextEditingController(value) {
    _sectorTextEditingController.text = value;
    notifyListeners();
  }

  bool _isBtnClicked = false;

  bool get isBtnClicked => _isBtnClicked;

  set isBtnClicked(bool value) {
    _isBtnClicked = value;
    notifyListeners();
  }

  bool _isHistoricalDataLoaded = true;

  bool get isHistoricalDataLoaded => _isHistoricalDataLoaded;

  set isHistoricalDataLoaded(bool value) {
    _isHistoricalDataLoaded = value;
    notifyListeners();
  }

  SelectedStockListResponse _selectedStockList =
      SelectedStockListResponse(data: []);

  SelectedStockListResponse get selectedStockList => _selectedStockList;

  set selectedStockList(SelectedStockListResponse value) {
    _selectedStockList = value;
  }

  List<String> _filterList = [
    "Select stocks by Sector",
    "Select stocks by Name/Ticker",
    "Rec. stocks based on extra cash",
    "Rec. ETF's based on extra cash"
  ];

  List<String> get filterList => _filterList;

  set filterList(List<String> value) {
    _filterList = value;
    notifyListeners();
  }

  List<SectorWiseStockListModel> _sectorList = [];

  List<SectorWiseStockListModel> get sectorList => _sectorList;

  set sectorList(List<SectorWiseStockListModel> value) {
    _sectorList = value;
    notifyListeners();
  }

  int _currentSectorPage = 0;

  int get currentSectorPage => _currentSectorPage;

  set currentSectorPage(int value) {
    _currentSectorPage = value;
    notifyListeners();
  }

  List<int> _tickerIdList = [];

  List<int> get tickerIdList => _tickerIdList;

  set tickerIdList(List<int> value) {
    _tickerIdList = value;
    notifyListeners();
  }

  String _selectedSector = "";

  String get selectedSector => _selectedSector;

  set selectedSector(String value) {
    _selectedSector = value;
    notifyListeners();
  }

  void updateSectorList(List<TickerModel> tempList) {
    tickerList = tempList;
    notifyListeners();
  }

  void updateTicker(int index, bool isStockSelected) {
    tickerList[index].isSelected = isStockSelected;
    notifyListeners();
  }

  void updateSectorTicker(int index, bool isStockSelected) {
    print("here is the index value $index");
    sectorTickerList[index].isSelected = isStockSelected;
    notifyListeners();
  }

  void updateTickerWatchlist(int index, bool isStockSelected, String wlId) {
    tickerList[index].isAddedToWatchList = isStockSelected;
    // tickerList[index].wlId = wlId;
    notifyListeners();
  }

  void updateSectorTickerWatchlist(
      int index, bool isStockSelected, String wlId) {
    print("here is the index value $index");
    sectorTickerList[index].isAddedToWatchList = isStockSelected;
    // sectorTickerList[index].wlId = wlId;
    notifyListeners();
  }

  void fillDummyData(CurrencyConstants currenyConstantsProvider) {
    if (currenyConstantsProvider.currency == "₹") {
      // tickerList = [
      //   TickerModel(
      //       tickerId: 3637,
      //       tickerExchange: "BSE",
      //       tickerIssuerName: "Tata Consultancy Services Ltd.",
      //       ticker: "TCS",
      //       isSelected: false),
      //   TickerModel(
      //       tickerId: 53,
      //       tickerExchange: "BSE",
      //       tickerIssuerName: "Aarti Industries Ltd",
      //       ticker: "AARTIIND",
      //       isSelected: false),
      //   TickerModel(
      //       tickerId: 4036,
      //       tickerExchange: "BSE",
      //       tickerIssuerName: "Wipro  Ltd.,",
      //       ticker: "WIPRO",
      //       isSelected: false)
      // ];
    } else {
      tickerList = [
        TickerModel(
            tickerId: 3637,
            tickerExchange: "NASDAQ",
            tickerIssuerName: "Microsoft Corp",
            ticker: "MSFT",
            isSelected: false),
        TickerModel(
            tickerId: 53,
            tickerExchange: "NASDAQ",
            tickerIssuerName: "Alphabet Inc Class C",
            ticker: "GOOG",
            isSelected: false),
        TickerModel(
            tickerId: 4036,
            tickerExchange: "NASDAQ",
            tickerIssuerName: "Amazon.com Inc",
            ticker: "AMZN",
            isSelected: false)
      ];
    }
  }

  // void removeFromList(int index) {
  //   tickerList.removeAt(index);
  //   notifyListeners();
  // }

  // void clearList() {
  //   tickerList.clear();
  //   notifyListeners();
  // }

  Future<bool> fetchWatchList() async {
    try {
      watchList.clear();

      WatchListDataResponse? res =
          await WatchlistRestApiService().fetchWatchList();

      if (res.message!.toLowerCase() == "success") {
        watchList = res.data ?? [];
        // otpResponse = res;
        // Fluttertoast.showToast(msg: res.message ?? "");
        return true;
      } else {
        return false;
      }

      return false;
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      return false;
    }
  }

  Future<void> getSectorList() async {
    try {
      SectorResponse? res = await SearchRestApiService().getSectorList();

      isLoading = false;

      sectorList.clear();

      for (var i = 0; i < res!.data!.length; i++) {
        sectorList.add(
          SectorWiseStockListModel(
            stockName: res.data![i].secName!,
            // route: StockBySectorPage(
            //   refreshProviderState: true,
            //   // selectedSector: res[i].secName!,
            // ),
          ),
        );
      }
      // updateState();
    } on HttpApiException catch (err) {
      print(err);
    } finally {
      print("In the finally statement");
    }
  }

  Future<bool> getHistoricalData(String stockName, BuildContext context) async {
    try {
      BuySellProvider _buySellProvider =
          Provider.of<BuySellProvider>(context, listen: false);
      await _buySellProvider.getHistoricalDataOfStock(stockName,
          checkHistorical: true);
      print("await statment is executed");
      return true;
    } on HttpApiException catch (err) {
      _isBtnClicked = false;
      if (err.errorCode == 404 &&
          err.errorTitle == "The symbol name is not found.") {
        String warningMessage =
            "We're sorry, but the historical data for $stockName is currently unavailable.";
        bool? userDecision = await showDialog(
            context: context,
            builder: (ctx) =>
                StockAddQueryDialog(warningMessage: warningMessage));
        isHistoricalDataLoaded = false;
        return userDecision ?? false;
      } else {
        print(err);
        return false;
      }
    } finally {
      print("finally is executed");
    }
  }

  Future<void> updateSelectedStockListNew(int index, BuildContext context,
      {bool isSectorPage = false}) async {
    print("inside updateSelectedStockListNew");

    if (selectedStockList.data!.length < 12) {
      List<TickerModel> actualTickerList = [];
      if (isSectorPage) {
        actualTickerList = sectorTickerList;
      } else {
        actualTickerList = tickerList;
      }
      try {
        if (await getHistoricalData(actualTickerList[index].ticker, context)) {
          await SearchRestApiService()
              .addStockToSelectedStockList(AddStocksToSelectedStockListRequest(
            tickerId: actualTickerList[index].tickerId,
          ));
          if (isSectorPage == true) {
            print("insideeeee if");

            updateSectorTicker(index, true);
          } else {
            updateTicker(index, true);

            // updateSelectedStock(index, true);
          }
          selectedStockList.data!.add(SelectedTickerModel(
              ssTicker: actualTickerList[index].ticker,
              ssExchange: actualTickerList[index].tickerExchange,
              ssTickerId: actualTickerList[index].tickerId));
          isBtnClicked = false;
          print("all the await functions executed");
        }
      } on HttpApiException catch (err) {
        isBtnClicked = false;

        print(err);
      } finally {
        isBtnClicked = false;

        if ((kDebugMode || kIsWeb) && isHistoricalDataLoaded) {
          if (isSectorPage == true) {
            updateSectorTicker(index, true);
          } else {
            updateTicker(index, true);
          }
          // updateSelectedStock(index, true);
          final value = await checkIfContainerSelectedStock(
              selectedStockList.data!,
              SelectedTickerModel(
                  ssTicker: actualTickerList[index].ticker,
                  ssExchange: actualTickerList[index].tickerExchange,
                  ssTickerId: actualTickerList[index].tickerId));
          if (value == false) {
            selectedStockList.data!.add(SelectedTickerModel(
                ssTicker: actualTickerList[index].ticker,
                ssExchange: actualTickerList[index].tickerExchange,
                ssTickerId: actualTickerList[index].tickerId));
          }

          isBtnClicked = false;
        }

        print("In the finally statement");
      }
      isBtnClicked = false;
    } else {
      isBtnClicked = false;
      print("in 12 stock already added condition");
      Utility().showSnack("12 stock already added",
          navigatorKey.currentState!.overlay!.context);
    }
  }

  // Future<void> updateSelectedStockList(int index, BuildContext context) async {
  //   try {
  //     if (await getHistoricalData(
  //         tickerList[index].ticker, context)) {
  //       await SearchRestApiService()
  //           .addStockToSelectedStockList(AddStocksToSelectedStockListRequest(
  //         tickerId: tickerList[index].tickerId,
  //       ));
  //
  //       // Provider.of<StockPriceListener>(context, listen: false)
  //       //     .socket!
  //       //     .emit('tick');
  //       // await appBarProvider!.fetchUserAccountDetails();
  //       updateSelectedStock(index, true);
  //       // await getSelectedStockList();
  //       // await searchingStocKByName(currentPage,
  //       //     query: textEditingController.text);
  //
  //       selectedStockList.data!.add(
  //         SelectedTickerModel(
  //           ssId: tickerList[index].tickerId
  //         )
  //       );
  //       isBtnClicked = false;
  //       print("all the await functions executed");
  //     }
  //   } on HttpApiException catch (err) {
  //     isBtnClicked = false;
  //     print(err);
  //   } finally {
  //     print("In the finally statement");
  //   }
  // }

  Future<void> getSelectedStockList(
      CurrencyConstants currenyConstantsProvider) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      SelectedStockListResponse? value = await SearchRestApiService()
          .getSelectedStockList(SelectedStockListRequest(
        regId: pref.getInt("reg_id").toString(),
      ));
      print("the await function is executed");
      print(value);
      selectedStockList = value!;
      print(selectedStockList.data!.length);
    } on HttpApiException catch (err) {
      _isBtnClicked = false;
      print(err);
    } finally {
      print("in finally of kDebugMode");
      // if (kDebugMode || kIsWeb) {
      //   print("in side kDebugMode");
      //   fillDummyData(currenyConstantsProvider);
      // }
      print("in the finally block");
    }
  }

  Future<bool> checkIfContainerSelectedStock(
      List<SelectedTickerModel> selectedTickerList,
      SelectedTickerModel selectedTicker) async {
    for (int i = 0; i < selectedTickerList.length; i++) {
      if (selectedTickerList[i].ssTickerId == selectedTicker.ssTickerId) {
        return true;
      }
    }
    return false;
  }

  Future<List<TickerModel>> determineSelectedAndUnselectedTickers(
      List<TickerModel> tickerList,
      List<SelectedTickerModel> selectedTickerList) async {
    print("inside determine");
    final List<TickerModel> tempTickerList = [];

    for (var i = 0; i < tickerList.length; i++) {
      print(
          "here is the list of ticker that you are searching ${tickerList[i].tickerId}");
      bool _isSelected = false;
      if (selectedTickerList.isNotEmpty) {
        for (int j = 0; j < selectedTickerList.length; j++) {
          if (selectedTickerList[j].ssTickerId == tickerList[i].tickerId) {
            _isSelected = true;
          }
        }
      }

      bool _isAddedToWatchList = false;
      String wlId = "";
      if (watchList.isNotEmpty) {
        for (int j = 0; j < watchList.length; j++) {
          if (watchList[j].wlTickerId == tickerList[i].tickerId) {
            _isAddedToWatchList = true;
            wlId = watchList[j].wlId.toString();
          }
        }
      }

      tempTickerList.add(TickerModel(
        isSelected: _isSelected,
        wlId: wlId,
        isAddedToWatchList: _isAddedToWatchList,
        tickerId: int.tryParse(tickerList[i].tickerId.toString()) ?? 0,
        tickerExchange: tickerList[i].tickerExchange ?? "",
        tickerIssuerName: tickerList[i].tickerIssuerName ?? "",
        ticker: tickerList[i].ticker ?? "",
      ));
    }
    print('Temp Ticker List: ${tempTickerList[0].tickerId}');
    return tempTickerList;
  }

  Future<void> searchingStockByNameNew(
    int pageNumber, {
    String query = "",
    String sectorName = "",
  }) async {
    print("inside searchingStockByNameNew");
    isLoading = true;
    try {
      final res = await SearchRestApiService().getSearchingStocksByName(
          GetSearchingStocksByNameRequest(
              pageNumber: pageNumber,
              stockName: query,
              sectorName: sectorName));

      isLoading = false;

      if (sectorName != "") {
        print("in side sector section");
        sectorTickerList = await determineSelectedAndUnselectedTickers(
            res!.data!, selectedStockList.data ?? []);
      } else {
        print("in side section");
        tickerList = await determineSelectedAndUnselectedTickers(
            res!.data!, selectedStockList.data ?? []);
        print("here is the list of--- tickers ${tickerList[0].tickerId}");
      }
    } on HttpApiException catch (err) {
      print(err);
      isLoading = false;
    } finally {
      print("In the finally block");
    }
  }

  // Future<void> searchingStocKByName(int pageNumber, {String query = ""}) async {
  //   try {
  //     final res = await SearchRestApiService().getSearchingStocksByName(
  //         GetSearchingStocksByNameRequest(
  //             pageNumber: pageNumber, stockName: query, sectorName: ""));
  //     final List<TickerModel> searchByName = [];
  //     for (var i = 0; i < res!.data!.length; i++) {
  //       bool _isSelected = false;
  //       if (selectedStockList.data!.isNotEmpty) {
  //         for (int j = 0; j < selectedStockList.data!.length; j++) {
  //           if (selectedStockList.data![j].ssTickerId == res.data![i].tickerId) {
  //             _isSelected = true;
  //           }
  //         }
  //       }
  //       searchByName.add(TickerModel(
  //         isSelected: _isSelected,
  //         tickerId: int.tryParse(res.data![i].tickerId.toString()) ?? 0,
  //         tickerExchange: res.data![i].tickerExchange ?? "",
  //         tickerIssuerName: res.data![i].tickerIssuerName ?? "",
  //         ticker: res.data![i].ticker ?? "",
  //       ));
  //
  //       updateSectorList(searchByName);
  //     }
  //
  //   } on HttpApiException catch (err) {
  //     print(err);
  //   } finally {
  //     print("In the finally block");
  //   }
  // }

  // Future<void> deleteStockDraftList(int tickerId, String ticker, int index, BuildContext context) async {
  //   try {
  //     final pref = await SharedPreferences.getInstance();
  //     DeleteStockFromSelectedStockListResponse? value = await SearchRestApiService().deleteStockFromSelectedStockList(
  //         DeleteStockFromSelectedStockListRequest(
  //           regId: pref.getInt("reg_id").toString(),
  //           ticker: tickerList[index].tickerId,
  //           forceDelete: false,
  //         ));
  //     await getSelectedStockList();
  //     await searchingStocKByName(currentPage,
  //         query: textEditingController.text);
  //
  //
  //     if (value!.status!) {
  //       // await appBarProvider!.fetchUserAccountDetails();
  //       print("all function awaitting is executed");
  //       updateSelectedStock(index, false);
  //     } else {
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return SelectedStockWarningDialog(
  //                 warningMessage: value.message!,
  //                 ladderName: [], // value.data?.ladders,
  //                 stockName: ticker,
  //                 isForWarning: true, //value.data?.anyLadderActive,
  //                 tickerId: tickerId);
  //           });
  //     }
  //   } on HttpApiException catch (err) {
  //     if (err.runtimeType == HttpApiException &&
  //         err.errorCode == 400 &&
  //         err.errorTitle ==
  //             "Funds are allocated to the ladders associated with the requested stock.") {
  //     } else {
  //       print(err);
  //     }
  //   } finally {
  //     print("in the finally block");
  //   }
  // }

  Future<String> removeSelectedStockNew(int tickerId, String ticker,
      BuildContext context, SelectedTickerModel selectedTicker) async {
    print("in removeSelectedStockNew");
    try {
      final pref = await SharedPreferences.getInstance();
      DeleteStockFromSelectedStockListResponse? value =
          await SearchRestApiService().deleteStockFromSelectedStockList(
              DeleteStockFromSelectedStockListRequest(
        regId: pref.getInt("reg_id").toString(),
        ticker: tickerId,
        forceDelete: false,
      ));
      print("await functions is successfully executed");

      if (value!.status!) {
        selectedStockList.data!.remove(selectedTicker);
        tickerList = await determineSelectedAndUnselectedTickers(
            tickerList, selectedStockList.data ?? []);
        sectorTickerList = await determineSelectedAndUnselectedTickers(
            tickerList, selectedStockList.data ?? []);

        print("below is snack bar");
        Utility().showSnack(
            value.message!, navigatorKey.currentState!.overlay!.context);

        return "";
      } else {
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return SelectedStockWarningDialog(
        //           warningMessage: value.message!,
        //           ladderName: [], //value.data?.ladders,
        //           stockName: ticker,
        //           isForWarning: true,
        //           tickerId: tickerId);
        //     });
        //
        return value.message!;
      }
    } on HttpApiException catch (err) {
      _isBtnClicked = false;
      print(err);
      return "";
    } finally {
      print("finally block of code");

      if (kDebugMode || kIsWeb) {
        selectedStockList.data!.remove(selectedTicker);
        tickerList = await determineSelectedAndUnselectedTickers(
            tickerList, selectedStockList.data ?? []);
        sectorTickerList = await determineSelectedAndUnselectedTickers(
            tickerList, selectedStockList.data ?? []);
      }
      return "";
      print("finally block of code");
    }
  }

  // Future<void> removeSelectedStock(int tickerId, String ticker, BuildContext context) async {
  //   try {
  //     final pref = await SharedPreferences.getInstance();
  //     DeleteStockFromSelectedStockListResponse? value =
  //     await SearchRestApiService().deleteStockFromSelectedStockList(
  //         DeleteStockFromSelectedStockListRequest(
  //           regId: pref.getInt("reg_id").toString(),
  //           ticker: tickerId,
  //         ));
  //     print("await functions is successfully executed");
  //
  //     if (value!.status!) {
  //       await getSelectedStockList();
  //       await searchingStocKByName(currentPage,
  //           query: textEditingController.text);
  //       // appBarProvider!.fetchUserAccountDetails();
  //     } else {
  //
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return SelectedStockWarningDialog(
  //                 warningMessage: value.message!,
  //                 ladderName: [], //value.data?.ladders,
  //                 stockName: ticker,
  //                 isForWarning: true,
  //                 tickerId: tickerId);
  //           });
  //
  //     }
  //   } on HttpApiException catch (err) {
  //     _isBtnClicked = false;
  //     print(err);
  //   } finally {
  //     print("finally block of code");
  //   }
  // }

  void callInitialApi(
      String selectedSector, CurrencyConstants currenyConstantsProvider) async {
    try {
      await getSelectedStockList(currenyConstantsProvider);
      searchingStockByNameNew(currentSectorPage,
          query: "", sectorName: selectedSector);
      // sectorTickerList = await getTickerListNew(sectorCurrentPage, selectedSector);
      print("the await function is executed");
    } on HttpApiException catch (err) {
      print(err);
    } finally {
      print("in the finally block");
    }
  }

  // Future<void> bseStockNameList(int pageNumber, String selectedSector) async {
  //   try {
  //
  //     GetSearchingStocksByNameResponse? res = await SearchRestApiService()
  //         .getBseStockNameBySector(GetBseStockNameBySectorRequest(
  //       stockName: "",
  //       sector: selectedSector,
  //       pageNumber: pageNumber,
  //     ));
  //
  //     print("the await function is executed");
  //     final List<TickerModel> tickerbolListTemp = [];
  //     for (var i = 0; i < res!.data!.length; i++) {
  //       bool _isSelected = false;
  //       if (_selectedStockList!.data!.isNotEmpty) {
  //         for (int j = 0; j < _selectedStockList.data!.length; j++) {
  //           if (_selectedStockList.data![j].ssTickerId == res.data![i].tickerId) {
  //             _isSelected = true;
  //           }
  //         }
  //       }
  //       tickerbolListTemp.add(
  //         TickerModel(
  //           tickerExchange: res.data![i].tickerExchange!,
  //           ticker: res.data![i].ticker,
  //           tickerId: res.data![i].tickerId,
  //           isSelected: _isSelected,
  //         ),
  //       );
  //     }
  //     updateSectorList(tickerbolListTemp);
  //
  //   } on HttpApiException catch (err) {
  //     print(err);
  //   } finally {
  //     print("In the finally block");
  //   }
  // }

  //check this
  // Future<List<TickerModel>> getTickerListNew(int pageNumber, String selectedSector) async {
  //   try {
  //
  //     getSelectedStockList();
  //     final res =
  //     await SearchRestApiService().getStockNameList(GetStockNameListRequest(
  //       sector: selectedSector,
  //       pageNumber: pageNumber,
  //     ));
  //     print("got the awaitted res");
  //
  //     final List<TickerModel> tickerListTemp = [];
  //     for (var i = 0; i < res!.length; i++) {
  //       bool _isSelected = false;
  //       if (selectedStockList.data!.isNotEmpty) {
  //         for (int j = 0; j < selectedStockList.data!.length; j++) {
  //           if (selectedStockList.data![j].ssTickerId == res[i].tickerId) {
  //             _isSelected = true;
  //           }
  //         }
  //       }
  //       tickerListTemp.add(
  //         TickerModel(
  //           tickerExchange: res[i].tickerExchange!,
  //           ticker: res[i].ticker!,
  //           tickerId: res[i].tickerId!,
  //           isSelected: _isSelected,
  //         ),
  //       );
  //     }
  //     // updateSectorList(tickerListTemp);
  //
  //     return tickerListTemp;
  //   } on HttpApiException catch (err) {
  //     print(err);
  //   } finally {
  //     print("in the finally block");
  //   }
  //
  //   return [];
  // }

  void updateTickerFromWatchlist(DdStock stock, bool isStockSelected) {
    tickerList
        .firstWhere((tick) => tick.tickerId == stock.tickerId)
        .isSelected =
        isStockSelected;

    notifyListeners();
  }

  void updateSectorTickerFromWatchlist(DdStock stock, bool isStockSelected) {
    sectorTickerList
        .firstWhere((tick) => tick.tickerId == stock.tickerId)
        .isSelected =
        isStockSelected;
    notifyListeners();
  }

  Future<bool> updateSelectedStockListFromWatchList(
      DdStock stock,
      BuildContext context, {
        bool isSectorPage = false,
      }) async {
    print("inside updateSelectedStockListNew");

    if (selectedStockList.data!.any(
          (ticker) => ticker.ssTickerId == stock.tickerId,
    )) {
      isBtnClicked = false;

      global.Utility().errorDialog(
          context, "", "Already added", "Stock is already added", "");

      return false;
      // Utility().showSnack(
      //   "Stock already added",
      //   context
      //   // navigatorKey.currentState!.overlay!.context,
      // );
    } else if (selectedStockList.data!.length < 12) {
      try {
        if (await getHistoricalData(stock.ticker.toString(), context)) {
          await SearchRestApiService().addStockToSelectedStockList(
            AddStocksToSelectedStockListRequest(
              tickerId: stock.tickerId?.toInt() ?? 0,
            ),
          );
          // if (isSectorPage == true) {
          //   print("insideeeee if");

          //   updateSectorTickerFromWatchlist(stock, true);
          // } else {
          //   updateTickerFromWatchlist(stock, true);

          //   // updateSelectedStock(index, true);
          // }
          selectedStockList.data!.add(
            SelectedTickerModel(
              ssTicker: stock.ticker.toString(),
              ssExchange: stock.tickerExchange.toString(),
              ssTickerId: stock.tickerId?.toInt() ?? 0,
            ),
          );
          isBtnClicked = false;
          print("all the await functions executed");
        }
      } on HttpApiException catch (err) {
        isBtnClicked = false;

        print(err);
      } finally {
        isBtnClicked = false;

        if ((kDebugMode || kIsWeb) && isHistoricalDataLoaded) {
          // if (isSectorPage == true) {
          //   updateSectorTickerFromWatchlist(stock, true);
          // } else {
          //   updateTickerFromWatchlist(stock, true);
          // }
          // updateSelectedStock(index, true);
          final value = await checkIfContainerSelectedStock(
            selectedStockList.data!,
            SelectedTickerModel(
              ssTicker: stock.ticker.toString(),
              ssExchange: stock.tickerExchange.toString(),
              ssTickerId: stock.tickerId?.toInt() ?? 0,
            ),
          );
          if (value == false) {
            selectedStockList.data!.add(
              SelectedTickerModel(
                ssTicker: stock.ticker.toString(),
                ssExchange: stock.tickerExchange.toString(),
                ssTickerId: stock.tickerId?.toInt() ?? 0,
              ),
            );
          }

          isBtnClicked = false;
        }

        print("In the finally statement");
      }
      isBtnClicked = false;

      return true;
    } else {
      isBtnClicked = false;
      print("in 12 stock already added condition");
      global.Utility().errorDialog(
          context, "", "12 stock already added", "12 stock already added", "");
      // Utility().showSnack(
      //   "12 stock already added",
      //   context
      //   // navigatorKey.currentState!.overlay!.context,
      // );

      return false;
    }
  }
}
