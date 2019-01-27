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
    TLoading tLoading = new TLoading(context: context,type: 0);
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
        child: new Center(
            child: new Container(
                child: new Column(
          children: <Widget>[
            new Expanded(child: Container()), 
            new Text("Entertain-Mate",
                style: Theme.of(context).textTheme.display2),
            new Container(
              width: 280.0,
              padding: EdgeInsets.all(1.0),
              child: new Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new SizedBox(
                    height: 128.0,
                    width: 180.0,
                    child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new SizedBox(
                          child: new TextFormField(
                            controller: textEditEmailController,
                            style: Theme.of(context).textTheme.body1,
                            decoration: new InputDecoration(
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                              hintText: "Email",
                              contentPadding: EdgeInsets.all(7.0),
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
                        new SizedBox(
                          child: new TextFormField(
                              controller: textEditPasswordController,
                              style:Theme.of(context).textTheme.body1,
                              obscureText: true,
                              decoration: new InputDecoration(
                                hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                                hintText: "Password",
                                contentPadding: EdgeInsets.all(7.0),
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
                      ],
                    ),
                  ),
                  new SizedBox(
                      height: 67.0,
                      width: 98.0,
                      
                      child: new OutlineButton(
                        
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(0.0)),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        child: Text('Log in',
                            style:Theme.of(context).textTheme.body1),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            _login();
                          }
                        },
                      )),
                ],
              ),
            ),
            new OutlineButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              borderSide: BorderSide(color: Colors.blue),
              child: Text('I am new!',
                  style: Theme.of(context).textTheme.body1),
              onPressed: () {
                _navigateSignup();
              },
            ),
            new Expanded(child: Container()),
            new Image.asset("images/login.png")
          ],
        ))),
      ),
    );
  }
}
