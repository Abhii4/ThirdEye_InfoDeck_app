import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ViewImages extends StatefulWidget {


  ViewImages({this.retailerId});
  final retailerId;


  @override
  _ViewImagesState createState() => new _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  String retailerID;
  List<NetworkImage> _listOfImages = <NetworkImage>[];
  bool imageUrls = false;
  int urlLen;
  var images;

  @override
  void initState() {
    retailerID = widget.retailerId;
    getData();
    super.initState();

  }


    getData() async {


    final DocumentReference document =   await Firestore.instance.collection('retailersList').document(retailerID);

    await document.get().then((snapshot) async{
      setState(() {
        if (snapshot.data['imageUrls'].toString() != null) {
          imageUrls = true;
          urlLen = snapshot.data['imageUrls'].length;
          print(urlLen);
          images=snapshot.data['imageUrls'];
          for (int i = 0;
          i <
              urlLen;
          i++) {
            _listOfImages.add(NetworkImage(images[i]));
          }
        }
        print(imageUrls);
      });
          });
        }







  @override
  Widget build(BuildContext context) {
    return (imageUrls)?Column(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        Flexible(
            child: Column(
                children: <Widget>[
                  Column(
                            children: <Widget>[
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.red,
                              ),
                              Container(
                                margin: EdgeInsets.all(15.0),
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Carousel(
                                    boxFit: BoxFit.cover,
                                    images: _listOfImages,
                                    autoplay: false,
                                    indicatorBgPadding: 5.0,
                                    dotPosition: DotPosition.bottomCenter,
                                    animationCurve: Curves.fastOutSlowIn,
                                    animationDuration:
                                    Duration(milliseconds: 2000)),
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.red,
                              )
                            ],
                          )
                          ]
                        )

                )
      ],
    ):  Center(
      child: Text('No Files'),
    );
  }


}




































