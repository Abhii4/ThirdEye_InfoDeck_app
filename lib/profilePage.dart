
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infodeck/secondAprroach/editRetailer.dart';
import 'HomePage.dart';
import 'auth/auth.dart';
import 'auth/authProvider.dart';
import 'package:path/path.dart';


class ProfilePage extends StatefulWidget {

  ProfilePage({this.onSignedOut});

  final  onSignedOut;




  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin{
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  var imageUrl = 'null';
  File _image;


  bool _status = true;

  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {



    getData();

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
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('userProfilePics').child(user.uid).child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    setState(() async {
      print("Profile Picture uploaded");
      imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      Firestore.instance.collection('users').document(user.uid).updateData({'profileUrl' :imageUrl});
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }


  Future getData() async {
    final FirebaseUser CUser = await FirebaseAuth.instance.currentUser();

    final DocumentReference document =   await Firestore.instance.collection('users').document(CUser.uid);

    await document.get().then((snapshot) async{
      print(snapshot['email'].toString());
      setState(() {
        if(snapshot.data['profileUrl'].toString()!=null){
          imageUrl=snapshot.data['profileUrl'].toString();
        }


        if(snapshot.data['name'] != null){
          nameController.text = snapshot.data['name'].toString();
        }else{
          nameController.text = '';

        }
        if(snapshot.data['email'] != null){
          emailController.text = snapshot.data['email'].toString();

        }else{
          emailController.text = '';

        }
        if(snapshot.data['phone'] != null){
          phoneController.text = snapshot.data['phone'].toString();

        }else{
          phoneController.text = '';

        }
        if(snapshot.data['address'] != null){
          addressController.text = snapshot.data['address'].toString();

        }else{
          addressController.text = '';

        }



      });
    });
  }



  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
      Fluttertoast.showToast(
          msg: "Successfully Logged Out",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
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
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(

          msg: "Press back again to exit",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return Future.value(false);
    }
    return Future.value(true);
  }




  @override
  Widget build(BuildContext context) {


    final makeBody = new Container(
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
                                    image: DecorationImage(image:(imageUrl!='null')? NetworkImage(imageUrl): new ExactAssetImage(
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
                                    uploadPic(context);
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
                                    'Parsonal Information',
                                    style: TextStyle(
                                        fontSize: 18.0,
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
                                    'Name',
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
                                    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                    Firestore.instance.collection('users').document(user.uid).updateData({'name' :value});
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Name",
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
                                    'Email',
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
                          controller: emailController,
                                  onChanged: (value) async {
                                    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                    Firestore.instance.collection('users').document(user.uid).updateData({'email' :value});
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Email",
                                  ),
                                  enabled: false,
                                  autofocus: false,

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
                                    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                    Firestore.instance.collection('users').document(user.uid).updateData({'phone' :value});
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Enter Mobile number"),
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
                                    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                    Firestore.instance.collection('users').document(user.uid).updateData({'address' :value});
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Enter Address "),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          )),
                      !_status ? _getActionButtons() : new Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );

    final makeBottom = CurvedNavigationBar(
      color: Color.fromRGBO(94, 197, 198, 1),
      backgroundColor: Colors.white,
      buttonBackgroundColor: Color.fromRGBO(94, 197, 198, 1),
      height: 50,
      items: <Widget>[
        Icon(Icons.event_note,size: 20,color: Colors.black),
        Icon(Icons.add,size: 50,color: Colors.black),
        Icon(Icons.account_box,size: 20,color: Colors.black),
      ],
      animationDuration: Duration(
          milliseconds: 200
      ),
      index:1,
      animationCurve: Curves.bounceInOut,
      onTap: (index){
        if(index==0){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        else if(index==1){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditRetailer()));
        }
        else{
        }
      },
    );

    final topAppBar = AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(94, 197, 198, 1),
      title: Text("Profile"),
        centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.white),
          onPressed: () {

            _signOut(context);

          },
        )
      ],
    );

    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar,
      body: WillPopScope(child: makeBody, onWillPop: onWillPop),
      bottomNavigationBar: makeBottom,
    );
  }
}


