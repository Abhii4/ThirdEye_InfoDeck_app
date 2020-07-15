import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:infodeck/animations/FadeAnimation.dart';
import 'package:infodeck/secondAprroach/packagePage.dart';
import 'package:infodeck/secondAprroach/retailer.dart';
import 'package:infodeck/secondAprroach/retailerProvider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class EditRetailer extends StatefulWidget {
  final Retailer retailer;

  EditRetailer([this.retailer]);
  

  @override
  _EditRetailerState createState() => _EditRetailerState();
}

class _EditRetailerState extends State<EditRetailer> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final gstController = TextEditingController();
  final addressController = TextEditingController();
  String phoneNumber;
  String userLocation='';
  String notiBtn = 'Notify Retailer';
  String token;
  var gstInfo;
  String gstNo;

  static const String BASE_URL = 'https://commonapi.mastersindia.co/commonapis/searchgstin';

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    gstController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.retailer == null) {
      //New Record
      nameController.text = "";
      phoneController.text = "";
      gstController.text = "";
      addressController.text = "";
      new Future.delayed(Duration.zero, () {
        final retailerProvider =
        Provider.of<RetailerProvider>(context, listen: false);
        retailerProvider.loadValues(Retailer(null, null, null, null,null,null));
      });
    } else {
      //Controller Update
      nameController.text = widget.retailer.name;
      phoneController.text = widget.retailer.phone;
      gstController.text = widget.retailer.gst;
      addressController.text = widget.retailer.address;
      userLocation = widget.retailer.location;

      //State Update
      new Future.delayed(Duration.zero, () {
        final retailerProvider =
        Provider.of<RetailerProvider>(context, listen: false);
        retailerProvider.loadValues(widget.retailer);
      });
    }

    super.initState();
  }
  _getretailerId(){
    String retailerId = widget.retailer.retailerId;
    return retailerId;
  }

  getLocation() async {

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemark);
    Placemark placeMark  = placemark[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    String address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
    return address;
  }

  Future getapiAuth() async {
    final response = await http.post('https://commonapi.mastersindia.co/oauth/access_token',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      body: jsonEncode(<String, String>{
          "username": "abhishek46810@gmail.com",
          "password" : "Abhishek@123",
          "client_id":"rtlfbXWpJpVpozfOnx",
          "client_secret":"kfhwzUK60jm7fKr2ExUNoHF4",
          "grant_type":"password"
        }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['access_token'];

    }
  }

   Future verifyGst() async {

    await getapiAuth().then((value) => token =value);
    print(token);
    final response = await http.get('${BASE_URL}?gstin=${gstNo}',
        headers: {
      'Authorization': 'Bearer ${token}',
          'client_id': 'rtlfbXWpJpVpozfOnx'
    });
    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);

    } else {
      return null;
    }
  }

  void NotVerfiedDialog() {
    showDialog(
        context: context,barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
        title: Text('NOT VERIFIED'),
        content: const Text('Invalid GST number!'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              gstController.text = "";
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
    }

  void VerfiedDialog() {
     showDialog(
        context: context,barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(' VERIFIED'),
            content:

              Container(

                child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[
                      Container(
                child: Text("Name :"+ gstInfo['data']['lgnm']),
              ),
                      SizedBox(height: 10),
            Container(
              child: Text("Trade Name :"+ gstInfo['data']['tradeNam']),
            ),],)



                ),



            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final retailerProvider = Provider.of<RetailerProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.orangeAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 130,
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeAnimation(
                    1,
                    Text(
                      "Edit Retailer Detail",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.4,
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[500]))),
                                  child: TextField(
                                    controller: nameController,
                                    onChanged: (value) =>
                                        retailerProvider.changeName(value),
                                    decoration: InputDecoration(
                                        hintText: "Retailer Name",
                                        hintStyle:
                                        TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[500]))),
                                  child: TextField(
                                    controller: phoneController,
                                    onChanged: (value) {
                                      retailerProvider.changePhone(value);
                                      phoneNumber=value;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Retailer Phone",
                                        hintStyle:
                                        TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[500]))),
                                  child: TextField(
                                    controller: gstController,
                                    onChanged: (value) {
                                      retailerProvider.changeGst(value);
                                      gstNo = value;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Retailer GST",
                                        hintStyle:
                                        TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),


                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[500]))),
                                  child: TextField(
                                    controller: addressController,
                                    onChanged: (value) =>
                                        retailerProvider.changeAddress(value),
                                    decoration: InputDecoration(
                                        hintText: "Retailer Address",
                                        hintStyle:
                                        TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          onPressed: () async {
                                            userLocation = await getLocation();
                                            print("Location is :" + userLocation);
                                            retailerProvider.changeLocation(userLocation);

//
                                          },
                                          color: Colors.blue,
                                          child: Text("Get Location", style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                    ],

                                  )

                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[500]))),
                                  child: Text(
                                    userLocation,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ),
                              ],
                            ),
                          ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row (
                        children: <Widget>[
                          Expanded(
                            child: FadeAnimation(
                              1.9,
                              (widget.retailer == null)
                                  ? InkWell(
                                  onTap: () async {


                                    await verifyGst().then((value) => gstInfo=value);
                                    print(gstInfo['error']);
                                    if(gstInfo['error']==false){

                                       VerfiedDialog();

                                    }
                                    else{
                                      NotVerfiedDialog();



                                    }
//

                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(50),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        'Verify GST',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ))
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FadeAnimation(
                              1.8,
                              InkWell(
                                  onTap: () {
                                    retailerProvider.saveRetailer();
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        "Add",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: FadeAnimation(
                              1.9,
                              (widget.retailer != null)
                                  ? InkWell(
                                  onTap: () {
                                    retailerProvider.removeProduct(
                                        widget.retailer.retailerId);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(50),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ))
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row (
                        children: <Widget>[
                          Expanded(
                            child: FadeAnimation(
                              1.9,
                              (widget.retailer != null)
                                  ? InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => PackagePage(
                                          retailerId : _getretailerId
                                        )));
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(50),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        "View Packages",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ))
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row (
                        children: <Widget>[
                          Expanded(
                            child: FadeAnimation(
                              1.9,
                              (widget.retailer == null)
                                  ? InkWell(
                                  onTap: () {
                                    FlutterOpenWhatsapp.sendSingleMessage(phoneNumber, "Your entry with all details has been created.Thank you.").whenComplete(() => notiBtn='Notified.');
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(50),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        notiBtn,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ))
                                  : Container(),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}