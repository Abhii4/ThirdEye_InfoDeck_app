import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infodeck/animations/FadeAnimation.dart';
import 'package:infodeck/auth/register.dart';
import 'auth.dart';
import 'authProvider.dart';

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}


class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}



class LoginPage extends StatefulWidget {


  const LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;


  @override
  _LoginPageState createState() => _LoginPageState();
}




class _LoginPageState extends State<LoginPage> {

  String email, password;
  bool _validate = false;
  final _email = TextEditingController();
  final _pass = TextEditingController();






  Future<void> login() async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      final String userId = await auth.signInWithEmailAndPassword(email, password);
      print('Signed in: $userId');

        widget.onSignedIn();
        if(userId !=null){
          Fluttertoast.showToast(
              msg: "Login Successful!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black12,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }


    } catch (e) {
      var status;
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          status = AuthResultStatus.invalidEmail;
          break;
        case "ERROR_WRONG_PASSWORD":
          status = AuthResultStatus.wrongPassword;
          break;
        case "ERROR_USER_NOT_FOUND":
          status = AuthResultStatus.userNotFound;
          break;
        case "ERROR_USER_DISABLED":
          status = AuthResultStatus.userDisabled;
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          status = AuthResultStatus.tooManyRequests;
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          status = AuthResultStatus.operationNotAllowed;
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          status = AuthResultStatus.emailAlreadyExists;
          break;
        default:
          status = AuthResultStatus.undefined;
      }

      String errorMessage;
      switch (status) {
        case AuthResultStatus.invalidEmail:
          errorMessage = "Your email address appears to be malformed.";
          break;
        case AuthResultStatus.wrongPassword:
          errorMessage = "Your password is wrong.";
          break;
        case AuthResultStatus.userNotFound:
          errorMessage = "User with this email doesn't exist.";
          break;
        case AuthResultStatus.userDisabled:
          errorMessage = "User with this email has been disabled.";
          break;
        case AuthResultStatus.tooManyRequests:
          errorMessage = "Too many requests. Try again later.";
          break;
        case AuthResultStatus.operationNotAllowed:
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        case AuthResultStatus.emailAlreadyExists:
          errorMessage =
          "The email has already been registered. Please login or reset your password.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(
          msg: "$errorMessage",
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
      backgroundColor: Color.fromRGBO(210, 253, 253, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                FadeAnimation(
                  1,
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Text(
                            "SIGN IN",
                            style: TextStyle(
                              fontSize: 30,
                              color: Color.fromRGBO(35, 121, 69, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
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
                            validator: EmailFieldValidator.validate,
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
                                color: Colors.grey,
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
                              errorText: _validate ? 'Value Can\'t Be Empty' : null,),
                            validator:  PasswordFieldValidator.validate,
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),

                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _email.text.isEmpty ? _validate = true : _validate = false;
                                _pass.text.isEmpty ? _validate = true : _validate = false;
                              });
                              login();
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 60),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(35, 121, 69, 1),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => RegPage()));
                            },
                            child: new Text(
                              "Need an Account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
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