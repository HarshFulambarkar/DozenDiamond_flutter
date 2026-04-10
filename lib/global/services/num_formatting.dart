import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

String numToCurrency(dynamic price) {
  return NumberFormat.currency(locale: 'HI', symbol: '₹').format(price);
}

String? formatUtcToLocalDate(String? utcTime) {
  DateTime unFormatedUtcTime =
      new DateFormat("dd/MM/yyyy").parse(utcTime!, true);
  DateTime formatedUtcTime = DateTime.parse(unFormatedUtcTime.toString());
  DateFormat outputFormat = DateFormat('dd-MM-yy');

  String localTime =
      outputFormat.format(formatedUtcTime.toLocal()); // UTC to local time
  return localTime;
}

String intToUnits(int units) {
  return NumberFormat('##,##,##,###').format(units);
}

String numToComma(dynamic price) {
  return NumberFormat.currency(locale: 'HI', symbol: ' ').format(price);
}

String amountStringSplittedFormatted(String? input) {
  String formattedString = "";
  formattedString = amountToInrFormatCLP(
    double.tryParse((input ?? "0.0").split('.')[0]) ?? 0.0,
  );
  if (input != null && input.split('.').length > 1) {
    formattedString += '.' + input.split('.')[1];
  }
  return formattedString;
}

String? amountToInrFormat(BuildContext context, double? amount) {
  // Get CurrencyConstants from Provider
  CurrencyConstants currencyConstants = Provider.of<CurrencyConstants>(context);

  if (amount == null) {
    return null;
  }

  return currencyConstants.currency == '₹'
      ? NumberFormat.currency(locale: 'en_IN', symbol: "₹").format(amount)
      : NumberFormat.currency(locale: 'en_USD', symbol: "\$").format(amount);
}

String amountToInrFormatCLP(double amount,
    {bool showSymbol = false, int decimalDigit = 0}) {
  return NumberFormat.currency(
    locale: 'en_IN',
    symbol: showSymbol ? "${CurrencyConstants().currency}" : "",
    decimalDigits: decimalDigit,
  ).format(amount);
}

List<String> doublValueSplitterBydot(String inputString) {
  List<String> splittedValues = [];
  if (inputString.isNotEmpty) {
    splittedValues.add(inputString.split('.')[0].replaceAll(',', ''));
    if (inputString.indexOf('.') > 0) {
      splittedValues.add(inputString.substring(
          inputString.indexOf('.'),
          inputString.length - inputString.indexOf('.') < 4
              ? inputString.length
              : inputString.indexOf('.') + 4));
    } else {
      splittedValues.add("");
    }
  } else {
    splittedValues = ["", ""];
  }
  return splittedValues;
}

Color determineColorByValue(double value) {
  if (value < 0) {
    return Colors.red;
  } else if (value > 0) {
    return Colors.green;
  } else {
    return Colors.white;
  }
}

class NumberToCurrencyFormatter extends TextInputFormatter {
  String? amountToInrFormat(context, double? amount) {
    return amount == null
        ? null
        : NumberFormat.currency(locale: 'en_IN', symbol: "", decimalDigits: 0)
            .format(amount);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return TextEditingValue()
          .copyWith(text: "", selection: TextSelection.collapsed(offset: 0));
    }
    String? formattedAmount = "";
    formattedAmount =
        NumberFormat.currency(locale: 'en_IN', symbol: "", decimalDigits: 0)
            .format(double.tryParse(newValue.text.replaceAll(',', '')));
    if (formattedAmount == null) {
      return oldValue;
    } else {
      return TextEditingValue().copyWith(
        text: formattedAmount,
        selection: TextSelection.collapsed(offset: formattedAmount.length),
      );
    }
  }
}
