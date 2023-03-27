import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/model/news_model.dart';

class HomePage extends StatelessWidget {
  NewsModel? newsModel;
  var url =
      "https://newsapi.org/v2/everything?q=football&pageSize=15&apiKey=5f0d1f9801a7498292e808d38b2d1428";

  Future<NewsModel> fetchHomeData() async {
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    newsModel = NewsModel.fromJson(data);
    return newsModel!;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            FutureBuilder<NewsModel>(
                future: fetchHomeData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("sumthing is worng");
                  } else if (snapshot.data==null){
                    return Text("Data are null");
                  }
                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        print("this is${snapshot.data!.articles!.length}");
                        return

                          ListTile(
                            title: Text(snapshot.data!.articles![index].title!));
                    },),
                  );
                }
                )
          ],
        ),
      ),
    );
  }
}
