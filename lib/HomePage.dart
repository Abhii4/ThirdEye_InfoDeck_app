import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:infodeck/root_page.dart';



import 'package:infodeck/secondAprroach/editRetailer.dart';
import 'package:infodeck/secondAprroach/firestoreservice.dart';
import 'package:infodeck/secondAprroach/retailer.dart';






class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Retailer> items;
  FirestoreService fireServ = new FirestoreService();
  StreamSubscription<QuerySnapshot> createRetailer;







  @override
  void initState() {
    super.initState();

    items = new List();

    createRetailer?.cancel();
    createRetailer =
        fireServ.getRetailerList().listen((QuerySnapshot snapshot) {
          final List<Retailer> retailers = snapshot.documents
              .map((documentSnapshot) => Retailer.fromMap(documentSnapshot.data))
              .toList();

          setState(() {
            this.items = retailers;
          });
        });
  }


  @override
  Widget build(BuildContext context) {
    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Icon(Icons.account_circle, color: Colors.white),
                ),
                title: Text(
                  items[index].name,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditRetailer(items[index])));
                },
              ),
            ),
          );
        },
      ),
    );

      final makeBottom = CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.orangeAccent,
        buttonBackgroundColor: Colors.white,
        height: 50,
        items: <Widget>[
          Icon(Icons.event_note,size: 20,color: Colors.black),
          Icon(Icons.add_circle,size: 50,color: Colors.redAccent),
          Icon(Icons.account_box,size: 20,color: Colors.black),
        ],
        animationDuration: Duration(
          milliseconds: 200
        ),
        index:1,
        animationCurve: Curves.bounceInOut,
        onTap: (index){
          if(index==0){
          }
          else if(index==1){
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditRetailer()));
          }
          else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => RootPage()));
          }
        },
      );

    final topAppBar = AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text("Retailers"),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      bottomNavigationBar: makeBottom,
    );
  }
}



