
class OptimalLadderCalculation {
  late int buySellQuantityValue;
  int? initialBuyQuantityValue;
  double? initialBuyPrice;
  late double stepSizeValue;
  double numberOfStepsAboveValue;
  double targetValue;
  late double
      averagePurchasePrice; // Mark as 'late' since it will be initialized later
  late double cashNeeded;
  double? cashLeft;
  double? priorCashAllocation;
  late double finalCashAllocation;
  double tickerPrice;
  late double initialBuyCash;
  late int numberOfStepsBelow;
  List<Map<String, dynamic>> listOfValues = [];
  String selectedMode;
  double priorBuyInitialPurchasePrice;

  // Constructor
  OptimalLadderCalculation({
    required this.initialBuyQuantityValue,
    required this.initialBuyPrice,
    required this.numberOfStepsAboveValue,
    required this.targetValue,
    required this.priorCashAllocation,
    required this.tickerPrice,
    required this.selectedMode,
    required this.priorBuyInitialPurchasePrice,
  });

  // Calculation function
  void calculations() {
    if(selectedMode == "Prior Buy") {

      // numberOfStepsAboveValue = (targetValue - (initialBuyPrice ?? 0)) / stepSizeValue;

      numberOfStepsAboveValue = double.tryParse(
          ((initialBuyQuantityValue ?? 0) / buySellQuantityValue)
              .toStringAsFixed(2)) ??
          0.0;

    } else {

      print("below is calculating numberOfStepsAboveValue");
      print(initialBuyQuantityValue);
      print(buySellQuantityValue);

      numberOfStepsAboveValue = double.tryParse(
          ((initialBuyQuantityValue ?? 0) / buySellQuantityValue)
              .toStringAsFixed(2)) ??
          0.0;

      print(numberOfStepsAboveValue);
    }


    // stepSizeValue = double.tryParse((((200 * (targetValue - initialBuyPrice!)) / numberOfStepsAboveValue) * (1/2)).toStringAsFixed(2)) ?? 0.0;
    // stepSizeValue = double.tryParse(((targetValue - initialBuyPrice!) / numberOfStepsAboveValue).toStringAsFixed(2)) ?? 0.0;

    if(selectedMode == "Prior Buy") {

      // stepSizeValue = (sqrt((200 * (targetValue - initialBuyPrice!)) / initialBuyQuantityValue!));

      stepSizeValue = double.tryParse(((targetValue - initialBuyPrice!) / numberOfStepsAboveValue).toStringAsFixed(2)) ?? 0.0;

      // stepSizeValue = (targetValue - (initialBuyPrice ?? 0)) / numberOfStepsAboveValue;
      //
      // print("-----------------------------");
      // print(initialBuyQuantityValue);
      // print(buySellQuantityValue);
      // print(targetValue);
      // print(priorBuyInitialPurchasePrice);
      // print(numberOfStepsAboveValue);
      // print("below is stepsizevalue");
      // print(stepSizeValue);
    } else {
      // stepSizeValue = (sqrt((200 * (targetValue - initialBuyPrice!)) / initialBuyQuantityValue!));

      print("below is calculating stepsize");
      print(targetValue);
      print(initialBuyPrice);
      print(numberOfStepsAboveValue);
      stepSizeValue = double.tryParse(((targetValue - initialBuyPrice!) / numberOfStepsAboveValue).toStringAsFixed(2)) ?? 0.0;
    }


    // stepSizeValue = (stepSizeValue * 100).truncateToDouble() / 100;
    // print("stepSizevalue is $stepSizeValue");
    if(selectedMode == "Prior Buy") {
      // numberOfStepsBelow = (priorBuyInitialPurchasePrice / stepSizeValue).floor();
      // // print("stepSizevalue nb steps is $numberOfStepsBelow");
      // averagePurchasePrice = priorBuyInitialPurchasePrice / 2;
      //
      // print("inside optimal calcualtion");
      // print(priorBuyInitialPurchasePrice);
      // print(stepSizeValue);
      // print(numberOfStepsBelow);
      // print(averagePurchasePrice);

      numberOfStepsBelow = (initialBuyPrice! / stepSizeValue).floor();
      // print("stepSizevalue nb steps is $numberOfStepsBelow");
      averagePurchasePrice = initialBuyPrice! / 2;
    } else {
      numberOfStepsBelow = (initialBuyPrice! / stepSizeValue).floor();
      // print("stepSizevalue nb steps is $numberOfStepsBelow");
      averagePurchasePrice = initialBuyPrice! / 2;
    }

    // print("initially $averagePurchasePrice and $initialBuyPrice");
    cashNeeded =
        numberOfStepsBelow * buySellQuantityValue * averagePurchasePrice;
    // print(
    // "stepSizevalue cashNeeded is $cashNeeded and $numberOfStepsBelow * $buySellQuantityValue * $averagePurchasePrice");
    // print(
    //     "numbers: $numberOfStepsBelow and $buySellQuantityValue and $averagePurchasePrice");
    cashLeft =
        priorCashAllocation! - initialBuyQuantityValue! * initialBuyPrice!;

    // print(
    //     "buySellQuantityValue: $buySellQuantityValue, initialBuyQuantityValue: $initialBuyQuantityValue, stepSizeValue: $stepSizeValue, numberOfStepsBelow: $numberOfStepsBelow, averagePurchasePrice: $averagePurchasePrice, cashNeeded: $cashNeeded, cashLeft: $cashLeft ");

    int d = buySellQuantityValue;
    double p = tickerPrice;
    double n = numberOfStepsAboveValue.toDouble();
    double t = targetValue;

    // finalCashAllocation = d * p * (n + ((p * n / (t - p))) / 2);

    initialBuyCash = initialBuyQuantityValue! * tickerPrice;
    if(selectedMode == "Prior Buy") {
      finalCashAllocation = priorCashAllocation!;
    } else {
      finalCashAllocation = cashNeeded + initialBuyCash;
    }

    // print(
    //     'finding error in finalCashAllocation d: $d, p: $p, n: $n, t: $t, finalCashAllocation: $finalCashAllocation');
    _addCurrentValuesToList();
  }

