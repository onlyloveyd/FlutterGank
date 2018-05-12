import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class PostPage extends StatefulWidget {
  final Map<String, dynamic> post;

  PostPage(this.post);

  @override
  State<StatefulWidget> createState() => new _PostWebViewState();
}

class _PostWebViewState extends State<PostPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();


// Instance of WebView plugin
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  final _history = [];

  void showSnack(String msg) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  bool loading = false;

  @override
  initState() {
    super.initState();


    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Webview Destroyed")));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add("onUrlChanged: $url");
        });
      }
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (mounted) {
            if(state!= WebViewState.finishLoad) {
              setState(() {
                _history.add("onStateChanged: ${state.type} ${state.url}");
                print('yidong'+ _history.toString());
                loading = false;
              });
            } else {
              loading = true;
            }
          }
        });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.post['desc'] == null
        ? widget.post['desc']
        : widget.post['desc'];
    var favIcon = loading
        ? new CupertinoActivityIndicator()
        : new Icon(Icons.rotate_right, color: Colors.white);
    return new WebviewScaffold(
      key: _scaffoldKey,
      url: widget.post['url'],
      withJavascript: true,
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          favIcon
        ],
      ),
    );
  }

}
