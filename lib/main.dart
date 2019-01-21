import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainmate/home/home.dart';
import 'package:entertainmate/intro/intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: MainPage(),
    theme: new ThemeData(
      hintColor: Colors.blueGrey[300],
      backgroundColor:  Colors.blueGrey[100],
      splashColor:  Colors.blueGrey[100],
      brightness: Brightness.light,
      primaryColor: Colors.blueGrey,
      accentColor: Colors.blueGrey[100],
      textTheme: new TextTheme(
        headline: TextStyle(
            color: Colors.blueGrey[300],
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'calibri'),
        title: TextStyle(
            fontFamily: 'calibri',
            color: Colors.blueGrey,
            fontSize: 23.0,
            fontWeight: FontWeight.bold),
        body1: TextStyle(
            fontFamily: 'calibri', color: Colors.blueGrey, fontSize: 20.0),
        body2: TextStyle(
            fontFamily: 'calibri', fontSize: 20.0, fontStyle: FontStyle.italic),
        display1: TextStyle(
            fontFamily: 'calibri', fontSize: 14.0, fontWeight: FontWeight.bold),
        display2: TextStyle(
          fontFamily: 'BRUSHSCI',
          color: Colors.blueGrey,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        display3: TextStyle(
          fontFamily: 'calibri',
          color: Colors.grey,
          fontSize: 16.0,
        ),
        display4: TextStyle(
          fontFamily: 'calibri',
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    ),
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
    checkFirstUse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Image.asset("images/logo.png"),
          new Text("Entertain-Mate",
              style: Theme.of(context).textTheme.display2),
        ],
      ),
    ));
  }

  Future<List<Intro>> _getIntroFromFireStore() async {
    FirebaseApp app = await FirebaseApp.configure(
      name: 'entertainmate',
      options: const FirebaseOptions(
        googleAppID: '1:560093923265:android:f3afa66d99637d32',
        apiKey: 'AIzaSyDyUnIcLNuVhU8koHZP15JfCyrTi9K9U5g',
        projectID: 'entertainmate-2019',
      ),
    );
    final Firestore firestore = Firestore(app: app);
    await firestore.settings(timestampsInSnapshotsEnabled: true);
    QuerySnapshot querySnapshot = await firestore
        .collection('intros')
        .orderBy('position', descending: false)
        .getDocuments();
    List<DocumentSnapshot> docs = querySnapshot.documents;
    List<Intro> intros = new List<Intro>();
    for (DocumentSnapshot doc in docs) {
      Intro i1 = new Intro(
          title: doc.data["title"],
          imageUrl: doc.data["imageUrl"],
          desc: doc.data["desc"]);
      intros.add(i1);
    }
    return intros;
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
      _getIntroFromFireStore().then((intros) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IntroPage(intros: intros)),
        );
      });
    }
  }
}
