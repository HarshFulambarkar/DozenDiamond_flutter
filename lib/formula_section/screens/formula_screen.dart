import 'package:flutter/material.dart';

import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';

class FormulaScreen extends StatefulWidget {
  @override
  State<FormulaScreen> createState() => _FormulaScreenState();
}

class _FormulaScreenState extends State<FormulaScreen> {
  bool showFormula = false;
  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {
        showFormula = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: screenWidth == 0 ? null : screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                      ),
                      // SizedBox(
                      //   height: AppBar().preferredSize.height * 1.5,
                      // ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: Text(
                          "Formulas",
                          style: TextStyle(
                              fontSize: 25,
                              color: Color(0xFFffffff),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // buildFormulaSection(context),

                      // Container(
                      //   height: 20,
                      //   width: 20,
                      //   color: Colors.red
                      // ),

                      //         TeXView(
                      //           renderingEngine: TeXViewRenderingEngine.mathjax(),
                      //           child: TeXViewDocument(
                      //             r"""
                      // <p>The formula for calculating extra cash is:</p>
                      // $$\text{Extra Cash} =  \frac{\text{Order Size} \times \text{Step Size}}{2}$$
                      // """,
                      //             style: TeXViewStyle(
                      //               padding: TeXViewPadding.all(10),
                      //               fontStyle: TeXViewFontStyle(
                      //
                      //               ),
                      //               backgroundColor: Colors.white,
                      //             ),
                      //           ),
                      //         ),

                      (showFormula)
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: TeXView(


                                // renderingEngine:
                                //     TeXViewRenderingEngine.mathjax(),
                                child: TeXViewDocument(
                                  r"""
                          <html>
        <head>
          <style>
            body {
              background-color: black; /* Set the background color to black */
              color: white; /* Set the text color to white */
              font-family: Arial, sans-serif; /* Optional: specify a font family */
            }
          </style>
        </head>
        <body>
<!--              <p>1. calculate \( K \):</p>-->
              <p>1. calculate \( K \):</p>
              $$K = \frac{\text{Target Price}}{\text{Initial Buy Price}}$$
              <hr>
              <br>
<!--              <p>2. calculate extra cash:</p>-->
<!--              <hr>-->
<!--              <br>-->
              <p>2. calculate extra cash:</p>
              $$\text{Extra Cash} =  \frac{\text{Order Size} \times \text{Step Size}}{2}$$
              <hr>
              <br>
<!--              <p>3. calculate Initial Buy Cash:</p>-->
<!--              <hr>-->
<!--              <br>-->
              <p>3. calculate Initial Buy Cash:</p>
              $$\text{Initial Buy Cash} = \text{Cash allocated} \cdot \frac{2k - 2}{2k - 1}$$
              <hr>
              <br>
<!--              <p>4. calculate Initial Buy Quantity:</p>-->
<!--              <hr>-->
<!--              <br>-->
              <p>4. calculate Initial Buy Quantity:</p>
              $$\text{Initial Buy Quantity} = \left\lfloor \frac{\text{Initial Buy Cash}}{\text{Initial Buy Price}} \right\rfloor$$
              <hr>
              <br>
<!--              <p>5. calculate Actual Initial Buy Cash:</p>-->
<!--              <hr>-->
<!--              <br>-->
              <p>5. calculate Actual Initial Buy Cash:</p>
              $$\text{Actual Initial Buy Cash} = \text{Initial Buy Quantity} \times \text{Initial Buy Price}$$
              <hr>
              <br>
<!--              <p>6. calculate Order Size:</p>-->
<!--              <hr>-->
<!--              <br>-->
              <p>6. calculate Order Size:</p>
              $$\text{Order Size} = \frac{\text{Initial Buy Quantity}}{\text{Number of Steps above}}$$
              <hr>
              <br>
<!--              <p>7. calculate Step Size:</p>-->
<!--              <hr>-->
<!--              <br>-->
              <p>7. calculate Step Size:</p>
              $$\text{Step Size} = \left\lfloor \frac{\text{Target Price} - \text{Initial Buy Price}}{\text{Number of Steps above}} \right\rfloor$$
              <hr>
              <br>
<!--              <p>8. calculate Number of Steps Below:</p>-->
<!--              <hr>-->
<!--              <br>-->
              <p>8. calculate Number of Steps Below:</p>
              $$\text{Number of Steps Below} = \frac{\text{Initial Buy Price}}{\text{Step Size}}$$
              <hr>
              <br>
<!--              <p>9. calculate Cash Needed:</p>-->
<!--              <hr>-->
<!--              <br>-->
              <p>9. calculate Cash Needed:</p>
              $$\text{Cash Needed} = \frac{\text{Current Price}}{2} \times \text{Number of Steps Below} \times \text{Order Size}$$
              </body>
      </html>""",
                                  style: TeXViewStyle(
                                    padding: TeXViewPadding.all(10),
                                    fontStyle: TeXViewFontStyle(),
                                    backgroundColor: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              CustomHomeAppBarWithProviderNew(
                backButton: true,
                widthOfWidget: screenWidth,
                isForPop:
                    true, //these leadingAction button is not working, I have tired making it work, but it isn't.
              )
            ],
          ),
        ),
      ),
    );
  }
}
