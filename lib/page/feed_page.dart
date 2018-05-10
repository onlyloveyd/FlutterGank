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


class FeedList extends StatefulWidget {
  final String feedType;
  final int pageSize;
  final int pageNum;

  FeedList({Key key, this.feedType, this.pageSize, this.pageNum})
      :super(key: key);

  @override
  State<StatefulWidget> createState() => new _FeedListState();

}

class _FeedListState extends State<FeedList> {

  final String _url = 'http://gank.io/api/data/';

  List data;

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        child: new FutureBuilder(
            future: get(widget.feedType, widget.pageSize, widget.pageNum),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(
                    child: new Card(
                      child: new Text('loading'),
                    ),
                  );
                default:
                  if (snapshot.hasError) {
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
    value = jsonDecode(snapshot.data)['error'] ? [''] : jsonDecode(
        snapshot.data)['results'];
    switch (value.length) {
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
          itemCount: value == null ? 0 : value.length,
          itemBuilder: (context, i) {
            return _buildRow(value[i]);
          },);
    }
  }

  Widget _buildRow(one) {
    print(widget.feedType);
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
                  child: new Text(one['desc'],
                    style: new TextStyle(fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),),
                ),),
              new Container(
                margin: new EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 4.0),
                child: new Align(
                  alignment: Alignment.centerLeft,
                  child: new Text(one['who'].toString(),
                    style: new TextStyle(fontSize: 12.0, color: Colors.grey),),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.centerLeft,
                    child:
                    new Card(
                        color: tagColors[one['type']],
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
                    child: new Text(one['publishedAt']),
                  )),
                ],
              )
            ],
          ),
        ),
      );
  }

  Future<String> get(String type, int pageSize, int pageNum) async {
    var httpClient = new HttpClient();
    String current = _url + type + '/' + pageSize.toString() + '/' +
        pageNum.toString();
    print(current);
    var request = await httpClient.getUrl(Uri.parse(current));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<Null> loadData() async {
    await get(widget.feedType, widget.pageSize, widget.pageNum);
    if (!mounted) return;
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
  new _Page(text: "all",
      feedList: new FeedList(feedType: 'all', pageSize: 10, pageNum: 0)),
  new _Page(text: "Android",
      feedList: new FeedList(feedType: 'Android', pageSize: 10, pageNum: 0)),
  new _Page(text: "瞎推荐",
      feedList: new FeedList(feedType: '瞎推荐', pageSize: 10, pageNum: 0)),
  new _Page(text: "iOS",
      feedList: new FeedList(feedType: 'iOS', pageSize: 10, pageNum: 0)),
  new _Page(text: "前端",
      feedList: new FeedList(feedType: '前端', pageSize: 10, pageNum: 0)),
  new _Page(text: "拓展资源",
      feedList: new FeedList(feedType: '拓展资源', pageSize: 10, pageNum: 0)),
  new _Page(text: "App",
      feedList: new FeedList(feedType: 'App', pageSize: 10, pageNum: 0)),
  new _Page(text: "休息视频",
      feedList: new FeedList(feedType: '休息视频', pageSize: 10, pageNum: 0)),
  new _Page(text: "福利",
      feedList: new FeedList(feedType: '福利', pageSize: 10, pageNum: 0)),
];

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
