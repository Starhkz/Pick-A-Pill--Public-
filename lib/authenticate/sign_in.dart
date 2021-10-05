import 'package:flutter/material.dart';
import 'package:pick_a_pill_pub/services/auth.dart';
import 'package:pick_a_pill_pub/shared/constant.dart';
import 'package:pick_a_pill_pub/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
          backgroundColor: Colors.brown[100],
          appBar: AppBar(
            backgroundColor:  Color.fromRGBO(58, 66, 86, 1.0),
            elevation: 0,
            title: Text('Sign In to Pick a Pill'),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person,
                  color: Colors.white,),
                  label: Text('Register',
                  style: TextStyle(
                    color: Colors.white
                  ),))
            ],
          ),
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
                      RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                              print(loading);
                            });
                            print('valid');

                            dynamic result = await _auth
                                .signInwithEmailAndPassword(email, password);
                            print('It should stop');
                            loading = false;
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error =
                                    'Could Not Sign In With Those Credentials';
                              });
                            }
                          }
                        },
                        color: Colors.pink[400],
                        child: Text(
                          'Sign In',
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
