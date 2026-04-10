enum FilterOption { all, active, inactive, cashEmpty }

class LadderListModel {
  String? stockName;
  List<Ladder> ladders;
  double currentPrice;
  FilterOption selectedFilter;
  LadderListModel({
    this.currentPrice = 0.0,
    this.stockName = "",
    this.selectedFilter = FilterOption.all,
    required this.ladders,
  });
}

class Ladder {
  bool isVisible;
  bool isAllValueVisible;
  final int? ladId;
  final int? ladUserId;
  final int? ladDefinitionId;
  final int? ladPositionId;
  final String ladTicker;
  final double ladStepsMoved;
  final double ladPriceMoved;
  final String ladName;
  final FilterOption ladStatus;
  final int? ladTickerId;
  final String ladExchange;
  final String ladTradingMode;
  double ladCashAllocated;
  double ladCashGain;
  double ladCashLeft;
  double ladMinimumPrice;
  double ladExtraCashGenerated;
  double ladExtraCashPerOrder;
  double ladStepSize;
  double ladExtraCashLeft;
  double ladLastTradePrice;
  double ladLastTradeOrderPrice;
  double ladRealizedProfit;
  final int ladInitialBuyQuantity;
  final int ladDefaultBuySellQuantity;
  double ladTargetPrice;
  final double ladNumOfStepsAbove;
  final int ladNumOfStepsBelow;
  double ladCashNeeded;
  double ladInitialBuyPrice;
  final int ladCurrentQuantity;
  final int ladInitialBuyExecuted;
  final int? ladRecentTradeId;
  bool noFollowup = false;
  int? ladExecutedOrders = 0;
  int? ladOpenOrders = 0;

  // int? timeToRecoverInMonth = 0;
  double? timeToRecoverInvestmentInYears = 0.0;
  int? timeToRecoverLossesInDays = 0;

  int? noOfTradesPerMonth = 0;
  double? amountAlreadyRecovered = 0.0;

  String ladCashAssigned = "0";

  double? actualBrokerageCost = 0.0;
  double? otherBrokerageCharges = 0.0;
  DateTime? createdAt = DateTime.now();
  bool isOneClick = false;

  Ladder({
    this.isVisible = true, // Default value for visibility
    this.isAllValueVisible = true,
    required this.ladId,
    required this.ladUserId,
    this.ladStepsMoved = 0.0,
    this.ladPriceMoved = 0.0,
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
    required this. ladExtraCashPerOrder,
    required this.ladExtraCashLeft,
    required this.ladRealizedProfit,
    required this.ladInitialBuyQuantity,
    required this.ladDefaultBuySellQuantity,
    required this.ladTargetPrice,
    required this.ladNumOfStepsAbove,
    required this.ladNumOfStepsBelow,
    required this.ladCashNeeded,
    required this.ladStepSize,
    required this.ladInitialBuyPrice,
    required this.ladCurrentQuantity,
    required this.ladInitialBuyExecuted,
    this.ladRecentTradeId,
    this.noFollowup = false,
    this.ladExecutedOrders = 0,
    this.ladOpenOrders = 0,
    this.timeToRecoverInvestmentInYears = 0.0,
    this.timeToRecoverLossesInDays = 0,
    this.noOfTradesPerMonth = 0,
    this.amountAlreadyRecovered = 0.0,
    this.ladCashAssigned = "0",
    this.actualBrokerageCost = 0.0,
    this.otherBrokerageCharges = 0.0,
    this.createdAt,
    this.isOneClick = false,
  });
}
