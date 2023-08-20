import 'dart:async';
import 'package:WashBuddy/SlotBook/confirmationslot.dart';
import 'package:WashBuddy/Widgits/app_drawer.dart';
import 'package:WashBuddy/global/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SlotBookingnew());
}

class SlotBookingnew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slot Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GridScreen(),
    );
  }
}

class GridScreen extends StatefulWidget {
  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  Map<String, bool> availabilityMap = {};
  List<String> updatedTimes = [];
  DateTime selectedDate = DateTime.now();
  String userEmail = '';
  bool hasBookedSlot = false;
  DateTime? lastBookedDate;
  bool isCurrentDateSelected = false;
  DateTime? nextBookingDate ;
  Color buttonColor = Colors.red; // Default color when no date is selected
  Color selectedButtonColor = Colors.green; // Color when a valid date is selected


  // Utility function to extract the date portion from a DateTime object
  DateTime extractDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  void initState() {
    super.initState();

    fetchUserEmail();
    checkUserBooking();
    fetchNextBookingDate(userEmail);
  }
  void fetchUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? '';
      });
    }
    checkUserBooking();
  }

  void checkUserBooking() async {
    final collection = FirebaseFirestore.instance.collection('Users');
    final selectedDay = DateFormat('EEEE').format(selectedDate);

    QuerySnapshot userSlotsSnapshot = await collection
        .where('email', isEqualTo: userEmail)
        .where('day', isEqualTo: selectedDay)
        .get();

    setState(() {
      hasBookedSlot = userSlotsSnapshot.docs.isNotEmpty;
      if (hasBookedSlot) {
        Timestamp lastTimestamp = userSlotsSnapshot.docs.first['timestamp'] as Timestamp;
        lastBookedDate = lastTimestamp.toDate();
      } else {
        lastBookedDate = null;
      }
    });
  }

  Future<DateTime?> fetchNextBookingDate(String userEmail) async {
    try {
      final userDocRef = FirebaseFirestore.instance.collection('Users').doc(userEmail);
      final slotsCollectionRef = userDocRef.collection('Slots');

      final slotsQuerySnapshot = await slotsCollectionRef.orderBy('timestamp', descending: true).limit(1).get();

      if (slotsQuerySnapshot.docs.isNotEmpty) {
        final lastSlotDocSnapshot = slotsQuerySnapshot.docs.first;
        final lastSlotDocData = lastSlotDocSnapshot.data();
        final firestoreNextBookingDate = (lastSlotDocData['nextBookingDate'] as Timestamp?)?.toDate();
        return firestoreNextBookingDate;
      } else {
        return null; // No slot documents found
      }
    } catch (e) {
      print("Error fetching next booking date: $e");
      return null;
    }
  }




  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      selectedDate = selectedDay;
      isCurrentDateSelected = isSameDay(selectedDay, DateTime.now());
    });
    checkUserBooking();

    final collection = FirebaseFirestore.instance.collection('Users');
    final userBookingSnapshot = await collection
        .where('email', isEqualTo: userEmail)
        .orderBy('nextBookingDate', descending: true)
        .limit(1)
        .get();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            "Select Current Date"
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
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(fontSize: 18.0),
              weekendTextStyle: TextStyle(fontSize: 18.0),
              selectedTextStyle: TextStyle(fontSize: 18.0),
              todayTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: _onDaySelected,
          ),
          ElevatedButton(
            onPressed: () async {
              DateTime? fetchedNextBookingDate = await fetchNextBookingDate(userEmail);
              if (isCurrentDateSelected &&
                  (fetchedNextBookingDate == null ||
                      fetchedNextBookingDate.isBefore(selectedDate))) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => one1(selectedDate: selectedDate, nextBookingDate: DateTime.now().add(Duration(days: 7)))),
                );

              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrentDateSelected ? selectedButtonColor : buttonColor,
            ),
            child: FutureBuilder<DateTime?>(
              future: fetchNextBookingDate(userEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error fetching next booking date');
                } else {
                  final fetchedNextBookingDate = snapshot.data;

                  // Convert both dates to the same time zone for accurate comparison
                  final fetchedNextBookingDateUtc = fetchedNextBookingDate?.toUtc();
                  final selectedDateUtc = selectedDate.toUtc();
                  print("$selectedDateUtc and $fetchedNextBookingDateUtc");
                  return Text(
                    fetchedNextBookingDateUtc != null &&
                        extractDate(fetchedNextBookingDateUtc).isAfter(extractDate(selectedDateUtc))
                        ? 'Next Booking Date: ${DateFormat('yyyy-MM-dd').format(fetchedNextBookingDateUtc)}'
                        : 'Book Your Slot $userEmail $fetchedNextBookingDate',
                  );
                }
              },
            ),
          )

        ],
      ),
    );
  }
}


