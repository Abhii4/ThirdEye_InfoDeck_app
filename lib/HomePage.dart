
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infodeck/secondAprroach/editRetailer.dart';
import 'package:infodeck/secondAprroach/firestoreservice.dart';
import 'package:infodeck/secondAprroach/retailer.dart';
import 'package:infodeck/secondAprroach/retailerScreen.dart';




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

    items=new List();

    createRetailer?.cancel();
    createRetailer=fireServ.getRetailerList().listen((QuerySnapshot snapshot){
      final List<Retailer> retailers=snapshot.documents
          .map((documentSnapshot) => Retailer. fromMap(documentSnapshot.data))
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
      body: Column(
        children: <Widget>[
          _myAppBar(context),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Stack(children: <Widget>[
                    // The containers in the background
                    Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80.0,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Material(
                              color: Colors.white,
                              elevation: 14.0,
                              shadowColor: Color(0x802196F3),
                              child: Center(
                                child: GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => EditRetailer(items[index])));
                                  },
                  ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ]);
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFA7397),
        child: Icon(
          FontAwesomeIcons.listUl,
          color: Color(0xFFFDDE42),
        ),
        onPressed: () {
          //Navigator.push(context,MaterialPageRoute(builder: (context) => TaskScreen()),
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditRetailer(),
                fullscreenDialog: true),
          );
        },
      ),
    );
  }











  Widget _myAppBar(context) {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color(0xFFFA7397),
              const Color(0xFFFDDE42),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          //
                        }),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Text(
                      'Retailers List',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          //
                        }),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}