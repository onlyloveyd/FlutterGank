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
    final Color iconColor = Theme
        .of(context)
        .accentColor;


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
            return new Text(page.text);
          }).toList()),
    );
  }
}


class _Page {
  _Page({
    this.icon,
    this.text,
  });

  final IconData icon;
  final String text;
}
// 存储所有页面的列表
final List<_Page> _allPages = <_Page>[
  new _Page(text: "all"),
  new _Page(text: "Android"),
  new _Page(text: "瞎推荐"),
  new _Page(text: "iOS"),
  new _Page(text: "前端"),
  new _Page(text: "拓展资源"),
  new _Page(text: "App"),
  new _Page(text: "休息视频"),
  new _Page(text: "福利"),
];
