import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infodeck/secondAprroach/retailer.dart';

import 'firestoreservice.dart';

class RetailerScreen extends StatefulWidget {
  final Retailer retailer;
  RetailerScreen(this.retailer);
  @override
  _RetailerScreenState createState() => _RetailerScreenState();
}

class _RetailerScreenState extends State<RetailerScreen> {
  FirestoreService fireServ = new FirestoreService();

  TextEditingController _retailerNameController;
  TextEditingController _retailerPhoneController;
  TextEditingController _retailerGstController;
  TextEditingController _retailerAddressController;



  @override
  void initState() {
    super.initState();

    _retailerNameController = new TextEditingController(text: widget.retailer.name);
    _retailerPhoneController = new TextEditingController(text: widget.retailer.phone);
    _retailerGstController = new TextEditingController(text: widget.retailer.gst);
    _retailerAddressController = new TextEditingController(text: widget.retailer.address);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          _myAppBar(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _retailerNameController,
                    decoration: InputDecoration(labelText: "Name: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _retailerPhoneController,
                    decoration: InputDecoration(labelText: "Phone: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _retailerGstController,
                    decoration: InputDecoration(labelText: "GST: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _retailerAddressController,
                    decoration: InputDecoration(labelText: "Address: "),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        color: Color(0xFFFA7397),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFFFDDE42)),
                        )),
                    // This button results in adding the contact to the database
                    RaisedButton(
                        color: Color(0xFFFA7397),
                        onPressed: () {
                          fireServ.createRetailer(_retailerNameController.text, _retailerPhoneController.text,_retailerGstController.text,_retailerAddressController.text).then((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Color(0xFFFDDE42)),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _myAppBar() {
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
                          Navigator.pop(context);
                        }),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Text(
                      'New Retailer',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}