import 'package:flutter/material.dart';

class TLoading {
  BuildContext _context;
  TModalRoute tModalRoute;
  TLoading(BuildContext context) {
    this._context = context;
    tModalRoute = TModalRoute(_context);
  }
  set title(String _title) {
    tModalRoute.title=_title;
  }

  void show() {
    Navigator.of(_context).push(tModalRoute);
  }

  void hide() {
    Navigator.pop(_context);
  }
}

class TModalRoute extends ModalRoute<void> {
  BuildContext _context;
  String _title;
  set title(String title) {
    setState(() {
      this._title = title;
      
    });
  }

  TModalRoute(BuildContext context) {
    this._context = context;
  }
  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Theme.of(_context).primaryColor.withOpacity(0.8);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return new WillPopScope(
        onWillPop: () {
          //  Navigator.pop(context);
          //  Navigator.pop(context);
          return new Future.value(true);
        },
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: _buildOverlayContent(context),
          ),
        ));
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
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
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
