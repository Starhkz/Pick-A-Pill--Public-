import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pick_a_pill_pub/models/drug.dart';
import 'package:pick_a_pill_pub/models/fire_user.dart';
import 'package:pick_a_pill_pub/models/pharm.dart';
import 'package:pick_a_pill_pub/screens/orders.dart';
import 'package:pick_a_pill_pub/services/database.dart';
import 'package:pick_a_pill_pub/shared/loading.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class CustomerPage extends StatefulWidget {
  final Pharm pharm;
  CustomerPage({this.pharm});
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class Item {
  bool isExpanded;
  Item({this.isExpanded});
}

class _CustomerPageState extends State<CustomerPage> {
  List<Item> stuff;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FireUser>(context);
    BuildContext cont;
    Pharm pharm = widget.pharm;
    return Scaffold(
      appBar: AppBar(
        title: Text(pharm.name),
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: StreamBuilder<List<Drug>>(
          stream: DatabaseService(uid: pharm.uid).drugList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Drug> drug = snapshot.data;

              if (drug.isNotEmpty) {
                List<Item> generateItems(int numberOfItems) {
                  return List.generate(numberOfItems, (index) {
                    return Item(isExpanded: false);
                  });
                }

                stuff = generateItems(drug.length);

                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: drug.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Drug myDrug = drug[index];

                      return Lists(
                        mydrug: myDrug,
                        me: user,
                        pharm: pharm,
                        cont: cont,
                      );
                    });
              } else {
                return Loading();
              }
            } else {
              return Loading();
            }
          }),
      bottomNavigationBar: Container(
        height: 55.0,
        child: BottomAppBar(
          elevation: 1,
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
                icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Orders()));
                },
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

class Lists extends StatefulWidget {
  Drug mydrug;
  FireUser me;
  Pharm pharm;
  BuildContext cont;
  Lists({this.mydrug, this.me, this.pharm, this.cont});

  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  bool selected = false;
  bool canRun = false;
  bool changeColor = false;
  @override
  Widget build(BuildContext context) {
    Drug myDrug = widget.mydrug;
    FireUser user = widget.me;
    Pharm pharm = widget.pharm;
    return Column(children: [
      GestureDetector(
        onTap: () {
          print('Drug List waas tapped');

          setState(() {
            print(selected);
            selected = !selected;
            if (canRun) {
              canRun = false;
            }
            print(selected);
          });
          print(selected);
        },
        child: Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          child: AnimatedContainer(
            onEnd: () {
              setState(() {
                if (selected) {
                  canRun = true;
                }
              });
            },
            height: selected ? 161 : 100,
            alignment:
                selected ? Alignment.center : AlignmentDirectional.topCenter,
            duration: Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(83, 93, 112, 1)),
              child: Column(
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        child: CircleAvatar(
                          radius: 35.0,
                          backgroundImage: NetworkImage(myDrug.photoUrl),
                        ),
                      ),
                      title: Text(
                        myDrug.name,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.star_rate, color: Colors.yellowAccent),
                          Text("Open", style: TextStyle(color: Colors.white))
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right,
                          color: Colors.white, size: 30.0)),
                  canRun
                      ? SizedBox(
                          height: 10,
                        )
                      : Container(),
                  canRun
                      ? Container(
                          width: 300,
                          height: 1,
                          color: Colors.white,
                        )
                      : Container(),
                  canRun
                      ? SizedBox(
                          height: 10,
                        )
                      : Container(),
                  canRun
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    changeColor = !changeColor;
                                  });
                                },
                                color: changeColor
                                    ? Colors.blueGrey[900]
                                    : Colors.blueGrey[700],
                                child: Text(
                                  'View Details',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            IconButton(
                                tooltip: 'Add Item to Order List',
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await DatabaseService(
                                          uid: user.uid, friendUid: pharm.uid)
                                      .uploadMyorder(myDrug.time, myDrug.name,
                                          myDrug.photoUrl);
                                  await DatabaseService(
                                          uid: user.uid, friendUid: pharm.uid)
                                      .uploadMyOrderList(
                                          pharm.name, pharm.imageUrl);

                                  setState(() {
                                    selected = !selected;
                                    if (canRun) {
                                      canRun = false;
                                    }
                                  });

                                  print('Order Added');
                                })
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      )
    ]);
  }
}
