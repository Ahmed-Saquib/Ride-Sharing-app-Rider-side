import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing_app/assistantMethods.dart';
import 'package:ride_sharing_app/requestAssistant.dart';
import 'package:ride_sharing_app/search_screen.dart';
import 'address.dart';
import 'appData.dart';
import 'assumed_fare.dart';
import 'directionDetails.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController userMap;
  Position currentPosition; //getting user current position
  var geolocator = Geolocator(); //instance of Geolocator
  double bottomPaddingOfMap = 0;
  double Latitude = 0;
  double Longitude = 0;
  String Lat;
  String Long;
  double rideDetailsContainer = 0;
  double searchContainerHeight =210.0;
  String AssumedFare ;
  void displayRideDetailsContainer() async
  {
    await obtainPlaceDirectionDetails();
    await calculateFares();
    setState(() {
      searchContainerHeight=0;
      rideDetailsContainer=400;
    });
  }
  //_MainScreenState({
  //  this.latitude,this.longitude
  //});

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition =
        position; // now we get the latitude and longitude of that position
    LatLng langPosition = LatLng(position.latitude,
        position.longitude); //making instance of positon's latitude,longitude
    setState(() {
      Latitude = langPosition.latitude;
      Longitude = langPosition.longitude;
      Lat = Latitude.toString();
      Long = Longitude.toString();
    });
    CameraPosition cameraPosition = CameraPosition(
        target: langPosition, zoom: 17.0); //making instance of cameraPosition
    userMap.animateCamera(CameraUpdate.newCameraPosition(
        cameraPosition));
    await getPlaceDirection();
    //newGoogleMapController(CameraUpdate.newCameraPosition(cameraPosition));
    //String address = await AssistantMethods.searchCoordinateAddress(position,context);
    //print("this is your address:"+address);

    //return placeAddress;
    //_MainScreenState loc = new _MainScreenState();
    //loc.latitude = position.latitude;
    //loc.longitude  = position.longitude;

  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom:17.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,

          title: Text("Welcome",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.green),
          ),

        drawer: Drawer(

            child: ListView(
              children: [
                Container(
                  child: DrawerHeader(
                      child: Row(
                        children: [
                          Icon(Icons.supervised_user_circle, size: 50.0),
                          SizedBox(width: 10.0),
                          Text("You Name", style: TextStyle(fontSize: 18.0),),
                        ],


                      )
                  ),

                ),
                Divider(color: Colors.green),
                ListTile(
                  title: Text(
                    "Yout Profile", style: TextStyle(fontSize: 18.0),),
                  leading: Icon(Icons.person, size: 30.0,),
                ),
                ListTile(
                  title: Text("Ratings", style: TextStyle(fontSize: 18.0),),
                  leading: Icon(Icons.star, size: 30.0,),
                ),
                ListTile(
                  title: Text("About", style: TextStyle(fontSize: 18.0),),
                  leading: Icon(Icons.info_outline, size: 30.0,),
                ),
              ],
            )
        ),
        body: Stack(children: [

          GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              //polylines: polylineSet,

              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                userMap = controller;
                setState(() {
                  bottomPaddingOfMap = 210;
                });

                getCurrentLocation();
              }),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,

            child: Container(
              height: searchContainerHeight,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ]
              ),

              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Where do you want to go?",
                      style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        //Navigator.of(context).pushReplacement(
                        //  MaterialPageRoute(
                        //    builder: (context) => SearchScreen()));
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchScreen(Latitude:Lat,Longitude:Long,),));
                        var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchScreen(
                                  Latitude: Lat,
                                  Longitude: Long,
                                ),),);
                         if (res == "obtainedDirection") {
                         await displayRideDetailsContainer();
                        }
                      },
                      child: Container(

                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                "Search Drop Off",
                                style:
                                TextStyle(fontSize: 18.0, color: Colors.white,fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                Provider
                                    .of<AppData>(context)
                                    .userPickUpLocation != null ?
                                Provider
                                    .of<AppData>(context)
                                    .userPickUpLocation
                                    .placeName :
                                "Please wait until we get your current location."
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              "Current Location",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Divider(
                      color: Colors.green,
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.work,
                    //       color: Colors.grey,
                    //     ),
                    //     SizedBox(
                    //       width: 12.0,
                    //     ),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //             Provider
                    //                 .of<AppData>(context)
                    //                 .userPickUpLocation != null ?
                    //             Provider
                    //                 .of<AppData>(context)
                    //                 .userPickUpLocation
                    //                 .placeName :
                    //             "Add Office ${Lat}"
                    //         ),
                    //         SizedBox(
                    //           height: 4.0,
                    //         ),
                    //         Text(
                    //           "Set As Your Office Location",
                    //           style: TextStyle(
                    //               color: Colors.grey,
                    //               fontSize: 15.0,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //       ],
                    //     )
                    //   ],
                    // ),

                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
            child: Container(
              height: rideDetailsContainer,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0),),
                boxShadow: [
                  BoxShadow(
                    color:Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: Column(

                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                            children: [
                          Padding(
                            padding: const EdgeInsets.only(top : 0.0),
                          ),
                          Row(
                            children: [
                            Padding(
                              padding: const EdgeInsets.only(right : 2.0,bottom: 20),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 15.0,
                            ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pickup Location",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    Provider
                                        .of<AppData>(context)
                                        .userPickUpLocation != null ?
                                    Provider
                                        .of<AppData>(context)
                                        .userPickUpLocation
                                        .placeName :
                                    "Please wait "
                                ),


                              ],
                            ),
                          ),


                          ],
                          ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right : 2.0,bottom: 35),
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.green,
                                        size: 15.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                          "Destination",
                                          style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                          height: 4.0,
                                          ),
                                          Text(
                                              Provider
                                                  .of<AppData>(context)
                                                  .dropOffLocation != null ?
                                              Provider
                                                  .of<AppData>(context)
                                                  .dropOffLocation
                                                  .placeName :
                                              "Please wait "
                                          ),
                                          ],
                                      ),
                                    ),



                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right : 2.0,bottom: 0),
                                      child: Icon(
                                        Icons.info_sharp,
                                        color: Colors.green,
                                        size: 15.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Distance :",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Text(
                                              Provider
                                                  .of<AppData>(context)
                                                  .DDetails != null ?
                                              Provider
                                                  .of<AppData>(context)
                                                  .DDetails
                                                  .distanceValue.toStringAsFixed(2)+"km":
                                              "Please wait "
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right : 2.0,bottom: 0),
                                      child: Icon(
                                        Icons.info_sharp,
                                        color: Colors.green,
                                        size: 15.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Duration:" ,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Text(
                                              Provider
                                                  .of<AppData>(context)
                                                  .DDetails != null ?
                                              Provider
                                                  .of<AppData>(context)
                                                  .DDetails.durationValue.toStringAsFixed(2)+"min":
                                              "Please wait "
                                          ),
                                        ],
                                      ),
                                    )


                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right : 2.0),
                                      child: Icon(
                                        Icons.attach_money_sharp,
                                        color: Colors.green,
                                        size: 15.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Fare: ",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),

                                          Text(
                                              Provider
                                                  .of<AppData>(context)
                                                  .assumedfare != null ?
                                              Provider
                                                  .of<AppData>(context)
                                                  .assumedfare
                                                  .amount.toStringAsFixed(2) +"tk":
                                              "Please wait "
                                          ),
                                        ],
                                      ),
                                    ),



                                  ],
                                ),
                              ),


                            ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.green,),
                    SizedBox(height: 13.0),
                    Container(
                      height: 60.0,
                      width: 320,
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search,color:Colors.white,size:26.0),
                              Text(
                                'Request for ride',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ]
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      height: 55.0,
                      width: 320,
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Center(
                              //  child:
                              //  Icon(Icons.cancel_rounded,color:Colors.black,size:26.0),
                              //),
                              SizedBox(width: 10.0),
                              Center(
                                child: Text('Cancel Request',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat')),
                              )
                          ],
                        ),
                      ),
                    ),
                    )
                  ],
                ),
              ),
            )
          )
        ]));
  }

   Future<void> getPlaceDirection() async {
    String latitude = Lat;
    String longitude = Long;
    print("im starting");
    String url = "https://barikoi.xyz/v1/api/search/reverse/MTpPVkhCVEZaM09F/geocode?longitude=${Long}&latitude=${Lat}";
    String placeAddress;
    int placeID;

    //https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyBB46X2LyVPZKvX6f7EecvHiPKCSfaYl0A
    //https://barikoi.xyz/v1/api/search/reverse/MTpPVkhCVEZaM09F/geocode?longitude=90.3678841063484&latitude=23.8362383341941
    var response = await RequestAssistant.getRequest(url);
    if(response=="failed"){
      print("response havent got");
    }else{
      print("response: got current location details");
      //placeAddress=response["results"][0]["formatted_address"];
      placeAddress=response["place"]["address"];
      placeID=response["place"]["id"];
      Address userPickupAddress = new Address();
      userPickupAddress.placeID=placeID.toString();
      print(placeID.toString());
      userPickupAddress.longitude = longitude;
      print(longitude);
      userPickupAddress.latitude=latitude;
      print(latitude);
      userPickupAddress.placeName=placeAddress;
      print(placeAddress);
      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickupAddress);

    }
