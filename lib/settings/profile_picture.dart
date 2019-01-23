import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainmate/modules/loading/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as path;
import 'package:entertainmate/modules/dialog/image_picker_dialog.dart';
import 'package:entertainmate/modules/slider/slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePicturePage extends StatefulWidget {
  final List<Widget> profilePictures;
  ProfilePicturePage({@required this.profilePictures});
  @override
  ProfilePictureState createState() {
    return new ProfilePictureState();
  }
}

class ProfilePictureState extends State<ProfilePicturePage> {
  bool _visibleDELETE;
  bool _visibleSAVE;
  final key = new GlobalKey<TSliderState>();
  @override
  void initState() {
    if (widget.profilePictures == null || widget.profilePictures.length == 0) {
      _visibleDELETE = false;
      _visibleSAVE = false;
    } else {
      _visibleDELETE = true;
      _visibleSAVE = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> avatarUrlsDeleted = new List();
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
                    _visibleDELETE
                        ? Container(
                            width: 50.0,
                            height: 50.0,
                            child: RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  int indx = key.currentState.index.toInt();
                                  var profilePicture =
                                      widget.profilePictures.removeAt(indx);
                                  if (profilePicture is ProfileNetworkPicture) {
                                    avatarUrlsDeleted
                                        .add(profilePicture.imageUrl);
                                  }

                                  if (widget.profilePictures == null ||
                                      widget.profilePictures.length == 0) {
                                    _visibleDELETE = false;
                                    _visibleSAVE = false;
                                  }
                                });
                              },
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
                          )
                        : Container(width: 50.0, height: 50.0),
                    Container(
                      width: 50.0,
                      height: 50.0,
                      child: RawMaterialButton(
                        onPressed: () {
                          TImagePickerDialog tipd = new TImagePickerDialog(
                              context: context,
                              imageSelected: (File image) {
                                if (image != null) {
                                  setState(() {
                                    ProfileLocalPicture plp =
                                        new ProfileLocalPicture(
                                      imageFile: image,
                                    );
                                    widget.profilePictures.insert(
                                        key.currentState.index.toInt(), plp);
                                    if (widget.profilePictures != null &&
                                        widget.profilePictures.length > 0) {
                                      _visibleDELETE = true;
                                      _visibleSAVE = true;
                                    }
                                  });
                                }
                              });
                          tipd.show();
                        },
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
                    _visibleSAVE
                        ? Container(
                            width: 50.0,
                            height: 50.0,
                            child: RawMaterialButton(
                              onPressed: uploadAndUpdateProfilePictures,
                              child: new Icon(
                                Icons.save,
                                color: Theme.of(context).cardColor,
                                size: 35.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(0.0),
                            ))
                        : Container(width: 50.0, height: 50.0),
                  ],
                )))
      ],
    ));
  }

  void uploadAndUpdateProfilePictures() async {
    List<String> avatarUrls = new List();
    TLoading tLoading = new TLoading(context);
    int i=1;
    int sum=widget.profilePictures.length;
    tLoading.show();
    for (var profilePicture in widget.profilePictures) {
      if (profilePicture is ProfileNetworkPicture) {
        avatarUrls.add(profilePicture.imageUrl);
      } else if (profilePicture is ProfileLocalPicture) {
        // is ProfileLocalPicture
        // 1.upload image
        String imageUrl = profilePicture.imageFile.path;
        tLoading.title="uploading "+i.toString()+" of "+sum.toString();
        i++;
        String networkUrl = await uploadProfilePicture(tLoading,imageUrl);
        
        // 2.get new imageurl and add to avatarUlrs
        avatarUrls.add(networkUrl);
      }
    }
    tLoading.hide();
    // 3. update avatarUrls in table users
    FirebaseApp app = await FirebaseApp.configure(
      name: 'entertainmate',
      options: const FirebaseOptions(
        googleAppID: '1:560093923265:android:f3afa66d99637d32',
        apiKey: 'AIzaSyDyUnIcLNuVhU8koHZP15JfCyrTi9K9U5g',
        projectID: 'entertainmate-2019',
      ),
    );
    final Firestore firestore = Firestore(app: app);
    await firestore.settings(timestampsInSnapshotsEnabled: true);
    var user = {'avatarUrls': avatarUrls};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");

// 3 : update imageurls table user
    tLoading.title="updating ...";
    tLoading.show();
    firestore.collection('users').document(uid).updateData(user).then((v) {
      int g = 0;
      //TODO update success
    }).catchError((e) {
      int g1 = 0;
      //TODO update fails
    });
    tLoading.hide();
  }

  Future<String> uploadProfilePicture(TLoading tLoading,String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");
    String fileName = path.basename(imageUrl);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(uid)
        .child('profile _pictures')
        .child(fileName);
    StorageUploadTask task = ref.putFile(File(imageUrl));
    task.events.listen((event) {
          setState(() {
            double _progess = event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble();
            tLoading.title=_progess.toString();
          });
        }).onError((error) {
          //error.toString()
        });
    return await (await task.onComplete).ref.getDownloadURL();
  }
}

class ProfileNetworkPicture extends StatelessWidget {
  final String imageUrl;
  ProfileNetworkPicture({@required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
            child: new Container(
      padding: EdgeInsets.only(top: 24.0),
      child: new Column(children: <Widget>[
        new Expanded(
          child: new CachedNetworkImage(
            imageUrl: imageUrl,
            errorWidget: new Icon(Icons.error),
          ),
        ),
      ]),
    )));
  }
}

class ProfileLocalPicture extends StatelessWidget {
  final File imageFile;
  ProfileLocalPicture({@required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
            child: new Container(
      padding: EdgeInsets.only(top: 24.0),
      child: new Column(children: <Widget>[
        new Expanded(
          child: new Image.file(imageFile),
        ),
      ]),
    )));
  }
}
