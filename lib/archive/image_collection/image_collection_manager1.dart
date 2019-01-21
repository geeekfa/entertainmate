import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:entertainmate/modules/dialog/image_picker_dialog.dart';
import 'package:flutter/material.dart';

class TImageCollectionManager1 extends StatefulWidget {
  String title;
  List imageUrls;
  TImageCollectionManager1({title, imageUrls}) {
    this.title = title;
    this.imageUrls = imageUrls;
  }
  @override
  _MainState createState() => new _MainState();
}

class _MainState extends State<TImageCollectionManager1> {
  List<Widget> _slides = new List();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onWillPop() async {
    //Navigator.pop(context, {"imageUrls": widget.imageUrls});
    return new Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: onWillPop,
      child: new Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: new AppBar(
          actions: <Widget>[
            new Padding(
                padding: const EdgeInsets.all(1.0),
                child: true
                    ? new SizedBox(
                        width: 50.0,
                        child: new IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          tooltip: 'delete this image',
                          onPressed: () {
                            //deleteImageFromSlider
                          },
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
        ),
        body: new Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Container(
              child: new ListView.builder(
                  physics: new PageScrollPhysics(),
                  itemCount: widget.imageUrls.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new CachedNetworkImage(
                      width: MediaQuery.of(context).size.width,
                      imageUrl: widget.imageUrls[index],
                      errorWidget: new Icon(
                        Icons.broken_image,
                        size: 200.0,
                        color: Colors.blueGrey[100],
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal),
            )),
            Text("sdf")
            // new Container(
            //   child: ListView.builder(
            //     itemCount: widget.imageUrls.length,
            //     itemBuilder: (context, position) {
            //       return Text(widget.imageUrls[position]);
            //     },
            //   ),
            // new ListView.builder(

            //   physics: new PageScrollPhysics(),
            //   itemCount: widget.imageUrls.length,
            //   itemBuilder: (BuildContext ctxt, int index) {
            //     // return new CachedNetworkImage(
            //     //   width: MediaQuery.of(context).size.width,
            //     //   imageUrl: widget.imageUrls[index],
            //     //   errorWidget: new Icon(
            //     //     Icons.broken_image,
            //     //     size: 200.0,
            //     //     color: Colors.blueGrey[100],
            //     //   ),
            //     // );

            //     return new Text("sdf");
            //   },
            //   scrollDirection: Axis.horizontal),
            // )
          ],

          //     ListView.builder(

          //   //controller: new FixedExtentScrollController(),
          //   physics: FixedExtentScrollPhysics(),
          //   children: widget.imageUrls.map((month) {
          //     return Card(
          //         child: Row(
          //       children: <Widget>[
          //         Expanded(
          //             child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Text(
          //             month,
          //             style: TextStyle(fontSize: 18.0),
          //           ),
          //         )),
          //       ],
          //     ));
          //   }).toList(),
          //   itemExtent: 60.0,
          // ),
        ),
      ),
    );
  }
}
