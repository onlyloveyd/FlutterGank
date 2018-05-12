import 'package:flutter/material.dart';
import 'package:flutter_gank/page/home_page.dart';
import 'package:flutter_gank/theme/theme.dart';

void main() => runApp(new App());

class App extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> {

  AppTheme _appTheme = kAllAppThemes[0];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: '干货集中营',
      home: new HomePage(_appTheme,(theme) {
        setState(() {
          _appTheme = theme;
        });
      }),
      theme: _appTheme.theme,
    );
  }

}



