import 'package:dozen_diamond/AD_Orders/models/partial_order_generation_request.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/info_alert_dialog.dart';
import '../models/get_all_open_order_list_response.dart';
import '../services/orders_rest_api_service.dart';

class OrderProvider extends ChangeNotifier {
  GetAllOpenOrderListResponse? _orders;

  bool _isSuperUser = false;

  bool get isSuperUser => _isSuperUser;

  set isSuperUser(bool value) {
    _isSuperUser = value;
    notifyListeners();
  }

  Map<String, dynamic> _isOrdersExpanded = {};

  Map<String, dynamic> get isOrdersExpanded => _isOrdersExpanded;

  set isOrdersExpanded(Map<String, dynamic> value) {
    _isOrdersExpanded = value;
    notifyListeners();
  }

  GetAllOpenOrderListResponse? _hiddenOrders;

  GetAllOpenOrderListResponse get hiddenOrders => _hiddenOrders!;

  set hiddenOrders(GetAllOpenOrderListResponse value) {
    _hiddenOrders = value;
    notifyListeners();
  }

  PartialOrderGenerationRequest? _partialOrderGenerationRequest;
  bool _isLoading = true;

  bool _isHiddenOrdersLoading = true;

  bool get isHiddenOrdersLoading => _isHiddenOrdersLoading;

  set isHiddenOrdersLoading(bool value) {
    _isHiddenOrdersLoading = value;
    notifyListeners();
  }

  List<bool> _orderActionVisible = [];

  List<bool> _hiddenOrderActionVisible = [];

  List<bool> get hiddenOrderActionVisible => _hiddenOrderActionVisible;

