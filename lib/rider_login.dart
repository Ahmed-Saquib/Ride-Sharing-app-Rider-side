import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_sharing_app/main.dart';
import 'package:ride_sharing_app/progress_custom.dart';
import 'main_screen.dart';


displayToastMessare(String message, BuildContext context){
  Fluttertoast.showToast(
      msg: message);
}

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Rider app"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0, left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: emailController,

                    decoration: InputDecoration(
                        hintText: "Enter Your E-mail",
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 20.0,
                        ),
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.black26,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        )),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter password",
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 20.0,
                        ),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.black26,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        )),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ButtonTheme(
                  minWidth: 200.0,
                  height: 50.0,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.8),
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            letterSpacing: 3.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (!emailController.text.contains("@")) {
                          Fluttertoast.showToast(msg: "Insert valid E-mail!");
                        }

                        if (passController.text.length < 6) {
                          Fluttertoast.showToast(
                              msg: "must be greater than 6 char!");
                        } else {
                          logInAuthentication(context);

                        }
                      }
                  ),
                )
              ],
            ),
          ),
        )
    );
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; //Initializing firebaase auth. grabing instance

  // ignore: non_constant_identifier_names
  void logInAuthentication(BuildContext context) async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProgressBar(message: "Please wait",);
        });

      final User firebaseUser  = ( await _firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text).catchError((errMsg){
        displayToastMessare( "Error:"+errMsg.toString(),context);
      })).user;
      if(firebaseUser!=null) { // data not null

        //  checking user already exist or not
        userReference.child(firebaseUser.uid).once().then(
            (DataSnapshot snap) {
          if (snap.value != null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => MainScreen()));

          } else {
            _firebaseAuth.signOut();
            displayToastMessare("Email/Password incorrect", context);

          }
        });
      }else{
        displayToastMessare("Error occured", context);

      }

        //Navigator.pushNamedAndRemoveUntil(context,LoginScreen.idScreen,(route) => false);

    }
  }


