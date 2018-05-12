import 'package:flutter/material.dart';
import 'package:flutter_gank/net/base_list.dart';
import 'package:flutter_gank/ext/constant.dart' as ext;

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
          //indicator: _generateIndicator(),
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

  Decoration _generateIndicator() {
    return new ShapeDecoration(
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.all(new Radius.circular(2.0)),
        side: new BorderSide(
            color: Colors.grey,
            width: 1.0
        ),
      ),
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
      feedList: new FeedList(url:ext.generateCategoryUrl('all',10, 0))),
  new _Page(text: "Android",
      feedList: new FeedList(url:ext.generateCategoryUrl('Android',10, 0))),
  new _Page(text: "瞎推荐",
      feedList: new FeedList(url:ext.generateCategoryUrl('瞎推荐',10, 0))),
  new _Page(text: "iOS",
      feedList: new FeedList(url:ext.generateCategoryUrl('iOS',10, 0))),
  new _Page(text: "前端",
      feedList: new FeedList(url:ext.generateCategoryUrl('前端',10, 0))),
  new _Page(text: "拓展资源",
      feedList: new FeedList(url:ext.generateCategoryUrl('拓展资源',10, 0))),
  new _Page(text: "App",
      feedList: new FeedList(url:ext.generateCategoryUrl('App',10, 0))),
  new _Page(text: "休息视频",
      feedList: new FeedList(url:ext.generateCategoryUrl('休息视频',10, 0))),
  new _Page(text: "福利",
      feedList: new FeedList(url:ext.generateCategoryUrl('福利',10, 0)))
];





