import 'package:flutter/material.dart';

Color hexToColor(String hexColor) {
  // Remove the hash (#) character if present
  if (hexColor.startsWith('#')) {
    hexColor = hexColor.substring(1);
  }

  // Parse the hexadecimal color code
  int hexValue = int.tryParse(hexColor, radix: 16) ?? 0xFF000000;

  // Return the Color object
  return Color(hexValue);
}
