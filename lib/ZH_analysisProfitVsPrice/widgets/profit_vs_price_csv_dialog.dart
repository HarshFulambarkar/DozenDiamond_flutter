
import '../../ZH_analysisProfitVsPrice/models/profit_vs_price_analytics_csv_request.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/analysis_profit_vs_price_rest_api_service.dart';

class ProfitVsPriceCsvDialog extends StatefulWidget {
  final String? stockName;
  final int? duration;
  final String? startDate;
  final String? endDate;
  final String? graphType;
  const ProfitVsPriceCsvDialog(
      {super.key,
        required this.stockName,
        required this.duration,
        required this.startDate,
        required this.endDate,
        required this.graphType,
      });

  @override
  State<ProfitVsPriceCsvDialog> createState() => _ProfitVsPriceCsvDialogState();
}

class _ProfitVsPriceCsvDialogState extends State<ProfitVsPriceCsvDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        // "Are you sure you want to download Profit vs Price records in CSV for ${widget.stockName} ?",
        "Are you sure you want to download ${widget.graphType} records in CSV for ${widget.stockName} ?",
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
                  print("clicked here");
                  Navigator.pop(context);
                  Map<String, dynamic> data = {
                    "stock_name": widget.stockName,
                    'startDate': widget.startDate,
                    'endDate' : widget.endDate,
                  };
                  AnalysisProfitVsPriceRestApiService()
                      .profitVsPriceAnalyticsCsv(widget.graphType ?? "",
                      data
                          // ProfitVsPriceAnalyticsCsvRequest(
                          //     stockName: widget.stockName,
                          //     month: widget.duration)
                  )
                      .then((value) {
                    Fluttertoast.showToast(msg: value!.message!);
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
