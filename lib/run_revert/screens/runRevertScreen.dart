import 'package:dozen_diamond/ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/run_revert/stateManagement/runRevertProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/widgets/custom_container.dart';

class RunRevertScreen extends StatefulWidget {
  @override
  _RunRevertScreenState createState() => _RunRevertScreenState();
}

class _RunRevertScreenState extends State<RunRevertScreen> {
  late ThemeProvider themeProvider;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RunRevertProvider>(
        context,
        listen: false,
      ).getAllRunOfAUser(page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final runRevertProvider = Provider.of<RunRevertProvider>(
      context,
      listen: true,
    );

    double screenWidth = screenWidthRecognizer(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    Widget paginationBtns(double screenWidth) {
      return Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12.0),
                child: CustomContainer(
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  padding: 0,
                  backgroundColor: Colors.transparent,
                  borderColor: (themeProvider.defaultTheme)
                      ? Color(0xff1a94f2)
                      : Color(0xfff0f0f0),
                  borderRadius: 50,
                  onTap: () {
                    if (runRevertProvider.currentPage > 1) {
                      runRevertProvider.getAllRunOfAUser(
                        page: runRevertProvider.currentPage - 1,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: runRevertProvider.currentPage > 1
                          ? Color(0xff1a94f2)
                          : Colors.grey,
                      size: 12,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
                child: CustomContainer(
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  padding: 0,
                  backgroundColor: Colors.transparent,
                  // borderColor: (themeProvider.defaultTheme)
                  //     ?Color(0xff1a94f2)
                  //     :Color(0xfff0f0f0),
                  borderColor: Colors.transparent,
                  borderRadius: 50,

                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      runRevertProvider.currentPage.toString(),
                      style: TextStyle(
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Color(0xfff0f0f0), // Color(0xff1a94f2),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 12.0),
                child: CustomContainer(
                  paddingEdge: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  padding: 0,
                  backgroundColor: Colors.transparent,
                  borderColor: (themeProvider.defaultTheme)
                      ? Color(0xff1a94f2)
                      : Color(0xfff0f0f0),
                  borderRadius: 50,
                  onTap: () {
                    if (runRevertProvider.currentPage <
                        runRevertProvider.totalPages) {
                      runRevertProvider.getAllRunOfAUser(
                        page: runRevertProvider.currentPage + 1,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color:
                      runRevertProvider.currentPage <
                          runRevertProvider.totalPages
                          ? Color(0xff1a94f2)
                          : Colors.grey,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: (themeProvider.defaultTheme)
          ? Color(0xfff0f0f0) //Color(0XFFF5F5F5)
          : Color(0xFF15181F),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: screenWidth,
                  child: Padding(
                    // padding: const EdgeInsets.only(top: 70.0, right: 8),
                    padding: const EdgeInsets.only(top: 55.0, right: 8),
                    child: Column(
                      children: [
                        paginationBtns(screenWidth),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          // height: screenWidthRecognizer(context) * 0.8,
                          child: Scrollbar(
                            controller: _horizontalScrollController,
                            thumbVisibility: true,
                            trackVisibility: true,
                            interactive: true,
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                interactive: true,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis
                                      .vertical, // Enables horizontal scrolling for large content
                                  child: DataTable(
                                    border: TableBorder.all(
                                      color: Colors.grey,
                                    ), // Optional: Adds border to table
                                    headingRowColor:
                                    MaterialStateColor.resolveWith(
                                          (states) => Colors.blue.shade100,
                                    ),
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'Run\n ID',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Start Date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'End Date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Ladders',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'option',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: runRevertProvider.revertRunData.asMap().entries.map((
                                        entry,
                                        ) {
                                      final index =
                                          ((runRevertProvider.currentPage - 1) *
                                              runRevertProvider.limit) +
                                              entry.key +
                                              1; // Start index from 1
                                      final run = entry.value;
                                      return DataRow(
                                        // onSelectChanged: (value) {
                                        //   runRevertProvider.selectedRunId = run.runId ?? -1;
                                        //   if (runRevertProvider.selectedRunId != -1) {
                                        //     _showConfirmationDialog(
                                        //         context, runRevertProvider.selectedRunId);
                                        //   } else {
                                        //     ScaffoldMessenger.of(context).showSnackBar(
                                        //       const SnackBar(
                                        //         content:
                                        //         Text('Please select a run ID first.'),
                                        //       ),
                                        //     );
                                        //   }
                                        // },
                                        cells: [
                                          DataCell(
                                            Text(index.toString()),
                                            onTap: () {
                                              print(index.toString());
                                              runRevertProvider.selectedRunId =
                                                  run.runId ?? -1;
                                              if (runRevertProvider
                                                  .selectedRunId !=
                                                  -1) {
                                                _showConfirmationDialog(
                                                  context,
                                                  runRevertProvider
                                                      .selectedRunId,
                                                  index,
                                                );
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Please select a run ID first.',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          DataCell(
                                            Text(run.createdAt.toString()),
                                            onTap: () {
                                              runRevertProvider.selectedRunId =
                                                  run.runId ?? -1;
                                              if (runRevertProvider
                                                  .selectedRunId !=
                                                  -1) {
                                                _showConfirmationDialog(
                                                  context,
                                                  runRevertProvider
                                                      .selectedRunId,
                                                  index,
                                                );
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Please select a run ID first.',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          DataCell(
                                            Text(run.updatedAt.toString()),
                                            onTap: () {
                                              runRevertProvider.selectedRunId =
                                                  run.runId ?? -1;
                                              if (runRevertProvider
                                                  .selectedRunId !=
                                                  -1) {
                                                _showConfirmationDialog(
                                                  context,
                                                  runRevertProvider
                                                      .selectedRunId,
                                                  index,
                                                );
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Please select a run ID first.',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          DataCell(
                                            Text(run.ladderCount.toString()),
                                            onTap: () {
                                              runRevertProvider.selectedRunId =
                                                  run.runId ?? -1;
                                              if (runRevertProvider
                                                  .selectedRunId !=
                                                  -1) {
                                                _showConfirmationDialog(
                                                  context,
                                                  runRevertProvider
                                                      .selectedRunId,
                                                  index,
                                                );
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Please select a run ID first.',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          DataCell(
                                            ElevatedButton(
                                              onPressed: () {
                                                if (runRevertProvider
                                                    .selectedRunId !=
                                                    -1) {
                                                  _showConfirmationDialog(
                                                    context,
                                                    runRevertProvider
                                                        .selectedRunId,
                                                    index,
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Please select a run ID first.',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Select',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // child: Row(
                        //   children: [
                        //     // Dropdown Button
                        //     CustomContainer(
                        //       borderColor: Colors.white,
                        //       borderWidth: 1,
                        //       backgroundColor: Colors.transparent,
                        //       width: screenWidth - 110,
                        //       height: 40,
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(left: 8.0, right: 8),
                        //         child: Text("Example"),
                        //       ),
                        //     ),
                        //     const SizedBox(
                        //         width: 16.0), // Spacing between dropdown and button
                        //     // Select Button
                        //     ElevatedButton(
                        //       onPressed: () {
                        //         if (runRevertProvider.selectedRunId != -1) {
                        //           _showConfirmationDialog(
                        //               context, runRevertProvider.selectedRunId);
                        //         } else {
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //               content:
                        //                   Text('Please select a run ID first.'),
                        //             ),
                        //           );
                        //         }
                        //       },
                        //       child: const Text(
                        //         'Select',
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomHomeAppBarWithProviderNew(
                backButton: true,
                widthOfWidget: screenWidth,
                isForPop: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context,
      int selectedRunId,
      int index,
      ) {
    final runRevertProvider = Provider.of<RunRevertProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Confirmation',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to revert to run ${index.toString()}?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                runRevertProvider.revertRunIdOfAUser();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: $selectedRunId')),
                );
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}