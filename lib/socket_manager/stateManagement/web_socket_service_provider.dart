import 'dart:convert';
import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/generic_socket/models/genericSocketModel.dart';
import 'package:dozen_diamond/generic_socket/service/genericSocketService.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/functions/timeConverter.dart';
import 'package:dozen_diamond/socket_manager/model/ddstock_socket_data_response.dart';
import 'package:dozen_diamond/socket_manager/model/last_traded_price_response.dart';
import 'package:dozen_diamond/socket_manager/model/selected_stock_web_socket_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../../global/functions/testing.dart';
import '../../global/functions/utils.dart';
import '../../global/models/http_api_exception.dart';
import '../model/latest_price_response.dart';
import '../model/test_socket_response.dart';
import '../services/socket_manager_rest_api_service.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class WebSocketServiceProvider with ChangeNotifier {
  WebSocketServiceProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  // IOWebSocketChannel? _channel;
  WebSocketChannel? _channel;
  WebSocketChannel? _channel2;
  String _status = "Disconnected";

  String get status => _status;

  SelectedStockWebSocketResponse _selectedStockWebSocketData =
      SelectedStockWebSocketResponse();

  SelectedStockWebSocketResponse get selectedStockWebSocketData =>
      _selectedStockWebSocketData;

  set selectedStockWebSocketData(SelectedStockWebSocketResponse value) {
    _selectedStockWebSocketData = value;
    notifyListeners();
  }

  List<TestWebSocketData> _testWebSocketData = [];

  List<TestWebSocketData> get testWebSocketData => _testWebSocketData;

  set testWebSocketData(List<TestWebSocketData> value) {
    _testWebSocketData = value;
    notifyListeners();
  }

  List<LatestPriceData> _latestPriceData = [];

  List<LatestPriceData> get latestPriceData => _latestPriceData;

  set latestPriceData(List<LatestPriceData> value) {
    _latestPriceData = value;
    notifyListeners();
  }

  Map<String, dynamic> _latestPriceMap = {};

  Map<String, dynamic> get latestPriceMap => _latestPriceMap;

  set latestPriceMap(Map<String, dynamic> value) {
    _latestPriceMap = value;
    notifyListeners();
  }

  Timer? _timer;
  Timer? _timer1;
  Timer? _timer2;
  bool _isActive = false;

  bool get isActive => _isActive;

  set isActive(bool value) {
    _isActive = value;
    notifyListeners();
  }

  LastTradedPriceResponse _lastTradedPriceResponse = LastTradedPriceResponse();

  LastTradedPriceResponse get lastTradedPriceResponse =>
      _lastTradedPriceResponse;

  set lastTradedPriceResponse(LastTradedPriceResponse value) {
    _lastTradedPriceResponse = value;
    notifyListeners();
  }

  Map<dynamic, dynamic> _lastTradedPriceResponseMap = {};

  Map<dynamic, dynamic> get lastTradedPriceResponseMap =>
      _lastTradedPriceResponseMap;

  set lastTradedPriceResponseMap(Map<dynamic, dynamic> value) {
    _lastTradedPriceResponseMap = value;
    notifyListeners();
  }

  Map<dynamic, dynamic> _upDownStockPrice = {};

  Map<dynamic, dynamic> get upDownStockPrice => _upDownStockPrice;

  set upDownStockPrice(Map<dynamic, dynamic> value) {
    _upDownStockPrice = value;
    notifyListeners();
  }

  Map<dynamic, dynamic> _upDownStockPercentage = {};

  Map<dynamic, dynamic> get upDownStockPercentage => _upDownStockPercentage;

  set upDownStockPercentage(Map<dynamic, dynamic> value) {
    _upDownStockPercentage = value;
    notifyListeners();
  }

  DdStockSocketDataResponse _ddStockSocketDataResponse =
      DdStockSocketDataResponse();

  DdStockSocketDataResponse get ddStockSocketDataResponse =>
      _ddStockSocketDataResponse;

  set ddStockSocketDataResponse(DdStockSocketDataResponse value) {
    _ddStockSocketDataResponse = value;
    notifyListeners();
  }

  List<DdStock> _ddWatchlistStockList = [];

  List<DdStock> get ddWatchlistStockList => _ddWatchlistStockList;

  set ddWatchlistStockList(List<DdStock> value) {
    _ddWatchlistStockList = value;
    notifyListeners();
  }

  Map<int, String> _updatedAtList = {};

  Map<int, String> get updatedAtList => _updatedAtList;

  set updatedAtList(Map<int, String> value) {
    _updatedAtList = value;
    notifyListeners();
  }

  Future<int> get _getUserID => AuthenticationRestApiService().getUserID();
  bool _isBlocked = false;
  bool get isBlocked => _isBlocked;
  set isBlocked(bool value) {
    _isBlocked = value;
    notifyListeners();
  }

  List<String> _blockedMessage = [];
  List<String> get blockedMessage => _blockedMessage;
  set blockedMessage(List<String> value) {
    _blockedMessage = value;
    notifyListeners();
  }

  bool _showAnotherLoginButton = true;
  bool get showAnotherLoginButton => _showAnotherLoginButton;
  set showAnotherLoginButton(bool value) {
    _showAnotherLoginButton = value;
    notifyListeners();
  }

  String _iconBase64 = "";
  String get iconBase64 => _iconBase64;
  set iconBase64(String value) {
    _iconBase64 = value;
    notifyListeners();
  }

  Map<String, double> _previousCurrentPrice = {};

  Map<String, double> get previousCurrentPrice => _previousCurrentPrice;

  set previousCurrentPrice(Map<String, double> value) {
    _previousCurrentPrice = value;
    notifyListeners();
  }

  Map<String, bool> _isCurrentPriceUp = {};

  Map<String, bool> get isCurrentPriceUp => _isCurrentPriceUp;

  set isCurrentPriceUp(Map<String, bool> value) {
    _isCurrentPriceUp = value;
    notifyListeners();
  }

  Set<int> _removedTickerIds = {};
  Set<int> get removedTickerIds => _removedTickerIds;
  void addToRemovedList(int tickerId) {
    _removedTickerIds.add(tickerId);
    notifyListeners();
  }

  void removeFromRemovedList(int tickerId) {
    _removedTickerIds.remove(tickerId);
    notifyListeners();
  }

  // new connect funciton
  bool _isFirstMessage = true;

  Future<void> saveStocksOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = ddWatchlistStockList.map((e) => e.tickerId.toString()).toList();

    await prefs.setStringList("watchlist_order", ids);

    Map<String, dynamic> messageData = {
      "type": "reorder_watchlist",
      "ordered_ticker_ids": ids,
    };
    sendMessage(messageData);
    notifyListeners();
  }

  Future<void> restoreLocalOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOrder = prefs.getStringList("watchlist_order");
    if (savedOrder == null) return; // nothing saved yet

    final list = ddWatchlistStockList;

    list.sort((a, b) {
      return savedOrder
          .indexOf(a.tickerId.toString())
          .compareTo(savedOrder.indexOf(b.tickerId.toString()));
    });
  }
  bool _localOrderAppliedOnce = false;

  Future<void> connect() async {
    try {
      String domain = ApiConstant.wsDomain_new;
      final userId = await _getUserID;
      AuthenticationRestApiService authentication =
      AuthenticationRestApiService();
      String token = await authentication.generateToken();
      // String url = "$domain/ddStockTable?userId=$userId";
      // String url = "$domain/wl/watchlist?userId=$userId";
      String url = "$domain/wl/watchlist?userId=${userId}";
      url = url + "&token=$token";

      // print("before callingss");
      // _channel = IOWebSocketChannel.connect(
      // _channel = WebSocketChannel.connect(
      //     Uri.parse(url),
      //     // url,
      //   headers: {
      //       "Authorization": "$token"
      //   },
      // );
      // Reset first message flag on new connection
      _isFirstMessage = true;
      _channel = WebSocketChannel.connect(Uri.parse(url));

      // print("after cllingss ${_channel}");
      _status = "Connected";

      _timer1?.cancel(); // clear previous timer if reconnecting
      _timer1 = Timer.periodic(Duration(seconds: 25), (timer) {
        if (_channel != null) {
          try {
            _channel!.sink.add(jsonEncode({"type": "ping"}));
            // print("Sent ping to keep connection alive");
          } catch (e) {
            // print("Error sending ping: $e");
          }
        }
      });

      // print("connected to the url ${url}");
      _channel!.stream.listen(
            (event) {
          // print("inside connect socket event $event");

          try {
            final decodedJson = jsonDecode(event) as Map<String, dynamic>;
            // print("till hereeee12");

            DdStockSocketDataResponse value = DdStockSocketDataResponse()
                .fromJson(decodedJson);
            // print("here is the decodedJson ${decodedJson}");
            // print("here is the value ${value}");

            //if data is changed from backend then update the list with latest value else use the old data response and just update the prices from the value

            bool isListChanged =
                _isFirstMessage || decodedJson['is_changed'] == true;

            if (isListChanged) {
              // FULL REFRESH - Replace entire list
              // print("List changed - full refresh");

              _ddStockSocketDataResponse = value;
              _removedTickerIds.clear(); // Sync with backend

              // COMPLETE REPLACEMENT
              ddWatchlistStockList.clear();
              ddWatchlistStockList.addAll(
                _ddStockSocketDataResponse.ddStock ?? [],
              );

              if (!_localOrderAppliedOnce) {
                restoreLocalOrder();
                _localOrderAppliedOnce = true;
              }

              // Reset all tracking maps
              previousCurrentPrice.clear();
              isCurrentPriceUp.clear();
              _updatedAtList.clear();
              _lastTradedPriceResponseMap.clear();
              upDownStockPrice.clear();
              upDownStockPercentage.clear();

              // Initialize tracking data for all stocks
              for (var stock in ddWatchlistStockList) {
                int tickerId = stock.tickerId!;

                previousCurrentPrice[tickerId.toString()] =
                    double.tryParse(stock.tickerPrice ?? '0') ?? 0;
                isCurrentPriceUp[tickerId.toString()] = stock.isPriceUp ?? true;
                _updatedAtList[tickerId] = TimeConverter().convertToISTTime(
                  stock.updatedAt ?? "",
                );
                _lastTradedPriceResponseMap[tickerId] = stock.tickerPrice;
                upDownStockPrice[tickerId] = stock.upDownPrice;
                upDownStockPercentage[tickerId] = stock.upDownPercentage;

                Testing().testWatchListData(stock);
              } // Mark that we've processed first message
              _isFirstMessage = false;
            } else {
              // PRICE UPDATE ONLY - Update existing stocks
              // print("Price update only");

              _ddStockSocketDataResponse.updatePrices(value);

              for (var updatedStock in value.ddStock!) {
                int tickerId = updatedStock.tickerId!;

                // Skip removed stocks (for local-only removals)
                if (_removedTickerIds.contains(tickerId)) {
                  continue;
                }

                int existingIndex = ddWatchlistStockList.indexWhere(
                      (e) => e.tickerId == tickerId,
                );

                if (existingIndex != -1) {
                  // Update prices only
                  ddWatchlistStockList[existingIndex].tickerPrice =
                      updatedStock.tickerPrice;
                  ddWatchlistStockList[existingIndex].upDownPrice =
                      updatedStock.upDownPrice;
                  ddWatchlistStockList[existingIndex].upDownPercentage =
                      updatedStock.upDownPercentage;
                  ddWatchlistStockList[existingIndex].updatedAt =
                      updatedStock.updatedAt;

                  // Track price movement
                  double previousPrice =
                      previousCurrentPrice[tickerId.toString()] ?? 0;
                  double currentPrice =
                      double.tryParse(updatedStock.tickerPrice ?? '0') ?? 0;

                  if (previousPrice != 0) {
                    // Only track if we have previous data
                    if (previousPrice < currentPrice) {
                      ddWatchlistStockList[existingIndex].isPriceUp = true;
                      isCurrentPriceUp[tickerId.toString()] = true;
                    } else if (previousPrice > currentPrice) {
                      ddWatchlistStockList[existingIndex].isPriceUp = false;
                      isCurrentPriceUp[tickerId.toString()] = false;
                    }
                  }

                  // Update tracking maps
                  previousCurrentPrice[tickerId.toString()] = currentPrice;
                  _updatedAtList[tickerId] = TimeConverter().convertToISTTime(
                    updatedStock.updatedAt ?? "",
                  );
                  _lastTradedPriceResponseMap[tickerId] =
                      updatedStock.tickerPrice;
                  upDownStockPrice[tickerId] = updatedStock.upDownPrice;
                  upDownStockPercentage[tickerId] =
                      updatedStock.upDownPercentage;

                  Testing().testWatchListData(updatedStock);
                }
                // DON'T add new stocks during price updates
              }
            }
            notifyListeners();

            // print("below is previousCurrentPrice");
            // print(previousCurrentPrice);
          } catch (e) {
            // debugPrint("Error parsing WebSocket data: $e");
          }

          notifyListeners();
        },
        onDone: () {
          // print("on done call socket");
          _status = "Disconnected";
          _isFirstMessage = true;
          // print("below is closeReason");
          // print(_channel!.closeReason);
          // print(_channel!.closeCode);
          if (_channel!.closeCode != 1005 && _channel!.closeCode != null) {
            connect();
          }
          // connect();
          notifyListeners();
        },
        onError: (error) {
          // print("on error socket");
          // print(error.toString());
          _status = "Error: $error";
          // connect();
          notifyListeners();
        },
      );
    } catch (err) {
      // print("here is the error in the connection function");
      // print(err);
    }
  }

  // old connect function
  // Future<void> connect() async {
  //   try {
  //     String domain = ApiConstant.wsDomain_new;
  //     final userId = await _getUserID;
  //     AuthenticationRestApiService authentication =
  //         AuthenticationRestApiService();
  //     String token = await authentication.generateToken();
  //     // String url = "$domain/ddStockTable?userId=$userId";
  //     // String url = "$domain/wl/watchlist?userId=$userId";
  //     String url = "$domain/wl/watchlist?userId=${userId}";
  //     url = url + "&token=$token";
  //
  //     // print("before callingss");
  //     // _channel = IOWebSocketChannel.connect(
  //     // _channel = WebSocketChannel.connect(
  //     //     Uri.parse(url),
  //     //     // url,
  //     //   headers: {
  //     //       "Authorization": "$token"
  //     //   },
  //     // );
  //
  //     _channel = WebSocketChannel.connect(
  //       Uri.parse(url),
  //     );
  //
  //     // print("after cllingss ${_channel}");
  //     _status = "Connected";
  //
  //     _timer1?.cancel(); // clear previous timer if reconnecting
  //     _timer1 = Timer.periodic(Duration(seconds: 25), (timer) {
  //       if (_channel != null) {
  //         try {
  //           _channel!.sink.add(jsonEncode({"type": "ping"}));
  //           // print("Sent ping to keep connection alive");
  //         } catch (e) {
  //           print("Error sending ping: $e");
  //         }
  //       }
  //     });
  //
  //     // print("connected to the url ${url}");
  //     _channel!.stream.listen((event) {
  //       print("inside connect socket event $event");
  //
  //       try {
  //         final decodedJson = jsonDecode(event) as Map<String, dynamic>;
  //         print("till hereeee12");
  //         DdStockSocketDataResponse value =
  //             DdStockSocketDataResponse().fromJson(decodedJson);
  //         // print("here is the decodedJson ${decodedJson}");
  //         // print("here is the value ${value}");
  //
  //
  //
  //         _ddStockSocketDataResponse = value;
  //
  //         for(int i = 0; i < _ddStockSocketDataResponse.ddStock!.length; i++) {
  //
  //           if(ddWatchlistStockList.any((e) => e.tickerId == _ddStockSocketDataResponse.ddStock![i].tickerId)) {
  //             ddWatchlistStockList[ddWatchlistStockList.indexWhere((e) => e.tickerId == _ddStockSocketDataResponse.ddStock![i].tickerId)] = _ddStockSocketDataResponse.ddStock![i];
  //           } else {
  //             ddWatchlistStockList.add(_ddStockSocketDataResponse.ddStock![i]);
  //           }
  //
  //           if((previousCurrentPrice[ddWatchlistStockList[i].tickerId!.toString()] ?? 0) < (double.tryParse(ddWatchlistStockList[i].tickerPrice ?? '0') ?? 0)) {
  //             // print("inside if");
  //             // print(previousCurrentPrice[ddWatchlistStockList[i].tickerId!.toString()]);
  //             // print(ddWatchlistStockList[i].tickerPrice);
  //             ddWatchlistStockList[i].isPriceUp = true;
  //             isCurrentPriceUp[ddWatchlistStockList[i].tickerId.toString()] = true;
  //             // print("below is isCurrentPriceUp");
  //             // print(isCurrentPriceUp[ddWatchlistStockList[i].tickerId.toString()]);
  //           } else if ((previousCurrentPrice[ddWatchlistStockList[i].tickerId!.toString()] ?? 0) > (double.tryParse(ddWatchlistStockList[i].tickerPrice ?? '0') ?? 0)) {
  //             // print("inside else");
  //             // print(previousCurrentPrice[ddWatchlistStockList[i].tickerId!.toString()]);
  //             // print(ddWatchlistStockList[i].tickerPrice);
  //             ddWatchlistStockList[i].isPriceUp = false;
  //             isCurrentPriceUp[ddWatchlistStockList[i].tickerId.toString()] = false;
  //             // print("below is isCurrentPriceUp");
  //             // print(isCurrentPriceUp[ddWatchlistStockList[i].tickerId.toString()]);
  //           }
  //
  //         }
  //
  //
  //         // ddWatchlistStockList = _ddStockSocketDataResponse.ddStock ?? [];
  //         for (int i = 0; i < ddStockSocketDataResponse.ddStock!.length; i++) {
  //           // print("inside for loop of watchlist");
  //           // print(ddWatchlistStockList[i].upDownPercentage);
  //           // print(ddWatchlistStockList[i].previousClose);
  //
  //
  //           _updatedAtList[ddStockSocketDataResponse.ddStock![i].tickerId ?? 0] = TimeConverter().convertToISTTime(_ddStockSocketDataResponse.ddStock![i].updatedAt ?? "");
  //
  //           _lastTradedPriceResponseMap[ddStockSocketDataResponse.ddStock![i].tickerId] = _ddStockSocketDataResponse.ddStock![i].tickerPrice;
  //
  //           upDownStockPrice[ddStockSocketDataResponse.ddStock![i].tickerId] = _ddStockSocketDataResponse.ddStock![i].upDownPrice;
  //
  //           upDownStockPercentage[ddStockSocketDataResponse.ddStock![i].tickerId] = _ddStockSocketDataResponse.ddStock![i].upDownPercentage;
  //
  //           Testing().testWatchListData(ddStockSocketDataResponse.ddStock![i]);
  //
  //           previousCurrentPrice[ddStockSocketDataResponse.ddStock![i].tickerId!.toString()] = double.tryParse(ddWatchlistStockList[i].tickerPrice ?? '0') ?? 0;
  //         }
  //         notifyListeners();
  //
  //         // print("below is previousCurrentPrice");
  //         // print(previousCurrentPrice);
  //       } catch (e) {
  //         debugPrint("Error parsing WebSocket data: $e");
  //       }
  //
  //       notifyListeners();
  //     }, onDone: () {
  //       // print("on done call socket");
  //       _status = "Disconnected";
  //
  //       print("below is closeReason");
  //       print(_channel!.closeReason);
  //       print(_channel!.closeCode);
  //       if(_channel!.closeCode != 1005 && _channel!.closeCode != null) {
  //         connect();
  //       }
  //       // connect();
  //       notifyListeners();
  //     }, onError: (error) {
  //       // print("on error socket");
  //       // print(error.toString());
  //       _status = "Error: $error";
  //       // connect();
  //       notifyListeners();
  //     });
  //   } catch (err) {
  //     print("here is the error in the connection function");
  //     print(err);
  //   }
  // }

  void sendMessage(Map<String, dynamic> data) {
    if (_channel != null) {

      if(_status == "Disconnected") {
        connect();
      }

      // print("inside sendMessagge");
      // _channel!.sink.add(jsonEncode({'message': message}));
      String jsonData = jsonEncode(data); // Convert Map to JSON String
      _channel!.sink.add(jsonData);
      // print("Sent: $jsonData");
    } else {
      connect();
    }
  }

  Future<void> disconnect() async {
    _channel?.sink.close();
    _status = "Disconnected";
    notifyListeners();
  }

  void accountBlockage(BuildContext context, String deviceId) async {
    // print("inside accountBlockage");
    bool isPopupOpen = false;
    // try {
      var userId = await _getUserID;
      String domainWs = ApiConstant.wsDomain;
      var url = Uri.parse("$domainWs/generic?userId=$userId&deviceId=$deviceId");
      // print("here is the url at the url $url");
      // _channel = IOWebSocketChannel.connect(url);
      _channel2 = WebSocketChannel.connect(
        url,
      );

    _timer2?.cancel(); // clear previous timer if reconnecting
    _timer2 = Timer.periodic(Duration(seconds: 25), (timer) {
      if (_channel2 != null) {
        try {
          _channel2!.sink.add(jsonEncode({"type": "ping"}));
          // print("Sent ping to keep connection alive");
        } catch (e) {
          // print("Error sending ping: $e");
        }
      }
    });
      // _channel = WebSocketChannel.connect(url);
      _channel2!.stream.listen((event) {
        final decodedJson = jsonDecode(event) as Map<String, dynamic>;
        // print("here is the event $event");
        GenericSocketResponse genericSocketResponse =
            GenericSocketResponse().fromJson(decodedJson);
        isBlocked = genericSocketResponse.isBlocked ?? false;
        blockedMessage = genericSocketResponse.message ?? [];
        showAnotherLoginButton =
            genericSocketResponse.showAnotherLoginButton ?? true;
        iconBase64 = genericSocketResponse.iconBase64 ?? "";

        // print("genericSocketResponse.type");
        // print(genericSocketResponse.type);

        if(genericSocketResponse.type == "CLOSE_POSITION"
            || genericSocketResponse.type == "DELETE_LADDER"
            || genericSocketResponse.type == "ADD_CASH"
            || genericSocketResponse.type == "WITHDRAW_CASH"
            || genericSocketResponse.type == "UPDATE_TARGET_PRICE") {

          if(isPopupOpen == false) {
            isPopupOpen = true;
            Utility().minLimitPriceAndTimeInMinDialog(
                context,
                genericSocketResponse.type.toString(),
                genericSocketResponse.orderId.toString(),
                genericSocketResponse.orderMessage.toString()
            );
          }


        }
      },
        onError: (error) {
          // print("generic WebSocket error: $error");
          // accountBlockage();
        },
        onDone: () {
          // print("generic WebSocket connection closed. ");
          accountBlockage(context, deviceId);
        },
      );
    // } catch (e) {
    //   throw e;
    // }
  }

  void startFetching() async {
    if (_isActive) return;
    _isActive = true;
    connect();
    // accountBlockage();
    notifyListeners();
  }

  void stopFetching() {
    _isActive = false;
    _timer?.cancel();
    notifyListeners();
  }

  Future<bool> getLatestPrice() async {
    // print("inside getLatestPrice");
    try {
      LatestPriceResponse? res =
          await SocketManagerRestApiService().getLatestPrice();

      if (res.status!) {
        latestPriceData = res.data ?? [];

        for (int i = 0; i < latestPriceData.length; i++) {
          latestPriceMap[latestPriceData[i].tickerName ?? "temp"] =
              double.parse((latestPriceData[i].tickerPrice ?? 0.0).toString());
        }

        return true;
      } else {
        return false;
      }
    } on HttpApiException catch (err) {
      // print(err.errorSuggestion);
      // print(err.errorTitle);
      // print(err.errorCode);

      return false;
    }
  }
}
