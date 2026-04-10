import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/models/api_request_response.dart';

class AccountInfoBarDetailsResponse extends ApiRequestResponse {
  bool? status;
  String? message;
  Data? data;

  AccountInfoBarDetailsResponse({this.status, this.message, this.data});

  AccountInfoBarDetailsResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data extends ApiRequestResponse {
  int? accountId;
  double accountRealizedProfit;
  int? accountUserId;
  double accountCashLeft;
  double accountCashDeposit;
  double accountCashGain;
  double accountFundsInPlay;
  double accountUnallocatedCash;
  double accountCashLeftInActiveLadders;
  double accountCashNeededForActiveLadders;
  double accountTransactionCashLeft;
  double accountExtraCashLeft;
  double accountExtraCashGenerated;
  double accountCashForNewLadders;
  double accountUnsoldStocksCashGain;
  double accountCashNeededForInactiveLadders;
  double withdrawableCash;
  double accountBrokerage;
  double accountOtherCharges;
  int accountCashEmptyCount;
  int accountSelectedTickersCount;
  int accountActiveLaddersCount;
  int accountInactiveLaddersCount;
  int accountUnsettledTradesCount;
  int accountOpenOrdersCount;
  List<PositionValueRequiredParameters> positionValueRequiredParameters;
  // List<UnrealizedProfitRequiredParameters>? unrealizedProfitRequiredParameters;
  List<CurrentPrices> currentPrices;
  double totalAccountValue;
  double cumulativeCharges;
  double accountCashWithdrawn;

  Data(
      {this.accountId,
      this.accountCashEmptyCount = 0,
      this.accountRealizedProfit = 0.0,
      this.withdrawableCash = 0.0,
      this.accountBrokerage = 0.0,
      this.accountOtherCharges = 0.0,
      this.accountUserId,
      this.accountCashLeft = 0.0,
      this.accountCashDeposit = 0.0,
      this.accountCashGain = 0.0,
      this.accountFundsInPlay = 0.0,
      this.accountUnallocatedCash = 0.0,
      this.accountCashLeftInActiveLadders = 0.0,
      this.accountCashNeededForActiveLadders = 0.0,
      this.accountTransactionCashLeft = 0.0,
      this.accountCashNeededForInactiveLadders = 0.0,
      this.accountExtraCashLeft = 0.0,
      this.accountExtraCashGenerated = 0.0,
      this.accountCashForNewLadders = 0.0,
      this.accountUnsoldStocksCashGain = 0.0,
      this.accountActiveLaddersCount = 0,
      this.accountInactiveLaddersCount = 0,
      this.accountOpenOrdersCount = 0,
      this.accountSelectedTickersCount = 0,
      this.accountUnsettledTradesCount = 0,
      this.positionValueRequiredParameters = const [],
      // this.unrealizedProfitRequiredParameters,
      this.currentPrices = const [],
        this.totalAccountValue = 0,
        this.cumulativeCharges = 0,
        this.accountCashWithdrawn = 0,
      });

  double? get accountUnsoldStocksCost => accountUnsoldStocksCashGain < 0
      ? -accountUnsoldStocksCashGain
      : accountUnsoldStocksCashGain;

  double get positionValues => calculatePositionValues();

  double calculatePositionValues() {
    double totalCurrentStockValues = 0.0;
    // print(
    //     "length of the currentPrice ${currentPrices.length} and ${positionValueRequiredParameters.length}");
    for (int i = 0; i < currentPrices.length; i++) {
      for (int j = 0; j < positionValueRequiredParameters.length; j++) {
        if (currentPrices[i].usTickerId == positionValueRequiredParameters[j].postnTickerId) {

          totalCurrentStockValues += currentPrices[i].usLtpProvidedByBroker! * positionValueRequiredParameters[j].postnTotalQuantity;

          // if(tradeMainProvider.tradingOptions == TradingOptions.simulationTradingWithSimulatedPrices) {
          //   totalCurrentStockValues += currentPrices[i].usSimulatedPrice! * positionValueRequiredParameters[j].postnTotalQuantity;
          // } else {
          //   totalCurrentStockValues += currentPrices[i].usLtpProvidedByBroker! * positionValueRequiredParameters[j].postnTotalQuantity;
          // }

        }
      }
    }

    return totalCurrentStockValues;
  }

  Data fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    accountRealizedProfit =
        double.tryParse(json['account_realized_profit'] ?? "0.0") ?? 0.0;
    withdrawableCash =
        double.tryParse(json['withdrawable_cash'] ?? "0.0") ?? 0.0;
    accountBrokerage =
        double.tryParse(json['account_brokerage'] ?? "0.0") ?? 0.0;
    accountOtherCharges =
        double.tryParse(json['account_other_charges'] ?? "0.0") ?? 0.0;
    accountUserId = json['account_user_id'];
    accountCashLeft =
        double.tryParse(json['account_cash_left'] ?? "0.0") ?? 0.0;
    accountCashDeposit =
        double.tryParse(json['account_cash_deposit'] ?? "0.0") ?? 0.0;
    accountCashGain =
        double.tryParse(json['account_cash_gain'] ?? "0.0") ?? 0.0;
    accountFundsInPlay =
        double.tryParse(json['account_funds_in_play'] ?? "0.0") ?? 0.0;
    accountUnallocatedCash =
        double.tryParse(json['account_unallocated_cash'] ?? "0.0") ?? 0.0;
    accountCashLeftInActiveLadders =
        double.tryParse(json['account_cash_left_in_active_ladders'] ?? "0.0") ??
            0.0;
    accountCashNeededForActiveLadders = double.tryParse(
            json['account_cash_needed_for_active_ladders'] ?? "0.0") ??
        0.0;
    accountTransactionCashLeft = double.tryParse(
        json['account_transaction_cash_left'].toString()) ??
        0.0;
    accountCashNeededForInactiveLadders = double.tryParse(
            json['account_cash_needed_for_inactive_ladders'] ?? "0.0") ??
        0.0;

    accountExtraCashLeft =
        double.tryParse(json['account_extra_cash_left'] ?? "0.0") ?? 0.0;
    accountExtraCashGenerated =
        double.tryParse(json['account_extra_cash_generated'] ?? "0.0") ?? 0.0;
    accountCashForNewLadders =
        double.tryParse(json['account_cash_for_new_ladders'] ?? "0.0") ?? 0.0;
    accountUnsoldStocksCashGain =
        double.tryParse(json['account_unsold_stocks_cash_gain'] ?? "0.0") ??
            0.0;
    accountCashEmptyCount = json['account_cash_empty_count'] ?? 0;
    accountSelectedTickersCount = json['account_selected_tickers_count'] ?? 0;
    accountActiveLaddersCount = json['account_active_ladders_count'] ?? 0;
    accountInactiveLaddersCount = json['account_inactive_ladders_count'] ?? 0;
    accountUnsettledTradesCount = json['account_unsettled_trades_count'] ?? 0;
    accountOpenOrdersCount = json['account_open_orders_count'] ?? 0;

    if (json['position_value_required_parameters'] != null) {
      positionValueRequiredParameters = <PositionValueRequiredParameters>[];
      json['position_value_required_parameters'].forEach((v) {
        positionValueRequiredParameters
            .add(new PositionValueRequiredParameters().fromJson(v));
      });
    }
    // if (json['unrealized_profit_required_parameters'] != null) {
    //   unrealizedProfitRequiredParameters =
    //       <UnrealizedProfitRequiredParameters>[];
    //   json['unrealized_profit_required_parameters'].forEach((v) {
    //     unrealizedProfitRequiredParameters!
    //         .add(new UnrealizedProfitRequiredParameters().fromJson(v));
    //   });
    // }
    if (json['currentPrices'] != null) {
      currentPrices = <CurrentPrices>[];
      json['currentPrices'].forEach((v) {
        currentPrices.add(new CurrentPrices().fromJson(v));
      });
    }
    totalAccountValue = json['total_account_value'] ?? 0;
    cumulativeCharges = json['cumulative_charges'] ?? 0;
    accountCashWithdrawn = double.tryParse(json['account_cash_withdrawn']) ?? 0;

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_id'] = this.accountId;
    data['account_realized_profit'] = this.accountRealizedProfit;
    data['account_user_id'] = this.accountUserId;
    data['account_cash_left'] = this.accountCashLeft;
    data['account_cash_deposit'] = this.accountCashDeposit;
    data['account_cash_gain'] = this.accountCashGain;
    data['account_funds_in_play'] = this.accountFundsInPlay;
    data['account_unallocated_cash'] = this.accountUnallocatedCash;
    data['account_cash_left_in_active_ladders'] =
        this.accountCashLeftInActiveLadders;
    data['account_cash_needed_for_active_ladders'] =
        this.accountCashNeededForActiveLadders;
    data['account_transaction_cash_left'] = this.accountTransactionCashLeft;
    data['account_extra_cash_left'] = this.accountExtraCashLeft;
    data['account_extra_cash_generated'] = this.accountExtraCashGenerated;
    data['account_cash_for_new_ladders'] = this.accountCashForNewLadders;
    data['account_unsold_stocks_cash_gain'] = this.accountUnsoldStocksCashGain;
    data['account_cash_empty_count'] = this.accountCashEmptyCount;
    data['account_selected_tickers_count'] = this.accountSelectedTickersCount;
    data['account_active_ladders_count'] = this.accountActiveLaddersCount;
    data['account_inactive_ladders_count'] = this.accountInactiveLaddersCount;
    data['account_unsettled_trades_count'] = this.accountUnsettledTradesCount;
    data['account_open_orders_count'] = this.accountOpenOrdersCount;
    data['withdrawable_cash'] = this.withdrawableCash;
    data['account_brokerage'] = this.accountBrokerage;
    data['account_other_charges'] = this.accountOtherCharges;
    // if (this.positionValueRequiredParameters != null) {
    //   data['position_value_required_parameters'] =
    //       this.positionValueRequiredParameters!.map((v) => v.toJson()).toList();
    // }
    // if (this.unrealizedProfitRequiredParameters != null) {
    //   data['unrealized_profit_required_parameters'] = this
    //       .unrealizedProfitRequiredParameters!
    //       .map((v) => v.toJson())
    //       .toList();
    // }
    // if (this.currentPrices != null) {
    //   data['currentPrices'] =
    //       this.currentPrices!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class PositionValueRequiredParameters extends ApiRequestResponse {
  int? postnId;
  int postnTotalQuantity;
  String? postnTicker;
  int? postnTickerId;
  int? postnUserId;
  String? postnCashLeft;

  PositionValueRequiredParameters(
      {this.postnId,
      this.postnTotalQuantity = 0,
      this.postnTicker,
      this.postnTickerId,
      this.postnUserId,
      this.postnCashLeft});

  PositionValueRequiredParameters fromJson(Map<String, dynamic> json) {
    postnId = json['postn_id'];
    postnTotalQuantity = json['postn_total_quantity'] ?? 0;
    postnTicker = json['postn_ticker'];
    postnTickerId = json['postn_ticker_id'];
    postnUserId = json['postn_user_id'];
    postnCashLeft = json['postn_cash_left'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postn_id'] = this.postnId;
    data['postn_total_quantity'] = this.postnTotalQuantity;
    data['postn_ticker'] = this.postnTicker;
    data['postn_ticker_id'] = this.postnTickerId;
    data['postn_user_id'] = this.postnUserId;
    data['postn_cash_left'] = this.postnCashLeft;
    return data;
  }
}

class UnrealizedProfitRequiredParameters extends ApiRequestResponse {
  int? tradeId;
  String? tradeExecutionPrice;
  String? tradeUnsettledTradeUnits;
  String? tradeTicker;
  int? tradeTickerId;
  int? tradeUserId;

  UnrealizedProfitRequiredParameters(
      {this.tradeId,
      this.tradeExecutionPrice,
      this.tradeUnsettledTradeUnits,
      this.tradeTicker,
      this.tradeTickerId,
      this.tradeUserId});

  UnrealizedProfitRequiredParameters fromJson(Map<String, dynamic> json) {
    tradeId = json['trade_id'];
    tradeExecutionPrice = json['trade_execution_price'];
    tradeUnsettledTradeUnits = json['trade_unsettled_trade_units'];
    tradeTicker = json['trade_ticker'];
    tradeTickerId = json['trade_ticker_id'];
    tradeUserId = json['trade_user_id'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_id'] = this.tradeId;
    data['trade_execution_price'] = this.tradeExecutionPrice;
    data['trade_unsettled_trade_units'] = this.tradeUnsettledTradeUnits;
    data['trade_ticker'] = this.tradeTicker;
    data['trade_ticker_id'] = this.tradeTickerId;
    data['trade_user_id'] = this.tradeUserId;
    return data;
  }
}

class CurrentPrices extends ApiRequestResponse {
  int? usTickerId;
  int? userId;
  double? usSimulatedPrice;
  double? usLtpProvidedByBroker;

  CurrentPrices(
      {this.usTickerId,
      this.userId,
      this.usSimulatedPrice,
      this.usLtpProvidedByBroker});

  CurrentPrices fromJson(Map<String, dynamic> json) {
    usTickerId = ((json['us_ticker_id'] is int))?json['us_ticker_id']:0;
    userId = json['user_id'];
    usSimulatedPrice = double.tryParse(json['us_simulated_price'] ?? "0.0");
    usLtpProvidedByBroker = (json['us_ltp_provided_by_broker'] == null)?0.0:double.tryParse(json['us_ltp_provided_by_broker'].toString() ?? "0.0");
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['us_ticker_id'] = this.usTickerId;
    data['user_id'] = this.userId;
    data['us_simulated_price'] = this.usSimulatedPrice;
    data['us_ltp_provided_by_broker'] = this.usLtpProvidedByBroker;
    return data;
  }
}
