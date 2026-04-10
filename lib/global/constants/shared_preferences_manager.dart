import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  static const String USER_ACCESS_TOKEN = "USER_ACCESS_TOKEN";

  static const String LADDER_CREATION_TYPE = "LADDER_CREATION_TYPE";
  static const String FIRST_TIME_IN_APP = "FIRST_TIME_IN_APP";

  static const String FIRST_TIME_ON_LADDER_PAGE = "FIRST_TIME_ON_LADDER_PAGE";
  static const String IS_LADDER_INTRO_DONE = "IS_LADDER_INTRO_DONE";

  static const String FCM_TOKEN = "FCM_TOKEN";

  static const String IS_SUPER = "IS_SUPER";

  static const String REMINDER_TIME = "REMINDER_TIME";
  static const String REMINDER_MESSAGE = "REMINDER_MESSAGE";

  static Future<void> saveUserAccessToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_ACCESS_TOKEN, value);
  }

  static Future<String?> getUserAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_ACCESS_TOKEN);
  }

  static Future<void> saveReminderTime(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(REMINDER_TIME, value);
  }

  static Future<String?> getReminderTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(REMINDER_TIME);
  }

  static Future<void> saveReminderMessage(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(REMINDER_MESSAGE, value);
  }

  static Future<String?> getReminderMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(REMINDER_MESSAGE);
  }

  static Future<void> saveLadderCreationType(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LADDER_CREATION_TYPE, value);
  }

  static Future<String?> getLadderCreationType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LADDER_CREATION_TYPE);
  }

  static Future<String?> getCountryCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isCountryUsa') ?? false ? "\$" : "₹";
  }

  static Future<void> saveIsFirstTimeInApp(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(FIRST_TIME_IN_APP, value);
  }

  static Future<bool?> getIsFirstTimeInApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(FIRST_TIME_IN_APP);
  }

  static Future<void> saveIsFirstTimeOnLadderPage(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(FIRST_TIME_ON_LADDER_PAGE, value);
  }

  static Future<bool?> getIsFirstTimeOnLadderPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(FIRST_TIME_ON_LADDER_PAGE);
  }

  static Future<void> saveIsLadderIntroDone(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_LADDER_INTRO_DONE, value);
  }

  static Future<bool?> getIsLadderIntroDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_LADDER_INTRO_DONE);
  }

  static Future<void> saveFCMToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FCM_TOKEN, value);
  }

  static Future<String?> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(FCM_TOKEN);
  }

  static Future<void> saveIsSuper(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_SUPER, value);
  }

  static Future<bool?> getIsSuper() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_SUPER);
  }

}
