import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/ext/data_repository.dart';


final String CATEGORY_URL_PREFIX =  'http://gank.io/api/data/';

String generateCategoryUrl(feedType, pageSize, pageNum) {
  return CATEGORY_URL_PREFIX + feedType + '/' + pageSize.toString() + '/' + pageNum.toString();
}


final Map<String, Color> tagColors = {
  'Android': const Color(0xff94859c),
  'iOS': const Color(0xff5b6356),
  '前端': const Color(0xffca8269),
  '瞎推荐': const Color(0xff9d3d3f),
  '拓展资源': const Color(0xffe4dc8b),
  '福利': const Color(0xffe5acbf),
  'App': const Color(0xff772f09),
  '休息视频': const Color(0xffa6c7b2),
};

Future<String> get(String url) async {
  var httpClient = new HttpClient();
  print(url);
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  return await response.transform(utf8.decoder).join();
}

Widget buildDailyListView(BuildContext context, AsyncSnapshot snapshot) {
  Map<String, dynamic> value;
  List content = new List();
  value = jsonDecode(snapshot.data);
  DailyResponse response = DailyResponse.fromJson(value);

  if (response.error) {
    return buildExceptionIndicator("网络请求错误");
  } else {
    if (response.category.length == 0) {
      return buildExceptionIndicator("这里空空的什么都没有呢...");
    } else {
      response.category.forEach((row) {
        content.addAll(response.results[row]);
      });
      print(content);
      return buildListViewBuilder(context, content);
    }
  }
}

Widget buildCategoryListView(BuildContext context, AsyncSnapshot snapshot) {
  print(snapshot);
  CategoryResponse categoryResponse = CategoryResponse.fromJson(
      jsonDecode(snapshot.data));
  List results = categoryResponse.results;

  if (categoryResponse.error) {
    return buildExceptionIndicator("网络请求错误");
  } else {
    if (categoryResponse.results.length == 0) {
      return buildExceptionIndicator("这里空空的什么都没有呢...");
    } else {
      return buildListViewBuilder(context, results);
    }
  }


  switch (results.length) {
    case 0:
      return new Center(
        child: new Card(
          elevation: 16.0,
          child: new Text("暂无数据"),
        ),
      );
    default:
      return buildListViewBuilder(context, results);
  }
}

Widget buildListViewBuilder(context, List content) {
  return new ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(2.0),
    itemCount: content == null ? 0 : content.length,
    itemBuilder: (context, i) {
      return buildRow(context, content[i]);
    },);
}

Widget buildRow(context, one) {
  final ThemeData theme = Theme.of(context);
  final TextStyle titleStyle = theme.textTheme.headline.copyWith(
      color: Colors.white);

  PostData postData = PostData.fromJson(one);
  print(postData);
  if (postData.type == '福利') {
    return new Card(
      margin: new EdgeInsets.all(2.0),
      child: new Padding(padding: new EdgeInsets.all(8.0),
          child:
          new SizedBox(
            height: 300.0,
            child: new Stack(
              children: <Widget>[
                new Positioned.fill(
                    child:
                    new FadeInImage.assetNetwork(
                      placeholder: 'empty_data.png',
                      image: postData.url,
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.repeat,)
                ),
                new Positioned(
                  bottom: 6.0,
                  left: 6.0,
                  right: 6.0,
                  child: new FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomLeft,
                    child: new Text(postData.desc,
                      style: titleStyle,
                    ),
                  ),
                ),
              ],
            ),
          )
      ),);
  } else {
    return
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
                  child: new Text(postData.desc,
                    style: new TextStyle(fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),),
                ),),
              new Container(
                margin: new EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 4.0),
                child: new Align(
                  alignment: Alignment.centerLeft,
                  child: new Text(postData.who.toString(),
                    style: new TextStyle(
                        fontSize: 12.0, color: Colors.grey),),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.centerLeft,
                    child:
                    new Card(
                        color: tagColors[postData.type],
                        child:
                        new Padding(padding: new EdgeInsets.all(2.0),
                          child: new Text(one['type'],
                            style: new TextStyle(color: Colors.white),),
                        )
                    ),
                  ),
                  new Expanded(child:
                  new Align(
                    alignment: Alignment.centerRight,
                    child: new Text(postData.publishedAt),
                  )),
                ],
              )
            ],
          ),
        ),
      );
  }
}

Widget buildExceptionIndicator(String message) {
  return new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new Align(
        alignment: Alignment.center,
        child: new Image.asset('images/empty_data.png'),
      ),
      new Align(
        alignment: Alignment.center,
        child: new Text(message, style: const TextStyle(color: Colors.grey),),
      )
    ],);
}

Widget buildLoadingIndicator() {
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

