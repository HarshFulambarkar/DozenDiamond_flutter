// lib/screens/questionnaire_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/stateManagement/progress_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/progress_bar.dart';
import '../../localization/translation_keys.dart';
import '../stateManagement/questionnaire_provider.dart';

class QuestionnaireScreen extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  QuestionnaireScreen(
      {super.key,
        this.isAuthenticationPresent = false,
        required this.updateIndex});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  late ThemeProvider themeProvider;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late ProgressProvider progressProvider;
  late QuestionnaireProvider questionnaireProvider;
  late NavigationProvider navigationProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      progressProvider = Provider.of(context, listen: false);
      progressProvider.updateProgress(0.01);

    });

  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {

    progressProvider = Provider.of<ProgressProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    questionnaireProvider = Provider.of<QuestionnaireProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);

    return SafeArea(
        child: Center(
          child: Stack(
            children: [
              Center(
                  child: Container(
                      color: (themeProvider.defaultTheme)
                          ? Color(0XFFF5F5F5)
                          : Colors.transparent,
                      width: screenWidth,
                      child: Scaffold(
                          drawer: NavDrawerNew(updateIndex: widget.updateIndex),
                          key: _key,
                          backgroundColor: (themeProvider.defaultTheme)
                              ? Color(0XFFF5F5F5)
                              : Color(0xFF15181F),
                          body: Stack(
                            children: [
                              ListView(
                                shrinkWrap: true,
                                children: [

                                  SizedBox(
                                    height: 45,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  (questionnaireProvider.noQuestionnaireFound)
                                      ?buildNoQuestionnaireWidget(context, screenWidth):(questionnaireProvider.showSubmitAnswerWidget)
                                      ?buildResponseSubmittedWidget(context, screenWidth)
                                      :Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16, right: 16.0),
                                            child: ProgressBar(),
                                          ),

                                          SizedBox(
                                            height: 25,
                                          ),

                                          buildAlmostThereSection(context, screenWidth),

                                          SizedBox(
                                            height: 20,
                                          ),

                                          questionnaireSection2(context, screenWidth),

                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),



                                  // questionnaireSection(context, screenWidth),
                                ],
                              ),

                              CustomHomeAppBarWithProviderNew(
                                  backButton: true,
                                backIndex: navigationProvider.previousSelectedIndex,
                                leadingAction: _triggerDrawer,
                              ),
                            ],
                          ))
                  )
              ),
            ],
          ),
        )
    );
  }

  Widget buildAlmostThereSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Row(
            children: [
              Text(
                TranslationKeys.almostThere,
                style: TextStyle(
                  fontFamily: 'Britanica',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 2,
        ),

        Container(
          width: screenWidth - 32,
          child: Text(
            TranslationKeys.completeThisShortQuestionnaireToMoveOneStepCloserToUnlockingRealTimeTradingWithUs,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0).withOpacity(0.6),
            ),
          ),
        )
      ],
    );
  }

  Widget questionnaireSection(BuildContext context, double screenWidth) {
    return Consumer<QuestionnaireProvider>(
      builder: (context, provider, _) {
        if (provider.questions.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        final question = provider.currentQuestion;

        Widget answerInput;
        switch (question.questionType) {
          case 'single_choice':
            answerInput = Column(
              children: question.options!
                  .map((opt) => ListTile(
                title: Text(opt),
                leading: Radio<String>(
                  value: opt,
                  groupValue: null,
                  onChanged: (val) => provider.submitAnswer(val, context),
                ),
              ))
                  .toList(),
            );
            break;

          case 'text':
          default:
            final controller = TextEditingController();
            answerInput = Column(
              children: [
                TextField(controller: controller),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Next'),
                  onPressed: () =>
                      provider.submitAnswer(controller.text.trim(), context),
                ),
              ],
            );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question ${provider.currentIndex + 1} '
                  'of ${provider.questions.length}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text(question.questionTest ?? "", style: TextStyle(fontSize: 18)),
              SizedBox(height: 24),
              answerInput,
            ],
          ),
        );
      },
    );
  }


  Widget questionnaireSection2(BuildContext context, double screenWidth) {
    return Consumer<QuestionnaireProvider>(
        builder: (context, provider, _) {
          if (provider.questions.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          final question = provider.currentQuestion;

          Widget answerInput;
          int index = 0;
          switch (question.questionType) {
            case 'single_choice':
              answerInput = Column(
                children: question.options!
                    .map((opt) {
                      index = index + 1;
                      return buildOptionCard(context, screenWidth, opt, index);
                    })
                  //   ListTile(
                  // title: Text(opt),
                  // leading: Radio<String>(
                  //   value: opt,
                  //   groupValue: null,
                  //   onChanged: (val) => provider.submitAnswer(val),
                  // ),
                // ))
                    .toList(),
              );
              break;

            case 'text':
            default:
              final controller = TextEditingController();
              answerInput = Column(
                children: [
                  TextField(controller: controller),
                  SizedBox(height: 16),
                  // ElevatedButton(
                  //   child: Text('Next'),
                  //   onPressed: () =>
                  //       provider.submitAnswer(controller.text.trim()),
                  // ),
                ],
              );
          }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    size: 14,
                  ),

                  SizedBox(
                    width: 8,
                  ),

                  Container(
                    width: screenWidth * 0.7,
                    child: Text(
                      question.questionTest ?? "-",
                      // "What does STM stand for?",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 8,
            ),

            answerInput,

            SizedBox(
              height: 25,
            ),

            buildBottomButtons(context, screenWidth)
          ],
        );
      }
    );
  }

  Widget buildOptionCard(BuildContext context, double screenWidth, String option, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4.0, bottom: 4),
      child: CustomContainer(
        onTap: () {
          questionnaireProvider.selectOptionAnswer = index;
          questionnaireProvider.selectedAnswer = option;
        },
        borderRadius: 10,
        paddingEdge: EdgeInsets.zero,
        padding: 0,
        margin: EdgeInsets.zero,
        backgroundColor: (questionnaireProvider.selectOptionAnswer == index)
            ?(themeProvider.defaultTheme)?Color(0xffbedaf0):Color(0xff1a94f2)
            :(themeProvider.defaultTheme)?Color(0xffffffff):Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${String.fromCharCode(65 + index-1)}. ",
                // "A. ",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  // color: (themeProvider.defaultTheme)?Colors.black:Color(0xffA2B0BC),
                  color: (questionnaireProvider.selectOptionAnswer == index)
                      ?(themeProvider.defaultTheme)?Color(0xff141414):Color(0xffffffff)
                      :(themeProvider.defaultTheme)?Color(0xff141414):Color(0xffA2B0BC),
                ),
              ),

              Container(
                width: screenWidth * 0.7,
                child: Text(
                  option,
                  // "Stock Timing Mechanism",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    // color: (themeProvider.defaultTheme)?Colors.black:Color(0xffffffff),
                    color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xffffffff),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomButtons(BuildContext context, double screenWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            if(questionnaireProvider.currentIndex == 0) {
              navigationProvider.selectedIndex = navigationProvider.previousSelectedIndex;
            } else {
              questionnaireProvider.currentIndex--;
              questionnaireProvider.selectedAnswer = "";
              questionnaireProvider.selectOptionAnswer = 100;
              progressProvider.updateProgress(questionnaireProvider.currentIndex/questionnaireProvider.questions.length);
            }
          },
          child: Text(
            "Back",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16.5,
                color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0)
            ),
          ),
        ),

        SizedBox(
          width: 25,
        ),
        //
        CustomContainer(
          backgroundColor: (themeProvider.defaultTheme)
              ?Colors.black
              :Color(0xfff0f0f0),
          borderRadius: 12,
          paddingEdge: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          padding: 0,
          onTap: () {
            if(questionnaireProvider.selectedAnswer != ""){
              questionnaireProvider.submitAnswer(questionnaireProvider.selectedAnswer, context);
              progressProvider.updateProgress(questionnaireProvider.currentIndex/questionnaireProvider.questions.length);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Select answer"),
                ),
              );
            }

          },
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 8, bottom: 8.0),
            child: Text(
              (questionnaireProvider.currentIndex == (questionnaireProvider.questions.length -1))?"Submit":"Next",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.5,
                  color: (themeProvider.defaultTheme)
                      ?Color(0xfff0f0f0)
                      :Color(0xff1a1a25)
              ),
            ),
          ),
        ),

        SizedBox(
          width: 18,
        ),
      ],
    );
  }

  Widget buildResponseSubmittedWidget(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (questionnaireProvider.submitAnswerData.status == "" || questionnaireProvider.submitAnswerData.status == null)
                ?Container()
                :(questionnaireProvider.submitAnswerData.status!.toLowerCase() == "failed")
                ?Icon(
                  Icons.clear,
                  size: 100,
                  color: Colors.red,
                ):Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Color(0xff1a94f2),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "Real Trading Enabled Successfully",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                        color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                      ),
                    ),
                  ],
                ),

            Text(
              TranslationKeys.responseSubmitted,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                Text(
                  "Status: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                  ),
                ),

                SizedBox(
                  width: 10,
                ),

                Text(
                  questionnaireProvider.submitAnswerData.status ?? "-",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 3,
            ),

            Row(
              children: [
                Text(
                  "Correct Answer: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                  ),
                ),

                SizedBox(
                  width: 10,
                ),

                Text(
                  (questionnaireProvider.submitAnswerData.correctAnswers == null)
                      ?""
                      :questionnaireProvider.submitAnswerData.correctAnswers.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 3,
            ),

            Row(
              children: [
                Text(
                  "Incorrect Answer: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                  ),
                ),

                SizedBox(
                  width: 10,
                ),

                Text(
                  (questionnaireProvider.submitAnswerData.incorrectAnswers == null)
                      ?""
                      :questionnaireProvider.submitAnswerData.incorrectAnswers.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),

            CustomContainer(
              backgroundColor: (themeProvider.defaultTheme)
                  ?Colors.black
                  :Color(0xfff0f0f0),
              borderRadius: 12,
              paddingEdge: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              padding: 0,
              onTap: () {

                navigationProvider.previousSelectedIndex = navigationProvider.selectedIndex;
                navigationProvider.selectedIndex = 0;
                questionnaireProvider.showSubmitAnswerWidget = false;

              },
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 8, bottom: 8.0),
                child: Text(
                  "Okay",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.5,
                      color: (themeProvider.defaultTheme)
                          ?Color(0xfff0f0f0)
                          :Color(0xff1a1a25)
                  ),
                ),
              ),
            ),




          ],
        ),
      ],
    );
  }

  Widget buildNoQuestionnaireWidget(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.clear,
              size: 100,
              color: Colors.red,
            ),

            Text(
              TranslationKeys.noQuestionnaireFound,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            CustomContainer(
              backgroundColor: (themeProvider.defaultTheme)
                  ?Colors.black
                  :Color(0xfff0f0f0),
              borderRadius: 12,
              paddingEdge: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              padding: 0,
              onTap: () {

                navigationProvider.selectedIndex = navigationProvider.previousSelectedIndex;
                questionnaireProvider.showSubmitAnswerWidget = false;
                questionnaireProvider.noQuestionnaireFound = false;

              },
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 8, bottom: 8.0),
                child: Text(
                  "Okay",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.5,
                      color: (themeProvider.defaultTheme)
                          ?Color(0xfff0f0f0)
                          :Color(0xff1a1a25)
                  ),
                ),
              ),
            ),




          ],
        ),
      ],
    );
  }

}
