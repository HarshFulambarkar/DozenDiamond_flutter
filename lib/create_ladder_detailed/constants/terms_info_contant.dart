import 'package:dozen_diamond/global/constants/currency_constants.dart';

class TermsInfoConstant {
  final titleTarget = "About Target price";
  final messageTarget =
      "The final price in the ladder at which all the stocks in the holdings will be sold according to the STM strategy.";
  final titleMultiplier = "About Target Price Multiplier";
  final messageMultiplier =
      "Target Price Multiplier is the Multipler of Initial Price that will lead to Target Price";
  final titleInitial = "About Initial Buy Price";
  final messageInitial =
      "Initial Buy Price is the price at which the initial stocks in the ladder will be purchased. By default, this is the current market price, but it can be modified by the user during the initial stage of ladder creation.";
  final titleMinimum = "About Minimum Price";
  final messageMinimum =
      "Minimum Price in the ladder is the lowest price at which the stocks can be bought";
  final titleBuyQty = "About Buy Quantity";
  final messageBuyQty =
      "Buy Quantity is quantity of units that are bought at the beginning of the trade.";
  final titleCashAllocated = "About Cash Allocated";
  final messageCashAllocated =
      "Cash Allocated is the amount of cash Allocated for executing the ladder process at the beginning of the trade.";
  final titleStepSize = "About Step Size";
  final messageStepSize =
      "Step size is the size at which if the stock price increases or decreases, buy or sell activity is executed";
  final titleDefaultBuySellQty = "About Default Buy/Sell Quantity";
  final messageDefaultBuySellQty =
      "Default Buy/Sell Quantity is the Quantity of the stocks that are bought or sold at every stepSize";
  final titleNumberOfStepsBelow = "About Number of Steps Below (NB)";
  final messageNumberOfStepsBelow =
      "Number of steps below is refered to the count of steps taken while buying the shares when the stock price drop";
  final titleStepSizeMultipler = "About the simulated price multiplier";
  final messageStepSizeMultipler =
      "Multiplier applied to the step size to simulate stock price changes in the ladder strategy.";
}
