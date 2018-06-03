import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/api/Api.dart';
import 'package:flutter_gank/ext/constant.dart' as ext;
import 'package:flutter_gank/ext/data.dart';
import 'package:flutter_gank/ext/http.dart';

// ignore: must_be_immutable
class FeedList extends StatefulWidget {
  String feedType;

  FeedList({Key key, this.feedType}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _FeedListState();
}

class _FeedListState extends State<FeedList> {
  var listData;
  var curPage = 1;
  var listTotalSize = 0;
  ScrollController _controller = new ScrollController();

  //List data;

  _FeedListState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      //&& listData.length < listTotalSize
      if (maxScroll == pixels ) {
        // scroll to bottom, get next page data
        print("load more ... ");
        curPage++;
        getNewsList(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getNewsList(false);
  }

  getNewsList(bool isLoadMore) {
    var url = Api.FEED_URL;
    url += widget.feedType + '/10/' + this.curPage.toString();
    print("feedListUrl: $url");
    HttpExt.get(url, (data) {
      if (data != null) {
        CategoryResponse categoryResponse =
            CategoryResponse.fromJson(jsonDecode(data));
        if (!categoryResponse.error) {
          var _listData = categoryResponse.results;
          print(_listData);
          if(_listData.length>0) {
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
    print(listData);
    if (listData == null) {
      return new Center(
        child:  new CupertinoActivityIndicator(),
      );
    } else {
      Widget listView = _buildListView(context, listData);
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Widget _buildListView(BuildContext context, List results) {
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
            return ext.buildRow(context, results[i]);
          },);
    }
  }

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    getNewsList(false);
    return null;
  }
}
