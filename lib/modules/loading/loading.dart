import 'package:entertainmate/modules/loading/modalroute.dart';
import 'package:flutter/material.dart';

class TLoading {
  BuildContext _context;
  TLoading(BuildContext context) {
    this._context = context;
  }

  void show(String title) {
   Navigator.of(_context).push(TModalRoute(title));
  }

  void hide() {
    Navigator.pop(_context);
  }
}

