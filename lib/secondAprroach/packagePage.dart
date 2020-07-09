

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PackagePage extends StatefulWidget {
  PackagePage({this.retailerId});
  final  retailerId;


  @override
  _PackagePage createState() => _PackagePage();
}

class _PackagePage extends State<PackagePage> {
  bool _isChecked = false;

  List _texts = [];

  @override
  void initState() {
    super.initState();
    getPackages();

  }

  getPackages() async{
    String retailerID = widget.retailerId();
    print(retailerID);
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot packages = await Firestore.instance.collection('users').document(user.uid).collection('retailers').document(retailerID).collection('packages').getDocuments();
    setState(() {
      for (int i = 0; i < packages.documents.length; i++) {
        var a = packages.documents[i];
        print(a.documentID);
        _texts.add(a.documentID);
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CheckBox in ListView Example"),
      ),
      body: Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _texts.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: CheckboxListTile(
                  title: Text(_texts[index]),
                  value: _isChecked,
                  onChanged: (newValue) { setState(() {
                    _isChecked = newValue;

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