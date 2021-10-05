import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pick_a_pill_pub/models/fire_user.dart';

import 'package:pick_a_pill_pub/screens/pharmacies.dart';

import 'package:pick_a_pill_pub/services/auth.dart';

import 'package:provider/provider.dart';

import 'orders.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FireUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      body: Column(
        children: [
          Container(
              color: Colors.green[50],
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Center(
                  child: GestureDetector(
                    onTap: () => null,
                    child: Text(
                      'Searches',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
              color: Colors.green[50],
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Pharmacies())),
                    child: Text(
                      'Pharmacies',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
              color: Colors.green[50],
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Orders())),
                    child: Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text(
                  'Options',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text(
                'Sign Out',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                await _auth.signOut();
                // Update the state of the app.
                Navigator.pop(context);
                // ...
              },
            ),
            ListTile(
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                // Update the state of the app.
                Navigator.pop(context);
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Settings(
                      userUid: user.uid,
                    ),
                  ),
                );

                // ...
              },
            ),
          ],
        ),
      ),
    );
  }
}
