import 'package:flutter/material.dart';

class TLoading {
  BuildContext _context;
  GlobalKey<TLoadState> key ;
  TLoading(BuildContext context) {
    this._context = context;
    this.key= new GlobalKey<TLoadState>();
  }
  set title(String title) {
    key.currentState._title = title;
  }

  void show() {
    
    Navigator.of(_context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => TLoad(key: key)));
  }

  void hide() {
    Navigator.pop(_context);
  }
}

class TLoad extends StatefulWidget {
  
  TLoad({@required Key key}) : super(key: key);
  @override
  TLoadState createState() => TLoadState();
}

class TLoadState extends State<TLoad> {
  String _title = "";
  set title(String title) {
    setState(() {
      this._title = title;
    });
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
                new Text(_title, style: Theme.of(context).textTheme.display4),
              ],
            ),
          )),
    );
  }
}
