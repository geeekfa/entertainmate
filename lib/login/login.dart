import 'package:entertainmate/home/home.dart';
import 'package:entertainmate/modules/dialog/alert_dialog.dart';
import 'package:entertainmate/modules/loading/loading.dart';
import 'package:entertainmate/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  var textEditEmailController =
      new TextEditingController(text: 'geeekfa@gmail.com');
  var textEditPasswordController = new TextEditingController(text: 'sadad912');

  void _login() async {
    TLoading tLoading = new TLoading(context: context, type: 0);
    try {
      tLoading.show(title: "login ...");
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
          email: _email, password: _password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLogin", true);
      prefs.setString("uid", user.uid);
      tLoading.hide();
      _navigateHome();
    } catch (e) {
      tLoading.hide();
      TAlertDialog tDialog = new TAlertDialog(context);
      tDialog.show(e.code, e.message);
    }
  }

  void _navigateSignup() async {
    Map results = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
    if (results != null && results.containsKey('email')) {
      setState(() {
        textEditEmailController.text = results['email'];
      });
    }
  }

  void _navigateHome() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 24.0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 45.0,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).indicatorColor,
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 100.0, left: 5.0)),
                      new Image.asset(
                        "images/logo.png",
                        width: 25.0,
                      ),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      new Text(
                        "Entertain-Mate",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 95.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.only(left: 65.0, right: 65.0, top: 10.0),
                        child: new TextFormField(
                          controller: textEditEmailController,
                          style: Theme.of(context).textTheme.body1,
                          decoration: new InputDecoration(
                            hintStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                            hintText: "Email",
                            contentPadding: EdgeInsets.all(5.0),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
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
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 65.0, right: 65.0),
                        child: new TextFormField(
                            controller: textEditPasswordController,
                            style: Theme.of(context).textTheme.body1,
                            obscureText: true,
                            decoration: new InputDecoration(
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                              hintText: "Password",
                              contentPadding: EdgeInsets.all(5.0),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
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
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: 65.0, right: 65.0, top: 15.0),
                          child: SizedBox(
                            width: 150.0,
                            height: 30.0,
                            child: new OutlineButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue),
                              child: Text('Log in',
                                  style: Theme.of(context).textTheme.body1),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  _login();
                                }
                              },
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.only(
                              left: 55.0, right: 65.0, top: 10.0),
                          child: SizedBox(
                            width: 120.0,
                            child: new FlatButton(
                              child: SizedBox(
                                width: double.infinity,
                                child: Text('I am new!',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.display3),
                              ),
                              onPressed: () {
                                _navigateSignup();
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 0.0,
                child: new Image.asset("images/login.png"),
              )
            ],
          )),
    );
  }
}
