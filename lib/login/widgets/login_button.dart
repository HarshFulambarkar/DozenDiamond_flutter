import 'package:flutter/material.dart';

import '../../global/constants/custom_colors_light.dart';

class LoginButton extends StatelessWidget {
  final int? bottomNavigatonIndex;
  final double? sizeOfButton;
  const LoginButton({
    Key? key,
    required this.sizeOfButton,
    required this.buttonText,
    required this.bottomNavigatonIndex,
    this.fun,
  }) : super(key: key);

  final String buttonText;
  final Function? fun;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * sizeOfButton!,
      decoration: BoxDecoration(
        color: const Color(0xFF0099CC),
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          side: const BorderSide(
            color: Color(0xFF0099CC),
          ),
        ),
        onPressed: (() {
          if (fun == null) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const BottomNavigationbar(
            //       bottomNavigatonIndex: 2,
            //     ),
            //   ),
            // );
          } else {
            fun!();
          }
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            buttonText,
            style: kBodyTextbig,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
