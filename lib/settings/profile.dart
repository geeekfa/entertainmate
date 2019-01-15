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
  String _name;
  String _family;
  List avatarUrls = new List();
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
// 1 : Upload imageUrls
    TLoading tLoading = new TLoading(context);
    tLoading.show("uploading ...");
    for (String imageUrl in avatarUrls) {
      String networkUrl = await _uploadProfilePicture(imageUrl);
      // print(newworkUrl);
    }
    tLoading.hide();

// 2 : get All uploaded urls
// 3 : update imageurls table user
// 4 : delete unused images
    // print(imageUrlsMustBeDeleted);
    // print(imageUrls);
  }

  void _openImageCollection() async {
    List imageUrlsOriginal = new List();
    List imageUrlsMustBeDeleted = new List();
    avatarUrls.forEach((imageUrl) {
      imageUrlsOriginal.add(imageUrl);
      imageUrlsMustBeDeleted.add(imageUrl);
    });
    Map results = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TImageCollection(
                title: "Profile Pictures",
                imageUrls: avatarUrls.toList(),
              )),
    );

    if (results != null && results.containsKey('imageUrls')) {

      avatarUrls = results['imageUrls'];
      for (String imageUrl in avatarUrls) {
        imageUrlsMustBeDeleted.removeWhere(
            (imageUrlMustBeDeleted) => imageUrlMustBeDeleted == imageUrl);
      }

      for (String imageUrlOriginal in imageUrlsOriginal) {
        avatarUrls.removeWhere((imageUrl) => imageUrl == imageUrlOriginal);
      }
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
      avatarUrls = datasnapshot.data['avatarUrls'];
      if (avatarUrls.length != 0) {
        setState(() {
          _imageUrlLast = avatarUrls[avatarUrls.length - 1];
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
                  onSaved: (String val) {
                    _name = val;
                  },
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
                  onSaved: (String val) {
                    _name = val;
                  },
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
