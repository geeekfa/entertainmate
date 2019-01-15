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
  @override
  void initState() {
    super.initState();
    checkFirstUse();
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
        body: new Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Image.asset("images/logo.png"),
          new Text("Entertain-Mate"),
        ],
      ),
    ));
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
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroPage()),
      );
    }
  }
}
