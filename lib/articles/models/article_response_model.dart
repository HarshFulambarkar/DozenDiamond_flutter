import 'package:dozen_diamond/articles/models/article_model.dart';

class ArticleDataResponse {
  String? message;
  bool? status;
  List<ArticleModel>? data;

  ArticleDataResponse({this.message, this.status, this.data});

  ArticleDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'].toString();
    status = json['status'];
    if (json['data'] != null) {
      data = <ArticleModel>[];
      json['data'].forEach((v) {
        data!.add(new ArticleModel.fromJson(v));
      });
    }
  }
}
