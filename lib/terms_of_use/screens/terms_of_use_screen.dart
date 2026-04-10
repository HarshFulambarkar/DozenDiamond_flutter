import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:pdfrx/pdfrx.dart';

class TermsOfUseScreen extends StatelessWidget {
  final VoidCallback onAgree;

  TermsOfUseScreen({required this.onAgree});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Terms of Use")),
      body: Column(
        children: [
          // Expanded(
          //   // child: PdfViewer.uri(
          //   //   Uri.parse('https://opensource.adobe.com/dc-acrobat-sdk-docs/pdfstandards/PDF32000_2008.pdf'),
          //   // ),
          //   child: PdfViewer.asset(
          //       'lib/terms_of_use/assets/terms_of_use.pdf',
          //   ),
          //   // child: SfPdfViewer.asset('lib/terms_of_use/assets/terms_of_use.pdf'), // Place your PDF in assets
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text(
                  "I Agree",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasAgreedToTerms', true);
                onAgree();
              },
            ),
          ),
        ],
      ),
    );
  }
}
