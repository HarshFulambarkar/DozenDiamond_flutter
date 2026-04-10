import 'package:flutter/widgets.dart';

class SettingsContentModel {
  final String title;
  final String subtitle;
  final Icon icons;
  final Widget routes;

  SettingsContentModel({
    required this.icons,
    required this.routes,
    this.subtitle = "",
    required this.title,
  });
}
