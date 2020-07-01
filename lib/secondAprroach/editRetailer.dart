
import 'package:flutter/material.dart';
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
        final retailerProvider = Provider.of<RetailerProvider>(context,listen: false);
        retailerProvider.loadValues(Retailer(null,null,null,null));
      });
    } else {
      //Controller Update
      nameController.text=widget.retailer.name;
      phoneController.text=widget.retailer.phone;
      gstController.text=widget.retailer.gst;
      addressController.text=widget.retailer.address;

      //State Update
      new Future.delayed(Duration.zero, () {
        final retailerProvider = Provider.of<RetailerProvider>(context,listen: false);
        retailerProvider.loadValues(widget.retailer);
      });

    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final retailerProvider = Provider.of<RetailerProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Edit Retailer')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Retailer Name'),
              onChanged: (value) {
                retailerProvider.changeName(value);
              },
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(hintText: 'Retailer Phone'),
              onChanged: (value) => retailerProvider.changePhone(value),
            ),
            TextField(
              controller: gstController,
              decoration: InputDecoration(hintText: 'Retailer GST'),
              onChanged: (value) => retailerProvider.changeGst(value),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(hintText: 'Retailer Address'),
              onChanged: (value) => retailerProvider.changeAddress(value),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () {
                retailerProvider.saveRetailer();
                Navigator.of(context).pop();
              },
            ),
            (widget.retailer !=null) ? RaisedButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Delete'),
              onPressed: () {
                retailerProvider.removeProduct(widget.retailer.name);
                Navigator.of(context).pop();
              },
            ): Container(),
          ],
        ),
      ),
    );

  }
}