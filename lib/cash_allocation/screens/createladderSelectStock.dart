import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../F_Funds/stateManagement/funds_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../create_ladder_easy/model/ladder_creation_tickers_response.dart';
import '../../create_ladder_easy/stateManagement/create_ladder_easy_provider.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/services/num_formatting.dart';
import '../../global/services/stock_price_listener.dart';
import '../models/ladder_creation_screen1.dart';
import '../models/ladder_details_request.dart';
import '../service/rest_api_service.dart';
import '../models/ladder_details_response.dart';
import '../stateManagement/create_ladder_provider.dart';

class CreateLadderSelectStock extends StatefulWidget {
  const CreateLadderSelectStock({super.key});

  @override
  State<CreateLadderSelectStock> createState() =>
      _CreateLadderSelectStockState();
}

class _CreateLadderSelectStockState extends State<CreateLadderSelectStock> {
  CreateLadderProvider? stateProvider;
  FundsProvider? _fundsProvider;
  late NavigationProvider _navigationProvider;
  StockPriceListener? _stockPriceListener;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  RestApiService restApiService = RestApiService();
  bool isListReorderable = false;
  TextStyle normalHead = TextStyle(
    fontSize: 16,
  );
  bool _isBtnClicked = false;

  LaddersDetail? ladderDetails;

  double minFontSize = 14;

  late CreateLadderEasyProvider createLadderEasyProvider;

