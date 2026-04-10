import 'package:dozen_diamond/articles/models/article_model.dart';
import 'package:dozen_diamond/articles/models/article_response_model.dart';
import 'package:dozen_diamond/articles/services/article_api_service.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ArticleProvider extends ChangeNotifier {
  List<ArticleModel> _articleList = [];

  List<ArticleModel> get articleList => _articleList;

  set articleList(List<ArticleModel> value) {
    _articleList = value;
    notifyListeners();
  }

  Map<String, bool> _isExpanded = {};

  Map<String, bool> get isExpanded => _isExpanded;

  set isExpanded(Map<String, bool> value) {
    _isExpanded = value;
    notifyListeners();
  }

  bool isGettingArticles = false;
  Future<bool> getArticles() async {
    isGettingArticles = true;
    notifyListeners();
    try {
      ArticleDataResponse res = await ArticleRestApiService().getArticles();
      print("getarticles");
      print(res);
      if (res.status == true) {
      _articleList.clear();
      _articleList = res.data ?? [];

      _articleList.forEach((article) {
        isExpanded[article.id] = false;
      });
      return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: err.toString());
      return false;
    } finally {
      isGettingArticles = false;
      notifyListeners();
    }
  }
}
