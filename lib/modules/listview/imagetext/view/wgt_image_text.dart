import 'package:flutter/material.dart';

class WgtImageText extends StatelessWidget {
  const WgtImageText({Key key, this.title, this.imageURL}) : super(key: key);
  final String title;
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return new Container(
        width: 200.0,
        height: 200.0,
        margin: EdgeInsets.all(4.0),
        child: new Stack(
          children: <Widget>[
            new Positioned(
              child: Image.asset(imageURL),
            ),
            new Positioned(
                bottom: 10.0,
                left: 10.0,
                child: Container(
                  decoration: BoxDecoration(color: Colors.black38),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ));
  }
}
