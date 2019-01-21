import 'package:flutter/material.dart';

class TSlider extends StatefulWidget {
  final List<Widget> slides;
  final Function slideChanged;
  final Function firstSlideReceived;
  final Function lastSlideReceived;

  TSlider(
      {Key key,
      @required this.slides,
      @required this.slideChanged,
      @required this.firstSlideReceived,
      @required this.lastSlideReceived})
      : super(key: key);
  @override
  TSliderState createState() {
    return new TSliderState();
  }
}

class TSliderState extends State<TSlider> {
  double _index;
  ScrollController _scrollController;
  void animateToNext() {
    //  key.currentState.animateToNext();
    _scrollController.animateTo(
      (_index + 1) * MediaQuery.of(context).size.width,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void animateToPrev() {
    //  key.currentState.animateToPrev();
    _scrollController.animateTo(
      (_index - 1) * MediaQuery.of(context).size.width,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void animateTo(index) {
    // key.currentState.animateTo(0);
    _scrollController.animateTo(
      (index) * MediaQuery.of(context).size.width,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void scrollListener() {
    List<double> arr1 = [
      0.0,
      1.0,
      2.0,
      3.0,
      4.0,
      5.0,
      6.0,
      7.0,
      8.0,
      9.0,
      10.0,
      11.0,
      12.0,
      13.0,
      14.0,
      15.0,
      16.0,
      17.0,
      18.0,
      19.0,
      20.0
    ];
    double index =
        _scrollController.position.pixels / MediaQuery.of(context).size.width;

    if (arr1.contains(index)) {
      setState(() {
        _index = index;
        if (index == 0.0) {
          widget.firstSlideReceived();
        } else if (index == widget.slides.length - 1) {
          widget.lastSlideReceived();
        } else {
          widget.slideChanged(index);
        }
      });
    }
  }

  List createIndicators(int length) {
    List<Widget> list = new List();
    for (var i = 0; i < length; i++) {
      list.add(
        _index == i
            ? new Container(
                margin: EdgeInsets.all(5.0),
                width: 8.0,
                height: 8.0,
                decoration: new BoxDecoration(
                  color: Theme.of(context).indicatorColor,
                  shape: BoxShape.circle,
                ),
              )
            : new Container(
                margin: EdgeInsets.all(5.0),
                width: 5.0,
                height: 5.0,
                decoration: new BoxDecoration(
                  color: Theme.of(context).indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
      );
    }
    return list;
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
    _index = 0;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: double.maxFinite,
        child: new Column(children: <Widget>[
          new Expanded(
            flex: 1,
            child: Container(
              child: new ListView.builder(
                  controller: _scrollController,
                  physics: new PageScrollPhysics(),
                  itemCount: widget.slides.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: widget.slides[index],
                    );
                  },
                  scrollDirection: Axis.horizontal),
            ),
          ),
          new Expanded(
              flex: 0,
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: new Align(
                    alignment: Alignment.bottomCenter,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: createIndicators(widget.slides.length),
                    )),
              ))
        ]),
      ),
    );
  }
}
