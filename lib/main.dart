import 'package:entertainmate/modules/slider/slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:entertainmate/intro/intro.dart';
import './home/home.dart';

void main() {
  runApp(MaterialApp(
    home: MainPage(),
    theme: new ThemeData(primaryColor: Colors.blueGrey),
  ));
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    //checkFirstUse();
  }

  _scrollListener() {
    // _scrollController.
    // _scrollController.position
    // int pos = int.parse();
    // int width = int.tryParse(MediaQuery.of(context).size.width.toString());
   
    print(_scrollController.position.pixels/ MediaQuery.of(context).size.width);
    // print( MediaQuery.of(context).size.width-_scrollController.offset);
//  _scrollController.animateTo(_controller.offset - itemSize,
//         curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    // checkFirstUse();
    // return new Scaffold(
    //     body: new Center(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
    //       new Image.asset("images/logo.png"),
    //       new Text("Entertain-Mate"),
    //     ],
    //   ),
    // ));
    List<Widget> wdgts = new List();
    IntroTest it1 = new IntroTest();
    IntroTest it2 = new IntroTest();
    IntroTest it3 = new IntroTest();
    wdgts.add(it1);
    wdgts.add(it2);
    wdgts.add(it3);

    return new Scaffold(
      backgroundColor: Colors.grey[500],
      body: Container(
        // width: MediaQuery.of(context).size.width,
        color: Colors.grey,
        height: double.maxFinite,
        child: new Column(children: <Widget>[
          new Expanded(
            flex: 1,
            child: Container(
              // width: MediaQuery.of(context).size.width,
              child: new ListView.builder(
                  controller: _scrollController,
                  physics: new PageScrollPhysics(),
                  itemCount: wdgts.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      // height: double.maxFinite,
                      child: wdgts[index],
                    );
                  },
                  scrollDirection: Axis.horizontal),
            ),
          ),
          new Expanded(
              flex: 0,
              child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: createIndicators(wdgts.length),
                  )))
        ]),
      ),
    );
  }

  List createIndicators(int length) {
    List<Widget> list = new List();
    for (var i = 0; i < length; i++) {
      list.add(
        new Container(
          margin: EdgeInsets.all(5.0),
          width: 10.0,
          height: 10.0,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }
    list.add(new RaisedButton(
      onPressed: () {
        _scrollController.jumpTo(2);
      },
    ));
    return list;
  }

  Future checkFirstUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool("isLogin", false);
    bool _isLogin = (prefs.getBool('isLogin') ?? false);
    if (_isLogin) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      List<Widget> wdgts = new List();
      IntroTest it1 = new IntroTest();
      IntroTest it2 = new IntroTest();
      IntroTest it3 = new IntroTest();

      wdgts.add(it1);
      wdgts.add(it2);
      wdgts.add(it3);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TSlider(wdgts)),
      );
    }
  }
}

class IntroTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[new Text("title")],
      ),
    );
  }
}
