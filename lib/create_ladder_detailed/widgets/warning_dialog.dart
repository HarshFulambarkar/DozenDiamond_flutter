import 'package:flutter/material.dart';

Future<void> showAlert(
    BuildContext context, Map<String, dynamic> message) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(message["title"], style: TextStyle(color: Colors.red)),
        content:
            Text(message["content"], style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
