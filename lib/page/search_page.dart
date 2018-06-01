import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/api/Api.dart';
import 'package:flutter_gank/ext/constant.dart';
import 'package:flutter_gank/ext/data_repository.dart';
import 'package:flutter_gank/ext/http.dart';
import 'package:flutter_gank/page/post_page.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var listData;

  var searchType = "Android";
  var curPage;
  var keyWord = "";

  ScrollController _controller = new ScrollController();

  _SearchPageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      //&& listData.length < listTotalSize
      if (maxScroll == pixels) {
        // scroll to bottom, get next page data
        print("load more ... ");
        curPage++;
        _doSearch(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _doSearch(false);
  }

  _doSearch(bool isLoadMore) {
    print("doSearchwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
    var url = Api.SEARCH_URL; //listview/category/Android/count/10/page/1
    url += keyWord.toString() +
        '/category/' +
        searchType.toString() +
        '/count/10/page/' +
        curPage.toString();
    print("searchUrl: $url");
    HttpExt.get(url, (data) {
      if (data != null) {
        SearchResponse searchResponse =
            SearchResponse.fromJson(jsonDecode(data));
        if (!searchResponse.error) {
          var _listData = searchResponse.results;
          print(_listData);
          if (_listData.length > 0) {
            setState(() {
              if (!isLoadMore) {
                listData = _listData;
              } else {
                List list1 = new List();
                list1.addAll(listData);
                list1.addAll(_listData);
                listData = list1;
              }
            });
          }
        }
      }
    }, (e) {
      print("get news list error: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('搜索'),
      ),
      body: _buildSearchBody(),
    );
  }

  Widget _buildSearchBody() {
    if (listData == null) {
      return new Center(
        child: new CupertinoActivityIndicator(),
      );
    } else {
      Widget listView = _buildListView(context, listData);
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Widget _buildListView(BuildContext context, List results) {
    print("_buildListView bobobobobobobo");
    print(results);
    switch (results.length) {
      case 1:
        return new Center(
          child: new Card(
            elevation: 16.0,
            child: new Text("暂无数据"),
          ),
        );
      default:
        return new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(2.0),
          controller: _controller,
          itemCount: results == null ? 0 : results.length,
          itemBuilder: (context, i) {
            return _buildRow(context, results[i]);
          },
        );
    }
  }

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    _doSearch(false);
    return null;
  }

  Widget _buildRow(context, one) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline.copyWith(color: Colors.white);

    SearchData searchData = SearchData.fromJson(one);
    print(searchData);
    return new InkWell(
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
            return new PostPage(searchData.toJson());
          }));
        },
        child: new Card(
          margin: new EdgeInsets.all(2.0),
          child: new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 4.0),
                  child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      searchData.desc,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 4.0),
                  child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      searchData.who.toString(),
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.centerLeft,
                      child: new Card(
                          color: tagColors[searchData.type],
                          child: new Padding(
                            padding: new EdgeInsets.all(2.0),
                            child: new Text(
                              one['type'],
                              style: new TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                    new Expanded(
                        child: new Align(
                      alignment: Alignment.centerRight,
                      child: new Text(
                        getTimestampString(
                            DateTime.parse(searchData.publishedAt)),
                        style:
                            new TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
