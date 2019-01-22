import 'package:entertainmate/login/login.dart';
import 'package:entertainmate/modules/slider/slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IntroPage extends StatefulWidget {
  final List<Intro> intros;
  IntroPage({@required this.intros});
  @override
  IntroPageState createState() {
    return new IntroPageState();
  }
}

class IntroPageState extends State<IntroPage> {
  bool _visibleSKIP;
  bool _visibleNEXT;
  bool _visibleDONE;
  final key = new GlobalKey<TSliderState>();
  @override
  void initState() {
    _visibleSKIP = true;
    _visibleNEXT = true;
    _visibleDONE = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        TSlider(
          key: key,
          slides: widget.intros,
          firstSlideReceived: () {
            setState(() {
              _visibleDONE = false;
              _visibleNEXT = true;
              _visibleSKIP = true;
            });
          },
          slideChanged: (index) {
            setState(() {
              _visibleDONE = false;
              _visibleNEXT = true;
              _visibleSKIP = true;
            });
          },
          lastSlideReceived: () {
            setState(() {
              _visibleDONE = true;
              _visibleNEXT = false;
              _visibleSKIP = false;
            });
          },
        ),
        Positioned(
            bottom: 20.0,
            child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _visibleSKIP
                        ? Container(
                            width: 50.0,
                            height: 50.0,
                            child: RawMaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: Center(
                                child: new Text(
                                  "SKIP",
                                  style: Theme.of(context).textTheme.display4,
                                ),
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(0.0),
                            ),
                          )
                        : Container(
                            width: 50.0,
                            height: 50.0,
                          ),
                    _visibleNEXT
                        ? Container(
                            width: 50.0,
                            height: 50.0,
                            child: RawMaterialButton(
                              onPressed: () {
                                key.currentState.animateToNext();
                              },
                              child: Center(
                                child: new Text(
                                  "NEXT",
                                  style: Theme.of(context).textTheme.display4,
                                ),
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(0.0),
                            ),
                          )
                        : Container(
                            width: 50.0,
                            height: 50.0,
                            child: RawMaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: Center(
                                child: new Text(
                                  "DONE",
                                  style: Theme.of(context).textTheme.display4,
                                ),
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(0.0),
                            ),
                          ),
                  ],
                ))),
      ],
    ));
  }
}

class Intro extends StatelessWidget {
  final String title;
  final String desc;
  final String imageUrl;
  Intro({@required this.title, @required this.desc, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
            child: new Container(
      padding: EdgeInsets.all(20.0),
      child: new Column(children: <Widget>[
        Padding(padding: EdgeInsets.only(bottom: 10.0)),
        new Text(title, style: Theme.of(context).textTheme.title),
        Padding(padding: EdgeInsets.only(bottom: 10.0)),
        new CachedNetworkImage(
          imageUrl: imageUrl,
          errorWidget: new Icon(Icons.error),
        ),
        Padding(padding: EdgeInsets.only(bottom: 7.0)),
        new Expanded(
            flex: 2,
            child: new SingleChildScrollView(
              child: new Text(
                desc,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.body2,
              ),
            )),
        Padding(padding: EdgeInsets.only(bottom: 40.0)),
      ]),
    )));
  }
}
