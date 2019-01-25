import 'dart:async';

import 'package:flutter/material.dart';

class TLoading {
  BuildContext context;
  StreamController<String> _controller;
  TLoading(BuildContext context) {
    this.context = context;
    _controller = StreamController<String>();
  }
  set title(String title) {
    _controller.add(title);
  }

  void show(String title) {
    _controller.add(title);
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => TLoadingWidget(
              stream: _controller.stream,
            )));
  }

  void hide() {
    Navigator.pop(context);
  }
}

class TLoadingModel {
  String $title;
  String get title {
    return $title;
  }

  set title(String title) {
    this.$title = title;
  }

  // TLoadingModel({@required this.$title});
}

class TLoadingWidget extends StatefulWidget {
  // final TLoadingModel tLoadingmodel;
  final Stream<String> stream;
  TLoadingWidget({@required this.stream});
  @override
  TLoadingWidgetState createState() => TLoadingWidgetState();
}

class TLoadingWidgetState extends State<TLoadingWidget> {
  String $title;
  set title(String title) {
    setState(() {
      this.$title = title;
    });
  }

  // TLoadState(String title) {
  //   this._title = title;
  // }

  @override
  void initState() {
    widget.stream.listen(($title) {
      title = $title;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future.value(true);
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10.0)),
                new Text($title, style: Theme.of(context).textTheme.display4),
              ],
            ),
          )),
    );
  }
}
