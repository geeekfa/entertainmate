import 'package:flutter/material.dart';

class TLoading {
  BuildContext _context;
  TLoading(BuildContext context) {
    this._context = context;
  }

  void show(String title) {
    Navigator.of(_context).push(TModalRoute(_context, title));
  }

  void hide() {
    Navigator.pop(_context);
  }
}

class TModalRoute extends ModalRoute<void> {
  BuildContext _context;
  String _title;
  TModalRoute(BuildContext context, String title) {
    this._context = context;
    this._title = title;
  }
  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Theme.of(_context).primaryColor.withOpacity(0.1);

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
          return new Future.value(false);
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
          new CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(bottom: 10.0)),
          new Text(_title),
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
