import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:infodeck/fileUpload/utils.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:smart_progress_bar/smart_progress_bar.dart';


class UploadImages extends StatefulWidget {

  final GlobalKey<ScaffoldState> globalKey;
  const UploadImages({Key key, this.globalKey,this.retailerId}) : super(key: key);
  final  retailerId;
  @override
  _UploadImagesState createState() => new _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  String _error = 'No Error Dectected';
  bool isUploading = false;
  String retailerID;
  StorageUploadTask uploadTask;


  @override
  void initState() {
    retailerID = widget.retailerId;
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        print(asset.getByteData(quality: 100));
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: ThreeDContainer(
            backgroundColor: MultiPickerApp.darker,
            backgroundDarkerColor: MultiPickerApp.darker,
            height: 50,
            width: 50,
            borderDarkerColor: MultiPickerApp.pauseButton,
            borderColor: MultiPickerApp.pauseButtonDarker,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: loadAssets,
                    child: ThreeDContainer(
                      width: 130,
                      height: 50,
                      backgroundColor: MultiPickerApp.navigateButton,
                      backgroundDarkerColor: MultiPickerApp.background,
                      child: Center(child: Text("Pick images",style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      if(images.length==0){
                        showDialog(context: context,builder: (_){
                          return AlertDialog(
                            title: Text("ERROR"),
                            content: Text("No Images Selected!"),
                            actions: [
                          FlatButton(
                          child: Text("OK"),
                          onPressed: () {

                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          ),
                            ],
                          );

                        });
                      }
                      else{
                        SnackBar snackbar = SnackBar(content: Text('Please wait, we are uploading'));
                        widget.globalKey.currentState.showSnackBar(snackbar);
                        uploadImages();
                      }
                    },
                    child: ThreeDContainer(
                      width: 130,
                      height: 50,
                      backgroundColor: MultiPickerApp.navigateButton,
                      backgroundDarkerColor: MultiPickerApp.background,
                      child: Center(child: Text("Upload Images",style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Expanded(
                child: buildGridView(),
              ),
            ],
          ),

        ),
      ],
    );
  }
  void uploadImages(){

      showProgressBar(whileRun: () async {
        for ( var imageFile in images) {
        await postImage(imageFile).then((downloadUrl) async {

          imageUrls.add(downloadUrl.toString());
          if(imageUrls.length==images.length){

            final FirebaseUser user = await FirebaseAuth.instance.currentUser();
            Firestore.instance.collection('users').document(user.uid).collection('retailers').document(retailerID).updateData({'imageUrls' :FieldValue.arrayUnion(imageUrls)});
            Firestore.instance.collection('retailersList').document(retailerID).updateData({'imageUrls': FieldValue.arrayUnion(imageUrls)}).then((_){

              SnackBar snackbar = SnackBar(content: Text('Uploaded Successfully'));
              widget.globalKey.currentState.showSnackBar(snackbar);
              setState(() {
                images = [];
                imageUrls = [];
              });
            });
          }
        }).catchError((err) {
          print(err);
        });
      }

    });

  }
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));

    } on Exception catch (e) {
      error = e.toString();
    }


    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }
  Future<dynamic> postImage(Asset imageFile) async {

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child('retailerFiles').child(retailerID).child(fileName);
     uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List());

    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;


    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

//  String _bytesTransferred(StorageTaskSnapshot snapshot) {
//    double res = (snapshot.bytesTransferred / 1024.0) / 1000;
//    double res2 = (snapshot.totalByteCount / 1024.0) / 1000;
//    return '${res.toStringAsFixed(2)}/${res2.toStringAsFixed(2)}';
//  }
//
//
//  Widget _uploadStatus(StorageUploadTask task) {
//
//      return (task!=null)? StreamBuilder(
//        stream: task.events,
//        builder: (BuildContext context, snapshot) {
//          Widget subtitle;
//          if (snapshot.hasData) {
//            final StorageTaskEvent event = snapshot.data;
//            final StorageTaskSnapshot snap = event.snapshot;
//            subtitle = Text('${_bytesTransferred(snap)} KB sent');
//            print(_bytesTransferred(snap));
//          } else {
//            subtitle = const Text('Starting...');
//            print('Starting');
//          }
//          return ListTile(
//            title: task.isComplete && task.isSuccessful
//                ? Text(
//              'Done',
//
//            )
//                : Text(
//              'Uploading',
//
//            ),
//            subtitle: subtitle,
//          );
//        },
//      ) :
//       ListTile(
//        title: Text(
//          'No Task',
//        )
//
//      );
//
//    }


}