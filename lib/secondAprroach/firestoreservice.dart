import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infodeck/secondAprroach/retailer.dart';


final CollectionReference myCollection = Firestore.instance.collection('Retailers');

class FirestoreService {

  Future<Retailer> createRetailer(String name, String phone,String gst,String address) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(myCollection.document());

      final Retailer retailer = new Retailer(name, phone,gst,address);
      final Map<String, dynamic> data = retailer.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Retailer.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getRetailerList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = myCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }


}