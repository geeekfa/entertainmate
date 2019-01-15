import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainmate/intro/intro_slider.dart';
import 'package:entertainmate/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IntroPage extends StatefulWidget {
  @override
  IntroPageState createState() {
    return new IntroPageState();
  }
}

class IntroPageState extends State<IntroPage> {
  TIntroSlider _tSlider;
  @override
  void initState() {
    super.initState();
    _getIntroFromFireStore().then((_intros) {
      setState(() {
        _tSlider = TIntroSlider(
          slides: _intros,
          donePressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tSlider == null) {
      return new Scaffold(
          body: new Center(
        child: new Text("Loading ..."),
      ));
    }
    return _tSlider;
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
        new Text(title,
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'calibri')),
        Padding(padding: EdgeInsets.only(bottom: 10.0)),
        new CachedNetworkImage(
          imageUrl: imageUrl,
          errorWidget: new Icon(Icons.error),
        ),
        Padding(padding: EdgeInsets.only(bottom: 10.0)),
        new Expanded(
            flex: 2,
            child: new SingleChildScrollView(
              child: new Text(
                desc,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    height: 1.0,
                    color: Color(0xff000000),
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'calibri'),
              ),
            )),
      ]),
    )));
  }
}
