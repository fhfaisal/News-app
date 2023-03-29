import 'dart:convert';

import 'package:http/http.dart'as http;

import '../model/news_model.dart';
class CustomHttpRequest{
 static Future<NewsModel> fetchHomeData(int pageNo, String sortBy) async {
    NewsModel? newsModel;
    var url =
        "https://newsapi.org/v2/everything?q=football&pageSize=10&page=${pageNo}&sortBy=${sortBy}&apiKey=5f0d1f9801a7498292e808d38b2d1428";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    newsModel = NewsModel.fromJson(data);
    return newsModel!;
  }
}