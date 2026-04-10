import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer_new.dart';
import 'package:dozen_diamond/create_ladder_easy/widgets/custom_container.dart';
import 'package:dozen_diamond/global/functions/utils.dart';
import 'package:dozen_diamond/global/widgets/my_text_field.dart';
import 'package:dozen_diamond/reminders/models/reminder_data.dart';
import 'package:dozen_diamond/reminders/services/reminder_service.dart';
import 'package:dozen_diamond/reminders/stateManagement/reminder_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';

class ReminderScreen extends StatefulWidget {
  final Function updateIndex;
  const ReminderScreen({super.key, required this.updateIndex});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  late ThemeProvider themeProvider;
  late ReminderProvider reminderProvider;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderProvider>().getReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);

    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    reminderProvider = Provider.of<ReminderProvider>(context, listen: true);
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
                      child:  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Reminders",
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
                                    onTap: () async {
                                      await showReminderDialog(
                                        context,null,
                                      );
                                      await reminderProvider.getReminders();
                                    },
                                    child: Text(
                                      "Create",
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
                            Expanded(
                              child: reminderProvider.isGettingReminders
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : reminderProvider.reminderList.isEmpty
                                  ? Center(child: Text("No Reminders"))
                                  : ListView.builder(
                                      itemCount:
                                          reminderProvider.reminderList.length,
                                      itemBuilder: (context, index) {
                                        return reminderCard(
                                          reminderProvider.reminderList[index],
                                          context,
                                        );
                                      },
                                    ),
                            ),
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
                        DateFormat('dd/MM/yyyy hh:mm a').format(
                          DateTime.tryParse(
                            reminder.scheduledTime ?? "",
                          )!.toLocal(),
                        ),

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
                onPressed: () async {
                  await showReminderDialog(context, reminder);
                  await reminderProvider.getReminders();
                },
                icon: Icon(
                  Icons.edit,
                  color: (themeProvider.defaultTheme)
                      ? Color(0xff141414)
                      : Color(0xfff0f0f0),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await deleteReminderDialog(context, reminder);
                  await reminderProvider.getReminders();
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showReminderDialog(BuildContext context, ReminderData? reminder) {
  double screenWidth = screenWidthRecognizer(context);
  ThemeProvider themeProvider = Provider.of<ThemeProvider>(
    context,
    listen: false,
  );
  ReminderProvider reminderProvider = Provider.of<ReminderProvider>(
    context,
    listen: false,
  );
  bool isEditing = reminder != null;
  final TextEditingController messageController = TextEditingController(
    text: isEditing ? reminder.message ?? "" : "",
  );

  DateTime dateTime = isEditing
      ? DateTime.parse(reminder.scheduledTime!).toLocal()
      : DateTime.now();

  String message = isEditing ? reminder.message ?? "" : "";
  bool showDateTime = isEditing ? true : false;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: screenWidth - 40,
              padding: const EdgeInsets.only(bottom: 5),
              // width: double.infinity,
              decoration: BoxDecoration(
                color: themeProvider.defaultTheme
                    ? Colors.white
                    : Color(
                        0xFF15181F,
                      ), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white54),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 20,
                          top: 10,
                        ),
                        // margin: const EdgeInsets.symmetric(
                        //   vertical: 20,
                        //   horizontal: 10,
                        // ),
                        child: const Text(
                          "Set Reminder",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  TextButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), // Default date to today
                        firstDate:
                            DateTime.now(), // You can set a minimum date if needed
                        lastDate: DateTime.now().add(
                          Duration(days: 365),
                        ), // Maximum date (365 days from now)
                      ); // Use current date if nothing is selected

                      if (pickedDate != null && pickedDate != dateTime) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            pickedDate,
                          ), // Default time set to the selected date's time
                        ); // Default to current time if the user cancels

                        if (pickedTime != null) {
                          // Combine both the date and time into a single DateTime object
                          final DateTime selectedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          // Update the UI with the selected DateTime
                          setState(() {
                            dateTime = selectedDateTime;
                            showDateTime = true;
                          });
                        }
                      }
                    },
                    child: Text(
                      (showDateTime)
                          ? "${DateFormat("dd-MM-yyyy hh:mm a").format(dateTime)}"
                          : 'show date time picker',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyTextField(
                          controller: messageController,
                          isFilled: true,
                          fillColor: (themeProvider.defaultTheme)
                              ? Color(0xffCACAD3)
                              : Color(0xff2c2c31),
                          borderColor: (themeProvider.defaultTheme)
                              ? Color(0xffCACAD3)
                              : Color(0xff2c2c31),
                          elevation: 0,
                          isLabelEnabled: false,
                          borderWidth: 1,
                          // fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.fromLTRB(
                            10,
                            10,
                            10,
                            10,
                          ),
                          borderRadius: 5,
                          labelText: "",
                          maxLine: 5,
                          // borderColor: Colors.white,
                          focusedBorderColor: Colors.white,
                          onChanged: (value) {
                            message = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12,
                      bottom: 10,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              isEditing
                                  ? reminderProvider.updateReminder(
                                      reminder.id!,
                                      dateTime,
                                      messageController.text,
                                    )
                                  : ReminderService().saveReminderDateTime(
                                      dateTime,
                                      messageController.text,
                                    );
                              Navigator.pop(context);
                            },
                            child: Text(
                              isEditing ? "Update" : 'Set',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> deleteReminderDialog(BuildContext context, ReminderData reminder) {
  ReminderProvider reminderProvider = Provider.of<ReminderProvider>(
    context,
    listen: false,
  );
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setStateSB) {
          return AlertDialog(
            title: Text(
              'Delete reminder?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),

            actions: [
              Row(
                children: [
                  SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        reminderProvider.deleteReminder(reminder.id!);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Proceed',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.blue),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
            actionsAlignment: MainAxisAlignment.center,
            backgroundColor: const Color(0xFF15181F),
          );
        },
      );
    },
  );
}