  // Add the current values to the listOfValues
  void _addCurrentValuesToList() {
    listOfValues.add({
      "numberOfStepsAbove": numberOfStepsAboveValue,
      "numberOfStepsBelow": numberOfStepsBelow,
      "buySellQuantityValue": buySellQuantityValue,
      "initialBuyQuantityValue": initialBuyQuantityValue,
      "stepSizeValue": stepSizeValue,
      "averagePurchasePrice": averagePurchasePrice,
      "cashNeeded": cashNeeded,
      "cashLeft": cashLeft,
      "finalCashAllocation": finalCashAllocation,
      "initialBuyCash": initialBuyCash
    });
  }

  // Calculate Ladder Parameter function
  Map<String, dynamic> calculateLadderParameter() {
    double numberOfStepsAboveTemp = numberOfStepsAboveValue;
    int initialBuyQtyTemp = initialBuyQuantityValue ?? 0;

    if(selectedMode == "Prior Buy") {
      // print("below is buySellQuantityValue");
      // print(targetValue);
      // print(priorBuyInitialPurchasePrice);
      // print(numberOfStepsAboveValue);
      // stepSizeValue = (targetValue - priorBuyInitialPurchasePrice) / numberOfStepsAboveValue;
      // buySellQuantityValue = (stepSizeValue / priorBuyInitialPurchasePrice).ceil();
      // print(stepSizeValue);
      // print(buySellQuantityValue);

      buySellQuantityValue = initialBuyQtyTemp < numberOfStepsAboveValue
          ? (((initialBuyQtyTemp) ?? 0) / numberOfStepsAboveTemp).ceil()
          : (((initialBuyQtyTemp) ?? 0) / numberOfStepsAboveTemp).floor();
    } else {

      print("below is calculating buySellQuantityValue");
      print(initialBuyQtyTemp);
      print(numberOfStepsAboveValue);
      print(numberOfStepsAboveTemp);
      buySellQuantityValue = initialBuyQtyTemp < numberOfStepsAboveValue
          ? (((initialBuyQtyTemp) ?? 0) / numberOfStepsAboveTemp).ceil()
          : (((initialBuyQtyTemp) ?? 0) / numberOfStepsAboveTemp).floor();

      print(buySellQuantityValue);
    }

    // print(
    //     "here is your buySellQuantity in the calculation ceil $buySellQuantityValue and $numberOfStepsAboveValue and $numberOfStepsAboveTemp ");
    calculations();
    // calculateOptimalParameters();
    // print("the cashNeeded you are serach for 1st $cashNeeded and $cashLeft");

    // Compare and assign the best results
    if (listOfValues.length == 2) {
      if (listOfValues[0]['finalCashAllocation'] >
          listOfValues[1]['finalCashAllocation']) {
        return _assignValuesFromList(0);
      } else {
        return _assignValuesFromList(1);
      }
    } else {
      return _assignValuesFromList(0);
    }
  }

