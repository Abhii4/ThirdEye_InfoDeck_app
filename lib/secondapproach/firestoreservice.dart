import 'dart:async';
import 'dart:js';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task.dart';


final _auth = FirebaseAuth.instance;


final CollectionReference myCollection = Firestore.instance.collection('Retailers');
class FirestoreService {

  Future<Task> createRetailer(String name, String phone,String gst,String address) async {
    final TransactionHandler createTransaction = (Transaction tx) async {

      final FirebaseUser user = await _auth.currentUser();
      final uid = user.uid;



      final DocumentSnapshot ds = await tx.get(myCollection.document(uid));

      final Task task = new Task(name, phone, gst, address);
      final Map<String, dynamic> data = task.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Task.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getTaskList({int offset, int limit}) {
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