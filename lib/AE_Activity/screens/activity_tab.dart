import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/AE_Activity/stateManagement/activity_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/info_icon_display.dart';
import '../../global/widgets/shimmer_loading_view.dart';
import '../models/get_new_user_activity_response.dart';

class ActivityTab extends StatefulWidget {
  const ActivityTab({super.key});

  @override
  State<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  // GetUserActivityResponse? getUserActivityResponse;
  GetNewUserActivityResponse? getUserNewActivityResponse;
  ActivityProvider? _activityProvider;
  late ActivityProvider activityProvider;
  late ThemeProvider themeProvider;
  late LadderProvider ladderProvider;
  bool isError = false;

  // int sequence = 0;

  @override
  void initState() {
    super.initState();
    _activityProvider = Provider.of(context, listen: false);
    callInitialApi();
  }

  Future<void> callInitialApi() async {
    try {
      await _activityProvider!.fetchActivities();
    } on HttpApiException catch (err) {
      print(err);
    }
  }

  String? formatUtcToLocal(String? utcTime) {
    DateTime unFormatedUtcTime =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(utcTime!, true);
    DateTime formatedUtcTime = DateTime.parse(unFormatedUtcTime.toString());
    DateFormat outputFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');
    String localTime =
        outputFormat.format(formatedUtcTime.toLocal()); // UTC to local time
    return localTime;
  }

