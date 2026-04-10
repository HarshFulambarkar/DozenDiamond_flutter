import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

late BuildContext loaderContext;


String convertEmailToFormal(String email) {
  String shortDomain = "@dd.com";
  String fullDomain = "@dozendiamonds.com";
  if (email.toLowerCase().contains(shortDomain)) {
    return email.replaceAll(shortDomain, fullDomain);
  } else {
    return email;
  }
}

extension DoubleRoundTo2 on double {
  double roundTo2() {
    return double.parse(toStringAsFixed(2));
  }
}

Future<void> progressbar(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    // context: loaderContext,
    context: context,
    builder: (ctx) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

Future<void> hideBar(BuildContext context) async {
  // Navigator.pop(loaderContext);
  Navigator.pop(context);
}

double floorToSpecifiedPrecision({required double value, int precision = 2}) {
  return (value * pow(10, precision)).floor() / pow(10, precision);
}

Future<void> showCustomAlertDialogFromHelper(BuildContext context, String msg,
    [Function? action]) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 10,
            left: 20,
            right: 20,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(
              20,
            ),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (action != null) {
                          action();
                          Fluttertoast.showToast(
                              msg: "Successfully reset done");
                        }
                      },
                      child: const Text(
                        "Ok",
                        style: TextStyle(
                          color: Color(0xFF0099CC),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
