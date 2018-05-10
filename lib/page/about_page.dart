import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AboutPageState();

}

class AboutPageState extends State<AboutPage> {

  var fetchResult = 'Unknown';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new RaisedButton(onPressed: () {
      print("btn is pressed");
      _getNetResult();
    },
        child: new Text("网络请求"));
  }

  _getNetResult() async {
    var url = "http://gank.io/api/data/Android/10/1";
    var httpClient = new HttpClient();

    String response;

    try {
      var request = await httpClient.getUrl(Uri.parse(url));

      var response  = await request.close();

      if(response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);

        print(data['error']);
        print(data['results']);
      }

    } catch(exception) {
      print(exception.toString());
    }


    if (!mounted) return;

//    setState(() {
//      _fetch_result = result; //显示请求结果
//    });
  }
}