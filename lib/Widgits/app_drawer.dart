import 'package:WashBuddy/AuthScr/authscrn.dart';
import 'package:WashBuddy/SlotBook/Userdetail.dart';
import 'package:WashBuddy/SlotBook/slotscreennew.dart';
import 'package:WashBuddy/main_screen/contact_Detail.dart';
import 'package:WashBuddy/main_screen/homenew.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../global/global.dart';
import '../main_screen/rules.dart';

buildDrawer1(BuildContext context) {
  return Drawer(
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 10, // Adjust the height as needed
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.amber,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          sharedPrefrences!.getString("photoUrl")!,
                        ),
                        radius: 6.8 * 6.8,
                      ),
                      Text(
                        sharedPrefrences!.getString("name")!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        sharedPrefrences!.getString("email")!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.home_work_rounded,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                  title: const Text('DashBoard'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.push(context
                        ,MaterialPageRoute(builder: (context)=> Home_Screen1()));
                  },
                ),


                ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.book,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: const Text('Booking Details'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {

                      Navigator.push(context
                          ,MaterialPageRoute(builder: (context)=> UserDetailsScreen(userEmail: sharedPrefrences!.getString("email")!)));
                    }),


                ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.book_online,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: const Text('Slot Booking '),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.pushReplacement(context
                          ,MaterialPageRoute(builder: (context)=> SlotBookingnew()));
                    }),


                ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.rule_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: const Text('Rules '),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(context
                          ,MaterialPageRoute(builder: (context)=> Rule()));
                    }),


                ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.contact_emergency,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: const Text('Contact'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(context
                          ,MaterialPageRoute(builder: (context)=> ContactDetail()));
                    }),


                ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: const Text('Log Out'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (c) => Auth_Scr()),
                            (route) => false, // Remove all routes from the stack
                      );
                    });
                  },),

              ],
            ),
          ),
        ],
      ),
    ),
  );
}