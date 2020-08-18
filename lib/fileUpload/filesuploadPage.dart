import 'package:flutter/material.dart';
import 'package:infodeck/fileUpload/uploadImages.dart';
import 'package:infodeck/fileUpload/viewImages.dart';




class FilesUploadPage extends StatefulWidget {
  FilesUploadPage({this.retailerId});
  final  retailerId;


  @override
  _FilesUploadPageState createState() => _FilesUploadPageState();
}

class _FilesUploadPageState extends State<FilesUploadPage> {
  String retailerID;


  @override
  void initState() {
     retailerID = widget.retailerId();





    super.initState();
  }






  final _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Color.fromRGBO(210, 253, 253, 1),
        appBar: AppBar(
          title: Text('Upload Files'),
          backgroundColor: Color.fromRGBO(94, 197, 198, 1),
            centerTitle: true,
          bottom:   TabBar(
            tabs: [
              Tab(icon: Icon(Icons.image),text: 'Images',),
              Tab(icon: Icon(Icons.cloud_upload),text: "Upload Images",),
            ],
            indicatorColor: Colors.red,
            indicatorWeight: 5.0,
          ),
        ),

        body: TabBarView(
          children: <Widget>[
            ViewImages(retailerId : retailerID),
            UploadImages(globalKey: _globalKey,retailerId : retailerID),
          ],
        ),
      ),
    );
  }
}