import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_sharing_app/main.dart';
import 'package:ride_sharing_app/rider_login.dart';

import 'main_screen.dart';

// ignore: must_be_immutable
class SignupScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Sign up"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "Enter Your Name",
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 20.0,
                        ),
                        suffixIcon: Icon(
                          Icons.account_circle,
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
                    controller: phoneController,
                    decoration: InputDecoration(
                        hintText: "Enter Your Phone",
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 20.0,
                        ),
                        suffixIcon: Icon(
                          Icons.phone,
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
                        "Signup",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            letterSpacing: 3.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (nameController.text.length < 4) {
                          displayToastMessare( "Name must be greater than 4 char!",context);
                        }
                        if (!emailController.text.contains("@")) {
                          displayToastMessare( "Insert valid E-mail!",context);
                        }
                        if (phoneController.text.isEmpty) {
                          displayToastMessare( "Phone number must be given!",context);
                        }
                        if (passController.text.length < 6) {
                          displayToastMessare( "must be greater than 6 char!",context);
                        } else {
                          registerNewUser(context); //passing all context to registerNewUser

                        }
                      }),
                )
              ],
            ),
          ),
        ));
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; //creating firebase auth

  // ignore: non_constant_identifier_names
  void registerNewUser(BuildContext context) async {
    final User firebaseUser  = ( await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text, password: passController.text).catchError((errMsg){
          displayToastMessare( "Error:"+errMsg,context);
    })).user;
    if(firebaseUser!=null){ //new user created
         Map userDataMap = {
           "name": nameController.text.trim(),
           "email": emailController.text.trim(),
           "phone": phoneController.text.trim(),
           "pass": passController.text.trim(),
         };
         userReference.child(firebaseUser.uid).set(userDataMap); //saving user info to database under unique user id
         displayToastMessare(  "Account successfully created.",context);
         //Navigator.pushNamedAndRemoveUntil(context,LoginScreen.idScreen,(route) => false);
         Navigator.of(context).pushReplacement(
             MaterialPageRoute(
                 builder: (context) => MainScreen()));
    }else{
      displayToastMessare( "Error : New user not created",context);
    }

    //Map userData = {
    //  "name": nameController.text.trim(),
    //  "email": emailController.text.trim(),
    //  "phone": phoneController.text.trim(),
    //  "pass": passController.text.trim(),
    //};
    //final User user = _firebaseAuth.currentUser;
    //final uid= user.uid;
    //databaseReference.child(uid).set(userData);
  }
}
displayToastMessare(String message, BuildContext context){
  Fluttertoast.showToast(
      msg: message);
}
