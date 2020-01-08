import 'package:flutter/material.dart';
import 'package:flutter_gank/net/feed_list.dart';

/// 分类阅读 通用列表界面
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
      appBar: new AppBar(
        title: const Text('分类阅读'),
        bottom: new TabBar(
          controller: _controller,
          indicatorColor: Theme
              .of(context)
              .primaryColor,
          isScrollable: true,
          tabs: _allPages.map((_Page page) {
            return
              new Tab(text: page.text
              );
          }).toList(),
        ),
        actions: <Widget>[
          new Padding(padding: const EdgeInsets.all(4.0),
            child: new IconButton(
              icon: new Icon(Icons.reorder),
              onPressed: () {
              },),
          ),
          new Padding(padding: const EdgeInsets.all(4.0),
            child: new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {

              },),),
        ],
      ),

      body: new TabBarView(controller: _controller,
          children: _allPages.map((_Page page) {
            return page.feedList;
          }).toList()),
    );
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
      feedList: new FeedList(feedType:('all'))),
  new _Page(text: "Android",
      feedList: new FeedList(feedType:('Android'))),
  new _Page(text: "瞎推荐",
      feedList: new FeedList(feedType:('瞎推荐'))),
  new _Page(text: "iOS",
      feedList: new FeedList(feedType:('iOS'))),
  new _Page(text: "前端",
      feedList: new FeedList(feedType:('前端'))),
  new _Page(text: "拓展资源",
      feedList: new FeedList(feedType:('拓展资源'))),
  new _Page(text: "App",
      feedList: new FeedList(feedType:('App'))),
  new _Page(text: "休息视频",
      feedList: new FeedList(feedType:('休息视频'))),
  new _Page(text: "福利",
      feedList: new FeedList(feedType:('福利')))
];





