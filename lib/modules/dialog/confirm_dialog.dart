import 'package:flutter/material.dart';

class TConfirmDialog {
  BuildContext _context;
  Function _noPressed;
  Function _yesPressed;
  TConfirmDialog({@required BuildContext context ,@required Function noPressed,@required Function yesPressed}) {
    this._context = context;
    this._noPressed = noPressed;
    this._yesPressed = yesPressed;
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
              child: new Text("No"),
              onPressed: _noPressed,
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: _yesPressed,
            )
          ],
        );
      },
    );
  }
}
