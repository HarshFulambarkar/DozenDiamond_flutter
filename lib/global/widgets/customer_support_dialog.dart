
import 'dart:io';

import 'package:dozen_diamond/Settings/stateManagement/setting_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/my_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomerSupportDialog extends StatefulWidget {
  const CustomerSupportDialog({super.key});

  @override
  State<CustomerSupportDialog> createState() => _CustomerSupportDialogState();
}

class _CustomerSupportDialogState extends State<CustomerSupportDialog> {
  late SettingProvider settingProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    settingProvider = Provider.of<SettingProvider>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    double screenWidth = screenWidthRecognizer(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: screenWidth - 25,
        padding: const EdgeInsets.only(bottom: 5),
        // width: double.infinity,
        decoration: BoxDecoration(
          color: themeProvider.defaultTheme ? Colors.white : Color(0xFF15181F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white54),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: const Text(
                    "Contact Customer Support",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Consumer<SettingProvider>(
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      (value.bugImage != null)
                          ? Container()
                          : InkWell(
                        onTap: () async {
                          final result = await FilePicker.platform
                              .pickFiles(
                            type: FileType.any,
                            allowMultiple: false,
                            withData: true,
                          );

                          if (result != null && result.files.isNotEmpty) {
                            final pickedFile = result.files.first;
                            final extension =
                                pickedFile.extension?.toLowerCase() ?? '';

                            print("Extension: $extension");

                            final int fileSize = pickedFile.size;

                            if (fileSize > 10 * 1024 * 1024) {
                              Fluttertoast.showToast(
                                msg: 'File size must be less than 10 MB',
                              );
                              return;
                            }

                            if (kIsWeb) {
                              if (pickedFile.bytes != null) {
                                value.bugImage = pickedFile;
                              }
                            } else {
                              if (pickedFile.path != null) {
                                value.bugImage = File(pickedFile.path!);
                              }
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'File selected: ${pickedFile.name}',
                                ),
                              ),
                            );
                          } else {
                            print("File picker canceled");
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.attach_file, size: 20),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Add Attachment",
                                overflow: TextOverflow.fade,
                                textScaleFactor: 0.9,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (value.bugImage != null)
                          ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              "File Uploaded",
                              textScaleFactor: 0.9,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (kIsWeb)
                                      ? "1 file uploaded"
                                      : "${value.bugImage.path.split('/').last}",
                                  textScaleFactor: 0.9,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: (themeProvider.defaultTheme)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        value.bugImage = null;
                                      },
                                      child: Icon(Icons.delete, size: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          : Container(),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: themeProvider.defaultTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 45,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Consumer<SettingProvider>(
                      builder: (context, value, child) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            padding: EdgeInsets.zero,
                            isExpanded: true,
                            iconSize: 24.0,
                            hint: Text(
                              value.selectedContactSupportCategory,
                              style: TextStyle(
                                color: (themeProvider.defaultTheme)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            value: value.selectedContactSupportCategory,
                            onChanged: (valuee) {
                              setState(() {
                                value.selectedContactSupportCategory =
                                    valuee ?? "";
                              });
                            },
                            dropdownColor: themeProvider.defaultTheme
                                ? Colors.white
                                : Colors.black,
                            items:
                            [
                              "Select Category",
                              "Ladder Creation",
                              "Orders",
                              "Analytics",
                              "Watchlist",
                              "Report a Bug",
                              "Feedback",
                              "Suggestion",
                            ]
                                .map(
                                  (String? option) =>
                                  DropdownMenuItem<String>(
                                    child: Text(option!),
                                    value: option,
                                  ),
                            )
                                .toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  MyTextField(
                    isFilled: true,
                    fillColor: (themeProvider.defaultTheme)
                        ? Color(0xffCACAD3)
                        : Color(0xff2c2c31),
                    borderColor: (themeProvider.defaultTheme)
                        ? Color(0xffCACAD3)
                        : Color(0xff2c2c31),
                    elevation: 0,
                    isLabelEnabled: false,
                    controller: settingProvider.subjectTextEditingController,
                    borderWidth: 1,
                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    borderRadius: 5,
                    labelText: "Subject",
                    maxLine: 1,
                    focusedBorderColor: Colors.white,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 5),
                  MyTextField(
                    controller: settingProvider.messageTextEditingController,
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
                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    borderRadius: 5,
                    labelText: "Message",
                    maxLine: 5,
                    focusedBorderColor: Colors.white,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
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
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
                        if (settingProvider.subjectTextEditingController.text !=
                            "" &&
                            settingProvider.messageTextEditingController.text !=
                                "") {
                          print("Sending info");
                          
                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                          
                          final value = await settingProvider
                              .sendContactSupportMain(
                            settingProvider
                                .subjectTextEditingController
                                .text,
                            settingProvider
                                .messageTextEditingController
                                .text,
                          );
                          
                          // Close the loading dialog
                          Navigator.pop(context);
                          
                          print(value);
                          
                          if (value == "true") {
                            // Close the main dialog FIRST
                            Navigator.pop(context);
                            
                            // THEN show SnackBar using the main scaffold context
                            // Option 1: Use a global key or get the main scaffold context
                            // Option 2: Use Fluttertoast which works better with dialogs
                            Fluttertoast.showToast(
                              msg: "Mail sent successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                            
                            // Clear the text fields after successful send
                            settingProvider.subjectTextEditingController.clear();
                            settingProvider.messageTextEditingController.clear();
                            settingProvider.bugImage = null;
                          } else {
                            // Close the main dialog
                            Navigator.pop(context);
                            
                            // Show error message
                            Fluttertoast.showToast(
                              msg: value,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please enter subject and message",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        }
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
  }
}





// import 'dart:io';

// import 'package:dozen_diamond/Settings/stateManagement/setting_provider.dart';
// import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
// import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
// import 'package:dozen_diamond/global/widgets/my_text_field.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class CustomerSupportDialog extends StatefulWidget {
//   const CustomerSupportDialog({super.key});

//   @override
//   State<CustomerSupportDialog> createState() => _CustomerSupportDialogState();
// }

// class _CustomerSupportDialogState extends State<CustomerSupportDialog> {
//   late SettingProvider settingProvider;
//   late ThemeProvider themeProvider;

//   @override
//   Widget build(BuildContext context) {
//     settingProvider = Provider.of<SettingProvider>(context, listen: false);
//     themeProvider = Provider.of<ThemeProvider>(context, listen: false);

//     double screenWidth = screenWidthRecognizer(context);
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         width: screenWidth - 25,
//         padding: const EdgeInsets.only(bottom: 5),
//         // width: double.infinity,
//         decoration: BoxDecoration(
//           color: themeProvider.defaultTheme ? Colors.white : Color(0xFF15181F),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white54),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(
//                     vertical: 20,
//                     horizontal: 10,
//                   ),
//                   child: const Text(
//                     "Contact Customer Support",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//             Consumer<SettingProvider>(
//               builder: (context, value, child) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       (value.bugImage != null)
//                           ? Container()
//                           : InkWell(
//                         onTap: () async {
//                           //   final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 10);
//                           //
//                           //   print(image!.path.split(".").last);
//                           //   if(image!.path.split(".").last == "png" || image.path.split(".").last == "PNG" || image.path.split(".").last == "jpeg" || image.path.split(".").last == "jpg"){
//                           //     // verificationController.droneImage1.value = File(image.path);
//                           //     value.bugImage = File(image.path);
//                           //
//                           //   }else{
//                           //     ScaffoldMessenger.of(context).showSnackBar(
//                           //       SnackBar(content: Text('Invalid Image format')),
//                           //     );
//                           //   }

//                           final result = await FilePicker.platform
//                               .pickFiles(
//                             type: FileType.any,
//                             allowMultiple: false,
//                             withData: true, // <-- important for web
//                           );

//                           if (result != null && result.files.isNotEmpty) {
//                             final pickedFile = result.files.first;
//                             final extension =
//                                 pickedFile.extension?.toLowerCase() ?? '';

//                             print("Extension: $extension");

//                             final int fileSize = pickedFile.size;

//                             if (fileSize > 10 * 1024 * 1024) {
//                               Fluttertoast.showToast(
//                                 msg: 'File size must be less than 10 MB',
//                               );

//                               return;
//                             }

//                             if (kIsWeb) {
//                               // WEB: Use bytes
//                               if (pickedFile.bytes != null) {
//                                 value.bugImage = pickedFile;
//                               }
//                             } else {
//                               // MOBILE / DESKTOP: Use File(path)
//                               if (pickedFile.path != null) {
//                                 value.bugImage = File(pickedFile.path!);
//                               }
//                             }

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   'File selected: ${pickedFile.name}',
//                                 ),
//                               ),
//                             );
//                           } else {
//                             print("File picker canceled");
//                           }
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.attach_file, size: 20),

//                             // Image.asset(
//                             //   AssetConstants.attacheIconImage,
//                             //   height: 20,
//                             //   width: 20,
//                             // ),
//                             SizedBox(width: 5),

//                             Expanded(
//                               child: Text(
//                                 "Add Attachment",
//                                 overflow: TextOverflow.fade,
//                                 textScaleFactor: 0.9,
//                                 style: GoogleFonts.inter(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       (value.bugImage != null)
//                           ? Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 5),

//                             Text(
//                               "File Uploaded",
//                               textScaleFactor: 0.9,
//                               style: GoogleFonts.inter(
//                                 fontSize: 14,
//                                 color: (themeProvider.defaultTheme)
//                                     ? Colors.black
//                                     : Colors.white,
//                               ),
//                             ),

//                             SizedBox(height: 4),

//                             Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   (kIsWeb)
//                                       ? "1 file uploaded"
//                                       : "${value.bugImage.path.split('/').last}",
//                                   textScaleFactor: 0.9,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.inter(
//                                     fontSize: 10,
//                                     color: (themeProvider.defaultTheme)
//                                         ? Colors.black
//                                         : Colors.white,
//                                   ),
//                                 ),


//                                 Row(
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         // value.bugImage = File("");
//                                         value.bugImage = null;
//                                         // verificationController.droneImages.removeAt(index);
//                                       },
//                                       child: Icon(Icons.delete, size: 16),
//                                       // child: Image.asset(
//                                       //   AssetConstants.deleteIconImage,
//                                       //   height: 16,
//                                       // ),
//                                     ),

//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       )
//                           : Container(),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: themeProvider.defaultTheme
//                             ? Colors.black
//                             : Colors.white,
//                       ),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     height: 45,
//                     margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//                     child: Consumer<SettingProvider>(
//                       builder: (context, value, child) {
//                         return DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             padding: EdgeInsets.zero,
//                             isExpanded: true,
//                             iconSize: 24.0,
//                             hint: Text(
//                               value.selectedContactSupportCategory,
//                               style: TextStyle(
//                                 color: (themeProvider.defaultTheme)
//                                     ? Colors.black
//                                     : Colors.white,
//                               ),
//                             ),
//                             value: value.selectedContactSupportCategory,
//                             onChanged: (valuee) {
//                               setState(() {
//                                 value.selectedContactSupportCategory =
//                                     valuee ?? "";
//                               });
//                             },
//                             dropdownColor: themeProvider.defaultTheme
//                                 ? Colors.white
//                                 : Colors.black,
//                             items:
//                             [
//                               "Select Category",
//                               "Ladder Creation",
//                               "Orders",
//                               "Analytics",
//                               "Watchlist",
//                               "Report a Bug",
//                               "Feedback",
//                               "Suggestion",
//                             ]
//                                 .map(
//                                   (String? option) =>
//                                   DropdownMenuItem<String>(
//                                     child: Text(option!),
//                                     value: option,
//                                   ),
//                             )
//                                 .toList(),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   MyTextField(
//                     isFilled: true,
//                     fillColor: (themeProvider.defaultTheme)
//                         ? Color(0xffCACAD3)
//                         : Color(0xff2c2c31),
//                     borderColor: (themeProvider.defaultTheme)
//                         ? Color(0xffCACAD3)
//                         : Color(0xff2c2c31),
//                     elevation: 0,
//                     isLabelEnabled: false,
//                     controller: settingProvider.subjectTextEditingController,
//                     borderWidth: 1,
//                     // fillColor: Colors.transparent,
//                     contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                     borderRadius: 5,
//                     labelText: "Subject",
//                     maxLine: 1,
//                     // borderColor: Colors.white,
//                     focusedBorderColor: Colors.white,
//                     onChanged: (value) {},
//                   ),
//                   SizedBox(height: 5),
//                   MyTextField(
//                     controller: settingProvider.messageTextEditingController,
//                     isFilled: true,
//                     fillColor: (themeProvider.defaultTheme)
//                         ? Color(0xffCACAD3)
//                         : Color(0xff2c2c31),
//                     borderColor: (themeProvider.defaultTheme)
//                         ? Color(0xffCACAD3)
//                         : Color(0xff2c2c31),
//                     elevation: 0,
//                     isLabelEnabled: false,
//                     borderWidth: 1,
//                     // fillColor: Colors.transparent,
//                     contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                     borderRadius: 5,
//                     labelText: "Message",
//                     maxLine: 5,
//                     // borderColor: Colors.white,
//                     focusedBorderColor: Colors.white,
//                     onChanged: (value) {},
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 12.0, right: 12),
//               child: Row(
//                 children: [
//                   SizedBox(width: 5),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         // if (settingProvider.subjectTextEditingController.text !=
//                         //     "" &&
//                         //     settingProvider.messageTextEditingController.text !=
//                         //         "") {
//                         //   final value =
//                         //   await settingProvider.sendContactSupportMain(
//                         //       settingProvider
//                         //           .subjectTextEditingController.text,
//                         //       settingProvider
//                         //           .messageTextEditingController.text);
//                         //
//                         //   if (value == "true") {
//                         //     Navigator.pop(context);
//                         //     ScaffoldMessenger.of(context).showSnackBar(
//                         //       SnackBar(
//                         //         content: Text("Mail sent successfully"),
//                         //       ),
//                         //     );
//                         //   } else {
//                         //     Navigator.pop(context);
//                         //     ScaffoldMessenger.of(context).showSnackBar(
//                         //       SnackBar(
//                         //         content: Text(value),
//                         //       ),
//                         //     );
//                         //   }
//                         // } else {
//                         //   ScaffoldMessenger.of(context).showSnackBar(
//                         //     SnackBar(
//                         //       content: Text("Please enter subject and message"),
//                         //     ),
//                         //   );
//                         // }

//                         if (settingProvider.subjectTextEditingController.text !=
//                             "" &&
//                             settingProvider.messageTextEditingController.text !=
//                                 "") {
//                           print("Sending info");
//                           final value = await settingProvider
//                               .sendContactSupportMain(
//                             settingProvider
//                                 .subjectTextEditingController
//                                 .text,
//                             settingProvider
//                                 .messageTextEditingController
//                                 .text,
//                           );
//                           print(value);
//                           if (value == "true") {
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("Mail sent successfully")),
//                             );
//                           } else {
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(
//                               context,
//                             ).showSnackBar(SnackBar(content: Text(value)));
//                           }
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("Please enter subject and message"),
//                             ),
//                           );
//                         }
//                       },
//                       child: Text(
//                         'Send',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         side: BorderSide(color: Colors.blue),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }