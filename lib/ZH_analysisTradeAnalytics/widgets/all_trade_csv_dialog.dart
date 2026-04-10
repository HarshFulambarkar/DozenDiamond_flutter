
import '../../ZH_analysisTradeAnalytics/models/all_trade_analytics_csv_request.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/analysis_trade_analytics_rest_api_service.dart';

class AllTradeCsvDialog extends StatefulWidget {
  final String? stockName;
  final int? duration;
  const AllTradeCsvDialog(
      {super.key, required this.stockName, required this.duration});

  @override
  State<AllTradeCsvDialog> createState() => _AllTradeCsvDialogState();
}

class _AllTradeCsvDialogState extends State<AllTradeCsvDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Are you sure you want to download All trade records in CSV for ${widget.stockName} ?",
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
                  AnalysisTradeAnalyticsRestApiService()
                      .allTradeAnalyticsCsv(AllTradeAnalyticsCsvRequest(
                          stockName: widget.stockName, month: widget.duration))
                      .then((value) {
                    Fluttertoast.showToast(msg: value!.msg!);
                  }).catchError((err) {
                    print("Error in the build widget of all trade csv $err");
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
