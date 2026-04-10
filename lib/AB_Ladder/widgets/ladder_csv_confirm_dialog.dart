import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ladder_rest_api_service.dart';

class LadderCsvConfirmDialog extends StatefulWidget {
  const LadderCsvConfirmDialog({super.key});

  @override
  State<LadderCsvConfirmDialog> createState() => _LadderCsvConfirmDialogState();
}

class _LadderCsvConfirmDialogState extends State<LadderCsvConfirmDialog> {
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

  void sendLadderDownloadCsvEmail() {
    LadderRestApiService().userLadderDownloadCsv().then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: value!.message!);
    }).catchError((err) {
      Navigator.pop(context);
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Are you sure you want to download ladder records ?",
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
              "* An email containing a CSV document will be sent to the registered email ID (${email}).",
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
                  sendLadderDownloadCsvEmail();
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
