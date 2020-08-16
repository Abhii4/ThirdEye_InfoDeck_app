
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';




class FileUploadPage extends StatefulWidget {
  FileUploadPage({this.retailerId});
  final  retailerId;






  @override
  _FileUploadPage createState() => _FileUploadPage();
}

class _FileUploadPage extends State<FileUploadPage> {

  var shopimageUrl='null';
  File _shopimage;
  var memoimageUrl='null';
  File _memoimage;

  @override
  void initState() {
    getData();
    super.initState();

  }


  Future chooseshopImg() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _shopimage = image;
      print('Image Path $_shopimage');
    });
  }

  Future choosememoImg() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _memoimage = image;
      print('Image Path $_memoimage');
    });
  }



  Future uploadshopImg(BuildContext context) async{
    String retailerID = widget.retailerId();
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String fileName = basename(_shopimage.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('retailerFiles').child(retailerID).child('shopImg').child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_shopimage);

    setState(() async {
      shopimageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      print(shopimageUrl);

      Firestore.instance.collection('retailersList').document(retailerID).updateData({'shopimageUrl': shopimageUrl});

      Firestore.instance.collection('users').document(user.uid).collection('retailers').document(retailerID).updateData({'shopimageUrl' :shopimageUrl});
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  Future uploadmemoImg(BuildContext context) async{
    String retailerID = widget.retailerId();
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String fileName = basename(_memoimage.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('retailerFiles').child(retailerID).child('memoImg').child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_memoimage);

    print(memoimageUrl);
    setState(() async {
      memoimageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      Firestore.instance.collection('retailersList').document(retailerID).updateData({'memoimageUrl': memoimageUrl});
      Firestore.instance.collection('users').document(user.uid).collection('retailers').document(retailerID).updateData({'memoimageUrl' :memoimageUrl});
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }



  Future getData() async {
    String retailerID = widget.retailerId();
    final DocumentReference document =   await Firestore.instance.collection('retailersList').document(retailerID);
    await document.get().then((snapshot) async{
      setState(() {
        if(snapshot.data['shopimageUrl'].toString()!=null){
          shopimageUrl=snapshot.data['shopimageUrl'].toString();
        }

        if(snapshot.data['memoimageUrl'].toString()!=null){
          memoimageUrl=snapshot.data['memoimageUrl'].toString();
        }

      });
    });
  }

  Widget showshopImg() {
    return Builder(
      builder: (BuildContext context) {
        if (shopimageUrl!= 'null') {
          return Flexible(
            child:
            Image.network(
              shopimageUrl,
              fit: BoxFit.fill,
            ),
          );
        }  else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }


  Widget showmemoImg() {
    return Builder(
      builder: (BuildContext context) {
        if (memoimageUrl!= 'null') {
          return Flexible(
            child:
            Image.network(
              memoimageUrl,
              fit: BoxFit.fill,
            ),
          );
        }  else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(210, 253, 253, 1),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.1,
          backgroundColor: Color.fromRGBO(94, 197, 198, 1),
          title: Text("Upload Files"),
          centerTitle: true
      ),
      body:  Container(
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 1200.0,
                  color: Color.fromRGBO(210, 253, 253, 1),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      SizedBox(
                        height: 20.0,
                      ),
                      showshopImg(),
                      SizedBox(
                        height: 20.0,
                      ),
                      OutlineButton(
                        onPressed:() async {
                          await chooseshopImg();

                          uploadshopImg(context);
                        } ,
                        child: Text('Upload Shop Image'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      showmemoImg(),
                      SizedBox(
                        height: 20.0,
                      ),
                      OutlineButton(
                        onPressed:() async {
                          await choosememoImg();

                          uploadmemoImg(context);
                        } ,
                        child: Text('Upload Memo Image'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
    ),
    );
  }
}