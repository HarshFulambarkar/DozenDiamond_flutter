import 'package:dozen_diamond/F_Funds/models/account_cash_details_response.dart';
import 'package:dozen_diamond/F_Funds/models/account_detail_response.dart';
import 'package:dozen_diamond/F_Funds/models/portfolio_cash_details.dart';
import 'package:dozen_diamond/F_Funds/services/funds_rest_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../global/models/http_api_exception.dart';
import '../../ladder_add_or_withdraw_cash/models/withdrawCashResponse.dart';


class FundsProvider extends ChangeNotifier {
  bool _isLoading = true;
  List<bool> _ladderExpansionControllers = [];

  AccountDetailResponse _accountDetails = AccountDetailResponse();

  AccountCashDetailsResponse _accountCashDetails = AccountCashDetailsResponse();
  PortfolioCashDetails _portfolioCashDetails = PortfolioCashDetails();

  AccountDetailResponse get accountDetails => _accountDetails;

  PortfolioCashDetails get portfolioCashDetails => _portfolioCashDetails;

  set updatePortfolioCashDetails(PortfolioCashDetails newValues) {
    _portfolioCashDetails = newValues;
    notifyListeners();
  }

  set initializeExpansionTileControllers(int i) {
    _ladderExpansionControllers.clear();
    for (int j = 0; j < i; j++) {
      _ladderExpansionControllers.add(true);
    }
  }

  bool get isLoading => _isLoading;
  AccountCashDetailsResponse? get accountCashDetails => _accountCashDetails;

  set updateApiStatus(bool newStatus) {
    _isLoading = newStatus;
    notifyListeners();
  }

  TextEditingController withdrawExtraCashTextEditingController = TextEditingController();
  TextEditingController withdrawAvailableCashTextEditingController = TextEditingController();

  Future<void> callInitialApi() async {
    _isLoading = false;
    _accountCashDetails =
        (await FundsRestApiService().getAccountCashDetails())!;
    notifyListeners();
  }

  Future<bool> withdrawExtraCash(TradingOptions tradingOptions) async {
    try {
      String currentTradingMode = "SIMULATION-PAPER";

      if (tradingOptions ==
          TradingOptions.simulationTradingWithSimulatedPrices) {
        currentTradingMode = "SIMULATION-PAPER";
      }

      if (tradingOptions ==
          TradingOptions.simulationTradingWithRealValues) {
        currentTradingMode = "REALTIME-PAPER";
      }

      if (tradingOptions ==
          TradingOptions.tradingWithRealCash) {
        currentTradingMode = "REAL";
      }

      Map<String, dynamic> request = {
        "trading_mode": currentTradingMode,
        "cash_to_withdraw": withdrawExtraCashTextEditingController.text.replaceAll(",", "")
      };

      WithdrawCashResponse res = await FundsRestApiService().withdrawExtraCash(request);

      if (res.status ?? false) {

        withdrawExtraCashTextEditingController.clear();
        Fluttertoast.showToast(msg: "withdraw cash successfully");
        return true;
      } else {
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

  Future<bool> withdrawAvailableCash(TradingOptions tradingOptions) async {
    try {
      String currentTradingMode = "SIMULATION-PAPER";

      if (tradingOptions ==
          TradingOptions.simulationTradingWithSimulatedPrices) {
        currentTradingMode = "SIMULATION-PAPER";
      }

      if (tradingOptions ==
          TradingOptions.simulationTradingWithRealValues) {
        currentTradingMode = "REALTIME-PAPER";
      }

      if (tradingOptions ==
          TradingOptions.tradingWithRealCash) {
        currentTradingMode = "REAL";
      }

      Map<String, dynamic> request = {
        "trading_mode": currentTradingMode,
        "cash_to_withdraw": withdrawAvailableCashTextEditingController.text.replaceAll(",", "")
      };

      WithdrawCashResponse res = await FundsRestApiService().withdrawAvailableCash(request);

      if (res.status ?? false) {

        withdrawAvailableCashTextEditingController.clear();

        Fluttertoast.showToast(msg: "withdraw cash successfully");
        return true;
      } else {
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }
}
