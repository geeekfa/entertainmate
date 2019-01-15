import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:entertainmate/modules/dialog/image_picker_dialog.dart';
import 'package:flutter/material.dart';


class TImageCollection extends StatefulWidget {
  final String title;
  final List imageUrls;
  TImageCollection({this.title, this.imageUrls});
  @override
  _MainState createState() => new _MainState();
}

class _MainState extends State<TImageCollection> with TickerProviderStateMixin {
  List<Widget> _slides = new List();
  TabController _tabController;
  TabPageSelector _tabPageSelector;
  bool _visibleDELETE;

  @override
  void initState() {
    super.initState();
    for (String imageUrl in widget.imageUrls) {
      CachedNetworkImage cachedNetworkImage = new CachedNetworkImage(
        imageUrl: imageUrl,
        errorWidget: new Icon(
          Icons.broken_image,
          size: 200.0,
          color: Colors.blueGrey[100],
        ),
      );
      _slides.add(cachedNetworkImage);
    }

    Container containerAddImage = new Container(
      child: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RawMaterialButton(
              onPressed: () {
                TImagePickerDialog tipd = new TImagePickerDialog(
                    context: context,
                    imageSelected: (File image) {
                      addImageToSlider(image);
                    });
                tipd.show();
              },
              child: new Icon(
                Icons.add,
                color: Colors.white,
                size: 100.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.blueGrey,
            )
          ],
        ),
      ),
    );
    _slides.add(containerAddImage);
    _tabController = new TabController(vsync: this, length: _slides.length);
    _tabPageSelector = new TabPageSelector(controller: _tabController);
    _tabController.addListener(_handleTabSelection);
    _handleTabSelection();
  }

  void _handleTabSelection() {
    if (_tabController.index == _tabController.length - 1) {
      setState(() {
        _visibleDELETE = false;
      });
    } else {
      setState(() {
        _visibleDELETE = true;
      });
    }
  }

  void addImageToSlider(File image) {
    List<Widget> _slidesTemp = new List();
    _slides.forEach((slide) {
      _slidesTemp.add(slide);
    });
    setState(() {
      _slides.clear();
    });
    _slidesTemp.forEach((slide) {
      setState(() {
        _slides.add(slide);
      });
    });

    widget.imageUrls.add(image.path);
    setState(() {
      
      _slides.insert(_slides.length - 1, Image.file(image));
      _tabController = new TabController(
          vsync: this,
          length: _slides.length,
          initialIndex: _slides.length - 2);
      _tabPageSelector = new TabPageSelector(controller: _tabController);
      _tabController.addListener(_handleTabSelection);
    });
    _handleTabSelection();
  }

  void deleteImageFromSlider() {
    widget.imageUrls.removeAt(_tabController.index);
    setState(() {
      _slides.removeAt(_tabController.index);
      _tabController = new TabController(
          vsync: this,
          length: _slides.length,
          initialIndex: _tabController.index);
      _tabPageSelector = new TabPageSelector(controller: _tabController);
      _tabController.addListener(_handleTabSelection);
    });
    _handleTabSelection();
  }

  Future<bool> onWillPop() async {
    Navigator.pop(context,
        {"imageUrls":widget.imageUrls});
    return new Future.value(false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: onWillPop,
      child: new Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: new AppBar(
          actions: <Widget>[
            new Padding(
                padding: const EdgeInsets.all(1.0),
                child: _visibleDELETE
                    ? new SizedBox(
                        width: 50.0,
                        child: new IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          tooltip: 'delete this image',
                          onPressed: deleteImageFromSlider,
                        ),
                      )
                    : new SizedBox(
                        width: 50.0,
                        child: new Container(),
                      )),
          ],
          title: Center(
            child: Text(widget.title),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                accentColor: Colors.white,
              ),
              child: Container(
                child: _tabPageSelector,
              ),
            ),
          ),
        ),
        body: new TabBarView(
          controller: _tabController,
          children: _slides.toList(),
        ),
      ),
    );
  }
}
