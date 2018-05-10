import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FeedHomeState();
}

class FeedHomeState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new TabBar(
        controller: _controller,
        isScrollable: true,
        tabs: _allPages.map((_Page page) {
          return new Tab(text: page.text);
        }).toList(),
      ),
      body: new TabBarView(controller: _controller,
          children: _allPages.map((_Page page) {
            return page.feedList;
          }).toList()),
    );
  }
}


class FeedList extends StatefulWidget{
  final String feedType;
  final int pageSize;
  final int pageNum;

  FeedList({Key key, this.feedType, this.pageSize, this.pageNum}):super(key:key);

  @override
  State<StatefulWidget> createState() => new _FeedListState();

}

class _FeedListState extends State<FeedList> {

  final String _url = 'http://gank.io/api/data/';

  List data;

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        child: new FutureBuilder(future: get(widget.feedType, widget.pageSize, widget.pageNum),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(
                    child: new Card(
                      child: new Text('loading'),
                    ),
                  );
                default:
                  if(snapshot.hasError) {
                    return new Text('Error:${snapshot.error}');
                  } else {
                    return createListView(context, snapshot);
                  }
              }
            }),
        onRefresh: loadData);
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    print(snapshot);
    List value;
    value =jsonDecode(snapshot.data)['error']?['']:jsonDecode(snapshot.data)['results'];
    print(value);
    return new Text("hello");
  }

  Future<String> get(String type, int pageSize, int pageNum ) async {
    var httpClient = new HttpClient();
    String current = _url  + type + '/' + pageSize.toString() + '/' + pageNum.toString();
    print(current);
    var request = await httpClient.getUrl(Uri.parse(current));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<Null> loadData() async {
    await get(widget.feedType, widget.pageSize , widget.pageNum);
    if(!mounted) return;
    setState(() {

    });
  }

}

class _Page {
  _Page({
    this.icon,
    this.text,
    this.feedList
  });

  final IconData icon;
  final String text;
  final FeedList feedList;
}
// 存储所有页面的列表
final List<_Page> _allPages = <_Page>[
  new _Page(text: "all", feedList:new FeedList(feedType: 'all',pageSize: 10, pageNum: 0)),
  new _Page(text: "Android",feedList:new FeedList(feedType: 'Android',pageSize: 10, pageNum: 0)),
  new _Page(text: "瞎推荐",feedList:new FeedList(feedType: '瞎推荐',pageSize: 10, pageNum: 0)),
  new _Page(text: "iOS",feedList:new FeedList(feedType: 'iOS',pageSize: 10, pageNum: 0)),
  new _Page(text: "前端",feedList:new FeedList(feedType: '前端',pageSize: 10, pageNum: 0)),
  new _Page(text: "拓展资源",feedList:new FeedList(feedType: '拓展资源',pageSize: 10, pageNum: 0)),
  new _Page(text: "App",feedList:new FeedList(feedType: 'App',pageSize: 10, pageNum: 0)),
  new _Page(text: "休息视频",feedList:new FeedList(feedType: '休息视频',pageSize: 10, pageNum: 0)),
  new _Page(text: "福利",feedList:new FeedList(feedType: '福利',pageSize: 10, pageNum: 0)),
];
