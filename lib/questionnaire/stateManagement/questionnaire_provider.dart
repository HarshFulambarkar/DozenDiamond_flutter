import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../Settings/models/switching_trading_mode_request.dart';
import '../../Settings/services/settings_rest_api_service.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../model/answer_data.dart';
import '../model/question_data.dart';
import '../model/question_data_response.dart';
import '../model/submit_answer_data.dart';
import '../model/submit_answer_data_response.dart';
import '../services/questionnaire_api_service.dart';

class QuestionnaireProvider extends ChangeNotifier {
  QuestionnaireProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  bool _noQuestionnaireFound = false;

  bool get noQuestionnaireFound => _noQuestionnaireFound;

  set noQuestionnaireFound(bool value) {
    _noQuestionnaireFound = value;
    notifyListeners();
  }

  bool _showSubmitAnswerWidget = false;

  bool get showSubmitAnswerWidget => _showSubmitAnswerWidget;

  set showSubmitAnswerWidget(bool value) {
    _showSubmitAnswerWidget = value;
    notifyListeners();
  }

  SubmitAnswerData _submitAnswerData = SubmitAnswerData();

  SubmitAnswerData get submitAnswerData => _submitAnswerData;

  set submitAnswerData(SubmitAnswerData value) {
    _submitAnswerData = value;
    notifyListeners();
  }

  int _selectOptionAnswer = 100;

  int get selectOptionAnswer => _selectOptionAnswer;

  set selectOptionAnswer(int value) {
    _selectOptionAnswer = value;
    notifyListeners();
  }

  String _selectedAnswer = "";

  String get selectedAnswer => _selectedAnswer;

  set selectedAnswer(String value) {
    _selectedAnswer = value;
    notifyListeners();
  }

  List<QuestionData> _questions = [];
  List<Answer> _answers = [];
  int _currentIndex = 0;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  List<QuestionData> get questions => _questions;
  int get currentIndex => _currentIndex;
  QuestionData get currentQuestion => _questions[_currentIndex];

  Future<void> loadQuestions() async {
    // final data = await rootBundle.loadString('assets/questions.json');
    // final data =
    // '''
    //   [
    //     {
    //       "id": 9,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 10,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 11,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 12,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 13,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 14,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 15,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 1,
    //       "text": "What is your favorite color?",
    //       "type": "text"
    //     },
    //     {
    //       "id": 2,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 3,
    //       "text": "What is your favorite color?",
    //       "type": "text"
    //     },
    //     {
    //       "id": 4,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 5,
    //       "text": "What is your favorite color?",
    //       "type": "text"
    //     },
    //     {
    //       "id": 6,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     },
    //     {
    //       "id": 7,
    //       "text": "What is your favorite color?",
    //       "type": "text"
    //     },
    //     {
    //       "id": 8,
    //       "text": "Choose your preferred pet:",
    //       "type": "single_choice",
    //       "options": ["Dog", "Cat", "Bird", "Fish"]
    //     }
    //   ]
    // ''';
    // final List<dynamic> jsonList = json.decode(data);
    // _questions = jsonList.map((e) => QuestionData.fromJson(e)).toList();

    noQuestionnaireFound = false;
    showSubmitAnswerWidget = false;
    try {
      QuestionDataResponse? res =
      await QuestionnaireRestApiService().fetchQuestionnaire();

      if (res.status!) {
        _questions = res.data ?? [];
        noQuestionnaireFound = false;
        // otpResponse = res;
        // Fluttertoast.showToast(msg: res.message ?? "");

      } else {
        _questions = [];
        noQuestionnaireFound = true;
      }
      notifyListeners();
    } catch (e) {
      print("came hrer");
      noQuestionnaireFound = true;
      throw e;
    }

  }

  void submitAnswer(dynamic response, BuildContext context) {

    try {

      final qId = currentQuestion.quesId ?? 0;
      _answers.removeWhere((a) => a.questionId == qId);
      _answers.add(Answer(questionId: qId, selectedOptionIndex: selectOptionAnswer));

      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        // All questions answered

        _onComplete(context);
      }
      selectedAnswer = "";
      selectOptionAnswer = 100;
      notifyListeners();

    } catch (e) {
      throw e;
    }
    // Save or update the answer for the current question

  }

  Future<void> _onComplete(BuildContext context) async {

    try {
      showSubmitAnswerWidget = true;
      submitAnswerData = SubmitAnswerData();
      _currentIndex = 0;

      List<Map<String, dynamic>> result = _answers.map((a) => a.toJson()).toList();
      final jsonString = json.encode(result);
      // TODO: send jsonString to your backend or handle it as needed
      log('Final submission: $jsonString');
      Map<String, dynamic> data = {
        "userResponse": result,
      };

      SubmitAnswerDataResponse? res = await QuestionnaireRestApiService().submitAnswer(data);

      if(res.status!) {
        submitAnswerData = res.data!;
        showSubmitAnswerWidget = true;
        print("before WidgetsBinding");
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          print("inside WidgetsBinding");


          if(submitAnswerData.status?.toLowerCase() == "passed") {

            // await SettingRestApiService().switchingTradeMode(
            //     SwitchingTradingModeRequest(tradingMode: "REAL"));

            // TradeMainProvider tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: false);
            // tradeMainProvider.getTradeMenuButtonsVisibilityStatus();

          }


          print("after switching trade mode");
          UserConfigProvider userConfigProvider = Provider.of<UserConfigProvider>(context, listen: false);
          userConfigProvider.getUserConfigData();

          print("after getUserConfigData");
        });

      } else {
        showSubmitAnswerWidget = true;
      }
    } catch (e) {
      throw e;
    }

  }
}
