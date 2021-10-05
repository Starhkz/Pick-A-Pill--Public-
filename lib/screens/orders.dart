import 'package:flutter/material.dart';
import 'package:pick_a_pill_pub/models/fire_user.dart';
import 'package:pick_a_pill_pub/models/pharm.dart';
import 'package:pick_a_pill_pub/screens/Order/ordered_drugs.dart';
import 'package:pick_a_pill_pub/services/database.dart';
import 'package:pick_a_pill_pub/shared/loading.dart';
import 'package:provider/provider.dart';

import 'Order/customerPage.dart';
import 'home.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FireUser>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text('Orders'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          )
        ],
      ),
      body: StreamBuilder<List<OrderPharm>>(
          stream: DatabaseService(uid: user.uid).pharmOrder,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('First now working');
              List<OrderPharm> pharmList = snapshot.data;
              if (pharmList.isNotEmpty) {
                print('next is working');
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: pharmList.length,
                  itemBuilder: (BuildContext context, int index) {
                    OrderPharm pharm = pharmList[index];
                    return Card(
                      elevation: 8.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(64, 75, 96, .9)),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => OrderedDrugs(
                                        pharm: pharm,
                                      ))),
                          child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                child: CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: NetworkImage(pharm.imageUrl),
                                ),
                              ),
                              title: Text(
                                pharm.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Row(
                                children: <Widget>[
                                  Icon(Icons.star_rate,
                                      color: Colors.yellowAccent),
                                  Text(" Intermediate",
                                      style: TextStyle(color: Colors.white))
                                ],
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.white, size: 30.0)),
                        ),
                      ),
                    );
                  },
                );
              } else {
                print('The list length ${pharmList.length}');
                return Loading();
              }
            } else {
              print('The current user ${user.uid}');
              return Loading();
            }
          }),
      bottomNavigationBar: Container(
        height: 55.0,
        child: BottomAppBar(
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Home()));
                },
              ),
              IconButton(
                icon: Icon(Icons.blur_on, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.hotel, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.account_box, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
