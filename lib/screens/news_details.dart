import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:news_app/model/news_model.dart';

class NewsDetails extends StatelessWidget {
  NewsDetails({Key? key, this.articles}) : super(key: key);
  Articles? articles;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${articles!.author}"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: mq.height * .25,
                width: mq.width * 1,
                child: CachedNetworkImage(
                  imageUrl: "${articles!.urlToImage}",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOmYqa4Vpnd-FA25EGmYMiDSWOl9QV8UN1du_duZC9mQ&s"),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  height: mq.height * .25,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                        Colors.black,
                        Colors.black38,
                        Colors.black26,
                        Colors.black12,
                        Colors.transparent
                      ])),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Flexible(
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: mq.width * 1,
                            color: Colors.black.withOpacity(0.5),
                            child: Text(
                              "${articles!.title}",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ))),
            ],
          ),
          Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    "${Jiffy.parse('${articles!.publishedAt}').startOf(Unit.year).yMMMMEEEEd}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Descriptions",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
                      Text(
                        "${articles!.description}",
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Content",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
                      Text(
                        "${articles!.content}",
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
