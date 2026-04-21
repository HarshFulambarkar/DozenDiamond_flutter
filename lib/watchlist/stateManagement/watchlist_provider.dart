import 'package:dozen_diamond/ZI_Search/models/selected_stock_model.dart';
import 'package:dozen_diamond/socket_manager/stateManagement/web_socket_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../global/models/http_api_exception.dart';
import '../models/add_to_watchlist_response.dart';
import '../models/remove_from_watch_list_data_response.dart';
import '../models/searched_stock_data_response.dart';
import '../models/watch_list_data_response.dart';
import '../services/watch_list_api_service.dart';

class WatchlistProvider extends ChangeNotifier {
  WatchlistProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  List<WatchlistData> _watchList = [];

  List<WatchlistData> get watchList => _watchList;

  set watchList(List<WatchlistData> value) {
    _watchList = value;
    notifyListeners();
  }

  String _selectedWatchListSection = "1";

  String get selectedWatchListSection => _selectedWatchListSection;

  set selectedWatchListSection(String value) {
    _selectedWatchListSection = value;
    notifyListeners();
  }

  List<SearchedStockData> _searchedStockList = [];


  List<SearchedStockData> get searchedStockList => _searchedStockList;

  set searchedStockList(List<SearchedStockData> value) {
    _searchedStockList = value;
    notifyListeners();
  }

  bool _isSearchingStock = false;

  bool get isSearchingStock => _isSearchingStock;

  set isSearchingStock(bool value) {
    _isSearchingStock = value;
    notifyListeners();
  }

  bool _isButtonClicked = false;

  bool get isButtonClicked => _isButtonClicked;

  set isButtonClicked(bool value) {
    _isButtonClicked = value;
    notifyListeners();
  }

  TextEditingController searchedStockNameTextController = TextEditingController();

  bool _showSearchPage = false;

  bool get showSearchPage => _showSearchPage;

  set showSearchPage(bool value) {
    _showSearchPage = value;
    notifyListeners();
  }

  bool _isEditingStockList = false;

  bool get isEditingStockList => _isEditingStockList;

  set isEditingStockList(bool value) {
    _isEditingStockList = value;
    notifyListeners();
  }

  // List<Map<String, dynamic>> watchlist = [
  //   {
  //     "name": "ZOMATO",
  //     "issuer_name": "ZOMATO LIMITED",
  //     "exchange": "BSE",
  //     "price": 174.52,
  //     "change": 1.24,
  //     "isPositive": true
  //   },
  //   {
  //     "name": "TCS",
  //     "issuer_name": "TATA CONSULTANCY SERVICES",
  //     "exchange": "BSE",
  //     "price": 2820.15,
  //     "change": -15.78,
  //     "isPositive": false},
  //   {
  //     "name": "WIPRO",
  //     "price": 3517.43,
  //     "issuer_name": "WIPRO",
  //     "exchange": "BSE",
  //     "change": 8.24,
  //     "isPositive": true
  //   },
  //   {
  //     "name": "TCS",
  //     "issuer_name": "TATA CONSULTANCY SERVICES",
  //     "exchange": "BSE",
  //     "price": 2820.15,
  //     "change": -15.78,
  //     "isPositive": false
  //   },
  //   {
  //     "name": "TCS",
  //     "price": 2820.15,
  //     "issuer_name": "TATA CONSULTANCY SERVICES",
  //     "exchange": "BSE",
  //     "change": -15.78,
  //     "isPositive": false
  //   },
  //   {
  //     "name": "WIPRO",
  //     "issuer_name": "WIPRO",
  //     "exchange": "BSE",
  //     "price": 3517.43,
  //     "change": 8.24,
  //     "isPositive": true
  //   },
  //   {
  //     "name": "TCS",
  //     "issuer_name": "TATA CONSULTANCY SERVICES",
  //     "exchange": "BSE",
  //     "price": 2820.15,
  //     "change": -15.78,
  //     "isPositive": false
  //   },
  //   {
  //     "name": "WIPRO",
  //     "issuer_name": "WIPRO",
  //     "exchange": "BSE",
  //     "price": 3517.43,
  //     "change": 8.24,
  //     "isPositive": true
  //   },
  //   {
  //     "name": "WIPRO",
  //     "issuer_name": "WIPRO",
  //     "exchange": "BSE",
  //     "price": 3517.43,
  //     "change": 8.24,
  //     "isPositive": true
  //   },
  //   {
  //     "name": "TCS",
  //     "issuer_name": "TATA CONSULTANCY SERVICES",
  //     "exchange": "BSE",
  //     "price": 2820.15,
  //     "change": -15.78,
  //     "isPositive": false
  //   },
  //   {
  //     "name": "WIPRO",
  //     "issuer_name": "WIPRO",
  //     "exchange": "BSE",
  //     "price": 3517.43,
  //     "change": 8.24,
  //     "isPositive": true
  //   },
  // ];

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

  Future<bool> removeWatchList(String? watchlistId, String? tickerId) async {
    try {
      Map<String, dynamic> request = {
        "wl_id": watchlistId,
        "tickerId": tickerId,
      };

      RemoveFromWatchListDataResponse? res =
          await WatchlistRestApiService().removeFromWatchList(request);

      if (res.message!.toLowerCase() == "success") {
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

  Future<bool> addToWatchlist(List<SelectedTickerModel> selectedTickers, BuildContext context) async {
    try {
      print("We came till the method");
      print("Selected Tickers length: ${selectedTickers.length}");
      // List<Map<String, dynamic>> dataList = [];
      List<String> dataList = [];
      for (int i = 0; i < selectedTickers.length; i++) {
        // Map<String, dynamic> data = {
        //   "ss_id": selectedTickers[i].ssId,
        // };
        // dataList.add(data);
        dataList.add(selectedTickers[i].ssTickerId.toString());
      }

      Map<String, dynamic> request = {
        // 'data': dataList,
        'ticker_id': dataList,
      };

      // AddToWatchlistResponse? res =
      //     await WatchlistRestApiService().addToWatchList(request);

      WebSocketServiceProvider webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(context, listen: false);
      Map<String, dynamic> messageData = {
        "add": true,
        "tickerIds": dataList,
      };

      webSocketServiceProvider.sendMessage(messageData);

      await Future.delayed(Duration(milliseconds: 500));
      await fetchWatchList();

      Fluttertoast.showToast(msg: "added to watchlist" ?? "");

      // if(res.message!.toLowerCase() == "success") {
      // if (res.status!) {
      //   isButtonClicked = false;
      //   // otpResponse = res;
      //   Fluttertoast.showToast(msg: res.message ?? "");
      //   return true;
      // } else {
      //   isButtonClicked = false;
      //   return false;
      // }

      return true;
    } on HttpApiException catch (err) {
      isButtonClicked = false;
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      return false;
    }
  }

  Future<bool> searchStock(String stockName) async {

    isSearchingStock = true;
    try {


      SearchedStockDataResponse? res =
      await WatchlistRestApiService().getSearchedStock(stockName);

      if (res!.status!) {
        // otpResponse = res;
        searchedStockList = res.data ?? [];
        isSearchingStock = false;
        return true;
      } else {

        isSearchingStock = false;
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);

      isSearchingStock = false;
      return false;
    }
  }
}
