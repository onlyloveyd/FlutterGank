import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/ext/constant.dart' as ext;

class DailyList extends StatefulWidget {
  final String url;

  DailyList({Key key, this.url})
      :super(key: key);

  @override
  State<StatefulWidget> createState() => new DailyListState();

}

class DailyListState extends State<DailyList> {


  List data;

  @override
  Widget build(BuildContext context) {
    return createBody();
  }

  Widget createBody() {
    return new RefreshIndicator(
        child: new FutureBuilder(
            future: get(widget.url),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return ext.buildLoadingIndicator();
                default:
                  if (snapshot.hasError) {
                    return ext.buildExceptionIndicator(snapshot.error);
                  } else {
                    return ext.buildDailyListView(context, snapshot);
                  }
              }
            }),
        onRefresh: loadData);
  }


  Future<String> get(String current) async {
    var httpClient = new HttpClient();

    var request = await httpClient.getUrl(Uri.parse(current));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<Null> loadData() async {
    await get(widget.url);
    if (!mounted) return;
    setState(() {

    });
  }
}