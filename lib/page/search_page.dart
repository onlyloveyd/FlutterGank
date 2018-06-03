import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/api/Api.dart';
import 'package:flutter_gank/ext/constant.dart';
import 'package:flutter_gank/ext/data.dart';
import 'package:flutter_gank/ext/http.dart';
import 'package:flutter_gank/page/post_page.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

const List<String> filterType = const <String>[
  'all',
  'Android',
  'iOS',
  '休息视频',
  '福利',
  '拓展资源',
  '前端',
  '瞎推荐',
];

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedItemIndex = 0;

  var listData;

  var _searchType;
  var curPage = 1;
  var keyWord = "";

  ScrollController _controller = new ScrollController();
  TextEditingController _text_controller = new TextEditingController();

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
    _searchType = filterType[_selectedItemIndex];
    print("yidong -- initstate");
    //_doSearch(false);
  }

  _doSearch(bool isLoadMore) {
    var url = Api.SEARCH_URL; //listview/category/Android/count/10/page/1
    url += keyWord +
        '/category/' +
        _searchType.toString() +
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
    }, (e) {
      print("get news list error: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('搜索'),
      ),
      body: _buildSearchBody(),
    );
  }

  Widget _buildSearchBody() {
    Widget searchBox = new Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
      child: new TextField(
        style: new TextStyle(fontSize: 16.0, color: Colors.black),
        autofocus: false,
        maxLines: 1,
        controller: _text_controller,
        decoration: new InputDecoration(
          hintText: '搜索关键词',
          hintStyle:
              const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          border: const OutlineInputBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(20.0))),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
          suffixIcon: new IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (_text_controller.text == null || _text_controller.text.isEmpty) {
                  _showSnackBar("请输入关键字");
                } else {
                  setState(() {
                    print("yidong -- text = " + _text_controller.text);
                    keyWord = _text_controller.text;
                    _doSearch(false);
                  });
                }
              }),
        ),
      ),
    );

    final List<Widget> textChips = filterType.map<Widget>((String name) {
      return new Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
        child: new Chip(
          key: new ValueKey<String>(name),
          backgroundColor: tagColors[name],
          label: new Text(name),
        ),
      );
    }).toList();

    return new Column(
      children: <Widget>[
        searchBox,
        new Wrap(
          children: textChips,
        ),
        const Padding(padding: const EdgeInsets.only(top: 32.0)),
        new GestureDetector(
          onTap: () async {
            await showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return _buildBottomPicker();
              },
            );
          },
          child: _buildMenu(),
        ),
        _buildListView(context, listData)
      ],
    );
  }

  void _showSnackBar(message) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }

  Widget _buildListView(BuildContext context, List results) {
    print("_buildListView bobobobobobobo");
    print(results);
    if (results != null) {
      switch (results.length) {
        case 0:
          return new Expanded(
            child: new Center(
              child: new Text(
                "暂无数据",
                style: new TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ),
          );
        default:
          return new Expanded(
              child: new Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new ListView.builder(
              padding: const EdgeInsets.all(2.0),
              controller: _controller,
              itemCount: results == null ? 0 : results.length,
              itemBuilder: (context, i) {
                return _buildRow(context, results[i]);
              },
            ),
          ));
      }
    } else {
      return new Expanded(
        child: new Center(
          child: new Text(
            "暂无数据",
            style: new TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
        ),
      );
    }
  }

  Widget _buildRow(context, one) {
    final ThemeData theme = Theme.of(context);

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

  Widget _buildMenu() {
    return new Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
        border: const Border(
          top: const BorderSide(color: const Color(0xFFBCBBC1), width: 0.0),
          bottom: const BorderSide(color: const Color(0xFFBCBBC1), width: 0.0),
        ),
      ),
      height: 44.0,
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new DefaultTextStyle(
            style: const TextStyle(
              letterSpacing: -0.24,
              fontSize: 17.0,
              color: CupertinoColors.black,
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('搜索范围'),
                new Text(
                  filterType[_selectedItemIndex],
                  style: const TextStyle(color: CupertinoColors.inactiveGray),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPicker() {
    final FixedExtentScrollController scrollController =
        new FixedExtentScrollController(initialItem: _selectedItemIndex);

    return new Container(
      height: _kPickerSheetHeight,
      color: CupertinoColors.white,
      child: new DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: new GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: new SafeArea(
            child: new CupertinoPicker(
              scrollController: scrollController,
              itemExtent: _kPickerItemHeight,
              backgroundColor: CupertinoColors.white,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedItemIndex = index;
                  _searchType = filterType[index];
                });
              },
              children:
                  new List<Widget>.generate(filterType.length, (int index) {
                return new Center(
                  child: new Text(filterType[index]),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
