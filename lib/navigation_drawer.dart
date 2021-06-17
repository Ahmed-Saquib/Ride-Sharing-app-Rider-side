import 'package:flutter/material.dart';
class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
         Container(
           child: DrawerHeader(
             child: Row(
               children: [
                 Icon(Icons.supervised_user_circle,size:50.0),
                 SizedBox(width:10.0),
                 Text("You Name",style:TextStyle(fontSize:18.0),),
               ],


             )
           ),

         ),
          Divider(color:Colors.black54),
          ListTile(
            title: Text("Yout Profile",style:TextStyle(fontSize:18.0),),
            leading: Icon(Icons.supervised_user_circle,size:30.0,),
          ),
          ListTile(
            title: Text("Ratings",style:TextStyle(fontSize:18.0),),
            leading: Icon(Icons.star,size:30.0,),
          ),
          ListTile(
            title: Text("About",style:TextStyle(fontSize:18.0),),
            leading: Icon(Icons.info_outline,size:30.0,),
          ),
        ],
      )
    );
  }
}
