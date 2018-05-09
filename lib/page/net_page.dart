import 'package:flutter/material.dart';

class NetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new NetPageState();
  }
}

class NetPageState extends State<NetPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("网络请求测试"),
        centerTitle: true,
      ),
      body: _buildNetBody(),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.map), title: new Text("Map")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text("Home")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.settings), title: new Text("Settings"))
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
    transitions.add(new Text("Page One"));
    transitions.add(new Text("Page Two"));
    transitions.add(new Text("Page Three"));
    return new IndexedStack(
      children: transitions,
      index: _currentIndex,
    );
  }
}
