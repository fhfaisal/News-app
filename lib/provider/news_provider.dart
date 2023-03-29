import 'package:flutter/material.dart';
import 'package:news_app/http/custom_http.dart';
import 'package:provider/provider.dart';

import '../model/news_model.dart';
class NewsProvider with ChangeNotifier{
  NewsModel? newsModel;
  Future<NewsModel>getHomeData(int pageNo,String sortBy)async{
    newsModel=await CustomHttpRequest.fetchHomeData(pageNo,sortBy);
    return newsModel!;
  }
}