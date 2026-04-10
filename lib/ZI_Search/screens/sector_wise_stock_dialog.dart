import 'package:provider/provider.dart';

import '../../ZI_search/screens/stock_by_sector_page.dart';
import 'package:flutter/material.dart';

import '../stateManagement/search_provider.dart';

class SectorWiseStockListDialog extends StatefulWidget {
  final BuildContext activityContext;

  final Function updateIndex;
  const SectorWiseStockListDialog(
      {Key? key, required this.activityContext, required this.updateIndex})
      : super(key: key);

  @override
  State<SectorWiseStockListDialog> createState() =>
      _SectorWiseStockListDialogState();
}

class _SectorWiseStockListDialogState extends State<SectorWiseStockListDialog> {
  late SearchProvider searchProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      searchProvider = Provider.of<SearchProvider>(context, listen: false);
      searchProvider.getSectorList();
    });
  }

  @override
  Widget build(BuildContext context) {
    searchProvider = Provider.of<SearchProvider>(context, listen: true);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xff1c1c1c),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff1c1c1c),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white54,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: const InkWell(
                    focusColor: Colors.amber,
                    hoverColor: Colors.green,
                    highlightColor: Colors.blue,
                    child: Text(
                      "Select Sector To Continue!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: searchProvider.isLoading
                  ? const Center(
                      child: Text("N/A"),
                    )
                  : ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: searchProvider.sectorList
                              .map(
                                (e) => Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.zero,
                                      color: Colors.transparent,
                                      child: ListTile(
                                        // contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        title: Text(
                                          e.stockName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        onTap: () async {
                                          await Navigator.of(context).push(
                                            // widget.activityContext,
                                            MaterialPageRoute(
                                              builder: (_) => StockBySectorPage(
                                                refreshProviderState: true,
                                                // selectedSector: res[i].secName!,
                                              ),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          // Navigator.of(context).pop(test);
                                          // print("test$test");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
