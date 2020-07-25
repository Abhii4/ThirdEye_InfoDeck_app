

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infodeck/secondAprroach/package.dart';


class GivenPackagePage extends StatefulWidget {
  GivenPackagePage({this.retailerId});
  final  retailerId;





  @override
  _GivenPackagePage createState() => _GivenPackagePage();
}

class _GivenPackagePage extends State<GivenPackagePage> {
  List<Package> packageList;

  List<Package> items;

  StreamSubscription<QuerySnapshot> createPackage;


  @override
  void initState() {
    super.initState();

    items = new List();
    Stream<QuerySnapshot> getPackageList({int offset, int limit}) async* {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String retailerID = widget.retailerId();
      Stream<QuerySnapshot> snapshots = Firestore.instance.collection('users').document(user.uid).collection('retailers').document(retailerID).collection('givenpackages').snapshots();
      print(snapshots);

      if (offset != null) {
        snapshots = snapshots.skip(offset);
      }
      if (limit != null) {
        snapshots = snapshots.take(limit);
      }
      yield* snapshots;
    }

    createPackage?.cancel();
    createPackage = getPackageList().listen((QuerySnapshot snapshot) {
      final List<Package> packages = snapshot.documents
          .map((documentSnapshot) => Package.fromFirestore(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = packages;
      });
    });


  }







  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(210, 253, 253, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(94, 197, 198, 1),
        title: Text("Packages Given"),
          centerTitle: true
      ),
      body: Container(
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
                  decoration: BoxDecoration(color: Colors.green),
                  child: CheckboxListTile(
                    title: Text(items[index].name,style: TextStyle(fontWeight: FontWeight.bold)),
                    value: items[index].check,
                    onChanged: (newValue) { setState(() async {
                      String retailerID = widget.retailerId();
                      print(retailerID);
                      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
                      Firestore.instance.collection('users').document(user.uid).collection('retailers').document(retailerID).collection('givenpackages').document(items[index].name).updateData({'check' :newValue});
                      Firestore.instance.collection('users').document(user.uid).collection('assignedpackages').document(items[index].name).setData({'name':items[index].name,'check' :newValue});
                      Firestore.instance.collection('users').document(user.uid).collection('retailers').document(retailerID).collection('givenpackages').document(items[index].name).delete();
                      String package = items[index].name;
                      Fluttertoast.showToast(

                          msg: "$package successfully removed",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black12,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );


                    }); },
                    controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                  )
              ),
            );
          },
        ),
      ),
    );
  }
}