//     //var initialPos = Provider.of<AppData>(context,listen:false).userPickUpLocation;
//     //var finalPos = Provider.of<AppData>(context,listen:false).dropOffLocation;
//     //var pickUpLatLng = LatLng(initialPos.latitude,initialPos.longitude);
//     //var dropOffLatLng = LatLng(finalPos.latitude,finalPos.longitude);
//
//     //var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
//     var details = await AssistantMethods.obtainPlaceDirectionDetails();
//     Navigator.pop(context);
//     print("This is Encoded Points ::");
//     print(details.encodedPoints);
//     pLineCordinates.clear();
//     PolylinePoints polylinePoints = PolylinePoints();
//     List<PointLatLng> decodedPolyLinePointsResult = polylinePoints
//         .decodePolyline(
//         "g}bqCmhpfPjf@uE_P}}BueAhZonBlGisJq_@wwBmXaaBxGqrAneBivA|xDiBtjAvZzhAuz@lSoi@omAuxEfS");
//     if (decodedPolyLinePointsResult.isNotEmpty) {
//       decodedPolyLinePointsResult.forEach((element) {
//         pLineCordinates.add(LatLng(Latitude, Longitude));
//       });
// //       }
//       polylineSet.clear();
//       setState(() {
//         Polyline polyline = Polyline(
//           color: Colors.pinkAccent,
//           polylineId: PolylineId("polylineID"),
//           jointType: JointType.round,
//           points: pLineCordinates,
//           startCap: Cap.roundCap,
//           endCap: Cap.roundCap,
//           geodesic: true,
//         );
//         polylineSet.add(polyline);
//       });
//     }
  }

 Future<void>obtainPlaceDirectionDetails() async{
    print("response: im in DirectionDetails");
   String pickUpLocationLongitidue= Provider.of<AppData>(context).userPickUpLocation.longitude??"";
   String pickUpLocationLaitidue= Provider.of<AppData>(context).userPickUpLocation.latitude??"";
   String dropOffLocationLongitidue= Provider.of<AppData>(context).dropOffLocation.longitude??"";
   String dropOffLocationLaitidue= Provider.of<AppData>(context).dropOffLocation.latitude??"";
   double duration;
    double distance;
    double durationMIN;
    double distanceKM;


   //String directionUrl ="https://barikoi.xyz/v1/api/route/MjE3MTo3RDc1WEJHUU9N/${initialPosition.latitude},${initialPosition.longitude};${finalPosition.latitude},${finalPosition.latitude}?overview=false&alternatives=true&steps=true&hints=;";
  String directionUrl ="https://barikoi.xyz/v1/api/route/MTpPVkhCVEZaM09F/$pickUpLocationLongitidue,$pickUpLocationLaitidue;$dropOffLocationLongitidue,$dropOffLocationLaitidue?overview=false&alternatives=true&steps=true&hints=";
  var res = await RequestAssistant.getRequest(directionUrl);
  if(res == "failed"){
    return ("DirectionDetails not found");
  }else {
    print("response: DirectionDetails");
    DirectionDetails directionDetails = DirectionDetails();
     duration= res["routes"][0]["duration"];
    print(res["routes"][0]["duration"]);
     distance= res["routes"][0]["distance"];
    print(res["routes"][0]["distance"]);
     durationMIN= duration/60;
     distanceKM= distance/1000;
      directionDetails.durationValue = durationMIN;
      directionDetails.distanceValue =distanceKM;
    //directionDetails.geometry=res["routes"]["geometry"];
    //directionDetails.hint1=res["waypoints"][0]["hint"];
    //directionDetails.hint2=res["waypoints"][1]["hint"];
    //directionDetails.encodedPoints=res["routes"]["geometry"];
    Provider.of<AppData>(context, listen: false).updateDirectionDetails(directionDetails);
    return directionDetails;
  }

  //setState(() {
   // tripDirectionDetails = details;
  //});
}
  Future<void>calculateFares() async{
    print ("Response: im in calculate fare");
    double durationValue= Provider.of<AppData>(context).DDetails.durationValue??"";
    double distanceValue= Provider.of<AppData>(context).DDetails.distanceValue??"";
    //double duration =double.parse(durationValue);
    //double distance = double.parse(distanceValue);
    Fare fare = Fare();
    double timeTraveledFare = (durationValue / 60) *
        0.20; // per min
    double distanceTraveledFare = (distanceValue / 1000) *
        0.20; // per km
    double totalFareAmount = timeTraveledFare * distanceTraveledFare;
    print (totalFareAmount);
    fare.amount=totalFareAmount;
    Provider.of<AppData>(context, listen: false).updateFareAmount(fare);
    return fare;

  }

}

