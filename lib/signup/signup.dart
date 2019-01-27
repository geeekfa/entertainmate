import 'package:entertainmate/modules/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:entertainmate/modules/dialog/alert_dialog.dart';

class SignupPage extends StatefulWidget {
  @override
  SignupPageState createState() {
    return SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  void _signup() async {
    TLoading tLoading = new TLoading(context: context, type: 0);
    try {
      tLoading.show(title: "test");
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      tLoading.hide();
      Navigator.pop(context, {'email': _email});
    } catch (e) {
      tLoading.hide();
      TAlertDialog tDialog = new TAlertDialog(context);
      tDialog.show(e.code, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: new Center(
            child: new Container(
                child: new Column(
          children: <Widget>[
            new Expanded(child: Container()),
            new Text("Entertain-Mate",
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'calibri')),
            new Card(
              elevation: 10.0,
              child: new Container(
                width: 230.0,
                padding: EdgeInsets.all(8.0),
                child: new Column(
                  children: <Widget>[
                    new TextFormField(
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20.0,
                          fontFamily: 'calibri'),
                      decoration: new InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.blueGrey[300],
                        ),
                        hintText: "Email",
                        contentPadding: EdgeInsets.all(7.0),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'Please enter valid email';
                        else
                          return null;
                      },
                      onSaved: (String val) {
                        _email = val;
                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 5.0)),
                    new TextFormField(
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20.0,
                            fontFamily: 'calibri'),
                        obscureText: true,
                        decoration: new InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.blueGrey[300],
                          ),
                          hintText: "Password",
                          contentPadding: EdgeInsets.all(7.0),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please choose a password';
                          } else if (value.length < 6) {
                            return 'More than 6 characters';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (String val) {
                          _password = val;
                        }),
                    Padding(padding: EdgeInsets.only(bottom: 5.0)),
                    new SizedBox(
                        width: double.infinity,
                        child: new RaisedButton(
                          child: const Text('Sign up',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'calibri')),
                          color: Theme.of(context).buttonColor,
                          splashColor: Colors.blueGrey,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _signup();
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
            new Expanded(child: Container()),
            new Image.asset("images/login.png")
          ],
        ))),
      ),
    );
  }
}
