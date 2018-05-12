import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/net/daily_list.dart';

class DailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DailyPageState();
}

class DailyPageState extends State<DailyPage> {

  DateTime selectedDate = new DateTime.now();

  final String _url = 'http://gank.io/api/day';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('每日干货'),
          actions: <Widget>[
            new Padding(padding: const EdgeInsets.all(4.0),
              child: new IconButton(
                icon: new Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context);
                },),
            ),
            new Padding(padding: const EdgeInsets.all(4.0),
              child: new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () {


                },),),
          ],
        ),
        body: new DailyList(
            url: _url + '/' + selectedDate.year.toString() + '/' +
                selectedDate.month.toString() + '/' +
                selectedDate.day.toString()));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

}