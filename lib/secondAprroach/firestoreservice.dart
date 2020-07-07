import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infodeck/secondAprroach/retailer.dart';




class FirestoreService {


  final CollectionReference myCollection = Firestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
   FirebaseUser user;

  @override
  Future<FirebaseUser> currentUser() async {
    user = await FirebaseAuth.instance.currentUser();
    return user;
  }








  Stream<QuerySnapshot> getRetailerList({int offset, int limit}) async* {
    final FirebaseUser user = await _auth.currentUser();
    Stream<QuerySnapshot> snapshots = myCollection.document(user.uid).collection('retailers').snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    yield* snapshots;
  }



  Future<void> saveRetailer(Retailer retailer)  {
    currentUser();
    return myCollection.document(user.uid).collection('retailers').document(retailer.retailerId).setData(retailer.toMap());
  }

  Future<void> removeProduct(String retailerId)  {
    currentUser();
    return myCollection.document(user.uid).collection('retailers').document(retailerId).delete();
  }


}