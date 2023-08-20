import 'package:WashBuddy/Admindashbord/approvegirlscr.dart';
import 'package:WashBuddy/Admindashbord/datewisehistory.dart';
import 'package:WashBuddy/Admindashbord/togglebutton.dart';
import 'package:WashBuddy/AuthScr/authscrn.dart';
import 'package:WashBuddy/SlotBook/Userdetail.dart';
import 'package:WashBuddy/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'allhistory.dart';

class AHome_Screen1 extends StatefulWidget {
  const AHome_Screen1({Key? key}) : super(key: key);

  @override
  State<AHome_Screen1> createState() => _AHome_Screen1State();
}

class _AHome_Screen1State extends State<AHome_Screen1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot> querySnapshot =
  FirebaseFirestore.instance.collection('Slot Info').snapshots();

  int bookingCount = BookingManager.instance.bookingCount;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end : const FractionalOffset(1.0, 0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
            "Admin Dadboard",

            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontFamily: "Lobster",
            )

        ),

        centerTitle: true,
      ),

      body: GridView.count(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            primary: false,
            shrinkWrap: true,
            children: <Widget>[

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WasherScreen()),
                  );
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('images/img.png'),
                        radius: 8 * 8,
                      ),
                      Text(
                        "Approve Email ID",
                        style: TextStyle(fontSize: 16, color: Colors.cyan),
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResetButton()),
                  );
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('images/6.jpg'),
                        radius: 8 * 8,
                      ),
                      Text(
                        "Refresh Slots",
                        style: TextStyle(fontSize: 16, color: Colors.cyan),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllHistoryn()));
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('images/5.jpg'),
                        radius: 8 * 8,
                      ),
                      Text(
                        "Date Wise History",
                        style: TextStyle(fontSize: 16, color: Colors.cyan),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllHistory()));
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('images/4.jpg'),
                        radius: 8 * 8,
                      ),
                      Text(
                        "User History",
                        style: TextStyle(fontSize: 16, color: Colors.cyan),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            crossAxisCount: 2,
          ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout_rounded),
        backgroundColor: Colors.black,
        onPressed: () {
          firebaseAuth.signOut().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => Auth_Scr()),
            );
          });
        },
      ),
    );
  }
}
