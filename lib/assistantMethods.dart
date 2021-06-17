import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing_app/address.dart';
import 'package:ride_sharing_app/directionDetails.dart';
import 'package:ride_sharing_app/requestAssistant.dart';
import 'package:ride_sharing_app/appData.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position,
      context) async {
    String placeAddress = "";
    double Lat = position.latitude;
    double Long = position.longitude;
    print("hello there");
    print(Lat);
    String url = "https://barikoi.xyz/v1/api/search/reverse/geocode/MjE3MTo3RDc1WEJHUU9N/place?longitude=90.36668110638857&latitude=23.83723803415923";
    //https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyBB46X2LyVPZKvX6f7EecvHiPKCSfaYl0A
    //https://barikoi.xyz/v1/api/search/reverse/MTpPVkhCVEZaM09F/geocode?longitude=90.3678841063484&latitude=23.8362383341941
    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      print("response got");
      //placeAddress=response["results"][0]["formatted_address"];
      placeAddress = response["place"]["address"];
      Address userPickupAddress = new Address();
      //userPickupAddress.longitude = position.longitude;
      //userPickupAddress.latitude=position.latitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(
          userPickupAddress);
    }
    return placeAddress;
  }

  //static Future<DirectionDetails>obtainPlaceDirectionDetails(LatLng initialPosition , LatLng finalPosition) async{
  // static Future<DirectionDetails>obtainPlaceDirectionDetails() async{
  //
  //   //String directionUrl ="https://barikoi.xyz/v1/api/route/MjE3MTo3RDc1WEJHUU9N/${initialPosition.latitude},${initialPosition.longitude};${finalPosition.latitude},${finalPosition.latitude}?overview=false&alternatives=true&steps=true&hints=;";
  //   String directionUrl ="https://barikoi.xyz/v1/api/route/MTpPVkhCVEZaM09F/90.362548828125,23.94107556246209;90.31585693359375,24.134221690669204?overview=false&alternatives=true&steps=true&hints=";
  //   var res = await RequestAssistant.getRequest(directionUrl);
  //   if(res == "failed"){
  //     return null;
  //   }
  //     DirectionDetails directionDetails = DirectionDetails();
  //     directionDetails.durationValue = res["routes"]["duration"];
  //     directionDetails.distanceValue = res["routes"]["distance"];
  //     //directionDetails.geometry=res["routes"]["geometry"];
  //     //directionDetails.hint1=res["waypoints"][0]["hint"];
  //     //directionDetails.hint2=res["waypoints"][1]["hint"];
  //     //directionDetails.encodedPoints=res["routes"]["geometry"];
  //
  //     return directionDetails;
  // }
  // static int calculateFares(DirectionDetails directionalDetails) {
  //   double timeTraveledFare = (directionalDetails.durationValue / 60) *
  //       0.20; // per min
  //   double distanceTraveledFare = (directionalDetails.distanceValue / 1000) *
  //       0.20; // per km
  //   double totalFareAmount = timeTraveledFare * distanceTraveledFare;
  // }

}
