import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infodeck/animations/FadeAnimation.dart';
import 'package:infodeck/root_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_indicators/progress_indicators.dart';






class RegPage extends StatefulWidget {


  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {


  String email, password, name;
  bool _validate = false;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();








  Future<void> register() async {
      try {
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


        final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);



          if (newUser != null) {
            Firestore.instance.collection('users').document(newUser.uid).setData({"email":email, "name": name});
            Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => RootPage()),
            );
          }



      } catch (e) {
        Fluttertoast.showToast(
            msg: "Error: $e",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black12,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.orangeAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
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
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeAnimation(
                  1,
                  Text(
                    "Hello there, \nwelcome",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                FadeAnimation(
                  1,
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.transparent,
                    ),

                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[100],
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: _name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name",
                              hintStyle: TextStyle(color: Colors.grey),
                              errorText: _validate ? 'Value Can\'t Be Empty' : null,
                            ),

                            onChanged: (value) {
                              name = value;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[100],
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey),
                              errorText: _validate ? 'Value Can\'t Be Empty' : null,
                            ),

                            onChanged: (value) {
                              email = value;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[100],
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: _pass,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                              errorText: _validate ? 'Value Can\'t Be Empty' : null,
                            ),

                            onChanged: (value) {
                              password = value;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FadeAnimation(
                  1,
                  InkWell(
                    onTap: () {
                      setState(() {
                        _name.text.isEmpty ? _validate = true : _validate = false;
                        _email.text.isEmpty ? _validate = true : _validate = false;
                        _pass.text.isEmpty ? _validate = true : _validate = false;
                      });
                      register();
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(49, 39, 79, 1),
                      ),
                      child: Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                FadeAnimation(
                  1,
                  InkWell(
                    onTap: () {

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RootPage()));
                    },
                    child: new Text(
                      "Already a Member?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}