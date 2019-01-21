import 'package:cached_network_image/cached_network_image.dart';
import 'package:entertainmate/settings/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:entertainmate/modules/dialog/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var textEditAccountEmailController = new TextEditingController();
  var textEditAccountNameController = new TextEditingController();
  String avatarUrl = "";
  String firstLetter = "";
  bool hasAvatarImage = false;
  @override
  void initState() {
    super.initState();
    _getUserInfoFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _exitApp,
      child: Scaffold(
          appBar: AppBar(),
          body: Center(
              child: TextField(
                  enabled: false,
                  controller: textEditAccountEmailController,
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                  ))),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: TextField(
                      controller: textEditAccountNameController,
                      enabled: false,
                      style: Theme.of(context).textTheme.display4,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0.0))),
                  accountEmail: TextField(
                      controller: textEditAccountEmailController,
                      enabled: false,
                      style: Theme.of(context).textTheme.display4,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0.0))),
                  currentAccountPicture: hasAvatarImage
                      ? CircleAvatar(
                          backgroundColor: Theme.of(context).backgroundColor,
                          backgroundImage:
                              CachedNetworkImageProvider(avatarUrl),
                        )
                      : CircleAvatar(
                          child: new Text(
                            firstLetter,
                            style: Theme.of(context).textTheme.headline,
                          ),
                          backgroundColor: Theme.of(context).backgroundColor,
                        ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: Text('Log out'),
                  onTap: _logout,
                ),
              ],
            ),
          )),
    );
  }

  Future<bool> _exitApp() async {
    exit(0);
    return new Future.value(true);
  }

  Future<bool> _logout() {
    TConfirmDialog tConfirmDialog = new TConfirmDialog(
        context: context,
        noPressed: () {
          Navigator.of(context).pop();
        },
        yesPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLogin", false);
          prefs.setString("uid", null);
          Navigator.of(context).pop();
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        });
    tConfirmDialog.show("Confirm Logout", "Are you sure you want to Log out?");
    return new Future.value(false);
  }

  Future _getUserInfoFromFireStore() async {
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
        await Firestore.instance.collection('users').document(uid).get();
    if (datasnapshot.exists) {
      String _name =
          datasnapshot.data['name'] == null ? "" : datasnapshot.data['name'];
      String _family = datasnapshot.data['family'] == null
          ? ""
          : datasnapshot.data['family'];
      String _email = datasnapshot.data['email'];
      List avatarUrls = datasnapshot.data['avatarUrls'];
      textEditAccountEmailController.text = _email;
      textEditAccountNameController.text = _name + " " + _family;
      setState(() {
        if (avatarUrls.length == 0) {
          if (_name != null &&
              _name != "" &&
              _family != null &&
              _family != "") {
            firstLetter = _name[0].toUpperCase() + _family[0].toUpperCase();
          } else {
            firstLetter = _email[0].toUpperCase();
          }

          hasAvatarImage = false;
        } else {
          avatarUrl = avatarUrls.elementAt(avatarUrls.length - 1);
          hasAvatarImage = true;
        }
      });
    }
  }
}
