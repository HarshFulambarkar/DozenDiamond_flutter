import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

double screenWidthRecognizer(BuildContext context) {
  double screenWidth = 0;
  if (MediaQuery.of(context).size.width >= 1366) {
    return MediaQuery.of(context).size.width * 0.28;
  } else if (MediaQuery.of(context).size.width < 1366 &&
      MediaQuery.of(context).size.width >= 821) { //768) {
    return MediaQuery.of(context).size.width * 0.28;
  } else if (MediaQuery.of(context).size.width < 821) { //768) {
    if(kIsWeb) {

      if(MediaQuery.of(context).size.width < 450) {
        return MediaQuery.of(context).size.width;
      } else {
        return 450;
      }
      // return 450;

    } else {
      return MediaQuery.of(context).size.width;
    }
    // return MediaQuery.of(context).size.width;
    // return 450;
  } else if (MediaQuery.of(context).size.width < 768) { //768) {
    if(kIsWeb) {
      // return 450;
      if(MediaQuery.of(context).size.width < 450) {
        return MediaQuery.of(context).size.width;
      } else {
        return 450;
      }

    } else {
      return MediaQuery.of(context).size.width;
    }
    // return MediaQuery.of(context).size.width;
    // return 450;
  }
  return screenWidth;
}
