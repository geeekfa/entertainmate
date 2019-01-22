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
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      height: 50.0,
                      child: RawMaterialButton(
                        onPressed: () {},
                        child: new Icon(
                          Icons.delete,
                          color: Theme.of(context).cardColor,
                          size: 35.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 2.0,
                        fillColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(0.0),
                      ),
                    ),
                    Container(
                      width: 50.0,
                      height: 50.0,
                      child: RawMaterialButton(
                        onPressed: () {},
                        child: new Icon(
                          Icons.add,
                          color: Theme.of(context).cardColor,
                          size: 35.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 2.0,
                        fillColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(0.0),
                      ),
                    ),
                    Container(
                        width: 50.0,
                        height: 50.0,
                        child: RawMaterialButton(
                          onPressed: () {},
                          child: new Icon(
                            Icons.save,
                            color: Theme.of(context).cardColor,
                            size: 35.0,
                          ),
                          shape: new CircleBorder(),
                          elevation: 2.0,
                          fillColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.all(0.0),
                        )),
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
