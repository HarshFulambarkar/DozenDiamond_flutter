
import 'dart:async';

import 'package:flutter/material.dart';

class Utility {


  void showSnack(String text, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
        SnackBar(content: Text(text), duration: const Duration(minutes: 1)),

    );

    Timer(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    });
  }

}