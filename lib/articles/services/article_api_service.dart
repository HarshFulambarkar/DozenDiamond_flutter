import 'dart:convert';
import 'dart:developer';

import 'package:dozen_diamond/articles/models/article_response_model.dart';
import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:http/http.dart' as http;

class ArticleRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;
  static const baseurl_version_v2 = ApiConstant.baseurl_version_v2;
  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<ArticleDataResponse> getArticles() async {
    try {
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

     var url = Uri.parse("${baseurl_version_v2}blog");
     // var url = Uri.parse('https://dqwh49qv-3001.inc1.devtunnels.ms/v2/blog');

      var response = await http.get(url);

      print(url);
      log(response.body);

      if (httpStatusChecker(response)) {
        return ArticleDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
