import 'package:flutter/material.dart';

class TAlertDialog {
  BuildContext _context;
  TAlertDialog(BuildContext context) {
    this._context = context;
  }

  void show(String title, String content) {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