  Widget buildActivityFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              CustomContainer(
                borderColor: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                borderWidth: 1,
                backgroundColor: Colors.transparent,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        onChanged: (String? value) {
                          // tradeMainState.updateSelectedTickerForSimulation =
                          //     value;
                          activityProvider.selectedLevelType = value!;
                          callInitialApi();
                        },
                        dropdownColor: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                        value: activityProvider.selectedLevelType,
                        items: activityProvider.levelType
                            .map((sortType) =>
                            DropdownMenuItem<String>(
                              child: Text(sortType!),
                              value: sortType,
                            ))
                            .toList(),
                      )),
                ),
              ),

              SizedBox(
                height: 27,
                width: 27,
                child: InfoIconDisplay().infoIconDisplay(
                  context,
                  "About Activity Levels",
                  "Level 1: User-visible activities (Ladder, Trades, Orders, Positions, Activity). \n\nLevel 2: Calculations during order creation, trade generation, and position updates. \n\nLevel 3: Database fetch and update operations. \n\nLevel 4: Error logs and system issues. \n\nLevel 5: All the modify ladder activity.",
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
              )
            ],
          ),

          // (ladderProvider.stockLadders.length <= 0)?Container():Row(
          //   children: [
          //     CustomContainer(
          //       borderColor: Colors.white,
          //       borderWidth: 1,
          //       backgroundColor: Colors.transparent,
          //       height: 40,
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 8, right: 8.0),
          //         child: DropdownButtonHideUnderline(
          //             child: DropdownButton<String?>(
          //               onChanged: (String? value) {
          //                 activityProvider.selectedLadder = value;
          //               },
          //               dropdownColor: Colors.black,
          //               value: activityProvider.selectedLadder ?? ladderProvider.stockLadders[0].stockName,
          //               items: ladderProvider.stockLadders
          //                   .map((stocks) =>
          //                   DropdownMenuItem<String>(
          //                     child: Text(stocks.stockName ?? "-"),
          //                     value: stocks.stockName,
          //                   ))
          //                   .toList(),
          //             )),
          //       ),
          //     ),
          //
          //     // SizedBox(
          //     //   height: 27,
          //     //   width: 27,
          //     //   child: InfoIconDisplay().infoIconDisplay(
          //     //     context,
          //     //     "About Ladder",
          //     //     "Info will come here",
          //     //     color: (themeProvider.defaultTheme)
          //     //         ? Colors.black
          //     //         : Colors.white,
          //     //   ),
          //     // )
          //   ],
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              CustomContainer(
                // borderColor: (activityProvider.isAscending)?Colors.white:Colors.grey,
                borderWidth: 0,
                backgroundColor: Colors.transparent,
                height: 40,
                elevation: 0,
                onTap: () {
                  activityProvider.isAscending = !activityProvider.isAscending ?? false;
                  callInitialApi();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Icon(
                    Icons.sort,
                    size: 20,
                    color: (activityProvider.isAscending)?Colors.white:Colors.grey,
                  ),
                ),
              ),

              CustomContainer(
                borderColor: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                borderWidth: 1,
                backgroundColor: Colors.transparent,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        onChanged: (String? value) {
                          // tradeMainState.updateSelectedTickerForSimulation =
                          //     value;
                          activityProvider.selectedSortType = value!;
                          callInitialApi();
                        },
                        dropdownColor: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                        value: activityProvider.selectedSortType,
                        items: activityProvider.sortType
                            .map((sortType) =>
                            DropdownMenuItem<String>(
                              child: Text(sortType!),
                              value: sortType,
                            ))
                            .toList(),
                      )),
                ),
              ),

              SizedBox(
                width: 10,
              )
            ],
          ),
        ],
      ),
    );
  }

  Color colorFromHex(String hexColor) {
    hexColor = hexColor.replaceFirst('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add alpha if missing
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Widget activityUI(Data activity, int indexTemp) {
    print("came in activityUI");
    print(activity.actType);
    // sequence++;
    int index = indexTemp + 1;
    String createdAt = activity.createdAt ?? "";
    String? formattedDateTime = formatUtcToLocal(createdAt);
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 20, bottom: 0, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activity.actType == "Ladder Update") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text("$index"),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Level ${activity.actLevel?? 1}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                          ),
                        ),
                      ),

                      // const SizedBox(
                      //   height: 5,
                      // ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          " ${activity.actMessageTitle?.trim()}".trim(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.green
                          ),
                        ),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Initial Purchase Price: ${activity.actMessageSubtitle?.initialPurchasePrice}"
                                  .trim(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200],
                              ),
                            ),

                            (activity.isExpanded!)?Text(
                              "Target Price: ${activity.actMessageSubtitle?.targetPrice} \nMinimum Purchase Price: ${activity.actMessageSubtitle?.minimumPrice} \nStep Size: ${activity.actMessageSubtitle?.stepSize}"
                                  .trim(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200],
                              ),
                            ):Container(),
                          ],
                        ),
                      ),
                      (activity.isExpanded!)?Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Created at: $formattedDateTime".trim(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.indigo[200]
                          ),
                        ),
                      ):Container(),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
          if (activity.actType == "Create Ladder") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text("$index"),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Level ${activity.actLevel?? 1}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                          ),
                        ),
                      ),

                      // const SizedBox(
                      //   height: 5,
                      // ),
                      Container(
                        width: screenWidthRecognizer(context) - 60,
                        child: Text(
                          " ${activity.actMessageTitle?.trim()}".trim(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.green
                          ),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   // "",
                            //   "Initial Purchase Price: ${activity.actMessageSubtitle?.initialPurchasePrice}"
                            //       .trim(),
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.normal,
                            //     color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200],
                            //   ),
                            // ),

                            (activity.isExpanded!)?Text(
                              "Target Price: ${activity.actMessageSubtitle?.targetPrice} \nMinimum Purchase Price: ${activity.actMessageSubtitle?.minimumPrice} \nStep Size: ${activity.actMessageSubtitle?.stepSize}"
                                  .trim(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200],
                              ),
                            ):Container(),
                          ],
                        ),
                      ),
                      (activity.isExpanded!)?Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Created at: $formattedDateTime".trim(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                              color: Colors.indigo[200]
                          ),
                        ),
                      ):Container(),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
          if (activity.actType == "Delete Ladder") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        // '$sequence',
                        "$index",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle?.trim()}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Deleted At: ${formattedDateTime?.trim()}".trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "Ladder Active") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        // '$sequence',
                        "$index",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Target Price: ${activity.actMessageSubtitle?.targetPrice}\nMinimum Purchase Price: ${activity.actMessageSubtitle?.minimumPrice}\nStep Size: ${activity.actMessageSubtitle?.stepSize}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Ladder activated at: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "Ladder Inactive") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        // '$sequence',
                        "$index",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Target Price: ${activity.actMessageSubtitle?.targetPrice} \nMinimum Purchase Price: ${activity.actMessageSubtitle?.minimumPrice} \nStep Size: ${activity.actMessageSubtitle?.stepSize}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Ladder inactivated at: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "Execute") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        // '$sequence',
                        "$index",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Buy trade executed".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}\nTrade Execution Price: ${activity.actMessageSubtitle?.tradeExePrice} \nBuy Quantity: ${activity.actMessageSubtitle?.buyQuantity}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Trading Started At: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "sellAllTrade") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        // '$sequence',
                        "$index",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Position closed".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}\nClosing Price: ${activity.actMessageSubtitle?.currentPrice} \nTotal Quantity: ${activity.actMessageSubtitle?.totalQuantity}\nTotal Return: ${activity.actMessageSubtitle?.totalReturn}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Ladder Closed At: ${formattedDateTime!.trim()}".trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "closedOrder") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        // '$sequence',
                        "$index",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Orders closed at: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "Open Order") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Level ${activity.actLevel?? 1}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                              ),
                            ),
                          ),

                          // const SizedBox(height: 5),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "${activity.actMessageTitle}".trim(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.green
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                    
                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Buy/Sell Price:"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                ),

                                Text(
                                  "${activity.actMessageSubtitle?.buyEntry!.toStringAsFixed(2)}/${activity.actMessageSubtitle?.sellEntry!.toStringAsFixed(2)}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                )
                              ],
                            ),
                          ),
                    
                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 8),
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Buy/Sell Quantity:"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                ),

                                Text(
                                  "${activity.actMessageSubtitle?.buyQuantity ?? '0'}/${activity.actMessageSubtitle?.sellQuantity ?? "0"}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                )
                              ],
                            ),
                          ),
                    
                    
                          (activity.isExpanded!)?Column(
                            children: [
                              const SizedBox(height: 5),
                              // Container(
                              //   width: MediaQuery.of(context).size.width * 0.8,
                              //   child:
                              //       Provider.of<TradeMainProvider>(context, listen: false)
                              //                   .tradingOptions ==
                              //               TradingOptions
                              //                   .simulationTradingWithSimulatedPrices
                              //           ? Text(
                              //               "Simulated Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             )
                              //           : Text(
                              //               "Current Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             ),
                              // ),
                              Container(
                                // width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  "Open order placed at: ${formatUtcToLocal(activity.createdAt)}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.indigo[200]
                                  ),
                                ),
                              ),
                            ],
                          ):Container(),
                    
                    
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
          if (activity.actType == "BUY Trade Execute") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Level ${activity.actLevel?? 1}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                          ),
                        ),
                      ),

                      // const SizedBox(
                      //   height: 5,
                      // ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "${activity.actMessageTitle}".trim(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.green
                          ),
                        ),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Trade Execution Price: ${activity.actMessageSubtitle?.tradeExePrice}\nBuy Quantity: ${activity.actMessageSubtitle?.buyQuantity}\nTicket# : ${activity.actMessageSubtitle?.ticketNumber}"
                              .trim(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                          ),
                        ),
                      ),

                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Buy order executed at: ${formatUtcToLocal(activity.createdAt)}"
                              .trim(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                              color: Colors.indigo[200]
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
          if (activity.actType == "buyOrderClosed") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        // '$sequence',
                        "$index",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Buy order closed at: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "sellOrderClosed") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        // '$sequence',
                        "$index",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Sell order closed at: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "replicateOrder") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        // '$sequence',
                        "$index",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Open order placed at: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "reduceLimitOrder") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        "$index",
                        // '$sequence',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Sell order placed at: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "reduceMarketOrderSold") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        "$index",
                        // '$sequence',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(height: 5),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Quantity sold: ${activity.actMessageSubtitle!.totalQuantity} units"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Sell execution price: ${activity.actMessageSubtitle!.currentPrice}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Ticket# : ${activity.actMessageSubtitle!.ticketNumber}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Sell order executed at: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "SELL Trade Execute") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          "$index",
                          // '$sequence',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(
                        height: 5,
                      ),

                      // const SizedBox(
                      //   height: 5,
                      // ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Level ${activity.actLevel?? 1}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                          ),
                        ),
                      ),

                      // const SizedBox(height: 5),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "${activity.actMessageTitle}".trim(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.green
                          ),
                        ),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Trade Execution Price: ${activity.actMessageSubtitle?.tradeExePrice}\nSell Qty: ${activity.actMessageSubtitle?.sellQuantity}"
                              .trim(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                          ),
                        ),
                      ),

                      (activity.isExpanded!)?Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: RichText(
                              text: TextSpan(
                                text: "Profit on close order: ".trim(),
                                // text: "Profit: ".trim(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                ),
                                children: [
                                  TextSpan(
                                    text: "+${activity.actMessageSubtitle?.profit}",
                                    style: TextStyle(
                                        color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                      // Customize profit style here if needed
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Ticket# : ${activity.actMessageSubtitle?.ticketNumber}"
                                  .trim(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.green
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Sell order executed at: ${formatUtcToLocal(activity.createdAt)}"
                                  .trim(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.indigo[200]
                              ),
                            ),
                          ),
                        ],
                      ):Container(),

                      const SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
            )
          ],
          if (activity.actType == "Buy Trade") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        "$index",
                        // '$sequence',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(height: 5),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Trade Execution Price: ${activity.actMessageSubtitle?.tradeExePrice}\nSell Qty: ${activity.actMessageSubtitle?.buyQuantity}\nTicket#: ${activity.actMessageSubtitle?.ticketNumber}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Buy trade closed at: ${formatUtcToLocal(activity.createdAt)}"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                            color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            )
          ],
          if (activity.actType == "newLimitOrder") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: 0,
                    paddingEdge: EdgeInsets.zero,
                    borderColor: Colors.white,
                    borderWidth: 0,
                    borderRadius: 50,
                    backgroundColor: Colors.white,
                    height: 15,
                    width: 15,
                    child: Center(
                      child: Text(
                        "$index",
                        // '$sequence',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                // Text("$index"),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Level ${activity.actLevel?? 1}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                        ),
                      ),
                    ),

                    // const SizedBox(height: 5),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "${activity.actMessageTitle}".trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.green
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Sell Entry Generated: ${activity.actMessageSubtitle?.newSellEntry}\nSell Qty: ${activity.actMessageSubtitle?.newSellQty}\n"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Buy Entry Generated: ${activity.actMessageSubtitle?.newBuyEntry}\nBuy Qty: ${activity.actMessageSubtitle?.newBuyQty}\n"
                            .trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                           color: Colors.indigo[200]
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            )
          ],

          if (activity.actType == "Merged Ladder") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Level ${activity.actLevel?? 1}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                              ),
                            ),
                          ),

                          // const SizedBox(height: 5),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "${activity.actMessageTitle}".trim(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.green
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 8),
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Merged Two Ladder ${activity.actMessageSubtitle!.ladder01} and ${activity.actMessageSubtitle!.ladder02}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                ),
                              ],
                            ),
                          ),


                          (activity.isExpanded!)?Column(
                            children: [
                              const SizedBox(height: 5),
                              // Container(
                              //   width: MediaQuery.of(context).size.width * 0.8,
                              //   child:
                              //       Provider.of<TradeMainProvider>(context, listen: false)
                              //                   .tradingOptions ==
                              //               TradingOptions
                              //                   .simulationTradingWithSimulatedPrices
                              //           ? Text(
                              //               "Simulated Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             )
                              //           : Text(
                              //               "Current Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             ),
                              // ),
                              Container(
                                // width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  "Ladder Merged at: ${formatUtcToLocal(activity.createdAt)}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.indigo[200]
                                  ),
                                ),
                              ),
                            ],
                          ):Container(),


                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
          if (activity.actType == "Add cash Buy Order") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Level ${activity.actLevel?? 1}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                              ),
                            ),
                          ),

                          // const SizedBox(height: 5),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "${activity.actMessageTitle}".trim(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.green
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Buy Entry:",
                                  // "Buy/Sell Price:"
                                  //     .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                ),

                                Text(
                                  "${activity.actMessageSubtitle?.buyEntry!.toStringAsFixed(2)}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                )
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 8),
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Buy Quantity:"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                ),

                                Text(
                                  "${activity.actMessageSubtitle?.buyQuantity ?? '0'}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                )
                              ],
                            ),
                          ),


                          (activity.isExpanded!)?Column(
                            children: [
                              const SizedBox(height: 5),
                              // Container(
                              //   width: MediaQuery.of(context).size.width * 0.8,
                              //   child:
                              //       Provider.of<TradeMainProvider>(context, listen: false)
                              //                   .tradingOptions ==
                              //               TradingOptions
                              //                   .simulationTradingWithSimulatedPrices
                              //           ? Text(
                              //               "Simulated Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             )
                              //           : Text(
                              //               "Current Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             ),
                              // ),
                              Container(
                                // width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  "Added cash at: ${formatUtcToLocal(activity.createdAt)}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.indigo[200]
                                  ),
                                ),
                              ),
                            ],
                          ):Container(),


                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
          if (activity.actType == "Withdraw cash Sell Order") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Level ${activity.actLevel?? 1}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                              ),
                            ),
                          ),

                          // const SizedBox(height: 5),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "${activity.actMessageTitle}".trim(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.green
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sell Price:"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                ),

                                Text(
                                  "${activity.actMessageSubtitle?.sellEntry!.toStringAsFixed(2)}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                )
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 8),
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sell Quantity:"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                ),

                                Text(
                                  "${activity.actMessageSubtitle?.sellQuantity ?? "0"}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]
                                  ),
                                )
                              ],
                            ),
                          ),


                          (activity.isExpanded!)?Column(
                            children: [
                              const SizedBox(height: 5),
                              // Container(
                              //   width: MediaQuery.of(context).size.width * 0.8,
                              //   child:
                              //       Provider.of<TradeMainProvider>(context, listen: false)
                              //                   .tradingOptions ==
                              //               TradingOptions
                              //                   .simulationTradingWithSimulatedPrices
                              //           ? Text(
                              //               "Simulated Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             )
                              //           : Text(
                              //               "Current Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             ),
                              // ),
                              Container(
                                // width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  "Withdraw cash at: ${formatUtcToLocal(activity.createdAt)}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.indigo[200]
                                  ),
                                ),
                              ),
                            ],
                          ):Container(),


                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],

          if (activity.actType == "Funds Move from Ladder") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Level ${activity.actLevel?? 1}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                              ),
                            ),
                          ),

                          // const SizedBox(height: 5),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "${activity.actMessageTitle}".trim(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.green
                              ),
                            ),
                          ),
                          // const SizedBox(height: 5),

                          // Padding(
                          //   padding: const EdgeInsets.only(left:8.0, right: 8),
                          //   child: Row(
                          //
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         "Funds Move from ${activity.actMessageSubtitle!.ladder01} to ${activity.actMessageSubtitle!.ladder02}"
                          //             .trim(),
                          //         style: TextStyle(
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.normal,
                          //             color: Colors.yellow[200]
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),


                          // (activity.isExpanded!)
                            (true)?Column(
                            children: [
                              const SizedBox(height: 5),
                              // Container(
                              //   width: MediaQuery.of(context).size.width * 0.8,
                              //   child:
                              //       Provider.of<TradeMainProvider>(context, listen: false)
                              //                   .tradingOptions ==
                              //               TradingOptions
                              //                   .simulationTradingWithSimulatedPrices
                              //           ? Text(
                              //               "Simulated Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             )
                              //           : Text(
                              //               "Current Price: ${activity.actMessageSubtitle?.currentPrice} \nSell Entry: ${activity.actMessageSubtitle?.sellEntry}\nBuy Entry: ${activity.actMessageSubtitle?.buyEntry}"
                              //                   .trim(),
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.normal,
                              //                   color: Colors.yellow[200]
                              //               ),
                              //             ),
                              // ),
                              Container(
                                // width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  "Ladder Moved at: ${formatUtcToLocal(activity.createdAt)}"
                                      .trim(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.indigo[200]
                                  ),
                                ),
                              ),
                            ],
                          ):Container(),


                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],

          if (activity.actType == "Make cash empty") ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text("$index"),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Level ${activity.actLevel?? 1}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                          ),
                        ),
                      ),

                      // const SizedBox(
                      //   height: 5,
                      // ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          " ${activity.actMessageTitle?.trim()}".trim(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.green
                          ),
                        ),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ladder Number: ${activity.actMessageSubtitle?.ladderName}"
                                  .trim(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200],
                              ),
                            ),


                          ],
                        ),
                      ),
                      (activity.isExpanded!)?Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Created at: $formattedDateTime".trim(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.indigo[200]
                          ),
                        ),
                      ):Container(),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],

          if(activity.actType != "Ladder Update" &&
              activity.actType != "Create Ladder" &&
              activity.actType != "Delete Ladder" &&
              activity.actType != "Ladder Active" &&
              activity.actType != "Ladder Inactive" &&
              activity.actType != "Execute" &&
              activity.actType != "sellAllTrade" &&
              activity.actType != "closedOrder" &&
              activity.actType != "Open Order" &&
              activity.actType != "BUY Trade Execute" &&
              activity.actType != "buyOrderClosed" &&
              activity.actType != "sellOrderClosed" &&
              activity.actType != "replicateOrder" &&
              activity.actType != "reduceLimitOrder" &&
              activity.actType != "reduceMarketOrderSold" &&
              activity.actType != "SELL Trade Execute" &&
              activity.actType != "Buy Trade" &&
              activity.actType != "newLimitOrder" &&
              activity.actType != "Merged Ladder" &&
              activity.actType != "Add cash Buy Order" &&
              activity.actType != "Withdraw cash Sell Order" &&
              activity.actType != "Funds Move from Ladder" &&
              activity.actType != "Make cash empty"
          ) ...[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                activity.isExpanded = _activityProvider!.changeExpanded(index-1);
                print("below is expanded");
                print(activity.isExpanded!);
                setState(() {

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text("$index"),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomContainer(
                      margin: EdgeInsets.zero,
                      padding: 0,
                      paddingEdge: EdgeInsets.zero,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: 50,
                      backgroundColor: Colors.white,
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Text(
                          // '$sequence',
                          "$index",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text("$index"),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Level ${activity.actLevel?? 1}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                          ),
                        ),
                      ),

                      // const SizedBox(
                      //   height: 5,
                      // ),
                      Container(
                        width: screenWidthRecognizer(context) - 110,
                        child: Text(
                          " ${activity.actMessageTitle?.trim()}".trim(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: (activity.actTitleColor == null)?Colors.green:colorFromHex(activity.actTitleColor!),
                              // color: Colors.green
                          ),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   // "",
                            //   "Initial Purchase Price: ${activity.actMessageSubtitle?.initialPurchasePrice}"
                            //       .trim(),
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.normal,
                            //     color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200],
                            //   ),
                            // ),

                            // (activity.isExpanded!)?Text(
                            //   "Target Price: ${activity.actMessageSubtitle?.targetPrice} \nMinimum Purchase Price: ${activity.actMessageSubtitle?.minimumPrice} \nStep Size: ${activity.actMessageSubtitle?.stepSize}"
                            //       .trim(),
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.normal,
                            //     color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200],
                            //   ),
                            // ):Container(),
                          ],
                        ),
                      ),
                      (activity.isExpanded!)?Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "Created at: $formattedDateTime".trim(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.indigo[200]
                          ),
                        ),
                      ):Container(),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    activityProvider = Provider.of<ActivityProvider>(context, listen: true);
    ladderProvider = Provider.of<LadderProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);

    return Consumer<ActivityProvider>(builder: (_, state, __) {
      return state.isLoading
          ? buildActivityLoadingWidget(context, screenWidth) //Center(child: Text("N/A"))
          : state.activities!.data!.isEmpty
              ? Center(
                  child: Text(
                    "No activities",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                children: [
                  buildActivityFilter(context),
                  Expanded(
                    child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {

                              return activityUI(state.activities!.data![index], index);
                            },
                            separatorBuilder: (context, index) {
                              return Consumer<ThemeProvider>(
                    builder: (context, value, child) {
                      return Divider(
                        height: 0,
                        thickness: 1,
                        color:
                        value.defaultTheme ? Colors.black : Colors.white54,
                        indent: 15,
                        endIndent: 15,
                      );
                    });
                            },
                            itemCount: state.activities!.data!.length,
                          ),
                  ),
                ],
              );
    });
  }

  Widget buildActivityLoadingWidget(BuildContext context, double screenWidth) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, stockIndex) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.6, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.6, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(60, 25)
                            :ShimmerLoadingView.loadingContainer(60, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(60, 25)
                            :ShimmerLoadingView.loadingContainer(60, 25),
                      ],
                    )




                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.4, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.4, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(40, 25)
                            :ShimmerLoadingView.loadingContainer(40, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(60, 25)
                            :ShimmerLoadingView.loadingContainer(60, 25),
                      ],
                    )




                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.3, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.3, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(50, 25)
                            :ShimmerLoadingView.loadingContainer(50, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(10, 25)
                            :ShimmerLoadingView.loadingContainer(10, 25),
                      ],
                    )




                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.3, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.3, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(50, 25)
                            :ShimmerLoadingView.loadingContainer(50, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(50, 25)
                            :ShimmerLoadingView.loadingContainer(50, 25),
                      ],
                    )




                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}
