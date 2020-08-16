import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infodeck/animations/FadeAnimation.dart';
import 'package:infodeck/secondAprroach/givenPackagePage.dart';
import 'package:infodeck/secondAprroach/packagePage.dart';
import 'package:infodeck/secondAprroach/retailer.dart';
import 'package:infodeck/secondAprroach/retailerProvider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:io';

import 'fileuploadPage.dart';
import 'gstinfoPage.dart';


class EditRetailer extends StatefulWidget {
  final Retailer retailer;
  EditRetailer([this.retailer]);
  @override
  _EditRetailerState createState() => _EditRetailerState();
}
class _EditRetailerState extends State<EditRetailer> with SingleTickerProviderStateMixin{
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final gstController = TextEditingController();
  final addressController = TextEditingController();
  String phoneNumber;
  String userLocation='';
  String token;
  var gstInfo;
  String gstNo;
  int _validate = 0;
  bool _status = true;
  String imageUrl;
  var verifiedIcon;
  File _image=null;
  final FocusNode myFocusNode = FocusNode();
  static const String BASE_URL = 'https://commonapi.mastersindia.co/commonapis/searchgstin';
  @override
  void dispose() {
    myFocusNode.dispose();
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
        Provider.of<RetailerProvider>(this.context, listen: false);
        retailerProvider.loadValues(Retailer(null, null, null, null,null,null,null,null));
      });
    } else {
      //Controller Update
      nameController.text = widget.retailer.name;
      phoneController.text = widget.retailer.phone;
      gstController.text = widget.retailer.gst;
      addressController.text = widget.retailer.address;
      userLocation = widget.retailer.location;
      imageUrl = widget.retailer.profileUrl;

      //State Update
      new Future.delayed(Duration.zero, () {
        final retailerProvider =
        Provider.of<RetailerProvider>(this.context, listen: false);
        retailerProvider.loadValues(widget.retailer);
      });
    }
    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadPic(BuildContext context) async{
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('retailerProfilePics').child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    setState(() async {
      imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    });
    print(imageUrl);
    print("Profile Picture uploaded");
  }






  _getretailerId(){
    String retailerId = widget.retailer.retailerId;
    return retailerId;
  }
  _getretailerName(){
    String retailerName = widget.retailer.name;
    return retailerName;
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

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(this.context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final retailerProvider = Provider.of<RetailerProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(35, 121, 69, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(94, 197, 198, 1),
        title: Text("Details"), centerTitle: true

      ),
      body: Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 250.0,
                  color: Color.fromRGBO(210, 253, 253, 1),

                  child: new Column(

                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(image:(imageUrl!=null)? NetworkImage(imageUrl):(_image!=null)? FileImage(_image): new ExactAssetImage(
                                          'assets/images/as.png'),
                                          fit: BoxFit.cover)

                                  )),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                      child: new CircleAvatar(
                                        backgroundColor: Colors.black,
                                        radius: 25.0,
                                        child: new Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () async {

                                        await getImage();

                                      }
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Retailer Information',
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Retailer Name',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: nameController,
                                    onChanged: (value) async {
                                      retailerProvider.changeName(value);
                                    },
                                    decoration:  InputDecoration(
                                      hintText: "Enter Retailer's Name",
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,

                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Mobile',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: phoneController,
                                    onChanged: (value) async {
                                      retailerProvider.changePhone(value);
                                      phoneNumber=value;
                                    },
                                    decoration:  InputDecoration(
                                      hintText: "Enter Retailer's Mobile",
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,

                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'GST Number',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: gstController,
                                    onChanged: (value) async {
                                      verifiedIcon=null;
                                      retailerProvider.changeGst(value);
                                      gstNo = value;
                                    },
                                    decoration:  InputDecoration(
                                      hintText: "Enter GST number",
                                        suffixIcon: verifiedIcon,
                                      ),
                                    enabled: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Address',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: addressController,
                                    onChanged: (value) async {
                                      retailerProvider.changeAddress(value);
                                    },
                                    decoration:  InputDecoration(
                                      hintText: "Enter Retailer's Address ",

                                    enabled: !_status,
                                  ),
                                ),
                                )],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Current Address :',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 20.0),
                          child: new Row(
                            children: <Widget>[
                              Flexible(
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      userLocation,

                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),

                            ],

                          ),),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 150.0, right: 25.0, top: 20),

                      child: (widget.retailer == null)
                          ?Container(

                        child: RaisedButton(
                          onPressed: () async {
                            userLocation = await getLocation();


                            print("Location is :" + userLocation);
                            retailerProvider.changeLocation(userLocation);},
                          color: Colors.lightBlue,
                          child: Text("Get Location", style: TextStyle(color: Colors.white),),
                        ),

                      ) : Container()

      ),
                        !_status ? _getActionButtons() : new Container(),
                      ],

                    ),

                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row (
                  children: <Widget>[
                    Expanded(
                      child: FadeAnimation(
                        1.9,(widget.retailer != null)
                          ? InkWell(
                          onTap: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => FileUploadPage(
                                    retailerId : _getretailerId,
                                  )));
                            },
                            child: Container(

                              margin: const EdgeInsets.fromLTRB(100,0,100,0),
                              padding: const EdgeInsets.all(3.0),
                              height: 50,

                              decoration: BoxDecoration(

                                  borderRadius:
                                  BorderRadius.circular(50),
                                  color: Color.fromRGBO(35, 121, 69, 1)),
                              child: Center(
                                child: Text(
                                  'Upload Files',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )) : Container(),

                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
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
                                setState(() {
                                  verifiedIcon = Icon(Icons.check_circle,color: Colors.green);
                                });
                                Fluttertoast.showToast(
                                    msg: "Your GST number is Verified!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.black,
                                    fontSize: 16.0
                                );

                                retailerProvider.changeGstInfo(gstInfo['data']['tradeNam'],gstInfo['data']['lgnm'],gstInfo['data']['stj'],gstInfo['data']['rgdt'],gstInfo['data']['ctb'],gstInfo['data']['dty'],gstInfo['data']['nba'].toString(),gstInfo['data']['sts'],gstInfo['data']['cxdt'],gstInfo['data']['lstupdt'],gstInfo['data']['stjCd'],gstInfo['data']['ctjCd'], gstInfo['data']['adadr'].toString(),gstInfo['data']['pradr']['addr'].toString());
                              }
                              else{
                                Fluttertoast.showToast(
                                    msg: "Incorrect GST Number!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.black,
                                    fontSize: 16.0
                                );
                                setState(() {
                                  verifiedIcon = Icon(Icons.cancel,color: Colors.red);
                                  gstController.text = "";
                                });
                              }
                            },
                            child: Container(

                              margin: const EdgeInsets.fromLTRB(100,0,100,0),
                              padding: const EdgeInsets.all(3.0),
                              height: 50,

                              decoration: BoxDecoration(

                                  borderRadius:
                                  BorderRadius.circular(50),
                                  color: Color.fromRGBO(35, 121, 69, 1)),
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
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FadeAnimation(
                        1.9,
                        (widget.retailer != null)
                            ? InkWell(

                            onTap: ()  async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => GstInfoPage(
                                        retailerId : _getretailerId
                                    )));
                              }
                              ,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(70,10,45,10),
                              padding: const EdgeInsets.all(3.0),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color.fromRGBO(35, 121, 69, 1)),
                              child: Center(
                                child: Text(
                                  "View GST Info",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                            )
                            : Container(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FadeAnimation(
                        1.8,
                        InkWell(
                            onTap: ()  async {
                              setState(() {
                                addressController.text.isEmpty ? Fluttertoast.showToast(
                                    msg: "Please enter Address!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.black,
                                    fontSize: 16.0
                                ) : _validate = _validate+1;
                                nameController.text.isEmpty ? Fluttertoast.showToast(
                                    msg: "Please enter Name!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.black,
                                    fontSize: 16.0
                                ) : _validate = _validate+1;

                                phoneController.text.isEmpty ? Fluttertoast.showToast(
                                    msg: "Please enter Phone no!!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.black,
                                    fontSize: 16.0
                                ) : _validate = _validate+1;
                              });
                              if(_validate== 3){
                                retailerProvider.changeLocation(userLocation);
                                retailerProvider.changeProfileUrl(imageUrl);

                                if(_image!=null){
                                  await uploadPic(context);
                                  print(imageUrl);
                                  retailerProvider.changeProfileUrl(imageUrl);
                                }
                                await retailerProvider.saveRetailer();

                                Navigator.of(context).pop();

                                Fluttertoast.showToast(
                                    msg: "Retailer successfully added!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(70,10,45,10),
                              padding: const EdgeInsets.all(3.0),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color.fromRGBO(35, 121, 69, 1)),
                              child: Center(
                                child: Text(
                                  "Save",
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
]    ),
                    Row(
                    children: <Widget>[
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
                              margin: const EdgeInsets.fromLTRB(100,0,100,0),
                              padding: const EdgeInsets.all(3.0),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(50),
                                  color: Color.fromRGBO(35, 121, 69, 1)),
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
                                      retailerId : _getretailerId,
                                      retailerName : _getretailerName
                                  )));
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(100,0,100,0),
                              padding: const EdgeInsets.all(3.0),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(50),
                                  color: Color.fromRGBO(35, 121, 69, 1)),
                              child: Center(
                                child: Text(
                                  "View Available Packages",
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
                                  MaterialPageRoute(builder: (context) => GivenPackagePage(
                                      retailerId : _getretailerId
                                  )));
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(100,0,100,0),
                              padding: const EdgeInsets.all(3.0),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(50),
                                  color: Color.fromRGBO(35, 121, 69, 1)),
                              child: Center(
                                child: Text(
                                  "View Assigned Packages",
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

              ],
            ),
          ],
        ),
      ),
    );
  }
}