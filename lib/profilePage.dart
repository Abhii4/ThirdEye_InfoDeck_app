


import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infodeck/auth/login.dart';
import 'package:infodeck/root_page.dart';
import 'package:infodeck/secondAprroach/editRetailer.dart';

import 'HomePage.dart';
import 'auth/auth.dart';
import 'auth/authProvider.dart';


class ProfilePage extends StatelessWidget {


  const ProfilePage({this.onSignedOut});
  final  onSignedOut;

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }




  @override
  Widget build(BuildContext context) {

    final makeBody = Container(
      child: Center(child: Text('Welcome', style: TextStyle(fontSize: 32.0))),
    );

    final makeBottom = CurvedNavigationBar(
      color: Colors.white,
      backgroundColor: Colors.orangeAccent,
      buttonBackgroundColor: Colors.white,
      height: 50,
      items: <Widget>[
        Icon(Icons.event_note,size: 20,color: Colors.black),
        Icon(Icons.add_circle,size: 50,color: Colors.redAccent),
        Icon(Icons.account_box,size: 20,color: Colors.black),
      ],
      animationDuration: Duration(
          milliseconds: 200
      ),
      index:1,
      animationCurve: Curves.bounceInOut,
      onTap: (index){
        if(index==0){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        else if(index==1){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditRetailer()));
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => RootPage()));
        }
      },
    );

    final topAppBar = AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text("Profile"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.white),
          onPressed: () {

            _signOut(context);

          },
        )
      ],
    );

    return  Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      bottomNavigationBar: makeBottom,
    );
  }
}