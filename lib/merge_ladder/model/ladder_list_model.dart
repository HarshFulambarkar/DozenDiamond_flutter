enum FilterOption { both, active, inactive }

class LadderListModel {
  String? stockName;
  List<Ladder> ladders;
  String? currentPrice;
  FilterOption selectedFilter;
  LadderListModel({
    this.currentPrice,
    this.stockName = "",
    this.selectedFilter = FilterOption.both,
    required this.ladders,
  });
}

class Ladder {
  bool isVisible;
  final int ladId;
  final int ladUserId;
  final int? ladDefinitionId;
  final int? ladPositionId;
  final String ladTicker;
  final String ladName;
  final FilterOption ladStatus;
  final int ladTickerId;
  final String ladExchange;
  final String ladTradingMode;
  final String ladCashAllocated;
  final String ladCashGain;
  final String ladCashLeft;
  final String ladMinimumPrice;
  final String ladExtraCashGenerated;
  final String ladExtraCashLeft;
  final double ladLastTradePrice;
  final double ladLastTradeOrderPrice;
  final String ladRealizedProfit;
  final int ladInitialBuyQuantity;
  final int ladDefaultBuySellQuantity;
  final String ladTargetPrice;
  final double ladNumOfStepsAbove;
  final int ladNumOfStepsBelow;
  final String ladCashNeeded;
  final String ladInitialBuyPrice;
  final int ladCurrentQuantity;
  final int ladInitialBuyExecuted;
  final int? ladRecentTradeId;
  final String? ladCashAssigned;

  Ladder({
    this.isVisible = true, // Default value for visibility
    required this.ladId,
    required this.ladUserId,
    this.ladDefinitionId,
    this.ladPositionId,
    required this.ladTicker,
    required this.ladName,
    required this.ladStatus,
    required this.ladTickerId,
    required this.ladExchange,
    required this.ladTradingMode,
    required this.ladCashAllocated,
    required this.ladCashGain,
    required this.ladCashLeft,
    required this.ladLastTradePrice,
    required this.ladLastTradeOrderPrice,
    required this.ladMinimumPrice,
    required this.ladExtraCashGenerated,
    required this.ladExtraCashLeft,
    required this.ladRealizedProfit,
    required this.ladInitialBuyQuantity,
    required this.ladDefaultBuySellQuantity,
    required this.ladTargetPrice,
    required this.ladNumOfStepsAbove,
    required this.ladNumOfStepsBelow,
    required this.ladCashNeeded,
    required this.ladInitialBuyPrice,
    required this.ladCurrentQuantity,
    required this.ladInitialBuyExecuted,
    required this.ladCashAssigned,
    this.ladRecentTradeId,
  });
}
