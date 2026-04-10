import 'package:flutter/material.dart';

import '../models/welcome_screen_data.dart';

class WelcomeScreensProvider extends ChangeNotifier {
  WelcomeScreensProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  List<WelcomeScreenData> _welcomeScreenData = [
    WelcomeScreenData(
      id: 0,
      title: "Enjoy stress-less, Automated Trading",
      imageUrl: "lib/welcome_screens/assets/images/welcome_image_1.png",
      // imageUrl: "https://dozendiamonds.com/app/wellcome_image_1.webp",
    ),
    WelcomeScreenData(
      id: 1,
      title: "Test & Trade with real or simulated mode",
      imageUrl: "lib/welcome_screens/assets/images/welcome_image_2.png",
      // imageUrl: "https://dozendiamonds.com/app/wellcome_image_2.webp",
    ),
    WelcomeScreenData(
      id: 2,
      title: "Enjoy stress-less, Automated Trading",
      imageUrl: "lib/welcome_screens/assets/images/welcome_image_3.png",
      // imageUrl: "https://dozendiamonds.com/app/wellcome_image_3.webp",
    ),
  ];

  List<WelcomeScreenData> get welcomeScreenData => _welcomeScreenData;

  set welcomeScreenData(List<WelcomeScreenData> value) {
    _welcomeScreenData = value;
    notifyListeners();
  }

  PageController pageController = PageController();

  int _selectedPageIndex = 0;

  int get selectedPageIndex => _selectedPageIndex;

  set selectedPageIndex(int value) {
    _selectedPageIndex = value;
    notifyListeners();
  }
}
