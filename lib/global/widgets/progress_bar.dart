import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../stateManagement/progress_provider.dart';

class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double progress = context.watch<ProgressProvider>().progress;
    double screenWidth = screenWidthRecognizer(context);

    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            // width: MediaQuery.of(context).size.width * progress,
            width: screenWidth * progress,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
