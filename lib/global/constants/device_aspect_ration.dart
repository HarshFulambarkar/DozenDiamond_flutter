import 'package:flutter/material.dart';

class DeviceAspectRatio {
  final BuildContext context;

  DeviceAspectRatio({required this.context});

  double get largeScreenWidth {
    return MediaQuery.of(context).size.width * 0.28;
  }

  double get smallScreenWidth {
    return MediaQuery.of(context).size.width;
  }

  double mediumScreenButtonWidth = 0.13;
  double largeScreenButtonWidth = 0.13;
  double get mediumScreenWidth {
    return MediaQuery.of(context).size.width * 0.28;
  }
}
