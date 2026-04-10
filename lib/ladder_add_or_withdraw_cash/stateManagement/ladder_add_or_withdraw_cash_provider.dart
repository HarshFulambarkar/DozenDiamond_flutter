import 'dart:math';

import 'package:dozen_diamond/ladder_add_or_withdraw_cash/models/addCashRequest.dart';
import 'package:dozen_diamond/ladder_add_or_withdraw_cash/models/withdrawCashRequest.dart';
import 'package:dozen_diamond/ladder_add_or_withdraw_cash/services/ladder_add_or_withdraw_cash_service.dart';
import 'package:flutter/material.dart';

import '../../AB_Ladder/models/ladder_list_model.dart';

class LadderAddOrWithdrawCashProvider extends ChangeNotifier {
  LadderAddOrWithdrawCashProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  double availableCashInAccount = 1000000;
  double target = 0.0;
  double cashAlreadyAllocated = 0.0;
  double stepSize = 0.0;
  int orderSize = 0;
  double currentPrice = 0;
  int currentStockOwn = 0;
  double cashNeeded = 0.0;
  double extraCashGenerated = 0.0;

  String _selectedDuration = "5 mins";

  String get selectedDuration => _selectedDuration;
  double _numberOfStepsAbove = 0.0;
  double get numberOfStepsAbove => _numberOfStepsAbove;
  set numberOfStepsAbove(double numberOfStepsAboveBunch) {
    _numberOfStepsAbove = numberOfStepsAboveBunch;
    notifyListeners();
  }

  int _numberOfStepsBelow = 0;
  int get numberOfStepsBelow => _numberOfStepsBelow;
  set numberOfStepsBelow(int numberOfStepsBelowBunch) {
    _numberOfStepsBelow = numberOfStepsBelowBunch;
    notifyListeners();
  }

  set selectedDuration(String duration) {
    _selectedDuration = duration;
    notifyListeners();
  }

  int _ladId = 0;
  int get ladId => _ladId;
  set ladId(int value) {
    _ladId = value;
    notifyListeners();
  }

  TextEditingController addOrWithdrawCashTextController =
      TextEditingController(text: "");

  bool _isWithdraw = false;

  bool get isWithdraw => _isWithdraw;

  set isWithdraw(bool value) {
    _isWithdraw = value;
    notifyListeners();
  }

  bool _initialBuyExecuted = false;

  bool get initialBuyExecuted => _initialBuyExecuted;

  set initialBuyExecuted(bool value) {
    _initialBuyExecuted = value;
    notifyListeners();
  }

  int _initialBuyQuantity = 0;

  int get initialBuyQuantity => _initialBuyQuantity;

  set initialBuyQuantity(int value) {
    _initialBuyQuantity = value;
    notifyListeners();
  }

  int _newInitialBuyQuantity = 0;

  int get newInitialBuyQuantity => _newInitialBuyQuantity;

  set newInitialBuyQuantity(int newInitialBuyQuantityBunch) {
    _newInitialBuyQuantity = newInitialBuyQuantityBunch;
    notifyListeners();
  }

  double _cashAdded = 0.0;
  double get cashAdded => _cashAdded;
  set cashAdded(double cashAddedBunch) {
    _cashAdded = cashAddedBunch;
    notifyListeners();
  }

  double _cashWithdrawn = 0.0;
  double get cashWithdrawn => _cashWithdrawn;
  set cashWithdrawn(double cashWithdrawnBunch) {
    _cashWithdrawn = cashWithdrawnBunch;
    notifyListeners();
  }

  String _adderAddOrWithdrawCashError = "";

  String get adderAddOrWithdrawCashError => _adderAddOrWithdrawCashError;

  set adderAddOrWithdrawCashError(String value) {
    _adderAddOrWithdrawCashError = value;
    notifyListeners();
  }

  bool _updateCheckbox = false;

