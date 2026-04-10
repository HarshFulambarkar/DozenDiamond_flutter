import 'package:flutter/material.dart';

int _largeScreenSize = 1366;
int _mediumScreenSize = 768;
int _smallScreenSize = 360;

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;
  ResponsiveWidget({
    super.key,
    required this.largeScreen,
    this.mediumScreen,
    this.smallScreen,
  });

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= _largeScreenSize;

  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < _largeScreenSize &&
      MediaQuery.of(context).size.width >= _mediumScreenSize;

  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < _mediumScreenSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double _width = constraints.maxWidth;
      if (_width >= _largeScreenSize) {
        return largeScreen;
      } else if (_mediumScreenSize <= _width && _width < _largeScreenSize) {
        return mediumScreen ?? largeScreen;
      } else if (_width < _mediumScreenSize) {
        return smallScreen ?? largeScreen;
      } else {
        return largeScreen;
      }
    });
  }
}
