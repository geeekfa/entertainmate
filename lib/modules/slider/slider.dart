import 'package:flutter/material.dart';

class TSlider extends StatefulWidget {
  final List<Widget> slides;
  TSlider(this.slides);
  @override
  _MainState createState() => new _MainState();
}

class _MainState extends State<TSlider> {

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
        backgroundColor: Colors.grey[100],
        body: new Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Container(
              child: new ListView.builder(
                  physics: new PageScrollPhysics(),
                  itemCount: widget.slides.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return widget.slides[index];
                  },
                  scrollDirection: Axis.horizontal),
            )),
          ],
        ),
      );
    
  }
}
