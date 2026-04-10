import 'package:dozen_diamond/download/services/download_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadCsvDialog extends StatefulWidget {
  final String csvType;
  final String stockName;
  final String? ladId;
  const DownloadCsvDialog({
    super.key,
    required this.csvType,
    required this.stockName,
    this.ladId,
  });

  @override
  State<DownloadCsvDialog> createState() => _DownloadCsvDialogState();
}

class _DownloadCsvDialogState extends State<DownloadCsvDialog> {
  @override
  void initState() {
    super.initState();

    getUserEmail();
  }

  String email = "-";

  getUserEmail() async {
    print("inside getUserEmail");
    final pref = await SharedPreferences.getInstance();

    setState(() {
      email = pref.getString("reg_user_email") ?? "-";
    });
  }

  void handleCsvDownload(Future<dynamic> Function() apiCall) {
    apiCall()
        .then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: value.message ?? "Email sent!");
    })
        .catchError((err) {
      print(err);
      Fluttertoast.showToast(msg: "Something went wrong!");
    });
  }

  void sendDownloadCsvEmail() {
    switch (widget.csvType) {
      case 'userLadderDownload':
        handleCsvDownload(
              () => DownloadRestApiService().userLadderDownloadCsv(),
        );
        break;

      case 'userPositonDownload':
        handleCsvDownload(
              () => DownloadRestApiService().userPositonDownloadCsv(),
        );
        break;
      case 'userOrderDownload':
        handleCsvDownload(
              () => DownloadRestApiService().userOrderDownloadCsv(),
        );
        break;
      case 'userLadderExecutedOrderDownload':
        Map<String, dynamic> data = {
          "lad_id": widget.ladId ?? "",
          "stock_name": widget.stockName,
        };
        handleCsvDownload(
              () =>
              DownloadRestApiService().userLadderExecutedOrderDownloadCsv(data),
        );

      case 'userLadderAllOrderDownload':
        Map<String, dynamic> data = {
          "lad_id": widget.ladId ?? "",
          "stock_name": widget.stockName,
        };
        handleCsvDownload(
              () => DownloadRestApiService().userLadderAllOrderDownloadCsv(data),
        );
        break;
    }
  }

  Map<String, String> csvTypeToTitle = {
    'userLadderExecutedOrderDownload': 'Ladder Executed Order',
    'userLadderAllOrderDownload': 'All Order',
    'userLadderDownload': 'Ladder',
    'userTradeDownloadCsv': 'Trade',
    'userOrderDownload': 'Order',
    'userPositonDownload': 'Positon',
  };
  String titleText() {
    return csvTypeToTitle[widget.csvType] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Are you sure you want to download ${titleText()} records?",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "* An email containing a CSV document will be sent to the registered email ID (${email}).",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            SizedBox(width: 5),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  sendDownloadCsvEmail();
                },
                child: Text('OK', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(width: 10),
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
            SizedBox(width: 5),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: const BorderSide(color: Colors.white, width: 1),
      ),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: const Color(0xFF15181F),
    );
  }
}