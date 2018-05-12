import 'package:flutter/material.dart';
import 'package:flutter_gank/page/about_page.dart';
import 'package:flutter_gank/page/article_page.dart';
import 'package:flutter_gank/page/daily_page.dart';
import 'package:flutter_gank/page/feed_page.dart';
import 'package:flutter_gank/theme/theme.dart';

class HomePage extends StatefulWidget {

  final AppTheme appTheme;
  final ValueChanged<AppTheme> onThemeChanged;

  HomePage(this.appTheme,this.onThemeChanged);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: _buildNetBody(),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text("每日干货")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.category), title: new Text("分类阅读")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.whatshot), title: new Text("匠心写作")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.settings), title: new Text("关于"))
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (int selected) {
          setState(() {
            this._currentIndex = selected;
          });
        },
      ),

    );
  }

  Widget _buildNetBody() {
    final List<Widget> transitions = <Widget>[];
    transitions.add(new DailyPage());
    transitions.add(new FeedPage());
    transitions.add(new ArticlePage());
    transitions.add(new AboutPage(widget.appTheme, widget.onThemeChanged));
    return new IndexedStack(
      children: transitions,
      index: _currentIndex,
    );
  }
}
