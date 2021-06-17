import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing_app/appData.dart';
import 'package:ride_sharing_app/rider_login.dart';
import 'package:ride_sharing_app/rider_signup.dart';
import 'package:ride_sharing_app/search_screen.dart';
import 'login.dart';
import 'main_screen.dart';
import 'navigation_drawer.dart';


//final databaseReference = FirebaseDatabase.instance.reference();
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
DatabaseReference userReference = FirebaseDatabase.instance.reference().child("Users");  //realtime database reference creating 'User' child

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>AppData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage (),
      ),
    );
  }
}


