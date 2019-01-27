import 'dart:async';

import 'package:flutter/material.dart';

class TLoading {
  BuildContext context;
  int type;
  StreamController<String> streamControllerTitle;
  StreamController<double> streamControllerValue;
  TLoading({@required context, @required int type}) {
    this.context = context;
    this.type = type;
    streamControllerTitle = StreamController<String>();
    streamControllerValue = StreamController<double>();
  }
  set title(String title) {
    streamControllerTitle.add(title);
  }

  set value(double value) {
    streamControllerValue.add(value);
  }

  void show({@required title, double value}) {
    streamControllerTitle.add(title);

    if (type == 0) {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => TLoadingWidget(
                type: 0,
                streamTitle: streamControllerTitle.stream,
              )));
    } else {
      streamControllerValue.add(value);
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => TLoadingWidget(
                type: 1,
                streamTitle: streamControllerTitle.stream,
                streamValue: streamControllerValue.stream,
              )));
    }
  }

  void hide() {
    Navigator.pop(context);
  }
}

class TLoadingWidget extends StatefulWidget {
  final int type;
  final Stream<String> streamTitle;
  final Stream<double> streamValue;
  TLoadingWidget(
      {@required this.type, @required this.streamTitle, this.streamValue});
  @override
  TLoadingWidgetState createState() => TLoadingWidgetState();
}

class TLoadingWidgetState extends State<TLoadingWidget> {
  String $title = "";
  double $value = 0.0;
  set title(String title) {
    setState(() {
      this.$title = title;
    });
  }

  set value(double value) {
    setState(() {
      this.$value = value;
    });
  }

  @override
  void initState() {
    widget.streamTitle.listen(($title) {
      this.title = $title;
    });
    if (widget.type == 1) {
      widget.streamValue.listen(($value) {
        this.value = $value;
      });
    }
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
                widget.type == 0
                    ? new CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : $value == 0.0
                        ? new CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : new CircularProgressIndicator(
                            value: $value,
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                Padding(padding: EdgeInsets.only(bottom: 10.0)),
                new Text($title, style: Theme.of(context).textTheme.display4),
              ],
            ),
          )),
    );
  }
}
