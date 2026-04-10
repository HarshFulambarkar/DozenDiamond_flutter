import 'package:flutter/services.dart';

class CustomCodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;

    // Limit length to 8
    if (text.length > 8) {
      return oldValue;
    }

    // First 2 chars must be uppercase A–Z
    if (text.length <= 2) {
      if (!RegExp(r'^[A-Z]*$').hasMatch(text)) {
        return oldValue;
      }
    }

    // Next up to 6 must be digits OR uppercase letters
    if (text.length > 2) {
      final firstTwo = text.substring(0, 2);
      final remaining = text.substring(2);

      if (!RegExp(r'^[A-Z]{2}$').hasMatch(firstTwo)) {
        return oldValue;
      }

      // 🔹 UPDATED RULE HERE
      if (!RegExp(r'^[A-Z0-9]*$').hasMatch(remaining)) {
        return oldValue;
      }
    }

    return newValue;
  }
}
