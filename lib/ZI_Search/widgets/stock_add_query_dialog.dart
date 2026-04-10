import 'package:flutter/material.dart';

class StockAddQueryDialog extends StatefulWidget {
  final String warningMessage;
  const StockAddQueryDialog({super.key, required this.warningMessage});

  @override
  State<StockAddQueryDialog> createState() => _StockAddQueryDialogState();
}

class _StockAddQueryDialogState extends State<StockAddQueryDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 10),
      content: SingleChildScrollView(
          child: Column(
        children: [
          Text(widget.warningMessage),
        ],
      )),
      actions: [
        Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                    'Proceed',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context, false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: const Color(0xFF15181F),
    );
  }
}
