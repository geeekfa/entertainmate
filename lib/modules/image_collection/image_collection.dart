import 'package:cached_network_image/cached_network_image.dart';
import 'package:entertainmate/modules/image_collection/image_collection_manager.dart';
import 'package:flutter/material.dart';

class TImageCollection extends StatefulWidget {
  final List imageUrls;
  TImageCollection({this.imageUrls});
  @override
  _MainState createState() => new _MainState();
}

class _MainState extends State<TImageCollection> {

void _openImageCollectionManager() async {
    Map results = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TImageCollectionManager(
                title: "Profile Pictures",
                imageUrls: widget.imageUrls.toList(),
              )),
    );

    // if (results != null && results.containsKey('imageUrls')) {
    //   avatarUrlsNew = results['imageUrls'];
    // }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      // child:widget.imageUrls==null?
      child: (widget.imageUrls == null || widget.imageUrls.length == 0)
          ? RawMaterialButton(
              onPressed: _openImageCollectionManager,
              child: new Icon(
                Icons.image,
                color: Colors.white,
                size: 80.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.blueGrey,
              padding: const EdgeInsets.all(10.0),
            )
          : new ListView.builder(
              itemCount: widget.imageUrls.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return new InkResponse(
                  onTap: _openImageCollectionManager,
                  splashColor: Colors.blueGrey[100],
                  highlightShape: BoxShape.rectangle,
                  containedInkWell: true,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: new CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    errorWidget: new Icon(
                      Icons.broken_image,
                      size: 200.0,
                      color: Colors.blueGrey[100],
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal),
    );
  }
}
