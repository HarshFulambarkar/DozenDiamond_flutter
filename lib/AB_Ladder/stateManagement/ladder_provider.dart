import 'package:dozen_diamond/AB_Ladder/models/get_ladder_response.dart';
import 'package:dozen_diamond/AB_Ladder/models/ladder_list_model.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';

import '../services/ladder_rest_api_service.dart';

class LadderProvider extends ChangeNotifier {
  List<LadderListModel> _stockLadders = [];
  bool _isLoading = false;
  List<bool> _ladderExpansionControllers = [];

  bool get isLoading => _isLoading;
  List<LadderListModel> get stockLadders => _stockLadders;
  List<bool> get ladderExpansionControllers => _ladderExpansionControllers;

  set initializeExpansionTileControllers(int i) {
    _ladderExpansionControllers.clear();
    for (int j = 0; j < i; j++) {
      _ladderExpansionControllers.add(true);
    }
  }

  set toggleExpandLadderTileAtIndex(int i) {
    _ladderExpansionControllers[i] = !_ladderExpansionControllers[i];
    notifyListeners();
  }

  set toggleExpandLadderExpansionTile(bool expand) {
    for (int i = 0; i < _ladderExpansionControllers.length; i++) {
      _ladderExpansionControllers[i] = expand;
    }
    notifyListeners();
  }

  set defaultVisibilitySOfLadderBtns(int i) {
    for (int j = 0; j < _stockLadders.length; j++) {
      for (int k = 0; k < _stockLadders[j].ladders.length; k++) {
        _stockLadders[j].ladders[k].isVisible = false;
      }
    }
  }

  List<String?> productType = ["MARKET", "LIMIT"];

  String _selectedProductType = "LIMIT";

  String get selectedProductType => _selectedProductType;

  set selectedProductType(String value) {
    _selectedProductType = value;
    notifyListeners();
  }

  String _limitPrice = "null";

  String get limitPrice => _limitPrice;

  set limitPrice(String value) {
    _limitPrice = value;
    notifyListeners();
  }

  String _limitPriceTimeInMin = "null";

  String get limitPriceTimeInMin => _limitPriceTimeInMin;

  set limitPriceTimeInMin(String value) {
    _limitPriceTimeInMin = value;
    notifyListeners();
  }

  String _limitPriceErrorText = "";

  String get limitPriceErrorText => _limitPriceErrorText;

  set limitPriceErrorText(String value) {
    _limitPriceErrorText = value;
    notifyListeners();
  }

  String _limitPriceTimeInMinErrorText = "";

  String get limitPriceTimeInMinErrorText => _limitPriceTimeInMinErrorText;

  set limitPriceTimeInMinErrorText(String value) {
    _limitPriceTimeInMinErrorText = value;
    notifyListeners();
  }

  bool _showLimitPriceTextField = true;

  bool get showLimitPriceTextField => _showLimitPriceTextField;

  set showLimitPriceTextField(bool value) {
    _showLimitPriceTextField = value;
    notifyListeners();
  }

  void toggleVisibilityOfLadderBtns(int stockIndex, int ladderIndex) {
    _stockLadders[stockIndex].ladders[ladderIndex].isVisible =
        !_stockLadders[stockIndex].ladders[ladderIndex].isVisible;
    for (int i = 0; i < _stockLadders.length; i++) {
      for (int j = 0; j < _stockLadders[i].ladders.length; j++) {
        if (stockIndex != i) {
          _stockLadders[i].ladders[j].isVisible = false;
        } else {
          if (ladderIndex != j) {
            _stockLadders[i].ladders[j].isVisible = false;
          }
        }
      }
    }
    notifyListeners();
  }

  bool _toggleAllVisibleValue = true;

  bool get toggleAllVisibleValue => _toggleAllVisibleValue;

  set toggleAllVisibleValue(bool value) {
    _toggleAllVisibleValue = value;
    notifyListeners();
  }

  void toggleAllVisible(bool value) {
    toggleAllVisibleValue = value;
    for (int i = 0; i < _stockLadders.length; i++) {
      for (int j = 0; j < _stockLadders[i].ladders.length; j++) {
        _stockLadders[i].ladders[j].isAllValueVisible = value;
      }
    }

    notifyListeners();
  }

  void toggleAllValueVisible(int stockIndex, int ladderIndex) {
    _stockLadders[stockIndex].ladders[ladderIndex].isAllValueVisible =
        !_stockLadders[stockIndex].ladders[ladderIndex].isAllValueVisible;
    // for (int i = 0; i < _stockLadders.length; i++) {
    //   for (int j = 0; j < _stockLadders[i].ladders.length; j++) {
    //     if (stockIndex != i) {
    //       _stockLadders[i].ladders[j].isAllValueVisible = false;
    //     } else {
    //       if (ladderIndex != j) {
    //         _stockLadders[i].ladders[j].isAllValueVisible = false;
    //       }
    //     }
    //   }
    // }
    notifyListeners();
  }

