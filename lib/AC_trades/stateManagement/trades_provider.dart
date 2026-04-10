import 'package:dozen_diamond/AC_trades/models/get_all_unsettled_trade_list_response.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';

import '../services/trades_rest_api_service.dart';

class TradesProvider extends ChangeNotifier {
  GetAllUnsettledTradeListResponse? _trades;
  bool _isLoading = true;
  List<bool> _tradeActionVisible = [];

  Map<String, dynamic> _isTradeExpanded = {};

  Map<String, dynamic> get isTradeExpanded => _isTradeExpanded;

  set isTradeExpanded(Map<String, dynamic> value) {
    _isTradeExpanded = value;
    notifyListeners();
  }

  String _selectedTradeFilter = "ALL";

  String get selectedTradeFilter => _selectedTradeFilter;

  set selectedTradeFilter(String value) {
    _selectedTradeFilter = value;
  }

  bool get isLoading => _isLoading;
  List<bool> get tradeActionVisible => _tradeActionVisible;
  GetAllUnsettledTradeListResponse? get trades => _trades;

  set defaultVisibilitySOfTradesBtns(int i) {
    _tradeActionVisible.clear();
    for (int j = 0; j < i; j++) {
      _tradeActionVisible.add(false);
    }
  }

  set toggleTradeActionBtnVisibilityAtIndex(int i) {
    _tradeActionVisible[i] = !_tradeActionVisible[i];
    for (int j = 0; j < _tradeActionVisible.length; j++) {
      if (i != j) {
        _tradeActionVisible[j] = false;
      }
    }

    notifyListeners();
  }

  Future<bool> fetchTrades(CurrencyConstants currencyConstantsProvider) async {
    try {

      Map<String, dynamic> request = {
        "ticker_name": "",
        "type": selectedTradeFilter,
      };

      GetAllUnsettledTradeListResponse? res = await TradesRestApiService()
          .getAllUnsettledTradeList(currencyConstantsProvider, request);
      if (res?.status == true && res?.data != null) {
        _isLoading = false;
        _trades = res;
        defaultVisibilitySOfTradesBtns = res!.data!.length;
        for(int i=0;i<res.data!.length; i++) {
          isTradeExpanded[res.data![i].tradeId.toString()] = true;
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
}
