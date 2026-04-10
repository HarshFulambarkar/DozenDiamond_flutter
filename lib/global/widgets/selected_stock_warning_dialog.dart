// import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
// import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ZI_Search/models/delete_user_stocks_draft_request.dart';
import '../../ZI_Search/models/selected_stock_list_respone.dart';
import '../../ZI_Search/services/search_rest_api_service.dart';
import '../../ZI_Search/stateManagement/search_provider.dart';

class SelectedStockWarningDialog extends StatefulWidget {
  final int? index;
  final String? warningMessage;
  final List<String>? ladderName;
  final String? stockName;
  final bool? isForWarning;
  final int? tickerId;
  const SelectedStockWarningDialog(
      {super.key,
      this.index,
      this.warningMessage,
      this.ladderName,
      this.stockName,
      this.isForWarning,
      this.tickerId});

  @override
  State<SelectedStockWarningDialog> createState() =>
      _SelectedStockWarningDialogState();
}

class _SelectedStockWarningDialogState
    extends State<SelectedStockWarningDialog> {
  // CustomHomeAppBarProvider? appBarProvider;
  SearchProvider? _socketProviderWithoutListener;
  SelectedStockListResponse? _selectedStockList;
  late CustomHomeAppBarProvider appBarProvider;

  @override
  void initState() {
    super.initState();

    appBarProvider =
        Provider.of<CustomHomeAppBarProvider>(context, listen: false);
    _socketProviderWithoutListener ??=
        Provider.of<SearchProvider>(context, listen: false);
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

//deleteLaddersAndStock
  Future<void> _deleteLaddersAndStock() async {
    final pref = await SharedPreferences.getInstance();

    await SearchRestApiService()
        .deleteStockFromSelectedStockList(
            DeleteStockFromSelectedStockListRequest(
          forceDelete: true,
          regId: pref.getInt("reg_id").toString(),
          ticker: widget.tickerId!,
        ))
        .then((value) => {
              print("deleteLaddersAndStock message ${value!.message}"),
            });
    // getSelectedStockList();
    print("Not Executing"); // remove from selectedStockList
    // appBarProvider!.fetchUserAccountDetails();
    _socketProviderWithoutListener!
        .updateTicker(widget.index!, false); // remove from SearchList
  }

  Future<void> getSelectedStockList() async {
    // SharedPreferences.getInstance().then((pref) {
    //   SearchRestApiService()
    //       .getSelectedStockList(SelectedStockListRequest(
    //     regId: pref.getInt("reg_id").toString(),
    //   ))
    //       .then((value) {
    //     _selectedStockList = value!;
    //     _updateState();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     padding: EdgeInsets.zero,
          //     icon: Icon(
          //       Icons.close,
          //       color: Colors.red,
          //     )),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 7.5, right: 7.5),
            child: Container(
              child: Text(
                widget.warningMessage ?? "Something went wrong",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (String ladder in widget.ladderName ?? [])
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      ladder,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: widget.isForWarning ?? false
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: widget.isForWarning ?? false
                ? [
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.red)),
                              onPressed: () {
                                Fluttertoast.showToast(msg: "Locked Feature");
                                // Navigator.pop(context);
                              },
                              child: Text("De-Active all the ladders")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Back"))
                        ],
                      ),
                    ),
                  ]
                : [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ElevatedButton.icon(
                            onPressed: () {
                              _deleteLaddersAndStock();

                              Fluttertoast.showToast(
                                  msg: "Stock Deleted Successfully");

                              Navigator.pop(context);
                              setState(() {});
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            icon: Icon(Icons.delete),
                            label: Text("Delete ${widget.stockName}")),
                      ),
                    ),
                  ],
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: BorderSide(
          color:
              Colors.white, //value.defaultTheme ? Colors.black : Colors.white,
          width: 1,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Color(0xFF15181F),
      // value.defaultTheme ? Color(0xFFF6F1EE) : const Color(0xFF15181F),
      titlePadding: EdgeInsets.zero,
    );
  }
}
