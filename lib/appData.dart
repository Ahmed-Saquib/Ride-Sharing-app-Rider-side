import 'package:flutter/cupertino.dart';
import 'package:ride_sharing_app/address.dart';

import 'assumed_fare.dart';
import 'directionDetails.dart';


class AppData extends ChangeNotifier{
  Address userPickUpLocation,dropOffLocation;
  DirectionDetails DDetails,totalFareAmount;
  Fare assumedfare;

   void updatePickUpLocationAddress(Address pickUpAddress){
    userPickUpLocation=pickUpAddress;
    notifyListeners(); // when address changes this will handle the address
  }
  void updatedropOffLocationAddress(Address dropOffAddress){
    dropOffLocation=dropOffAddress;
    notifyListeners(); // when address changes this will handle the address
  }
  void updateDirectionDetails(DirectionDetails DirectionDetails){
    DDetails=DirectionDetails;
    notifyListeners(); // when address changes this will handle the address
  }
  void updateFareAmount(Fare fare){
    assumedfare=fare;
    notifyListeners(); // when address changes this will handle the address
  }

}