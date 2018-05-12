import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/ext/constant.dart' as ext;
import 'package:flutter_gank/ext/data_repository.dart';

class FeedList extends StatefulWidget {
  final String url;

  FeedList({Key key, this.url})
      :super(key: key);

  @override
  State<StatefulWidget> createState() => new _FeedListState();

}

class _FeedListState extends State<FeedList> {


  List data;

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        child: new FutureBuilder(
            future: ext.get(widget.url),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return ext.buildLoadingIndicator();
                default:
                  if (snapshot.hasError) {
                    return ext.buildExceptionIndicator(snapshot.error);
                  }else {
                    return _buildListView(context, snapshot);
                  }
              }
            }),
        onRefresh: loadData);
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot snapshot) {
    print(snapshot);
    CategoryResponse categoryResponse = CategoryResponse.fromJson(
        jsonDecode(snapshot.data));
    List results = categoryResponse.results;
    switch (results.length) {
      case 1:
        return new Center(
          child: new Card(
            elevation: 16.0,
            child: new Text("暂无数据"),
          ),
        );
      default:
        return ext.buildListViewBuilder(context, results);
    }
  }


  Future<Null> loadData() async {
    await ext.get(widget.url);
    if (!mounted) return;
    setState(() {

    });
  }

}