import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainmate/modules/loading/loading.dart';
import 'package:entertainmate/settings/profile_picture.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() {
    return new ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  List avatarUrlsOld = new List();
  List avatarUrlsNew = new List();

  var textEditNameController = new TextEditingController();
  var textEditFamilyController = new TextEditingController();


  void _save() async {
  }

  void getCurrentUserInfoFromFireStore() async {
    TLoading tl = new TLoading(context: context, type: 0);
    tl.show(title: "loading ...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");

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

    DocumentSnapshot datasnapshot =
        await firestore.collection('users').document(uid).get();

    if (datasnapshot.exists) {
      textEditNameController.text =
          datasnapshot.data['name'] == null ? "" : datasnapshot.data['name'];
      textEditFamilyController.text = datasnapshot.data['family'] == null
          ? ""
          : datasnapshot.data['family'];
      setState(() {
        avatarUrlsOld = datasnapshot.data['avatarUrls'];
      });
    }
    tl.hide();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentUserInfoFromFireStore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                new Container(
                  height: 100.0,
                  child: TProfilePictures(
                    imageUrls: avatarUrlsOld,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 5.0)),
                new TextFormField(
                  controller: textEditNameController,
                  style: Theme.of(context).textTheme.body1,
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    hintText: "Name",
                    contentPadding: EdgeInsets.all(7.0),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(0.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(padding: EdgeInsets.only(bottom: 5.0)),
                new TextFormField(
                  controller: textEditFamilyController,
                  style: Theme.of(context).textTheme.body1,
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    hintText: "Family",
                    contentPadding: EdgeInsets.all(7.0),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(0.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _save,
        tooltip: 'save profile',
        child: Icon(Icons.save),
      ),
    );
  }
}

class TProfilePictures extends StatefulWidget {
  final List imageUrls;
  TProfilePictures({this.imageUrls});
  @override
  TProfilePicturesState createState() => new TProfilePicturesState();
}

class TProfilePicturesState extends State<TProfilePictures> {
  void _openImageCollectionManager() async {
    ProfileNetworkPicture p0 = new ProfileNetworkPicture(
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/entertainmate-2019.appspot.com/o/Linux-Wallpaper-30.png?alt=media&token=23f34db5-302f-49ff-a33b-9b8dbd459af1",
    );
    ProfileNetworkPicture p1 = new ProfileNetworkPicture(
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/entertainmate-2019.appspot.com/o/intro_a.png?alt=media&token=ecaa2004-6b70-4bc0-95bd-473b05453c44",
    );
    ProfileNetworkPicture p2 = new ProfileNetworkPicture(
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/entertainmate-2019.appspot.com/o/intro_b.png?alt=media&token=d2042839-255e-4992-9752-7210dc588d9a",
    );
    List<Widget> lp = new List();
    // lp.add(p0);
    // lp.add(p1);
    // lp.add(p2);
    Map results = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePicturePage(
                profilePictures: lp,
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
                color: Theme.of(context).cardColor,
                size: 80.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(10.0),
            )
          : new ListView.builder(
              physics: new PageScrollPhysics(),
              itemCount: widget.imageUrls.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return new InkResponse(
                  onTap: _openImageCollectionManager,
                  highlightShape: BoxShape.rectangle,
                  containedInkWell: true,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: new CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    errorWidget: new Icon(
                      Icons.broken_image,
                      size: 200.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal),
    );
  }
}
