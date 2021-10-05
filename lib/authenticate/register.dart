import 'package:flutter/material.dart';
import 'package:pick_a_pill_pub/services/auth.dart';
import 'package:pick_a_pill_pub/shared/constant.dart';
import 'package:pick_a_pill_pub/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String pharmName = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
          backgroundColor: Colors.brown[100],
          appBar: AppBar(
              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              elevation: 0,
              title: Text('Sign Up to Pick a Pill'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person,
                      color: Colors.white,),
                    label: Text('Sign In',
                      style: TextStyle(
                          color: Colors.white
                      ),))
              ]),
          body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter an E-Mail' : null,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (value) => value.length < 6
                            ? 'Enter a Password at least 6 chars long'
                            : null,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'User Name'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter Name of Pharmacy' : null,
                        onChanged: (value) {
                          setState(() {
                            pharmName = value;
                          });
                        },
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                              print(loading);
                            });
                            dynamic result =
                                await _auth.registerwithEmailAndPassword(
                                    email, password, pharmName);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please Supply a valid Email';
                              });
                            }
                          }
                        },
                        color: Colors.pink[400],
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red[600], fontSize: 14),
                      )
                    ],
                  ))));
    }
  }
}
