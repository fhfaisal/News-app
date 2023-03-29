import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNo = 1;
  int selectedIndex = 1; // initialize the selected index to -1
  String sortBy="publishedAt";
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var newsProvider = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.only(right: mq.width*.05,),
            width: mq.width*.50,
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                focusedBorder: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(fontSize: 16,color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )

              ),
            ),
          ),]
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: mq.width * .90,
            height: 40,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      onPressed: () {
                        if (pageNo == 1) {
                          return;
                        } else {
                          setState(() {
                            pageNo -= 1;
                            selectedIndex-=1;
                          });
                        }
                      },
                      child: Text("Prev")),
                ),
                Expanded(
                    flex: 4,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        index = index + 1;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex =
                                  index; // update the selected index
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? Colors.redAccent
                                    : Colors.blue,
                                // change color based on selected index
                                borderRadius: BorderRadius.circular(5)),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Center(
                                child: Text(
                                  "${index}",
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      onPressed: () {
                        if (pageNo < 10) {
                          setState(() {
                            pageNo += 1;
                            selectedIndex += 1;
                          });
                        }
                      },
                      child: Text("Next")),
                ),
              ],
            ),
          ),
          DropdownButton(
            alignment:Alignment.center ,
            value: sortBy,
            items: [
              DropdownMenuItem(child: Text("PublishedAt"),
                value: "publishedAt",

              ),
              DropdownMenuItem(child: Text("Relevancy"),
                value: "relevancy",
              ),
              DropdownMenuItem(child: Text("Popularity"),
                value: "popularity",
              ),
            ],
            onChanged: (String?value) {
              setState(() {
                sortBy=value!;
              });
            },

          ),
          Expanded(
            flex: 5,
            child: FutureBuilder<NewsModel>(
                future: newsProvider.getHomeData(pageNo,sortBy),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("sumthing is worng");
                  } else if (snapshot.data == null) {
                    return Text("Data are null");
                  }
                  return ListView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>NewsDetails(articles: snapshot.data!.articles![index],)));
                        },
                        child: Column(
                          children: [
                            Card(
                              child: Container(
                                width: mq.width * .90,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      height: mq.height * .20,
                                      width: mq.width * .90,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        "${snapshot.data!.articles![index].urlToImage}",
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.network(
                                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOmYqa4Vpnd-FA25EGmYMiDSWOl9QV8UN1du_duZC9mQ&s"),
                                        fit: BoxFit.cover,
                                      ),
                                      //Image(image: NetworkImage("${snapshot.data!.articles![index].urlToImage}",))
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${snapshot.data!.articles![index].title}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                          ),
                                          Text(
                                            "${snapshot.data!.articles![index].description}",
                                            maxLines: 3,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Published: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                        "${Jiffy.parse('${snapshot.data!.articles![index].publishedAt}').startOf(Unit.year).yMMMMEEEEd}"),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Source: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                        "${snapshot.data!.articles![index].source!.name}")
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}


