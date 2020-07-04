import 'package:flutter/material.dart';
import 'package:infodeck/animations/FadeAnimation.dart';
import 'package:infodeck/secondAprroach/retailer.dart';
import 'package:infodeck/secondAprroach/retailerProvider.dart';
import 'package:provider/provider.dart';

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
        retailerProvider.loadValues(Retailer(null, null, null, null));
      });
    } else {
      //Controller Update
      nameController.text = widget.retailer.name;
      phoneController.text = widget.retailer.phone;
      gstController.text = widget.retailer.gst;
      addressController.text = widget.retailer.address;

      //State Update
      new Future.delayed(Duration.zero, () {
        final retailerProvider =
        Provider.of<RetailerProvider>(context, listen: false);
        retailerProvider.loadValues(widget.retailer);
      });
    }

    super.initState();
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
                                    onChanged: (value) =>
                                        retailerProvider.changePhone(value),
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
                                    onChanged: (value) =>
                                        retailerProvider.changeGst(value),
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
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 10,
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
                                        widget.retailer.name);
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
                          )
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