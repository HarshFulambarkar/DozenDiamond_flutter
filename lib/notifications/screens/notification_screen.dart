import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer_new.dart';
import 'package:dozen_diamond/create_ladder_easy/widgets/custom_container.dart';
import 'package:dozen_diamond/global/functions/utils.dart';
import 'package:dozen_diamond/reminders/models/reminder_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../stateManagement/notification_screen_provider.dart';

class NotificationScreen extends StatefulWidget {
  final Function updateIndex;
  const NotificationScreen({super.key, required this.updateIndex});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ThemeProvider themeProvider;
  late NotificationScreenProvider notificationScreenProvider;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);

    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    notificationScreenProvider = Provider.of<NotificationScreenProvider>(context, listen: true);
    return Center(
      child: Container(
        width: screenWidth,
        child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: false,

          drawer: NavDrawerNew(updateIndex: widget.updateIndex),
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    color: (themeProvider.defaultTheme)
                        ? Color(0XFFF5F5F5)
                        : Colors.transparent,
                    height: MediaQuery.of(context).size.height,
                    width: screenWidth,
                  ),
                ),
                Padding(
                  // padding: const EdgeInsets.only(top: 60.0),
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Center(
                    child: Container(
                      color: (themeProvider.defaultTheme)
                          ? Color(0XFFF5F5F5)
                          : Colors.transparent,
                      width: screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Notifications",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Britanica',
                                    color: (themeProvider.defaultTheme)
                                        ? Color(0xff141414)
                                        : Color(0xFFffffff),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {},
                                  child: Text(
                                    "Clear",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'Britanica',
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),

                          // if (reminderProvider.isGettingReminders)
                          //   Center(
                          //     child: CircularProgressIndicator(
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // if (!reminderProvider.isGettingReminders)
                          //   ...(reminderProvider.reminderList.isNotEmpty)
                          //       ? reminderProvider.reminderList
                          //             .map(
                          //               (reminder) =>
                          //                   reminderCard(reminder, context),
                          //             )
                          //             .toList()
                          //       :
                          Center(child: Text("No notifications")),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomHomeAppBarWithProviderNew(
                  backButton: false,
                  leadingAction: _triggerDrawer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget reminderCard(ReminderData reminder, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12.0, bottom: 0),
      child: CustomContainer(
        borderRadius: 15,
        // backgroundColor: Color(0xff28282a),
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0xffdadde6)
            : Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  // width: screenWidthRecognizer(context) * 0.63,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${reminder.message ?? "-"}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff141414)
                              : Color(0xfff0f0f0),
                          fontSize: 16,

                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${Utility().formatUtcToLocal(reminder.scheduledTime) ?? "-"}',
                        style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff141414)
                              : Color(0xffa2b0bc), //Color(0xff545455),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          // Optional: limits the text to 2 lines
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              IconButton(
                onPressed: () async {},
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}