  bool get updateCheckbox => _updateCheckbox;

  set updateCheckbox(bool value) {
    _updateCheckbox = value;
    notifyListeners();
  }

  int _newStockToBuy = 0;

  int get newStockToBuy => _newStockToBuy;

  set newStockToBuy(int value) {
    _newStockToBuy = value;
    notifyListeners();
  }

  double _newCashNeeded = 0.0;

  double get newCashNeeded => _newCashNeeded;

  set newCashNeeded(double value) {
    _newCashNeeded = value;
    notifyListeners();
  }

  double _newExtraCashGeneratedPerTrade = 0.0;

  double get newExtraCashGeneratedPerTrade => _newExtraCashGeneratedPerTrade;

  set newExtraCashGeneratedPerTrade(double value) {
    _newExtraCashGeneratedPerTrade = value;
    notifyListeners();
  }

  int _newOrderSize = 0;

  int get newOrderSize => _newOrderSize;

  set newOrderSize(int value) {
    _newOrderSize = value;
    notifyListeners();
  }

  double _newStepSize = 0.0;

  double get newStepSize => _newStepSize;

  set newStepSize(double value) {
    _newStepSize = value;
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

  late Ladder _selectedLadderData;

  Ladder get selectedLadderData => _selectedLadderData;

  set selectedLadderData(Ladder value) {
    _selectedLadderData = value;
    notifyListeners();
  }

  Future<void> resetValues(BuildContext context) async {
    availableCashInAccount = 1000000;
    target = 0.0;
    cashAlreadyAllocated = 0.0;
    stepSize = 0.0;
    orderSize = 0;
    currentPrice = 0;
    currentStockOwn = 0;
    cashNeeded = 0.0;
    extraCashGenerated = 0.0;

    isWithdraw = false;
    adderAddOrWithdrawCashError = "";
    updateCheckbox = false;
    newStockToBuy = 0;
    newCashNeeded = 0.0;
    newExtraCashGeneratedPerTrade = 0.0;
    newOrderSize = 0;
    newStepSize = 0.0;
  }

  Future<void> addAndWithdrawLadderCash(BuildContext context) async {
    if (addOrWithdrawCashTextController.text != "") {
      int Ca;

      if (isWithdraw) {
        Ca = -int.parse(addOrWithdrawCashTextController.text);
      } else {
        Ca = int.parse(addOrWithdrawCashTextController.text);
      }

      double T = target;
      int quantities_hold = currentStockOwn;
      double old_step_size = stepSize;
      double current_price = currentPrice;

      print("T: $T");
      print("quantities_hold: ${quantities_hold}");
      print("old_step_size: ${old_step_size}");
      print("current_price: ${current_price}");

      double old_number_of_steps = (T - current_price) / old_step_size;

      print("old_number_of_steps: ${old_number_of_steps}");

      double old_cash_needed = cashNeeded;

      print("old_cash_needed: ${old_cash_needed}");

      Map<String, dynamic> values = await calculateNewValues(
        initialBuyExecuted,
        initialBuyQuantity,
        Ca,
        T,
        quantities_hold,
        _numberOfStepsAbove,
        _numberOfStepsBelow,
        old_cash_needed,
        current_price,
      );

      print("here are the values $values");
      if (initialBuyExecuted) {
        newStockToBuy = values['final_stocks_to_be_bought'];
      } else {
        print("here is the value ${values['initial_buy_quantity']}");
        newInitialBuyQuantity = values['initial_buy_quantity'];
      }
      if (isWithdraw) {
        cashWithdrawn = values['cash_used'];
      } else {
        cashAdded = values['cash_used'];
      }
      newCashNeeded = values['new_cash_needed'];
      newExtraCashGeneratedPerTrade = values['extra_cash_generated_per_trade'];
      newOrderSize = values['order_size'];
      newStepSize = values['new_step_size'];
    }
  }

  Map<String, dynamic> calculateNewValues(
      bool ladInitialBuyExecuted,
      int ladInitialBuyQuantity,
      Ca,
      T,
      stocks_owned,
      old_number_of_steps,
      old_number_of_steps_below,
      old_cash_needed,
      current_price) {
    double X = (Ca / current_price) *
        (2 * T - 2 * current_price) /
        (2 * T - current_price);
    print("----------------");
    print(X);
    int total_stocks_to_be_sold;
    print("ladInitialBuyExecuted is $ladInitialBuyExecuted");
    if (!ladInitialBuyExecuted) {
      stocks_owned = ladInitialBuyQuantity;
      print("ladInitialBuyQuantity is here stated $ladInitialBuyQuantity");
    } else {
      print("here is the $stocks_owned and $X");
    }
    total_stocks_to_be_sold = (stocks_owned + X).floor();
    print(
        "total stocks to sold $total_stocks_to_be_sold $ladInitialBuyQuantity and $X and $old_number_of_steps");

    int d = isWithdraw
        ? (total_stocks_to_be_sold / old_number_of_steps).ceil()
        : (total_stocks_to_be_sold / old_number_of_steps).floor();
    print(d);
    double number_of_steps_above = total_stocks_to_be_sold / d;
    print(number_of_steps_above);
    double step_size = (T - current_price) / number_of_steps_above;
    print(step_size);
    int calculated_number_of_steps_below = (current_price / step_size).floor();
    print(calculated_number_of_steps_below);
    double c_used = (X * current_price) +
        (current_price / (2 * (old_number_of_steps_below * orderSize)));
    print("here is the c_used $c_used");
    print("Debugging Values:");
    print("X (Multiplier): $X");
    print("Current Price: $current_price");
    print("Old Number of Steps Below: $old_number_of_steps_below");
    print("Order Size: $orderSize");
    int x_new = X.floor();
    double c_used_new = c_used;
    int d_new = d;
    double step_size_new = step_size;
    double na_new = number_of_steps_above;
    int nb_new = calculated_number_of_steps_below;
    int new_total_stocks_to_be_sold = total_stocks_to_be_sold;
    print("here is your ca $Ca");
    while (c_used_new <= Ca) {
      X = x_new.toDouble();
      print("in the loop for x $X");
      c_used = c_used_new;
      print("in the loop for  c_used $c_used");
      d = d_new;
      print("in the loop for d $d");
      step_size = step_size_new;
      print("in the loop for step_size $step_size");
      number_of_steps_above = na_new;
      print("in the loop for numberOfSteps $number_of_steps_above");
      calculated_number_of_steps_below = nb_new;
      print(
          "in the loop for calculatedNumberOfStepsBelow $calculated_number_of_steps_below");
      total_stocks_to_be_sold = new_total_stocks_to_be_sold;
      print("in the loop for totalStocksToBeSold $total_stocks_to_be_sold");

      x_new++;
      print("here is the x_new $x_new");
      new_total_stocks_to_be_sold = (stocks_owned + x_new).floor();
      print('new_total_stocks_to_be_sold: $new_total_stocks_to_be_sold');
      d_new = (new_total_stocks_to_be_sold / number_of_steps_above).floor();
      print('d_new: $d_new');
      na_new = new_total_stocks_to_be_sold / d_new;
      print('na_new: $na_new');
      step_size_new = (T - current_price) / na_new;
      print('step_size_new: $step_size_new');
      nb_new = (current_price / step_size_new).floor();
      print('nb_new: $nb_new');
      c_used_new = (x_new.toDouble() * current_price) +
          (current_price /
              2 *
              (nb_new * d_new - old_number_of_steps_below * orderSize));

      print('c_used_new: $c_used_new');
    }

    double extra_cash_generated_per_trade = d * step_size / 2;

    double reteOfSale = currentStockOwn / (target - current_price);
    double initialButPrice = target - (initialBuyQuantity / reteOfSale);

    print("below is initialButPrice");
    print(initialButPrice);
    double averagePurchasePrice = (initialButPrice - ( (currentStockOwn + X) - initialBuyQuantity ) * step_size / d)/ 2;

    print("below is averagePurchasePrice");
    print(averagePurchasePrice);

    double new_cash_needed =
        calculated_number_of_steps_below * current_price / 2 * d;
        // calculated_number_of_steps_below * averagePurchasePrice * d;

    print("below is new_cash_needed");
    print(new_cash_needed);

    print("below is step_size");
    print(step_size);

    double cash_to_be_returned =
        Ca - (current_price * X + (new_cash_needed - old_cash_needed));

    if (initialBuyExecuted) {
      return {
        'cash_used': c_used,
        'number_of_steps_above': number_of_steps_above,
        'order_size': d,
        'final_stocks_to_be_bought': X.floor(),
        'cash_to_be_returned': cash_to_be_returned,
        'extra_cash_generated_per_trade': extra_cash_generated_per_trade,
        'new_cash_needed': new_cash_needed,
        'new_step_size': step_size,
      };
    } else {
      print("not executed $X and $stocks_owned");
      return {
        'cash_used': c_used,
        'number_of_steps_above': number_of_steps_above,
        'order_size': d,
        'initial_buy_quantity': X.floor() + stocks_owned,
        'cash_to_be_returned': cash_to_be_returned,
        'extra_cash_generated_per_trade': extra_cash_generated_per_trade,
        'new_cash_needed': new_cash_needed,
        'new_step_size': step_size,
      };
    }
  }

  void validateAddCashToLadderPrice(BuildContext context) {
    if (addOrWithdrawCashTextController.text != "") {
      if (double.parse(addOrWithdrawCashTextController.text) >
          availableCashInAccount) {
        adderAddOrWithdrawCashError = "Your Account Cash is not Enough";
      } else if (availableCashInAccount < minimumCashUserCanAdd(context)) {
        adderAddOrWithdrawCashError = "Not enough cash in account";
      } else if (double.parse(addOrWithdrawCashTextController.text) <
          minimumCashUserCanAdd(context)) {
        adderAddOrWithdrawCashError =
            "You can't add cash less then ${minimumCashUserCanAdd(context).toStringAsFixed(2)}";
      } else {
        adderAddOrWithdrawCashError = "";
      }
    } else {
      adderAddOrWithdrawCashError = "";
    }
  }

  double minimumCashUserCanAdd(BuildContext context) {
    double minmum_cash_user_can_add = currentPrice;

    print("minmum_cash_user_can_add");
    print(minmum_cash_user_can_add);

    return minmum_cash_user_can_add;
  }

  void validateWithdrawCashToLadderPrice(BuildContext context) {
    if (addOrWithdrawCashTextController.text != "") {
      double p = currentPrice;

      int Q = currentStockOwn;
      double T = target;
      double S = stepSize;

      print("p: ${p}");
      print("Q: ${Q}");
      print("T: ${T}");
      print("S: ${S}");

      print("r = Q / (T - p)");

      double r = Q / (T - p);

      print("r: ${r}");

      double a = (((p * p) * r) / 2 + Q * p);

      print("a = (((p * p) * r) / 2 + Q * p)");

      print("a: ${a}");

      double b = (T * 2) / 2 * S;

      print("b = (T * 2) / 2 * S");

      print("b: ${b}");

      double maximumCashUserCanWithdraw = a - b;

      print("maximumCashUserCanWithdraw = a - b");

      print("maximumCashUserCanWithdraw: ${maximumCashUserCanWithdraw}");

      print(a);
      print(b);
      print(maximumCashUserCanWithdraw);

      if (double.parse(addOrWithdrawCashTextController.text) >
          maximumCashUserCanWithdraw.abs()) {
        adderAddOrWithdrawCashError =
            "Please add value less then ${maximumCashUserCanWithdraw.toStringAsFixed(2)}";
      } else {
        adderAddOrWithdrawCashError = "";
      }
    }
  }

  bool isAddWithdrawCash = false;
  Future<void> addCashToLadder() async {
    isAddWithdrawCash = true;
    notifyListeners();
    try {
      double? tempLimitPrice = null;
      int? timeInMin = null;

      print("below is limit price");
      print(limitPrice);
      print(limitPriceTimeInMin);

      tempLimitPrice = double.tryParse(limitPrice);
      timeInMin = int.tryParse(limitPriceTimeInMin);

      print(timeInMin);
      print(ladId);
      print(addOrWithdrawCashTextController.text);
      print(newStockToBuy);
      print(newCashNeeded);
      print(newStepSize);
      print(newOrderSize);
      print(newInitialBuyQuantity);
      print(initialBuyExecuted);

      AddCashRequest addCashRequest;
      if (initialBuyExecuted) {
        addCashRequest = AddCashRequest(
          ladId: ladId,
          // newCashAdded: cashAdded,
          newCashAdded: double.tryParse(addOrWithdrawCashTextController.text),
          stocksToBeBought: newStockToBuy,
          newCashNeeded: newCashNeeded,
          newStepSize: newStepSize,
          newOrderSize: newOrderSize,
          time: 5,
          minLimitPrice: tempLimitPrice,
          timeInMin: timeInMin,
        );
      } else {
        addCashRequest = AddCashRequest(
          ladId: ladId,
          // newCashAdded: cashAdded,
          newCashAdded: double.tryParse(addOrWithdrawCashTextController.text),
          newInitialBuyQuantity: newInitialBuyQuantity,
          newCashNeeded: newCashNeeded,
          newStepSize: newStepSize,
          newOrderSize: newOrderSize,
          time: 5,
          minLimitPrice: tempLimitPrice,
          timeInMin: timeInMin,
        );
      }

      await LadderAddOrWithdrawCashService().addCashToLadderService(
        addCashRequest,
      );
    } catch (e) {
      print("error in the addCashToLadder function in the provider $e");
      throw e;
    } finally {
      isAddWithdrawCash = false;
      notifyListeners();
    }
  }

  Future<void> withdrawCashToLadder() async {
    isAddWithdrawCash = true;
    notifyListeners();
    try {
      double? tempLimitPrice = null;
      int? timeInMin = null;

      tempLimitPrice = double.tryParse(limitPrice);
      timeInMin = int.tryParse(limitPriceTimeInMin);

      WithdrawCashRequest withdrawCashRequest;
      if (initialBuyExecuted) {
        withdrawCashRequest = WithdrawCashRequest(
          ladId: ladId,
          newCashWithdraw: cashWithdrawn,
          stocksToBeSold: newStockToBuy,
          newCashNeeded: newCashNeeded,
          newStepSize: newStepSize,
          newOrderSize: newOrderSize,
          time: 5,
          minLimitPrice: tempLimitPrice,
          timeInMin: timeInMin,
        );
      } else {
        withdrawCashRequest = WithdrawCashRequest(
          ladId: ladId,
          newCashWithdraw: cashWithdrawn,
          stocksToBeSold: newStockToBuy,
          newInitialBuyQuantity: newInitialBuyQuantity,
          newCashNeeded: newCashNeeded,
          newStepSize: newStepSize,
          newOrderSize: newOrderSize,
          time: 5,
          minLimitPrice: tempLimitPrice,
          timeInMin: timeInMin,
        );
      }
      await LadderAddOrWithdrawCashService().withdrawCashToLadderService(
        withdrawCashRequest,
      );
    } catch (e) {
      print("error in the addCashToLadder function in the provider $e");
      throw e;
    } finally {
      isAddWithdrawCash = false;
      notifyListeners();
    }
  }
}
