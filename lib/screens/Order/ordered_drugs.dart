import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_a_pill_pub/models/drug.dart';
import 'package:pick_a_pill_pub/models/fire_user.dart';
import 'package:pick_a_pill_pub/models/pharm.dart';
import 'package:pick_a_pill_pub/models/user_model.dart';
import 'package:pick_a_pill_pub/services/database.dart';
import 'package:pick_a_pill_pub/shared/loading.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import '../orders.dart';

class OrderedDrugs extends StatefulWidget {
  final OrderPharm pharm;
  OrderedDrugs({this.pharm});
  @override
  _OrderedDrugsState createState() => _OrderedDrugsState();
}

class _OrderedDrugsState extends State<OrderedDrugs> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FireUser>(context);
    OrderPharm pharm = widget.pharm;
    User myData;
    return Scaffold(
      appBar: AppBar(
        title: Text(pharm.name),
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: StreamBuilder<List<Drug>>(
          stream:
              DatabaseService(uid: user.uid, friendUid: pharm.uid).drugOrder,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Drug> drug = snapshot.data;
              if (drug.isNotEmpty) {
                print('This is the uid ${user.uid}');

                return StreamBuilder<User>(
                    stream: DatabaseService(uid: user.uid).myData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        myData = snapshot.data;
                        print(myData.uid);
                        print(user.uid);
                      }
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
                              myData: myData,
                            );
                          });
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
  OrderPharm pharm;
  User myData;
  Lists({this.mydrug, this.me, this.pharm, this.myData});

  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  bool selected = false;
  bool canRun = false;
  bool changeColor = false;
  bool canShowAddNote = false;
  bool canAddNote = false;
  final _formKey = GlobalKey<FormState>();
  String note;
  int amount;
  @override
  Widget build(BuildContext context) {
    Drug myDrug = widget.mydrug;
    FireUser user = widget.me;
    OrderPharm pharm = widget.pharm;
    User mydata = widget.myData;
    if (myDrug.ordered) {
      return Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          child: AnimatedContainer(
              onEnd: () {
                setState(() {
                  if (selected) {
                    canRun = true;
                  }
                  if (canAddNote) {
                    canShowAddNote = true;
                  }
                });
              },
              height: canAddNote ? 313 : 100,
              alignment:
                  selected ? Alignment.center : AlignmentDirectional.topCenter,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(83, 93, 112, 1)),
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            myDrug.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: myDrug.accepted
                                  ? Colors.greenAccent[700]
                                  : myDrug.rejected
                                      ? Colors.red
                                      : Colors.blueGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  myDrug.accepted
                                      ? 'Accepted'
                                      : myDrug.rejected
                                          ? 'Rejected'
                                          : 'Ordered',
                                  style: TextStyle(
                                      letterSpacing: 0.75,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.star_rate, color: Colors.yellowAccent),
                          Text(
                              myDrug.isAvailable
                                  ? "Available"
                                  : "Not Available",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                      trailing: myDrug.replied
                          ? IconButton(
                              onPressed: () async {
                                if (myDrug.replied) {
                                  setState(() {
                                    canAddNote = !canAddNote;
                                    canShowAddNote = !canShowAddNote;
                                  });
                                  if (myDrug.unread) {
                                    await DatabaseService(
                                            uid: user.uid, friendUid: pharm.uid)
                                        .updateMyOrderRead(myDrug.time);
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.circle,
                                size: 25,
                                color: myDrug.unread
                                    ? Colors.greenAccent
                                    : Colors.blueGrey,
                              ),
                            )
                          : null,
                    ),
                    canShowAddNote
                        ? Container(
                            child: Text(myDrug.reply),
                          )
                        : Container(),
                  ],
                ),
              )));
    } else {
      if (canAddNote == false) {
        canShowAddNote = false;
        changeColor = false;
      }
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
              if (canShowAddNote) {
                canAddNote = false;
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
                  if (canAddNote) {
                    canShowAddNote = true;
                  }
                });
              },
              height: myDrug.ordered
                  ? 100
                  : canAddNote
                      ? 313
                      : selected
                          ? 183
                          : 100,
              alignment:
                  selected ? Alignment.center : AlignmentDirectional.topCenter,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(83, 93, 112, 1)),
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
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          changeColor = !changeColor;
                                          canAddNote = !canAddNote;
                                        });
                                      },
                                      color: changeColor
                                          ? Colors.blueGrey[900]
                                          : Colors.blueGrey[700],
                                      child: Text(
                                        canAddNote ? 'Remove Note' : 'Add Note',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                    width: 50,
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black54),
                                        decoration: const InputDecoration(
                                            counterStyle:
                                                TextStyle(color: Colors.white),
                                            hintText: 'Amount',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 3.0),
                                            fillColor: Colors.white,
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 2)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.pink,
                                                    width: 2))),
                                        maxLength: 3,
                                        maxLines: 1,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (value) => value.isEmpty
                                            ? 'Enter Number of items'
                                            : null,
                                        onChanged: (value) {
                                          setState(() {
                                            String _amount = value;
                                            amount = int.parse(_amount);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          print('$note and $amount');
                                        }
                                        setState(() {
                                          selected = !selected;
                                          if (canRun) {
                                            canRun = false;
                                          }
                                          if (canShowAddNote) {
                                            canAddNote = false;
                                          }
                                        });
                                        await DatabaseService(
                                                uid: user.uid,
                                                friendUid: pharm.uid)
                                            .uploadPharmOrder(
                                          myDrug.time,
                                          myDrug.name,
                                          myDrug.photoUrl,
                                          amount,
                                          note,
                                        );
                                        await DatabaseService(
                                                uid: user.uid,
                                                friendUid: pharm.uid)
                                            .uploadPharmOrderList(
                                                mydata.name, mydata.imageUrl);
                                        print(
                                            'Order Uploaded ${mydata.name} ${mydata.imageUrl}');
                                        await DatabaseService(
                                                uid: user.uid,
                                                friendUid: pharm.uid)
                                            .updateMyOrder(myDrug.time);
                                      })
                                ],
                              ),
                              canShowAddNote
                                  ? Row(
                                      children: [
                                        Center(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            height: 130,
                                            child: Expanded(
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 20,
                                                ),
                                                decoration: const InputDecoration(
                                                    counterStyle: TextStyle(
                                                        color: Colors.white),
                                                    hintText: 'Notes',
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10.0),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .pink,
                                                                    width: 2))),
                                                maxLength: 150,
                                                maxLines: 4,
                                                onChanged: (value) {
                                                  setState(() {
                                                    note = value;
                                                    print(note);
                                                  });
                                                  print(
                                                      'This is the note $note');
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
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
}