  InputDecoration cashAllocatedTextFormFieldDecoration = InputDecoration(
    prefixIcon: Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 0.0),
      // child: CurrencyIcon(
      //   color: Colors.white,
      //   size: 15,
      // ),
    ), // White icon
    hintText: 'Enter amount',
    hintStyle: TextStyle(color: Colors.white), // White hint text
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // White border when enabled
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // White border when focused
    ),
    border: OutlineInputBorder(),
  );
  void initState() {
    super.initState();
    stateProvider = Provider.of(context, listen: false);
    _fundsProvider = Provider.of(context, listen: false);
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    _stockPriceListener = Provider.of(context, listen: false);
    stateProvider!.index = 0;
    callInitialApi();
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  Future<void> callInitialApi() async {
    try {
      bool stockListEmpty = await stateProvider!.getUserStockAndLadder();

      if (stockListEmpty) {
        Navigator.pop(context);
      }
    } on HttpApiException catch (err) {
      print("something gone wrong");
      print(err.errorTitle);
    }
  }

  void updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getLadderDetails(
      LadderDetailsRequest ladderDetailsRequest) async {
    try {
      LadderDetailsResponse? value =
          await RestApiService().getLadderDetails(ladderDetailsRequest);
      ladderDetails = value.laddersDetail;
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  Future<void> _deleteUserStockFromCreationStockList(int? userClipID) async {
    restApiService
        .deleteUserStockFromCreationStockList(userClipID)
        .then((value) {
      Fluttertoast.showToast(
          msg: "Stock excluded from ladder creation process");
      callInitialApi();
    }).catchError((err) {
      print(err);
      if (kDebugMode || kIsWeb) {
        print(userClipID);

        stateProvider!.ladderCreationScreen1.removeWhere((value) {
          return (value.clpStockId == userClipID);
        });

        stateProvider!.notifyListeners();
      }
    });
  }

  Widget listWidget(
      BuildContext context, bool themeValue, LaddersDetail ladderDetails) {
    return SizedBox(
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${ladderDetails.ladStockName} - ${ladderDetails.ladLadderName}",
              style: TextStyle(fontSize: 16)),
          Text(
              "Current Price: ${numToCurrency(double.parse(ladderDetails.ladInitialPurchasePrice ?? "0"))}",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Target Price: "),
              Text(
                  "${numToCurrency(double.parse(ladderDetails.ladTargetPrice ?? "0"))}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Minimum Price:"),
              Text(
                  "${numToCurrency(double.parse(ladderDetails.ladMinimumPrice ?? "0"))}"),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Cash Allocated:"),
              Text(
                  "${numToCurrency(double.parse(ladderDetails.ladCashInitialAllocated ?? "0"))}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Initial Buy Quantity:"),
              Text("${numToComma(ladderDetails.ladInitialBuyQuantity)}"),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Step Size: "),
              Text(
                  "${numToCurrency(double.parse(ladderDetails.ladStepSize ?? "0"))}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Default Buy/Sell Quantity:"),
              Text(" ${numToComma(ladderDetails.ladDefaultBuySellQuantity)}"),
            ],
          ),
        ],
      )),
    );
  }

  Future<void> displayDialog(BuildContext context,
      LadderDetailsRequest ladderDetailsRequest, int? stockId) async {
    stateProvider!.updateStockSubscribedId = stockId;

    _getLadderDetails(ladderDetailsRequest)
        .then((value) => showDialog(
              context: context,
              builder: (context) {
                return Consumer<ThemeProvider>(
                    builder: (context, themeValue, child) {
                  return AlertDialog(
                    backgroundColor: Color(0XFF121212),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    titlePadding: EdgeInsets.only(top: 0.5),
                    title: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _isBtnClicked = false;
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                        Text("Review Ladder"),
                      ],
                    ),
                    content: listWidget(
                        context, themeValue.defaultTheme, ladderDetails!),
                  );
                });
              },
            ))
        .catchError((err) {
      print(err);
    });
  }

  Widget stockAndLadderBuilder(
      List<LadderCreationScreen1> listofData,
      LadderCreationScreen1 stockLadderProvData,
      int valueIndex,
      int stockListIndex) {
    return Container(
      key: Key("$stockListIndex"),
      margin: EdgeInsets.only(top: 7, bottom: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white,
          width: 2.0, // Specify the border width
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 3,
                child: Text(
                  stockLadderProvData.clpTicker ?? "Stock name NA",
                  style: normalHead,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  stockLadderProvData.clpInitialPurchasePrice!.text,
                  style: normalHead,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () async {
                    await _deleteUserStockFromCreationStockList(
                        stockLadderProvData.clpStockId);
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "Cash Allocated",
                style: TextStyle(fontSize: minFontSize),
              ),
              SizedBox(
                width: 50,
              ),
              Container(
                height: 30,
                width: 150, // Adjust the width of the TextFormField here
                child: TextFormField(
                  controller: stateProvider
                      ?.cashAllocatedControllerList[stockListIndex],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white), // Text color is white
                  decoration: cashAllocatedTextFormFieldDecoration.copyWith(
                    contentPadding: EdgeInsets
                        .zero, // Remove padding inside the TextFormField
                  ),
                  onChanged: (value) {
                    double sum = 0;

                    // Loop through all the controllers and sum the values
                    for (int i = 0;
                        i < stateProvider!.cashAllocatedControllerList.length;
                        i++) {
                      String textValue =
                          stateProvider?.cashAllocatedControllerList[i].text ??
                              "0.0";
                      print("Text value at index $i: ${textValue.runtimeType}");

                      double parsedValue =
                          double.tryParse(textValue.replaceAll(",", "")) ?? 0.0;

                      sum += parsedValue;
                      print("Parsed value: $parsedValue");
                    }

                    // Check if the sum exceeds the limit
                    if (sum >
                        (stateProvider?.accountCashForNewLadders ?? 0.0)) {
                      stateProvider!.isLimitExceeding = true;
                    } else {
                      stateProvider!.isLimitExceeding = false;
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child:
                Consumer<ThemeProvider>(builder: (context, themeValue, child) {
              return Column(
                children: [
                  for (int i = 0;
                      i < stockLadderProvData.ladderDetails!.length;
                      i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " ${stockLadderProvData.clpTicker} ${stockLadderProvData.ladderDetails?[i].ladId} - ${stockLadderProvData.ladderDetails?[i].ladStatus}",
                          style: TextStyle(fontSize: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (!_isBtnClicked) {
                                  displayDialog(
                                    context,
                                    LadderDetailsRequest(
                                        ladId: stockLadderProvData
                                            .ladderDetails?[i].ladId),
                                    stockLadderProvData.clpTickerId,
                                  );
                                  _isBtnClicked = true;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(0, 0),
                                fixedSize: Size(70, 20),
                              ),
                              child: Text("Review",
                                  style: TextStyle(fontSize: 12)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              );
            }),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget itemIsBeingDraggedStyle(
      Widget child, int index, Animation<double> animation) {
    return Material(
      color: Color(0xFF0099CC).withOpacity(0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        color: Colors.transparent,
        child: child,
      ),
      elevation: 0, // Elevation for shadow effect
    );
  }

  Widget buildLadderTitle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        "Build Ladder",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        // textAlign: TextAlign.start,
      ),
    );
  }

  Widget selectSequenceTitle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Select stock sequence for building ladder",
        style: TextStyle(fontSize: 16),
        // textAlign: TextAlign.start,
      ),
    );
  }

  Widget checkboxToToggleReordering() {
    return Checkbox(
        value: isListReorderable,
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Color(0xFF0099CC); // Color when selected
          }
          return Color(0xFF0099CC);
        }),
        onChanged: (isReorderable) {
          isListReorderable = isReorderable ?? true;
          updateState();
        });
  }

  Widget selectLadderParameterBtn() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Consumer<CreateLadderProvider>(
        builder: (_, value, __) {
          if (value.ladderCreationScreen1.isEmpty) {
            return Center(child: Container());
          }
          return Center(
            child: ElevatedButton(
              onPressed: () async {
                if (!_isBtnClicked) {
                  String ladderCreationType =
                      await SharedPreferenceManager.getLadderCreationType() ??
                          "";

                  if (ladderCreationType == 'beginner') {
                    createLadderEasyProvider.ladderDetailsList.clear();
                    for (int i = 0;
                        i < value.ladderCreationScreen1.length;
                        i++) {
                      createLadderEasyProvider.ladderDetailsList
                          .add(LadderDetails(
                        ladExchange: value.ladderCreationScreen1[i].clpExchange ?? '',
                        ladTickerId: value.ladderCreationScreen1[i].clpTickerId,
                        ladTicker: value.ladderCreationScreen1[i].clpTicker,
                        ladInitialBuyPrice: value.ladderCreationScreen1[i]
                            .clpInitialPurchasePrice!.text,
                        ladCashAllocated:
                            value.cashAllocatedControllerList[i].text,
                      ));
                      // data.add(
                      //     {
                      //       'ticker': value.ladderCreationScreen1[i].clpTicker,
                      //       'initial_purchase_price': value.ladderCreationScreen1[i].clpInitialPurchasePrice!.text,
                      //       'current_price': value.ladderCreationScreen1[i].clpInitialPurchasePrice!.text,
                      //       'cash_allocation': value.cashAllocatedControllerList[i].text
                      //     }
                      // );
                    }

                    _navigationProvider.previousSelectedIndex =
                        _navigationProvider.selectedIndex;
                    _navigationProvider.selectedIndex = 8;
                  } else if (ladderCreationType == 'custom') {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return showLadderCreationOptionDialog(
                            "Select Ladder creation option", context, value);
                      },
                    );
                  } else {
                    _navigationProvider.previousSelectedIndex =
                        _navigationProvider.selectedIndex;
                    _navigationProvider.selectedIndex = 5;
                  }

                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => CreateLadder2()));
                }
              },
              child: Text(
                  "Select ${value.ladderCreationParametersScreen1.clpTicker} Parameters"),
            ),
          );
        },
      ),
    );
  }

  Widget showLadderCreationOptionDialog(
      String msg, BuildContext context, value) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 10,
              left: 20,
              right: 20,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _navigationProvider.previousSelectedIndex =
                            _navigationProvider.selectedIndex;
                        _navigationProvider.selectedIndex = 5;
                      },
                      child: const Text(
                        "Advance",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        createLadderEasyProvider.ladderDetailsList.clear();
                        for (int i = 0;
                            i < value.ladderCreationScreen1.length;
                            i++) {
                          createLadderEasyProvider.resetValue();

                          createLadderEasyProvider.ladderDetailsList
                              .add(LadderDetails(
                            ladExchange: value.ladderCreationScreen1[i].clpExchange,
                            ladTickerId:
                                value.ladderCreationScreen1[i].clpTickerId,
                            ladTicker: value.ladderCreationScreen1[i].clpTicker,
                            ladInitialBuyPrice: value.ladderCreationScreen1[i]
                                .clpInitialPurchasePrice!.text,
                            ladCashAllocated:
                                value.cashAllocatedControllerList[i].text,
                          ));
                        }

                        _navigationProvider.previousSelectedIndex =
                            _navigationProvider.selectedIndex;
                        _navigationProvider.selectedIndex = 8;
                      },
                      child: const Text(
                        "Easy",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stockListing() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Consumer<CreateLadderProvider>(
        builder: (context, value, child) {
          if (value.ladderCreationScreen1.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
          return isListReorderable
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  margin: EdgeInsets.all(18),
                  child: ReorderableListView(
                    onReorder: value.reorderStocksInList,
                    proxyDecorator: itemIsBeingDraggedStyle,
                    children: [
                      for (int stockListIndex = 0;
                          stockListIndex < value.ladderCreationScreen1.length;
                          stockListIndex++)
                        stockAndLadderBuilder(
                            value.ladderCreationScreen1,
                            value.ladderCreationScreen1[stockListIndex],
                            value.index,
                            stockListIndex),
                    ],
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  margin: EdgeInsets.all(18),
                  child: ListView(
                    children: [
                      for (int stockListIndex = 0;
                          stockListIndex < value.ladderCreationScreen1.length;
                          stockListIndex++)
                        stockAndLadderBuilder(
                            value.ladderCreationScreen1,
                            value.ladderCreationScreen1[stockListIndex],
                            value.index,
                            stockListIndex),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget unallocatedCashAvailableForLadder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Unallocated cash for new ladders: ",
                style: TextStyle(fontSize: minFontSize),
              )),
        ),
        Expanded(
          child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 15),
              child: Text(amountToInrFormat(
                      context, stateProvider!.accountUnallocatedCash) ??
                  "N/A")),
        ),
      ],
    );
  }

  Widget extraCashAvailableForLadder() {
    return Row(
      children: [
        Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15),
                child: Text("Extra cash generated/left: ",
                    style: TextStyle(fontSize: minFontSize)))),
        Expanded(
            child: Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 15),
                child: Text(
                    "${amountToInrFormat(context, stateProvider?.accountExtraCashGenerated ?? 0.0)}/${amountToInrFormat(context, stateProvider?.accountExtraCashLeft ?? 0.0)}"))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    stateProvider = Provider.of<CreateLadderProvider>(context, listen: true);
    createLadderEasyProvider =
        Provider.of<CreateLadderEasyProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        _navigationProvider.selectedIndex =
            _navigationProvider.previousSelectedIndex;
        return false;
      },
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        drawer: const NavDrawerNew(),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: AppBar().preferredSize.height * 1.2,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    color: const Color.fromARGB(255, 45, 44, 44),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: const Text(
                            'Review Stock Cash Allocation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.5,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      selectSequenceTitle(),
                      checkboxToToggleReordering(),
                    ],
                  ),
                  unallocatedCashAvailableForLadder(),
                  SizedBox(
                    height: 7,
                  ),
                  extraCashAvailableForLadder(),
                  Expanded(flex: 4, child: stockListing()),
                  Consumer<CreateLadderProvider>(
                    builder: (context, value, child) {
                      return value.isLimitExceeding
                          ? Container(
                              padding:
                                  EdgeInsets.all(8), // Add padding if needed
                              child: Text(
                                "You have allocated more cash than you have",
                                style: TextStyle(color: Colors.yellow),
                              ),
                            )
                          : SizedBox
                              .shrink(); // Use SizedBox.shrink() instead of an empty Container
                    },
                  ),
                  Expanded(child: selectLadderParameterBtn())
                ],
              ),
              // CustomHomeAppBarWithProvider(
              //   backButton: false,
              //   leadingAction: _triggerDrawer,
              // ),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