  // Helper method to assign values from the list
  Map<String, dynamic> _assignValuesFromList(int index) {
    numberOfStepsAboveValue = listOfValues[index]['numberOfStepsAbove'];
    numberOfStepsBelow = listOfValues[index]['numberOfStepsBelow'];
    buySellQuantityValue = listOfValues[index]['buySellQuantityValue'];
    initialBuyQuantityValue = listOfValues[index]['initialBuyQuantityValue'];
    stepSizeValue = listOfValues[index]['stepSizeValue'];
    averagePurchasePrice = listOfValues[index]['averagePurchasePrice'];
    cashNeeded = listOfValues[index]['cashNeeded'];
    cashLeft = listOfValues[index]['cashLeft'];
    finalCashAllocation = listOfValues[index]['finalCashAllocation'];
    initialBuyCash = listOfValues[index]['initialBuyCash'];

    return {
      'numberOfStepsAbove': numberOfStepsAboveValue,
      'numberOfStepsBelow': numberOfStepsBelow,
      'buySellQuantityValue': buySellQuantityValue,
      'initialBuyQuantityValue': initialBuyQuantityValue,
      'stepSizeValue': stepSizeValue,
      'averagePurchasePrice': averagePurchasePrice,
      'cashNeeded': cashNeeded,
      'cashLeft': cashLeft,
      'finalCashAllocation': finalCashAllocation,
      'initialBuyCash': initialBuyCash
    };
  }
}

void main() {
  // Example values for the constructor
  int? initialBuyQuantityValue = 164;
  double? initialBuyPrice = 4060.00;
  double numberOfStepsAboveValue = 40.00;
  int k = 2;
  double targetValue = initialBuyPrice * k;
  double? priorCashAllocation = 1000000;
  double tickerPrice = initialBuyPrice;

  // Create an instance of OptimalLadderCalculation
  OptimalLadderCalculation optimalLadder = OptimalLadderCalculation(
    initialBuyQuantityValue: initialBuyQuantityValue,
    initialBuyPrice: initialBuyPrice,
    numberOfStepsAboveValue: numberOfStepsAboveValue,
    targetValue: targetValue,
    priorCashAllocation: priorCashAllocation,
    tickerPrice: tickerPrice,
    priorBuyInitialPurchasePrice: 0,
    selectedMode: ""
  );

  // Call the method to calculate ladder parameters
  Map<String, dynamic> result = optimalLadder.calculateLadderParameter();

  // Print the result
  print("Optimal Ladder Parameters:");
  print(result);
}
