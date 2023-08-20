import 'package:WashBuddy/AuthScr/authscrn.dart';
import 'package:WashBuddy/SlotBook/Userdetail.dart';
import 'package:WashBuddy/SlotBook/slotscreennew.dart';
import 'package:WashBuddy/Widgits/app_drawer.dart';
import 'package:WashBuddy/global/global.dart';
import 'package:WashBuddy/main_screen/contact_Detail.dart';
import 'package:WashBuddy/main_screen/rules.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home_Screen1 extends StatefulWidget {
  const Home_Screen1({Key? key}) : super(key: key);

  @override
  State<Home_Screen1> createState() => _Home_Screen1State();
}

class _Home_Screen1State extends State<Home_Screen1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot> querySnapshot =
  FirebaseFirestore.instance.collection('Slot Info').snapshots();

  int bookingCount = BookingManager.instance.bookingCount;

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
        ),
        title: Text(
          sharedPrefrences!.getString("name")!,
        ),
        leading: GestureDetector(
          onTap: _openDrawer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                sharedPrefrences!.getString("photoUrl")!,
              ),
              radius: 12 * 12,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      drawer: buildDrawer1(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: querySnapshot,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Get the user email from shared preferences
          String userEmail = sharedPrefrences!.getString("email")!;

          // Filter the snapshot to get the documents for the user's email
          var userSlots = snapshot.data!.docs
              .where((doc) => doc.get('email') == userEmail)
              .toList();

          int numBookedSlots = userSlots.length;

          return GridView.count(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            primary: false,
            shrinkWrap: true,
            children: <Widget>[

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SlotBookingnew()),
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
                        "Book Your Slot",
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
                            UserDetailsScreen(userEmail: sharedPrefrences!.getString("email")!)),
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
                        "Booking Details",
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
                      MaterialPageRoute(builder: (context) => ContactDetail()));
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
                        "Contact Details",
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
                      MaterialPageRoute(builder: (context) => Rule()));
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
                        "Rules",
                        style: TextStyle(fontSize: 16, color: Colors.cyan),
                      ),
                    ],
                  ),
                ),
              ),

            ],
            crossAxisCount: 2,
          );
        },
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
