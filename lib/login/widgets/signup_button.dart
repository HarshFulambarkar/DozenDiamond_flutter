import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dozen_diamond/navigateAuthentication/stateManagement/navigate_authentication_provider.dart';

import '../../login/constants/loginStyleConstants.dart';

class SignUpButton extends StatelessWidget {
  double sizeOfButton;
  SignUpButton({
    Key? key,
    required this.sizeOfButton,
    required this.buttonText,
  }) : super(key: key);

  final String buttonText;

  late NavigateAuthenticationProvider navigateAuthenticationProvider;

  @override
  Widget build(BuildContext context) {
    // Accessing provider with listen set to false as we don't want the whole button
    // to rebuild if the provider changes, just the onPressed callback should depend on it.
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);

    return Container(
      width: MediaQuery.of(context).size.width * sizeOfButton!,
      decoration: BoxDecoration(
        color: Colors.transparent,
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
        onPressed: () {
          navigateAuthenticationProvider.previousIndex =
              navigateAuthenticationProvider.selectedIndex;
          navigateAuthenticationProvider.selectedIndex = 0;
          // RegisterCommonScreen();
          // // Navigate to the SignUpPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const SignUpPage(),
          //   ),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            buttonText,
            style: kBodyTextBig,
          ),
        ),
      ),
    );
  }
}
