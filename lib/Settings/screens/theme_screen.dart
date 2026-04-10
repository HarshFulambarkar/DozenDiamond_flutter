import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

// List<int> ThemeChanger = [1,2];

class _ThemeScreenState extends State<ThemeScreen> {
  TextStyle checkerFont =
      TextStyle(fontSize: 20); // int themeChanger = ThemeChanger[0];
  ThemeProvider? _themeProvider;

  void initState() {
    super.initState();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              // padding: const EdgeInsets.only(top: 60.0),
              padding: const EdgeInsets.only(top: 45.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header(),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                    child: const Text(
                      "Select your Theme",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Default", style: checkerFont),
                        Consumer<ThemeProvider>(
                            builder: (context, value, child) {
                          return Radio<ThemeController>(
                              value: ThemeController.Dark,
                              groupValue: value.themeController,
                              onChanged: (value) {
                                _themeProvider?.themeController = value!;

                                _themeProvider?.defaultTheme = false;
                              });
                        }),
                        // Checkbox(
                        //     side: MaterialStateBorderSide.resolveWith(
                        //       (states) => BorderSide(
                        //           width: 2.0,
                        //           color: value.defaultTheme
                        //               ? Colors.black54
                        //               : Colors.white),
                        //     ),
                        //     activeColor: Color(0xFF15181F),
                        //     fillColor:
                        //         MaterialStateProperty.all(Colors.white),
                        //     shape: const CircleBorder(),
                        //     value: !value.defaultTheme,
                        //     onChanged: (bool? newValue) {
                        //       value.defaultTheme = !newValue!;
                        //     })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Light", style: TextStyle(fontSize: 20)),
                        Consumer<ThemeProvider>(
                            builder: (context, value, child) {
                          return Radio<ThemeController>(
                              value: ThemeController.Light,
                              groupValue: value.themeController,
                              onChanged: (value) {
                                _themeProvider?.themeController = value!;

                                _themeProvider?.defaultTheme = true;
                              });
                        }),
                        // Checkbox(
                        //     side: MaterialStateBorderSide.resolveWith(
                        //       (states) => BorderSide(
                        //           width: 2.0,
                        //           color: value.defaultTheme
                        //               ? Colors.black54
                        //               : Colors.white),
                        //     ),
                        //     activeColor: Colors.white,
                        //     checkColor: Colors.black,
                        //     fillColor:
                        //         MaterialStateProperty.all(Colors.black),
                        //     shape: const CircleBorder(),
                        //     value: value.defaultTheme,
                        //     onChanged: (bool? newValue) {
                        //       value.defaultTheme = newValue!;
                        //     })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomHomeAppBarWithProviderNew(backButton: true),
          ],
        ),
      ),
    );
  }
}
