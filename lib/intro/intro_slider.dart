import 'package:flutter/material.dart';

class TIntroSlider extends StatefulWidget {
  final List<Widget> slides;
  final Function donePressed;
  TIntroSlider({@required this.slides, @required this.donePressed});
  @override
      _IntroSliderState createState() =>
      _IntroSliderState();
}

class _IntroSliderState extends State<TIntroSlider>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _visibleDONE;
  bool _visibleNEXT;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.slides.length);
    _tabController.addListener(_handleTabSelection);
    _visibleNEXT = true;
    _visibleDONE = false;
  }

  void _handleTabSelection() {
    if (_tabController.index == _tabController.length - 1) {
      setState(() {
        _visibleNEXT = false;
        _visibleDONE = true;
      });
    } else {
      setState(() {
        _visibleNEXT = true;
        _visibleDONE = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < _tabController.length - 1) {
      _tabController.animateTo(newIndex);
    } else if (newIndex == _tabController.length - 1) {
      _tabController.animateTo(newIndex);
      setState(() {
        _visibleNEXT = false;
        _visibleDONE = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: const Text('AppBar Bottom Widget'),
          // leading: IconButton(
          //   tooltip: 'Previous choice',
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     _nextPage(-1);
          //   },
          // ),
          leading: new FlatButton(
            child: Text('SKIP',
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'calibri')),
            textColor: Colors.white,
            splashColor: Colors.grey,
            onPressed: widget.donePressed,
          ),
          actions: <Widget>[
            _visibleNEXT
                ? new SizedBox(
                    width: 65.0,
                    child: new FlatButton(
                      child: Text("NEXT",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'calibri')),
                      textColor: Colors.white,
                      splashColor: Colors.grey,
                      onPressed: () {
                        _nextPage(1);
                      },
                    ),
                  )
                : new Container(),
            _visibleDONE
                ? new SizedBox(
                    width: 65.0,
                    child: new FlatButton(
                      child: Text("DONE",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'calibri')),
                      textColor: Colors.white,
                      splashColor: Colors.grey,
                      onPressed: widget.donePressed,
                    ),
                  )
                : new Container(),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                accentColor: Colors.white,
              ),
              child: Container(
                child: TabPageSelector(controller: _tabController),
              ),
            ),
          ),
        ),
        body: Container(
          child: TabBarView(controller: _tabController, children: widget.slides),
        ));
  }
}
