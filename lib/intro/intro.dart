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
  final key = new GlobalKey<TSliderState>();
  @override
  void initState() {
    _visibleSKIP = true;
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
              _visibleSKIP = true;
            });
          },
          slideChanged: (index) {
            setState(() {
              _visibleSKIP = true;
            });
          },
          lastSlideReceived: () {
            setState(() {
              _visibleSKIP = true;
            });
          },
        ),
        Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 160.0,
            child: Center(
                child: SizedBox(
              width: 120.0,
              height: 30.0,
              child: new OutlineButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                borderSide: BorderSide(color: Colors.blue),
                child: Text('Login now !',
                    style: Theme.of(context).textTheme.body1),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            )))
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
        body: Container(
      padding: EdgeInsets.all(20.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: 70.0)),
          new CachedNetworkImage(
            width: 130.0,
            height: 130.0,
            imageUrl: imageUrl,
            errorWidget: new Icon(Icons.error),
          ),
          Padding(padding: EdgeInsets.only(bottom: 20.0)),
          new Text(title,
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center),
          Padding(padding: EdgeInsets.only(bottom: 20.0)),
          new SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(right: 40.0, left: 40.0),
              child: new Text(
                desc,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
          ),
        ],
      ),
    )
        //     new Container(
        //   padding: EdgeInsets.all(20.0),
        //   child: new Column(children: <Widget>[
        //     Padding(padding: EdgeInsets.only(bottom: 10.0)),
        //     new Text(title, style: Theme.of(context).textTheme.title),
        //     Padding(padding: EdgeInsets.only(bottom: 10.0)),
        //     new CachedNetworkImage(
        //       width: 100.0,
        //       height: 100.0,
        //       imageUrl: imageUrl,
        //       errorWidget: new Icon(Icons.error),
        //     ),
        //     Padding(padding: EdgeInsets.only(bottom: 7.0)),
        //     new SingleChildScrollView(
        //           child: new Text(
        //             desc,
        //             textAlign: TextAlign.justify,
        //             style: Theme.of(context).textTheme.body2,
        //           ),
        //         ),
        //     Padding(padding: EdgeInsets.only(bottom: 40.0)),
        //   ]),
        // )

        );
  }
}
