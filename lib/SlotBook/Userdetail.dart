
import 'package:WashBuddy/Widgits/app_drawer.dart';
import 'package:WashBuddy/global/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userEmail;

  UserDetailsScreen({required this.userEmail});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  List<Map<String, dynamic>> userSlots = [];

  @override
  void initState() {
    super.initState();
    fetchUserSlots();
  }

  void fetchUserSlots() async {
    final userDocRef = FirebaseFirestore.instance.collection('Users').doc(widget.userEmail);
    final userSlotsCollection = userDocRef.collection('Slots');

    QuerySnapshot snapshot = await userSlotsCollection.get();

    setState(() {
      userSlots = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      BookingManager.instance.incrementBookingCount();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    int bookingCount = BookingManager.instance.bookingCount;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
              "User Booking Detail"
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



        body: ListView.builder(
          itemCount: userSlots.length,
          itemBuilder: (context, index) {
            final slot = userSlots[index];
            final timestamp = slot['timestamp'] as Timestamp?;
            final time = slot['time'] as String;
            final day = slot['day'] as String;
            print("$bookingCount");
            return ListTile(
              title: Text('Time: $time'),
              subtitle: Text('Day: $day'),
              trailing: Text('Booked on: ${timestamp?.toDate().toString() ?? "Unknown"}'),

            );
          },
        ),
      ),
    );
  }
}
class BookingManager {
  BookingManager._privateConstructor();

  static final BookingManager instance = BookingManager._privateConstructor();

  int _bookingCount = 1;

  int get bookingCount => _bookingCount;

  void incrementBookingCount() {
    _bookingCount++;
  }
}

