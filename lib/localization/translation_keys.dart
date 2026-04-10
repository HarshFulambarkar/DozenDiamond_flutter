class TranslationKeys {
  TranslationKeys._();

  static const dozenDiamonds = "Dozen Diamonds";

  static const noInternetConnection = "No Internet Connection";
  static const pleaseCheckYourConnectionAndTryAgain = "Please check your connection and try again.";
  static const retry = "Retry";

  static const reviewAndCustomizeYourLadderSetup = "Review & Customize Your Ladder Setup";
  static const setYourStockOrderAndCashAllocationBeforeFinalizingYourLadder = "Set your stock order and cash allocation before finalizing your ladder.";
  // static const unallocatedCashForNewLadders = "Unallocated cash for new ladders";
  static const unallocatedCashForNewLadders = "Un-alloc cash for new lad";
  static const extraCashGeneratedLeft = "Extra cash generated/left";
  static const unassignedCash = "Unassigned cash";
  static const cashAllocated = "Cash allocated";
  static const addMoreStocks = "add more stocks";
  static const selectMode = "Select Mode";

  static const chooseYourLadderMode = "Choose your ladder mode";
  static const selectTheTradingModeThatSuitsYouBestStartSimpleOrGoInDepthWithAdvancedSettings = "Select the trading mode that suits you best--start simple or go in-depth with advanced settings.";
  static const easy = "Easy";
  static const recommended = "Recommended";
  static const noFormulasSimpleAutomation = "No formulas, simple automation.";
  static const detailed = "Detailed";
  static const fullControlWithAdvancedSettings = "Full control with advanced settings.";
  static const useTheSameModeForAllSelectedStocks = "Use the same mode for all selected stocks";
  static const cancel = "Cancel";
  static const continuee = "Continue";

  static const authorize = "Authorize";
  static const ok = "Ok";

  static const cdslAndNsdlDepositoriesAuthenticationStatus = "CDSL & NSDL Depositories Authentication Status";
  static const checkStatus = "Check Status";

  static const laddersAlreadyCreated = "ladders already created";
  static const view = "View";

  static const existingLadders = "Existing ladders";
  static const currentPrice = "Current price";

  static const stock = "Stock";
  static const ladder = "Ladder";
  static const active = "Active";
  static const inactive = "Inactive";
  static const okay = "Okay";
  static const initialBuyQuantity = "Initial Buy Quantity";
  static const targetPrice = "Target price";
  static const minimumPrice = "Minimum price";
  static const stepSize = "Step size";
  static const defaultBuySellQuantity = "Default buy/sell quantity";

  static const createLadder = "Create Ladder";
  static const mode = "Mode";
  static const configurations = "Configurations";
  static const target = "Target";
  static const numberOfStepsAbove = "Number of Steps above";
  static const updateValueByClickingOnTheCheckbox = "Update value by clicking on the checkbox";
  static const breakdown = "Breakdown";
  static const initialBuyCash = "Initial Buy Cash";
  static const calculatedNumberOfStepsAbove = "Calculated number of steps above";
  static const calculatedNumberOfStepsBelow = "Calculated number of steps below";
  static const cashNeeded = "Cash needed";
  static const finalCashAllocation = "Final cash allocation";
  static const selectCheckboxBelow = "Select checkbox below";
  static const warning = "Warning";
  static const showLadder = "Show ladder";

  static const simulationReviewLadder = "Simulation/Review ladder";
  static const tabularView = "Tabular view";
  static const graphicalView = "Graphical view";
  static const price = "Price";
  static const initialPurchasePrice = "Initial purchase price";
  static const orderSize = "Order size";
  static const allocatedCash = "Allocated cash";
  static const saveLadder = "Save ladder";
  static const updateLadder = "Update ladder";
  static const simulationDuration = "Simulation duration";
  static const ordersBuySell = "Orders(Buys/Sells)";
  static const stocksSold = "Stocks sold";
  static const tradesCashGain = "Trades cash gain";
  static const averageSellPrice = "Average sell price";
  static const averageBuyPrice = "Average buy price";
  static const extraCashPerOrder = "EXT. cash (per order)";
  static const graphUnavailable = "Graph unavailable";
  static const weCouldntFindHistoricalDataForThisStock = "We coundn't find historical data for this stock";

  static const nextStep = "Next step";
  static const selectPrice = "Select price";
  static const viewFormulas = "View formulas";
  static const initialBuyPrice = "Initial Buy Price";
  static const thePriceAtWhichTheStocksAreBoughtTheyAreSetToBeAsTheCurrentMarketPriceByDefault = "The price at which the initial stocks in the ladder will be purchased. By default, this is the current market price, but it can be modified by the user during the initial stage of ladder creation.";
  static const itIsTheLowestPriceAtWhichAStockCanBeBoughtInTheLadder = "The lowest price level at which a stock can be bought within the ladder.";
  static const targetPriceMultiplier = "Target Price Multiplier";
  static const theMultiplierOfTheInitialPriceThatWillLeadToTargetPrice = "The multiplier applied to the initial price to calculate the target (final) price.";
  static const targetPriceDescription = "The final price in the ladder at which all the stocks in the holdings will be sold according to the STM strategy.";
  static const formula = "Formula";
  static const stockCurrentPrice = "The stock’s current market trading price.";

  static const selectInitialBuy = "Select Initial Buy";
  static const cashAssigned = "Cash assigned";
  static const cashAssignedDescription = "The amount of cash allocated to this ladder.";
  static const estInitialBuyCash = "Est. initial buy cash";
  static const estInitialBuyCashDescription = "The estimated amount of cash that will be required to initiate the first buy order in the ladder.";
  static const actualInitialBuyCash = "Actual initial buy cash";
  static const actualInitialBuyCashDescription = "The actual amount of cash that will be used for the first executed buy order in the ladder.";
  static const buyQuantity = "Buy Quantity";
  static const buyQuantityDescription = "The number of stock units to be purchased in the ladder initial trade.";

  static const selectLadderStepSize = "Select Step Size";
  static const calculatedInitialBuyQuantity = "Calculated Initial Buy Quantity";
  static const cashNeededDescription = "Estimated cash required to buy stocks at their ladder-defined prices."; // "The price at which the initial stocks in the ladder will be purchased. By default, this is the current market price, but it can be modified by the user during the initial stage of ladder creation.";
  static const actualCashAllocated = "Actual Cash Allocated";
  static const actualCashAllocatedDescription = "The total cash that has been allocated to the ladder for buying stocks."; // "The lowest price level at which a stock can be bought within the ladder.";
  static const calculatedStepsAbove = "Calculated Steps Above";
  static const calculatedStepsAboveDescription = "The number of steps above the initial price needed to reach the target price."; // "The multiplier applied to the initial price to calculate the target (final) price.";
  static const stepsBelow = "Steps Below (SB)";
  static const stepsBelowDescription = "The number of  steps between the initial price and the minimum price, where each step represents a fixed price difference (step size).";
  static const calculatedStepSize = "Calculated Step Size";
  static const calculatedStepSizeDescription = "The system-calculated step size, representing the price difference between consecutive buy or sell points.";
  static const orderSizeDescription = "Number of units of stock bought or sold at each ladder step.";
  static const stepsAbove = "Steps Above";
  // static const suggestedByUser = "Suggested by user";
  static const suggestedByUser = "Sugg. by user";
  static const stepsAboveDescription = "User-suggested number of steps between initial price and maximum price, where each step is defined by the step size.";
  static const stepSizeDescription = "User-suggested step size at which buy or sell orders are triggered.";
  static const stepSizeWarning = "Suggested values by user are used to guide the calculated values and may not be accepted exactly by the app";


  static const orContinueWith = "or continue with";

  static const almostThere = "Almost There!";
  static const completeThisShortQuestionnaireToMoveOneStepCloserToUnlockingRealTimeTradingWithUs = "Complete this short questionnaire to move one step closer to unlocking real-time trading with us.";
  static const responseSubmitted = "Response Submitted";
  static const noQuestionnaireFound = "No Questionnaire Found";

  static const accessRealTimeTrading = "Access real trading";
  static const weSentYourA6DigitVerificationCodeAt = "We sent you a 6-digit verification code at";
  static const verificationCode = "Verification code";

  static const myProfile = "My Profile";
  static const edit = "Edit";
  static const saveChanges = "Save changes";
  static const name = "Name";
  static const email = "Email";
  static const phoneNumber = "Phone number";
  static const phone = "Phone";
  static const brokerDetails = "Broker details";
  static const broker = "Broker";
  static const joinedOn = "Joined on";
  static const joined = "Joined";

  static const clientCode = "Client Code";

  static const download = "Download";

  static const country = "Country";
  static const state = "State";
  static const city = "City";

  static const subscription = "Subscription";
  static const nameAsPerBroker = "Name as per Broker";


}