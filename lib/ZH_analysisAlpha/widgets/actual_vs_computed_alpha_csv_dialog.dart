
import '../../ZH_analysisAlpha/models/actual_vs_computed_alpha_csv_request.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/analysis_alpha_rest_api_service.dart';

class ActualVsComputedAlphaCsvDialog extends StatefulWidget {
  final String? stockName;
  ActualVsComputedAlphaCsvDialog({super.key, this.stockName});

  @override
  State<ActualVsComputedAlphaCsvDialog> createState() =>
      _ActualVsComputedAlphaCsvDialogState();
}

class _ActualVsComputedAlphaCsvDialogState
    extends State<ActualVsComputedAlphaCsvDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Are you sure you want to download actual vs computed alpha records in CSV for ${widget.stockName} ?",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "* An email containing a CSV document will be sent to the registered email ID.",
              style: TextStyle(color: Colors.greenAccent),
            )
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  AnalysisAlphaRestApiService()
                      .actualVsComputedAlphaCsv(ActualVsComputedAlphaCsvRequest(
                          month: 100, stockName: widget.stockName))
                      .then((value) {
                    Fluttertoast.showToast(msg: value!.msg!);
                  }).catchError((err) {
                    print(err);
                  });
                },
                child: Text('OK', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(fontSize: 18)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue),
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
