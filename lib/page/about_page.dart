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
  Set<String> mCartoonTags = new Set<String>();
  Set<String> mSelfTag = new Set<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mCartoonTags.add('灌篮高手');
    mCartoonTags.add('足球小将');
    mCartoonTags.add('择天记');
    mCartoonTags.add('全职高手');
    mCartoonTags.add('斗罗大陆');
    mCartoonTags.add('镇魂街');
    mCartoonTags.add('一人之下');
    mCartoonTags.add('火影忍者');
    mCartoonTags.add('斗破苍穹');

    mSelfTag.add('Java');
    mSelfTag.add('Android');
    mSelfTag.add('Kotlin');
    mSelfTag.add('SpringBoot');
    mSelfTag.add('Dart');
    mSelfTag.add('Flutter');
    mSelfTag.add('Docker');
    mSelfTag.add('Ionic');
  }

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
    return
      new SingleChildScrollView(child:
      new Padding(
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
                            child: new Padding(
                                padding: const EdgeInsets.all(1.0),
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
                      child: new Wrap(
                        children: _buildChips(mCartoonTags, false),
                      ),
                    ),
                    new Padding(padding: const EdgeInsets.only(top: 20.0),
                      child: new Wrap(
                        children: _buildChips(mSelfTag, true),
                      ),
                    ),
                    new Padding(padding: const EdgeInsets.all(24.0))
                  ],
                )
              ],
            )
        ),
      )
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

  _switchTheme() {
    var index = kAllAppThemes.indexOf(widget.appTheme);
    var nextIndex = index + 1 == kAllAppThemes.length ? 0 : index + 1;
    widget.onThemeChangd(kAllAppThemes[nextIndex]);
  }

  List<Widget> _buildChips(tags, haveBg) {
    List<Widget> widgets = new List();
    tags.forEach((tag) {
      widgets.add(
          _buildChip(tag, haveBg))
      ;
    });
    return widgets;
  }

  Widget _buildChip(tag, haveBg) {
    if (haveBg) {
      return new Padding(padding: const EdgeInsets.all(4.0), child:
      new Chip(label: new Text(tag), backgroundColor: _nameToColor(tag), shape:
      new BeveledRectangleBorder(
        side: const BorderSide(
            width: 0.66, style: BorderStyle.solid, color: Colors.grey),
        borderRadius: new BorderRadius.circular(10.0),
      )));
    } else {
      return new Padding(padding: const EdgeInsets.all(4.0), child:
      new Chip(label: new Text(tag), backgroundColor: _nameToColor(tag))
      );
    }
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = 360.0 * hash / (1 << 15);
    return new HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }
}
