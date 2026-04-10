import 'package:flutter/material.dart';

import '../../global/constants/constants.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: const Alignment(0, -0.1),
          colors: [
            kBackgroundColor,
            kBackgroundColor.withOpacity(0),
          ],
        ),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: const AssetImage('lib/global/assets/images/home_bg1.png'),
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
        ),
      ),
    );
  }
}
