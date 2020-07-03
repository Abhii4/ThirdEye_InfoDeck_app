import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:infodeck/animations/FadeAnimation.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.orangeAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 120,
            child: Stack(
              children: <Widget>[
                Positioned(
                    child: FadeAnimation(
                      1,
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/1.png"),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          Positioned(
            child: Text(
              "Retailers List",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            top: 30,
            left: 20,
          ),
          Expanded(
            child: DraggableScrollableSheet(
              maxChildSize: 0.85,
              minChildSize: 0.1,
              builder:
                  (BuildContext context, ScrollController scrolController) {
                return Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40)),
                      ),
                      child: Expanded(
                        child: ListView.builder(
                          // itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Stack(children: <Widget>[
                              // The containers in the background
                              Expanded(
                                child: Column(children: <Widget>[
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 80.0,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: GestureDetector(
                                          child: Material(
                                            color: Colors.white,
                                            elevation: 14.0,
                                            shadowColor: Color(0x802196F3),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        '${items[index].name}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditRetailer(
                                                            items[index])));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ]);
                          },
                          controller: scrolController,
                          itemCount: items.length,
                        ),
                      ),
                    ),
                    Positioned(
                      child: FloatingActionButton(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.pinkAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditRetailer(),
                                fullscreenDialog: true),
                          );
                        },
                      ),
                      top: -30,
                      right: 30,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}