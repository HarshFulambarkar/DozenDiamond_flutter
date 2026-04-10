import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any formatting and non-digit characters
    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Return empty if the input is empty
    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse the value as a double
    double value = double.parse(cleanText) / 100;

    // Format the value as currency
    String newText = _currencyFormat.format(value);

    // Update the cursor position
    int selectionIndex = newText.length;

    return TextEditingValue(

      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}