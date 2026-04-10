import 'package:dozen_diamond/global/services/num_formatting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';

class StockLadder1 extends StatefulWidget {
  const StockLadder1({
    super.key,
    required this.stepSize,
    required this.currentStockPrice,
    required this.initialBuyQty,
    required this.targetPrice,
    required this.ladderLinesValueAboveCP,
    required this.ladderLinesValueBelowCP,
    required this.stocksHeldAboveCP,
    required this.stocksHeldBelowCP,
    required this.firstPurchasePrice,
    required this.noOfStepsAbovePurchasePrice,
    required this.noOfStepsBelowPurchasePrice,
    required this.defaultBuySellQty,
    required this.stoocksBoughtSoldQtyAboveCp,
    required this.stoocksBoughtSoldQtyBelowCp,
    required this.updateScrollToCpCellFunction,
  });

  final double stepSize;
  final double currentStockPrice;
  final double targetPrice;
  final int initialBuyQty;
  final Function updateScrollToCpCellFunction;
  final List<double> ladderLinesValueAboveCP;
  final List<double> ladderLinesValueBelowCP;
  final List<String> stoocksBoughtSoldQtyAboveCp;
  final List<String> stoocksBoughtSoldQtyBelowCp;
  final List<int> stocksHeldAboveCP;
  final List<int> stocksHeldBelowCP;
  final double firstPurchasePrice;
  final int noOfStepsAbovePurchasePrice;
  final int defaultBuySellQty;
  final int noOfStepsBelowPurchasePrice;

  @override
  State<StockLadder1> createState() => _StockLadder1State();
}

class _StockLadder1State extends State<StockLadder1> {
  ScrollController _ladderScrollbar = ScrollController();
  late ThemeProvider themeProvider;

  final dataKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    widget.updateScrollToCpCellFunction(scrollToCurrentPriceCell);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollToCurrentPriceCell());
  }

  void scrollToCurrentPriceCell() {
    if (dataKey.currentContext != null) {
      Scrollable.ensureVisible(dataKey.currentContext!);
    }
  }

  Widget currentPriceCell() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade800,
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      child: Text(
        "Current Price: ${numToComma(widget.currentStockPrice)}",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget emptyCell() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade800,
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      child: const Text(
        "Empty Ladder",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget rowElements(String text1, String text2, String text3,
      {bool currentPriceCell = false, Key? key, bool formatToComma = false}) {
    return IntrinsicHeight(
      key: key,
      child: Row(children: [
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: currentPriceCell
                  ? Colors.lightGreen.shade800
                  : Colors.transparent,
              border: Border.all(
                  color: (themeProvider.defaultTheme)
                      ?Colors.black:Colors.white, width: 0.5),
            ),
            child: Text(
              formatToComma ? intToUnits(int.tryParse(text1) ?? 0) : text1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: currentPriceCell ? Colors.white : (themeProvider.defaultTheme)
                    ?Colors.green:Colors.greenAccent,
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: currentPriceCell
                  ? Colors.lightGreen.shade800
                  : Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white, width: 0.5),
            ),
            child: Text(
              formatToComma ? intToUnits(int.tryParse(text2) ?? 0) : text2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: currentPriceCell ? Colors.white : (themeProvider.defaultTheme)
                    ?Colors.green:Colors.greenAccent,
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: currentPriceCell
                  ? Colors.lightGreen.shade800
                  : Colors.transparent,
              border: Border.all(color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white, width: 0.5),
            ),
            child: Text(
              formatToComma ? numToComma(double.tryParse(text3) ?? 0.0) : text3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: currentPriceCell ? Colors.white : (themeProvider.defaultTheme)
                    ?Colors.green:Colors.greenAccent,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(right: 10.0),
        //   child: rowElements(
        //       "Stocks\nHeld", "Stocks\nBought/Sold", "Stock\nPrice"),
        // ),
        LimitedBox(
          maxHeight: MediaQuery.of(context).size.height * 0.25,
          child: RawScrollbar(
            controller: _ladderScrollbar,
            thumbColor: Colors.white70,
            thickness: 5,
            radius: const Radius.circular(20),
            thumbVisibility: true,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SingleChildScrollView(
                  controller: _ladderScrollbar,
                  child: Column(
                    children: [
                      if (widget.ladderLinesValueAboveCP.isEmpty &&
                          widget.ladderLinesValueBelowCP.isEmpty)
                        emptyCell()
                      else ...[
                        for (var i = 0;
                            i < widget.ladderLinesValueAboveCP.length;
                            i++) ...[
                          rowElements(
                            widget.stocksHeldAboveCP[i].toString(),
                            widget.stoocksBoughtSoldQtyAboveCp[i].toString(),
                            widget.ladderLinesValueAboveCP[i]
                                .toStringAsFixed(2),
                            key: widget.ladderLinesValueAboveCP.length < 3
                                ? i == widget.ladderLinesValueAboveCP.length - 1
                                    ? dataKey
                                    : null
                                : i == widget.ladderLinesValueAboveCP.length - 4
                                    ? dataKey
                                    : null,
                            formatToComma: true,
                          ),
                          if (i == widget.ladderLinesValueAboveCP.length - 2)
                            currentPriceCell()
                        ],
                        for (var i = 0;
                            i < widget.ladderLinesValueBelowCP.length;
                            i++)
                          rowElements(
                              widget.stocksHeldBelowCP[i].toString(),
                              widget.stoocksBoughtSoldQtyBelowCp[i].toString(),
                              widget.ladderLinesValueBelowCP[i]
                                  .toStringAsFixed(2),
                              formatToComma: true)
                      ]
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