  set updateStockFilterAtIndex(int index) {
    switch (_stockLadders[index].selectedFilter) {
      case FilterOption.active:
        {
          _stockLadders[index].selectedFilter = FilterOption.inactive;
          notifyListeners();
          break;
        }
      case FilterOption.all:
        {
          _stockLadders[index].selectedFilter = FilterOption.active;
          notifyListeners();
          break;
        }
      case FilterOption.inactive:
        {
          _stockLadders[index].selectedFilter = FilterOption.cashEmpty;
          notifyListeners();
          break;
        }
      case FilterOption.cashEmpty:
        {
          _stockLadders[index].selectedFilter = FilterOption.all;
          notifyListeners();
          break;
        }
    }
  }

  int? nextCursor;
  bool hasMore = true;

  Future<bool> fetchAllLadder(
    CurrencyConstants currencyConstantsProvider, {
    int? nextCursor,
    int indexOfStockFilterChange = -1,
    FilterOption filterOption = FilterOption.all,
    bool isInitialLoading = true,
  }) async {
    // if (_isLoading || !hasMore) return false;
    if (isInitialLoading) {
      _isLoading = true;
    }

    try {
      print("fetchAllLadder incoming cursor: $nextCursor");

      GetLadderResponse? res = await LadderRestApiService().getLadder(
        nextCursor,
        currencyConstantsProvider,
        limit: 3,
      );

      if (res?.status != true || res?.data == null) {
        print("res?.status ${res?.status}");
        throw HttpApiException(errorCode: 404);
      }

      /// Update pagination values
      this.nextCursor = res!.pagination?.nextCursor;
      hasMore = res.pagination?.hasMore ?? false;

      print("fetchAllLadder updated cursor: ${this.nextCursor}");

      /// Fresh load
      if (nextCursor == null) {
        _stockLadders.clear();
        _ladderExpansionControllers.clear();
      }

      List<LadderListModel> newStockLadders = [];

      for (var i in res.data!) {
        List<Ladder> ladders = [];

        if (i.ladderData != null) {
          for (var j in i.ladderData!) {
            ladders.add(
              Ladder(
                isVisible: false,
                ladCashAllocated: j.ladCashAllocated,
                ladCashGain: j.ladCashGain,
                ladStepSize: j.ladStepSize,
                ladCashLeft: j.ladCashLeft,
                ladCashNeeded: j.ladCashNeeded,
                ladNumOfStepsAbove: j.ladNumOfStepsAbove,
                ladNumOfStepsBelow: j.ladNumOfStepsBelow,
                ladCurrentQuantity: j.ladCurrentQuantity,
                ladDefaultBuySellQuantity: j.ladDefaultBuySellQuantity,
                ladExchange: j.ladExchange ?? "",
                ladExtraCashGenerated: j.ladExtraCashGenerated,
                ladExtraCashPerOrder: j.ladExtraCashPerOrder,
                ladExtraCashLeft: 0.0,
                ladId: j.ladId,
                ladInitialBuyExecuted: j.ladInitialBuyExecuted ?? 0,
                ladName: j.ladName ?? "",
                ladInitialBuyPrice: j.ladInitialBuyPrice,
                ladInitialBuyQuantity: j.ladInitialBuyQuantity,
                ladMinimumPrice: j.ladMinimumPrice,
                ladRealizedProfit: j.ladRealizedProfit,
                ladStatus: j.ladStatus!.toUpperCase() == "INACTIVE"
                    ? FilterOption.inactive
                    : j.ladStatus!.toUpperCase() == "ACTIVE"
                    ? FilterOption.active
                    : FilterOption.cashEmpty,
                ladTargetPrice: j.ladTargetPrice,
                ladTicker: j.ladTicker ?? "",
                ladTickerId: j.ladTickerId!,
                ladTradingMode: j.ladTradingMode ?? "Simulation",
                ladUserId: j.ladUserId,
                ladDefinitionId: j.ladDefinitionId,
                ladLastTradeOrderPrice: j.ladLastTradeOrderPrice,
                ladLastTradePrice: 0,
                ladPositionId: j.ladPositionId,
                ladRecentTradeId: j.ladRecentTradeId,
                noFollowup: j.noFollowup!,
                ladExecutedOrders: j.ladExecutedOrders,
                ladOpenOrders: j.ladOpenOrders,
                timeToRecoverLossesInDays: j.timeToRecoverLossesInDays ?? 0,
                timeToRecoverInvestmentInYears:
                    j.timeToRecoverInvestmentInYears ?? 0.0,
                noOfTradesPerMonth: j.noOfTradesPerMonth ?? 0,
                amountAlreadyRecovered: j.amountAlreadyRecovered ?? 0.0,
                ladCashAssigned: j.ladCashAssigned ?? '0',
                actualBrokerageCost: j.actualBrokerageCost ?? 0.0,
                otherBrokerageCharges: j.otherBrokerageCharges ?? 0.0,
                createdAt: j.createdAt ?? DateTime.now(),
                isOneClick: j.isOneClick ?? false,
              ),
            );
          }

          newStockLadders.add(
            LadderListModel(
              selectedFilter: filterOption,
              ladders: ladders,
              stockName: i.stockName,
              currentPrice: i.currentPrice,
            ),
          );
        }
      }

      /// Append only newly fetched data
      _stockLadders.addAll(newStockLadders);
      // Add this loop to sync the expansion controllers
      for (var i = 0; i < newStockLadders.length; i++) {
        _ladderExpansionControllers.add(true);
      }
      return true;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
