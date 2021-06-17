import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ProgressBar extends StatelessWidget {
  String message;
  ProgressBar({this.message});


  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.white,
      child:Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              JumpingText(message,style: TextStyle(color: Colors.blue),)
            ],
          )
        )
      ,
      )
    );
  }
}
