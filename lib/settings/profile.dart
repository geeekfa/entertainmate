import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainmate/modules/image_collection/image_collection.dart';
import 'package:entertainmate/modules/loading/loading.dart';
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

  String _imageUrlLast;
  var textEditNameController = new TextEditingController();
  var textEditFamilyController = new TextEditingController();

  Future<String> _uploadProfilePicture(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");
    String fileName = path.basename(imageUrl);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(uid)
        .child('profile_pictures')
        .child(fileName);
    StorageUploadTask task = ref.putFile(File(imageUrl));
    return await (await task.onComplete).ref.getDownloadURL();
  }

  void _save() async {
    List avatarUrlsMustBeDeleted = new List();
    List avatarUrlsMustBeRemained = new List();
    avatarUrlsOld.forEach((imageUrl) {
      avatarUrlsMustBeDeleted.add(imageUrl);
      avatarUrlsMustBeRemained.add(imageUrl);
    });
    for (String avatarUrlNew in avatarUrlsNew) {
      avatarUrlsMustBeDeleted.removeWhere(
          (avatarUrlMustBeDeleted) => avatarUrlMustBeDeleted == avatarUrlNew);
    }
    for (String avatarUrlNew in avatarUrlsNew) {
      // خط زیر باید در واقع باشد
      //RemainWhere
      avatarUrlsMustBeRemained.removeWhere(
          (avatarUrlMustBeRemained) => avatarUrlMustBeRemained != avatarUrlNew);
    }
    for (String avatarUrlOld in avatarUrlsOld) {
      avatarUrlsNew.removeWhere((avatarUrlNew) => avatarUrlNew == avatarUrlOld);
    }
// 1 : Upload imageUrls
    TLoading tLoading = new TLoading(context);
    tLoading.show("uploading ...");
    List networkUrls = new List();
    for (String avatarUrlNew in avatarUrlsNew) {
      String networkUrl = await _uploadProfilePicture(avatarUrlNew);
      networkUrls.add(networkUrl);
    }
    tLoading.hide();

// 2 : get All uploaded urls
    avatarUrlsNew = networkUrls;
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
    //concat remain images and uploaded images
    List newAvatarUrls = new List.from(avatarUrlsMustBeRemained)
      ..addAll(avatarUrlsNew);
    var user = {
      'name': textEditNameController.text,
      'family': textEditFamilyController.text,
      'avatarUrls': newAvatarUrls
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");

// 3 : update imageurls table user
    tLoading.show("saving ...");
    firestore.collection('users').document(uid).updateData(user).then((v) {
      int g = 0;
      //TODO update success
    }).catchError((e) {
      int g1 = 0;
      //TODO update fails
    });
    tLoading.hide();
// 4 : delete unused images

// 5. load new sata from users table and fill textboxs and image profile
    // print(imageUrlsMustBeDeleted);
    // print(imageUrls);
  }

  void _openImageCollection() async {
    Map results = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TImageCollection(
                title: "Profile Pictures",
                imageUrls: avatarUrlsOld.toList(),
              )),
    );

    if (results != null && results.containsKey('imageUrls')) {
      avatarUrlsNew = results['imageUrls'];
    }
  }

  void _getCurrentUserInfoFromFireStore() async {
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
      avatarUrlsOld = datasnapshot.data['avatarUrls'];
      if (avatarUrlsOld.length != 0) {
        setState(() {
          _imageUrlLast = avatarUrlsOld[avatarUrlsOld.length - 1];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserInfoFromFireStore();
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
                  child: new GestureDetector(
                    onTap: _openImageCollection,
                    child: _imageUrlLast == null
                        ? new Icon(
                            Icons.image,
                            color: Colors.blueGrey,
                            size: 100.0,
                          )
                        : new CachedNetworkImage(
                            height: 100.0,
                            imageUrl: _imageUrlLast,
                            errorWidget: new Icon(
                              Icons.broken_image,
                              size: 100.0,
                              color: Colors.blueGrey[100],
                            )),
                  ),
                ),
                new TextFormField(
                  controller: textEditNameController,
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20.0,
                      fontFamily: 'calibri'),
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.blueGrey[300],
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
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20.0,
                      fontFamily: 'calibri'),
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.blueGrey[300],
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
        backgroundColor: Colors.blueGrey,
        onPressed: _save,
        tooltip: 'save profile',
        child: Icon(Icons.save),
      ),
    );
  }
}