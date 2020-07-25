import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infodeck/secondAprroach/retailer.dart';





class FirestoreService {


  final CollectionReference myCollection = Firestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
   FirebaseUser CUser;

  @override
  Future<FirebaseUser> currentUser() async {
    CUser = await FirebaseAuth.instance.currentUser();
    return CUser;
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


  Future<void> saveRetailer(Retailer retailer)  async {
    await currentUser();
    return myCollection.document(CUser.uid).collection('retailers').document(retailer.retailerId).setData(retailer.toMap());
  }



  Future<void> removeProduct(String retailerId)  {
    currentUser();
    return myCollection.document(CUser.uid).collection('retailers').document(retailerId).delete();
  }


}