
import 'package:flutter/material.dart';

import 'package:infodeck/secondAprroach/retailerProvider.dart';
import 'package:provider/provider.dart';
import 'package:infodeck/secondAprroach/firestoreservice.dart';


import 'main2.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirestoreService fireServ = new FirestoreService();



    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RetailerProvider()),
         StreamProvider(create: (context)=> fireServ.getRetailerList()),
      ],
      child: MaterialApp(
        title: 'InfoDeck',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Main2(),
      ),
    );
  }
}
