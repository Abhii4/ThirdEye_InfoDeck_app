
import 'package:flutter/material.dart';
import 'package:infodeck/secondAprroach/retailer.dart';
import 'package:uuid/uuid.dart';


import 'firestoreservice.dart';

class RetailerProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String _name;
  String _phone;
  String _gst;
  String _address;
  String _retailerId;
  String _location;
  var uuid = Uuid();

  //Getters
  String get name => _name;
  String get phone => _phone;
  String get gst => _gst;
  String get address => _address;
  String get location => _location;



  //Setters
  changeName(String value) {
    _name = value;
    notifyListeners();
  }

  changePhone(String value) {
    _phone = value;
    notifyListeners();
  }
  changeGst(String value) {
    _gst = value;
    notifyListeners();
  }

  changeAddress(String value) {
    _address = value;
    notifyListeners();
  }
  changeLocation(String value) {
    _location = value;
    notifyListeners();
  }


  loadValues(Retailer retailer){
    _name=retailer.name;
    _phone=retailer.phone;
    _gst=retailer.gst;
    _address=retailer.address;
    _retailerId=retailer.retailerId;
    _location=retailer.location;

  }


  saveRetailer() {

    if (_retailerId == null) {
      var newRetailer = Retailer(name,phone,gst,address,uuid.v4(),location);
      firestoreService.saveRetailer(newRetailer);
    } else {
      //Update
      var updatedRetailer =
      Retailer(name,phone,gst,address,_retailerId,location);
      firestoreService.saveRetailer(updatedRetailer);
    }
  }

  removeProduct(String retailerId){
    firestoreService.removeProduct(retailerId);
  }

}