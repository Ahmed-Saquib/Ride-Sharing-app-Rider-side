import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing_app/placePredictions.dart';
import 'package:ride_sharing_app/requestAssistant.dart';

import 'address.dart';
import 'appData.dart';
import 'directionDetails.dart';

class SearchScreen extends StatefulWidget {

  final String Latitude;
  final String Longitude;
  const SearchScreen(
      {Key key, this.Latitude, this.Longitude})
      : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  String Lat;
  String Long;
  _SearchScreenState({this.Lat, this.Long});

  TextEditingController pickUpController = TextEditingController();
  TextEditingController longPickUpController = TextEditingController();
  TextEditingController latDropOffController = TextEditingController();
  TextEditingController longDropOffController = TextEditingController();



  List<PlacePredictions> placePredictionList=[];

  @override
  Widget build(BuildContext context) {
    String pickUpAdress= Provider.of<AppData>(context).userPickUpLocation.placeName??"";
    pickUpController.text = pickUpAdress;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,

        title: Text("Set Destination",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body:
      SingleChildScrollView(

        child: Column(

          children: [
            Container(

              height: 135,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomRight:Radius.circular(30),bottomLeft:Radius.circular(30)),boxShadow: [

                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )
              ]),
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
                          padding: const EdgeInsets.only(right : 8.0,bottom :8.0),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 30.0,
                          ),
                        ),
                        Expanded(
                            child: Column(
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
                                    "Please wait, getting your current location."
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "Pickup Location",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                        )

                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top : 0.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right : 8.0,top : 20.0),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 29.0,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  child: TextField(
                                    onChanged: (val){
                                      findPlace(val);
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Search Destination",
                                        hintStyle: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green)),
                                        contentPadding: EdgeInsets.only(left:8.0,top:20.0)
                                    ),
                                  ),

                                ),
                              )
                        ],
                      ),
                    )
                  ],


                ),
              ),
            ),
              (placePredictionList.length>0) ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index){
                    return PredictionTile(placePredictions: placePredictionList[index],);
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.green,),
                  itemCount: placePredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ) ,
              )
                  : Container(

              )
            //tile for predictions
          ],
        ),
      ),
    );
  }
  String mapKey="AIzaSyBB46X2LyVPZKvX6f7EecvHiPKCSfaYl0A";
  void findPlace(String placeName)async{
    if(placeName.length>3){
      String autoCompleteUrl="https://barikoi.xyz/v1/api/search/autocomplete/MTpPVkhCVEZaM09F/place?q=$placeName";
      var result = await RequestAssistant.getRequest(autoCompleteUrl);
      if(result=="failed"){
        return;
      }else{
        print("Find Me");
        print(result);
        var places = result["places"];
        var placesList=(places as List).map((e) => PlacePredictions.formJson(e)).toList();
        //var placesList = (List<places>).map((e) => PlacePredictions.formJson(e)).toList();
        print("Printing placeList");
        print(placesList);
         setState((){
          placePredictionList=placesList;
        });


      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  String mapKey = "AIzaSyBB46X2LyVPZKvX6f7EecvHiPKCSfaYl0A";
  final PlacePredictions placePredictions;

  PredictionTile({Key key, this.placePredictions}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddressDetails(placePredictions.id.toString(), context);
      },
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              //SizedBox(width: 10.0,),
              Row(
                children: [
                  Icon(Icons.add_location, size: 20,),
                  SizedBox(width: 14.0,),
                 // Padding(
                   // padding: const EdgeInsets.all(8.0),
                    //child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(

                          width : 300,
                          child: Text(placePredictions.address,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            //style: TextStyle(fontSize: 14.0),),
                         // SizedBox(height: 3.0,),
                        )

                        )//Text(placePredictions.id, overflow:TextOverflow.ellipsis,style: TextStyle(fontSize:12.0,color: Colors.grey),)
                      ],
                    ),
                 // )
                ],
              ),

              //SizedBox(width: 10.0,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getPlaceAddressDetails(String placeId, context) async {
    //showDialog(
     // context:context,
     // builder: (BuildContext context) => ProgressDialog(message:"setting dropoff , please wait")
   // );
    displayToastMessare( "Please wait",context);
    //String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    String placeDetailsUrl = "https://barikoi.xyz/v1/api/search/geocode/MjE3MTo3RDc1WEJHUU9N/place/$placeId";
    //https://barikoi.xyz/v1/api/search/geocode/MjE3MTo3RDc1WEJHUU9N/place?
    var res = await RequestAssistant.getRequest(placeDetailsUrl);
    print ("response: got destination details ");
    print(placeId);
    //Navigator.pop(context);
    if (res == "failed") {
      return;
    }else{
      //if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["place"]["address"];
      print(res["place"]["address"]);
      address.placeID = placeId.toString();
      print(placeId.toString());
      address.latitude = res["place"]["latitude"];
      print(res["place"]["latitude"]);
      address.longitude = res["place"]["longitude"];
      print(res["place"]["longitude"]);
      Provider.of<AppData>(context, listen : false).updatedropOffLocationAddress(address);

     //  print ("directionUrl:: ");
     //  String directionUrl ="https://barikoi.xyz/v1/api/route/MTpPVkhCVEZaM09F/90.362548828125,23.94107556246209;90.31585693359375,24.134221690669204?overview=false&alternatives=true&steps=true&hints=";
     //  var rest = await RequestAssistant.getRequest(directionUrl);
     //  if(rest == "failed"){
     //    return null;
     //  }
     //  DirectionDetails directionDetails = DirectionDetails();
     //  directionDetails.durationValue = rest["routes"][0]["duration"];
     //  print(rest["routes"][0]["duration"]);

     Navigator.pop(context, "obtainedDirection");
      Navigator.pop(context, "obtainedDirection");
    }
  }
  // static Future<DirectionDetails>obtainPlaceDirectionDetails() async{
  //
  //   // //String directionUrl ="https://barikoi.xyz/v1/api/route/MjE3MTo3RDc1WEJHUU9N/${initialPosition.latitude},${initialPosition.longitude};${finalPosition.latitude},${finalPosition.latitude}?overview=false&alternatives=true&steps=true&hints=;";
  //     String directionUrl ="https://barikoi.xyz/v1/api/route/MTpPVkhCVEZaM09F/90.362548828125,23.94107556246209;90.31585693359375,24.134221690669204?overview=false&alternatives=true&steps=true&hints=";
  //     var rest = await RequestAssistant.getRequest(directionUrl);
  //     if(rest == "failed"){
  //       return null;
  //      }
  //       DirectionDetails directionDetails = DirectionDetails();
  //       directionDetails.durationValue = rest["routes"][0]["duration"];
  //         print(rest["routes"][0]["duration"]);
  //   //     directionDetails.distanceValue = res["routes"]["distance"];
  //   //     //directionDetails.geometry=res["routes"]["geometry"];
  //   //     //directionDetails.hint1=res["waypoints"][0]["hint"];
  //   //     //directionDetails.hint2=res["waypoints"][1]["hint"];
  //   //     //directionDetails.encodedPoints=res["routes"]["geometry"];
  //   //
  //        return directionDetails;
  //    }
}
displayToastMessare(String message, BuildContext context){
  Fluttertoast.showToast(
      msg: message);
}