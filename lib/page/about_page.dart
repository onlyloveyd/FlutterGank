// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_gank/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {

  AppTheme appTheme;
  ValueChanged<AppTheme> onThemeChangd;

  AboutPage(this.appTheme, this.onThemeChangd);
  @override
  State<StatefulWidget> createState() => new AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("关于"),
          actions: <Widget>[
            new Padding(padding: const EdgeInsets.all(4.0),
              child: new IconButton(
                icon: new Icon(Icons.color_lens),
                onPressed: () {
                  _switchTheme();
                },),
            ),
          ],
        ),
        body: _createAbout(),
        floatingActionButton: new FloatingActionButton.extended(
            onPressed: () {
              _launchURL();
            },
            icon: new Icon(Icons.feedback),
            label: new Text("反馈"))
    );
  }

  Widget _createAbout() {
    return new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Card(
          child:
          new Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.topCenter,
                child: new SizedBox(
                  height: 180.0,
                  child: new Image.asset(
                    'images/profile_cover.jpg', fit: BoxFit.cover,),
                ),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new SizedBox(
                      height: 180.0,
                      child: new CircleAvatar(
                          radius: 60.0,
                          child: new Padding(padding: const EdgeInsets.all(1.0),
                              child: new Image.asset(
                                'images/ic_launcher.png', fit: BoxFit.cover,))


                      )),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child:
                    new Align(
                      alignment: Alignment.center,
                      child: new Text("onlyloveyd", style: new TextStyle(
                          fontSize: 20.0,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  new Padding(padding: const EdgeInsets.only(top: 6.0),
                      child:
                      new Align(
                        alignment: Alignment.center,
                        child: new Text("Android Developer",
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.grey),),
                      )
                  ),
                  new Padding(padding: const EdgeInsets.only(top: 20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Icon(Icons.mail),
                          new Icon(Icons.web),
                          new Icon(Icons.android)
                        ],
                      )
                  ),
                ],
              )
            ],
          )
      ),
    );
  }

  _launchURL() async {
    const url = 'mailto:onlyloveyd@gmail.com?subject=Issues&body=Issue:';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _switchTheme(){
    var index = kAllAppThemes.indexOf(widget.appTheme);
    var nextIndex = index+1 == kAllAppThemes.length?0:index+1;
    widget.onThemeChangd(kAllAppThemes[nextIndex]);
  }

}