  set hiddenOrderActionVisible(List<bool> value) {
    _hiddenOrderActionVisible = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  GetAllOpenOrderListResponse? get orders => _orders;

  PartialOrderGenerationRequest? get partialOrderGenerationRequest =>
      _partialOrderGenerationRequest;

  List<bool> get orderActionVisible => _orderActionVisible;

  String _limitPriceErrorText = "";

  String get limitPriceErrorText => _limitPriceErrorText;

  set limitPriceErrorText(String value) {
    _limitPriceErrorText = value;
    notifyListeners();
  }

  String _limitPrice = "";

  String get limitPrice => _limitPrice;

  set limitPrice(String value) {
    _limitPrice = value;
    notifyListeners();
  }

  Future<bool> fetchOrders(CurrencyConstants currencyConstantsProvider) async {
    try {
      GetAllOpenOrderListResponse? res = await OrdersRestApiService()
          .getAllStockOrderList(currencyConstantsProvider);
      if (res?.status == true && res?.data != null) {
        _isLoading = false;
        _orders = res;
        defaultVisibilitySOfOrderBtns = res!.data!.length;

        for(int i=0;i<res.data!.length; i++) {
          isOrdersExpanded[res.data![i].orderId.toString()] = true;
        }
        notifyListeners();
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> fetchHiddenOrders(CurrencyConstants currencyConstantsProvider) async {
    try {
      GetAllOpenOrderListResponse? res = await OrdersRestApiService()
          .getAllStockHiddenOrderList(currencyConstantsProvider);
      if (res?.status == true && res?.data != null) {
        _isHiddenOrdersLoading = false;
        _hiddenOrders = res;
        defaultVisibilitySOfHiddenOrderBtns = res!.data!.length;
        notifyListeners();
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  set toggleOrderActionBtnVisibilityAtIndex(int i) {
    orderActionVisible[i] = !orderActionVisible[i];
    for (int j = 0; j < orderActionVisible.length; j++) {
      if (i != j) {
        orderActionVisible[j] = false;
      }
    }
    notifyListeners();
  }

  set defaultVisibilitySOfOrderBtns(int i) {
    _orderActionVisible.clear();
    for (int j = 0; j < i; j++) {
      _orderActionVisible.add(false);
    }
  }

  set defaultVisibilitySOfHiddenOrderBtns(int i) {
    _hiddenOrderActionVisible.clear();
    for (int j = 0; j < i; j++) {
      _hiddenOrderActionVisible.add(false);
    }
  }

  Future<void> calculatePartialBuySell(
      String type, int i, CurrencyConstants currencyConstantsProvider, double stepSize, BuildContext context, double limitPrice) async {
    // double currentPrice = _orders!.data?[i].currentPrice ?? 0.0;
    double currentPrice = limitPrice;

    if (type == "Sell") {
      await _calculateSell(i, currentPrice, stepSize, context);
    } else {
      await _calculateBuy(i, currentPrice, stepSize, context);
    }

    await fetchOrders(currencyConstantsProvider);
    notifyListeners();
  }

  Future<void> _calculateSell(int i, double currentPrice, double stepSize, BuildContext context) async {
    int sellQty = _orders!.data?[i].orderUnits ?? 0;
    double sellStepSize = stepSize; //_parseToDouble(_orders!.data?[i].opoSellStepSize);
    double sellEntryPrice = _orders!.data?[i].orderOpenPrice ?? 0.0;
    double lastTradeExecutedPrice = sellEntryPrice - sellStepSize;
    if (currentPrice > lastTradeExecutedPrice) {}
    await _calculateSplitOrder(i, sellEntryPrice, sellQty.abs(), sellStepSize,
        currentPrice, lastTradeExecutedPrice, context);
  }

  Future<void> _calculateBuy(int i, double currentPrice, double stepSize, BuildContext context) async {
    int buyQty = _orders!.data?[i].orderUnits ?? 0;
    double buyStepSize = stepSize; //_parseToDouble(_orders!.data?[i].opoBuyStepSize);
    double buyEntryPrice = _orders!.data?[i].orderOpenPrice ?? 0.0;
    double lastTradeExecutedPrice = buyEntryPrice + buyStepSize;
    if (currentPrice < lastTradeExecutedPrice) {}
    await _calculateSplitOrder(i, buyEntryPrice, buyQty, buyStepSize,
        currentPrice, lastTradeExecutedPrice, context);
  }

  Future<void> _calculateSplitOrder(
      int i,
      double entryPrice,
      int qty,
      double stepSize,
      double currentPrice,
      double lastTradeExecutedPrice,
      BuildContext context) async {

    print("inside _calculateSplitOrder");
    print(currentPrice);
    print(qty);
    print(stepSize);
    print(i);
    print(lastTradeExecutedPrice);

    bool forSellOrder = (currentPrice > lastTradeExecutedPrice);
    String orderType = forSellOrder ? "Sell" : "Buy"; //"intervention-sell" : "intervention-buy";
    double difference = forSellOrder
        ? currentPrice - lastTradeExecutedPrice
        : lastTradeExecutedPrice - currentPrice;

    print(difference);

    int orderId = forSellOrder
        ? (_orders!.data![i].orderId ?? 0)
        : (_orders!.data![i].orderId ?? 0);

    int splitOrderUnits1 = ((difference / stepSize) * qty).floor();
    int splitOrderUnits2 = qty - splitOrderUnits1;

    if(splitOrderUnits1 < 1 || splitOrderUnits2 < 1) {
      InfoAlertDialog().showInfoAlertDialog(
        context,
        "Warning",
        "0 Units are coming for $orderType",
      );
    } else {

      Map<String, dynamic> request = {
        "order_id": orderId,
        "order_type": orderType.toUpperCase(),
        "lad_id": _orders!.data![i].orderLadderId,
        "partial_order": [
          {
            "units": splitOrderUnits1,
            "price": currentPrice
          },
          {
            "units": splitOrderUnits2
          }
        ]
      };
      await OrdersRestApiService()
          .partialOrderGeneration(request);

    }


    print(
        "here is your split order units 1 $splitOrderUnits1 and split order units 2 $splitOrderUnits2 ");
  }

  double _parseToDouble(String? value) {
    return double.tryParse(value ?? '') ?? 0.0;
  }

  Future<void> cancelOrder(String orderId, CurrencyConstants currencyConstantsProvider) async {

    Map<String, dynamic> request = {
      "orderId": orderId,
    };

    await OrdersRestApiService().cancelOrder(request);

    await fetchOrders(currencyConstantsProvider);
    notifyListeners();

  }
}
