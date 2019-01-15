import 'package:entertainmate/settings/profile.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(title:new Text('Settings')),
          body:  ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: Text('Delete Account'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                  },
                ),
              ],
            )
    );
  }
}