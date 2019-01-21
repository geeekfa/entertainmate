import 'package:entertainmate/modules/slider/slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePicturePage extends StatefulWidget {
  final List<ProfilePicture> profilePictures;
  ProfilePicturePage({@required this.profilePictures});
  @override
  ProfilePictureState createState() {
    return new ProfilePictureState();
  }
}

class ProfilePictureState extends State<ProfilePicturePage> {
  final key = new GlobalKey<TSliderState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        TSlider(
          key: key,
          slides: widget.profilePictures,
          firstSlideReceived: () {},
          slideChanged: (index) {},
          lastSlideReceived: () {},
        ),
        Positioned(
            bottom: 20.0,
            child: Container(
                // height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {},
                      tooltip: 'delete this image',
                      child: Icon(
                        Icons.delete,
                        size: 40.0,
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {},
                      tooltip: 'insert new image',
                      child: Icon(
                        Icons.add,
                        size: 40.0,
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {},
                      tooltip: 'save images',
                      child: Icon(
                        Icons.save,
                        size: 40.0,
                      ),
                    ),
                  ],
                )))
      ],
    ));
  }
}

class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  ProfilePicture({@required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
            child: new Container(
      padding: EdgeInsets.only(top: 24.0),
      child: new Column(children: <Widget>[
        new CachedNetworkImage(
          imageUrl: imageUrl,
          errorWidget: new Icon(Icons.error),
        ),
      ]),
    )));
  }
}
