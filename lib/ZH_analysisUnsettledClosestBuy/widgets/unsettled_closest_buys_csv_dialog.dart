import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../ZH_analysisPriceVsNumberOfStocks/stateManagement/analyticsDateProvider.dart';
import '../models/unsettled_closest_buy_csv_request.dart';
import '../services/analysis_unsettled_closest_buy_rest_api_service.dart';

class UnsettledClosestBuysCsvDialog extends StatefulWidget {
  final String? stockName;
  UnsettledClosestBuysCsvDialog({super.key, required this.stockName});

  @override
  State<UnsettledClosestBuysCsvDialog> createState() =>
      _UnsettledClosestBuysCsvDialogState();
}

class _UnsettledClosestBuysCsvDialogState
    extends State<UnsettledClosestBuysCsvDialog> {

  DateTimeProvider? _dateTimeState;

  @override
  void initState() {
    // TODO: implement initState

    _dateTimeState = Provider.of<DateTimeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Are you sure you want to download closest unsettled buys records in CSV for ${widget.stockName} ?",
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
                  AnalysisUnsettledClosestBuyRestApiService()
                      .unsettledClosestBuysCsvRequest(
                          UnsettledClosestBuyCsvRequest(
                              startDate: DateFormat('yyyy-MM-dd')
                                  .format(_dateTimeState!.startFullDate),
                              endDate:
                              DateFormat('yyyy-MM-dd').format(_dateTimeState!.endFullDate),
                              stockName: widget.stockName))
                      .then((value) {
                    Fluttertoast.showToast(msg: value.msg!);
                  }).catchError((err) {
                    print(
                        "error in the build widget of unsettled closest buy $err}");
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
