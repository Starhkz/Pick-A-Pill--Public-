import 'package:flutter/material.dart';
import 'package:pick_a_pill_pub/models/pharm.dart';
import 'package:pick_a_pill_pub/services/database.dart';
import 'package:pick_a_pill_pub/shared/loading.dart';

import 'Order/customerPage.dart';
import 'home.dart';

class Pharmacies extends StatefulWidget {
  @override
  _PharmaciesState createState() => _PharmaciesState();
}

class _PharmaciesState extends State<Pharmacies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text('List of Pharmacies'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          )
        ],
      ),
      body: StreamBuilder<List<Pharm>>(
          stream: DatabaseService().getPharm,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Pharm> pharm = snapshot.data;
              if (pharm.isNotEmpty) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: pharm.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Pharm myPharm = pharm[index];
                    return Lists(
                      pharm: myPharm,
                    );
                  },
                );
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

class Lists extends StatefulWidget {
  Pharm pharm;
  Lists({this.pharm});

  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  bool selected = false;
  bool canRun = false;
  bool changeColor = false;
  bool changeColor2 = false;
  @override
  Widget build(BuildContext context) {
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
                          backgroundImage: NetworkImage(pharm.imageUrl),
                        ),
                      ),
                      title: Text(
                        pharm.name,
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => CustomerPage(
                                                  pharm: pharm,
                                                )));
                                  });
                                },
                                color: changeColor
                                    ? Colors.blueGrey[900]
                                    : Colors.blueGrey[700],
                                child: Text(
                                  'View Drug Register',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    changeColor2 = !changeColor2;
                                  });
                                },
                                color: changeColor2
                                    ? Colors.blueGrey[900]
                                    : Colors.blueGrey[700],
                                child: Text(
                                  'View Profile',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
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
