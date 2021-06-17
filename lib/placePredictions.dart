class PlacePredictions{
  String address;
  int id;
  String uCode;
  PlacePredictions({this.address,this.id,this.uCode});
  PlacePredictions.formJson(Map<String,dynamic>json){
    address = json["address"];
    id = json["id"];
    uCode = json["uCode"];
  }

}