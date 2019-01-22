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
            bottom: 17.0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: (){},
                      child: new Icon(
                        Icons.delete,
                        color: Theme.of(context).cardColor,
                        size: 40.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(2.0),
                    ),
                    RawMaterialButton(
                      onPressed: (){},
                      child: new Icon(
                        Icons.add,
                        color: Theme.of(context).cardColor,
                        size: 40.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(2.0),
                    ),
                    RawMaterialButton(
                      onPressed: (){},
                      child: new Icon(
                        Icons.save,
                        color: Theme.of(context).cardColor,
                        size: 40.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(2.0),
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
