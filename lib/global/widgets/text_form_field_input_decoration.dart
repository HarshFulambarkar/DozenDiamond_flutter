import 'package:flutter/material.dart';

InputDecoration allocatedAmountFieldDecoration(
    Widget? iconAtRight, bool themeValue) {
  return InputDecoration(
      errorMaxLines: 8,
      errorStyle: TextStyle(color: Colors.yellow, fontSize: 18),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: themeValue ? Colors.black : Colors.white,
        ),
      ),
      counterText: "",
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: themeValue ? Colors.black : Colors.white,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      prefixIcon: iconAtRight == null
          ? null
          : Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: iconAtRight,
            ),
      prefixIconConstraints: BoxConstraints(minWidth: 30));
}
