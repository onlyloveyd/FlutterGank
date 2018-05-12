import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/ext/constant.dart' as ext;
import 'package:flutter_gank/page/post_page.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parse;

class ArticlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ArticlePageState();
}

class ArticlePageState extends State<ArticlePage> {
  // TODO: implement build
  List<Post> mPost;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mPost = new List();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text("匠心写作")),
      body: new FutureBuilder(
          future: getPostHtml(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return new Center(
                    child: ext.buildLoadingIndicator());

              default:
                if (snapshot.hasError) {
                  return ext.buildExceptionIndicator('网络请求错误');
                } else {
                  var html = snapshot.data;
                  var document = parse.parse(html);
                  List<dom.Element> container = document.getElementsByClassName(
                      "u-full-width");
                  List<dom.Element> elements = container[0]
                      .getElementsByClassName("title");
                  List<dom.Element> times = container[0].getElementsByClassName(
                      "time");

                  mPost.clear();
                  elements.forEach((element) {
                    List<dom.Element> head = element.getElementsByTagName('a');
                    List<dom.Element> author = element.getElementsByTagName(
                        'small');
                    print(head[0].text);
                    print("http://gank.io/" + head[0].attributes['href']);
                    print(author[0].text.replaceAll('\(', '').replaceAll(
                        '\)', ''));
                    print(times[elements.indexOf(element)].text);
                    mPost.add(new Post(
                        head[0].text, times[elements.indexOf(element)].text,
                        author[0].text.replaceAll('\(', '').replaceAll(
                            '\)', ''),
                        "http://gank.io/" + head[0].attributes['href']));
                  });
                  return _createPostList();
                }
            }
          }
      ),);
  }

  Widget _createPostList() {
    return new ListView.builder(
        itemCount: mPost.length,
        itemBuilder: (context, index) {
          return _buildPostRow(mPost[index]);
        });
  }

  Widget _buildPostRow(Post data) {
    return
      new InkWell(
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
                return new PostPage(data.toJson());
              }));
        },
        child:
        new Card(
          margin: new EdgeInsets.all(2.0),
          child: new Padding(padding: new EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 4.0),
                  child:
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(data.desc,
                      style: new TextStyle(fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),),
                  ),),
                new Container(
                  margin: const EdgeInsets.fromLTRB(2.0, 10.0, 10.0, 4.0),
                ),
                new Row(
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(data.who, style: new TextStyle(
                          fontSize: 12.0, color: Colors.grey)),
                    ),
                    new Expanded(child:
                    new Align(
                      alignment: Alignment.centerRight,
                      child: new Text(data.publishAt),
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }

  Future<String> getPostHtml() async
  {
    var httpClient = new HttpClient();
    final url = 'http://gank.io/post/published';
    var request = await
    httpClient.getUrl(Uri.parse(url));
    var response = await
    request.close();
    return await
    response.transform(utf8.decoder).join();
  }

  Widget _buildLoadingIndicator() {
    return new Center(
      child: new Card(
        elevation: 4.0,
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          new Wrap(
            direction: Axis.vertical,
            spacing: 8.0,
            children: <Widget>[
              new CupertinoActivityIndicator(),
              new Text('正在加载中...'),
            ],
            crossAxisAlignment: WrapCrossAlignment.center,
          ),),),
    );
  }


}

class Post {

  String publishAt;
  String url;
  String desc;
  String who;

  Post(this.desc, this.publishAt, this.who, this.url);

  Map<String, dynamic> toJson() =>
      {
        "desc": desc,
        "publishAt": publishAt,
        "who": who,
        "url": url
      };

}