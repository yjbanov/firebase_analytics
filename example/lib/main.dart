import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Firebase Analytics Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Firebase Analytics Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = '';

  void _sendAnalyticsEvent() {
    new FirebaseAnalytics().logEvent('test_event').then((_) async {
      setState(() {
        _message = 'Analytics event sent successfully';
      });

      await new Future.delayed(const Duration(seconds: 1));
      setState(() {
        _message = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(config.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Text(_message),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _sendAnalyticsEvent,
        tooltip: 'Send Analytics Event',
        child: new Icon(Icons.add),
      ),
    );
  }
}
