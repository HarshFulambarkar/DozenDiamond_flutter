import 'package:dozen_diamond/global/models/api_request_response.dart';

class AccountInfoBarFieldVisibility implements ApiRequestResponse {
  bool showUnallocatedCashLeftForTrading = true;
  bool showCashLeftInActiveLadders = true;
  bool showCashForNewLadders = true;
  bool showCashLeft = true;
  bool showFundsInPlay = true;
  bool showExtraCash = true;
  bool showCashNeededForActiveLadders = false;

  @override
  Map<String, dynamic> toJson() {
    return {
      "show_unallocated_cash_left_for_trading":
          this.showUnallocatedCashLeftForTrading,
      "show_cash_left_in_active_ladders": this.showCashLeftInActiveLadders,
      "show_cash_for_new_ladders": this.showCashForNewLadders,
      "show_cash_left": this.showCashLeft,
      "show_funds_in_play": this.showFundsInPlay,
      "show_extra_cash": this.showExtraCash,
      "show_cash_needed_for_active_ladders": this.showCashNeededForActiveLadders
    };
  }

  @override
  AccountInfoBarFieldVisibility fromJson(Map<String, dynamic> json) {
    showUnallocatedCashLeftForTrading =
        json['show_unallocated_cash_left_for_trading'];
    showExtraCash = json['show_extra_cash'];
    showCashLeftInActiveLadders = json['show_cash_left_in_active_ladders'];
    showCashForNewLadders = json['show_cash_for_new_ladders'];
    showCashLeft = json['show_cash_left'];
    showFundsInPlay = json['show_funds_in_play'];
    showCashNeededForActiveLadders =
        json['show_cash_needed_for_active_ladders'];

    return this;
  }

  int numberOfFieldsVisible() {
    // Store all boolean fields in a list
    List<bool> fields = [
      showUnallocatedCashLeftForTrading,
      showExtraCash,
      showCashNeededForActiveLadders,
      showCashLeftInActiveLadders,
      showCashForNewLadders,
      showCashLeft,
      showFundsInPlay
    ];
    // Count the number of true values
    return fields.where((field) => field).length;
  }
}
