import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'custom_container_gradients.dart';

class CustomBottomSheets {

  static Future<T?> showBottomSheetWithHeightWithoutClose<T>(
      Widget child, BuildContext context, {double? height, bool? isDismissible, bool? enableDrag}) {
    Completer<T?> completer = Completer<T?>();

    showCustomModalBottomSheet(
      isDismissible: isDismissible ?? true,
      expand: false,
      bounce: true,
      context: context,
      enableDrag: enableDrag ?? true,
      duration: const Duration(milliseconds: 500),
      containerWidget: (context, animation, child) {
        return child;
      },

      shape: const RoundedRectangleBorder(// <-- SEE HERE

        borderRadius: BorderRadius.vertical(

          top: Radius.circular(20.0),
        ),
      ),
      backgroundColor: Colors.transparent, // Color(0xFF15181F),
      builder: (BuildContext context) {
        final MediaQueryData mediaQueryData = MediaQuery.of(context);
        return Padding(
          // padding: EdgeInsets.only(
              // bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: mediaQueryData.viewInsets,
          child: Container(
            height: height ?? MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.transparent, //Color(0xFF15181F),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent, //Color(0xFF15181F),
              resizeToAvoidBottomInset: false,
              body: Container(
                  height: height ?? MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.transparent, //Color(0xFF15181F),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 25,
                        color: Colors.transparent, //Color(0xFF15181F),
                      ),

                      Expanded(
                        flex: 1,
                        child: CustomContainerGradients(
                          borderBottomLeftRadius: 0,
                          borderTopLeftRadius: 20,
                          borderTopRightRadius: 20,
                          borderBottomRightRadius: 0,
                          backgroundColor: Colors.transparent, //Color(0xFF15181F),
                          borderColor: Colors.transparent, // Color(0xFF15181F),
                          padding: 0,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Align(
                            child: child,
                            alignment: Alignment.bottomCenter,
                          ),
                          // height:
                          //     MediaQuery.of(context).size.height * 0.8,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    ).then((value) {
      completer.complete(value);
    });

    return completer.future;
  }

}