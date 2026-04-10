import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoIconDisplay {
  Widget infoDialog(String title, String message) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return AlertDialog(
        backgroundColor:
        value.defaultTheme ? Color(0xFFF6F1EE) : Color(0xFF15181F),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    });
  }

  Widget infoIconDisplay(BuildContext context, String title, String message,
      {double? size, Color? color}) {
    return IconButton(
      // icon: Icon(Icons.info),
      icon: Icon(Icons.info_outline),
      iconSize: size ?? 18,
      color: color ?? Colors.white,
      onPressed: () {
        // Show the dialog box here
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return infoDialog(title, message);
          },
        );
      },
      padding: EdgeInsets.zero,
    );
  }
}
