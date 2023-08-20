import 'package:WashBuddy/SlotBook/slotscreennew.dart';
import 'package:WashBuddy/Widgits/app_drawer.dart';
import 'package:WashBuddy/global/global.dart';
import 'package:WashBuddy/main_screen/homenew.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class one1 extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime? nextBookingDate;

  const one1({Key? key, required this.selectedDate, this.nextBookingDate})
      : super(key: key);

  @override
  State<one1> createState() => _one1State();
}

class _one1State extends State<one1> {
  String userEmail = '';
  Map<String, bool> availabilityMap = {};
  bool hasBookedSlot = false;
  DateTime? lastBookedDate;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchUserEmail();
  }

  void fetchData() async {
    // Fetch initial data from Firestore
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('TimeSlots').get();
    List<QueryDocumentSnapshot<Object?>> documents = snapshot.docs;

    // Iterate over the documents and initialize availabilityMap
    for (var document in documents) {
      String time = document.get('time') as String;
      bool isAvailable = document.get('available') as bool;
      availabilityMap[time] = isAvailable;
    }
  }

  void fetchUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? '';
      });
    }
  }

  void storeSlotInformation(
      String time, DateTime selectedDate, DateTime nextBookingDate) async {
    final userDocRef =
    FirebaseFirestore.instance.collection('Users').doc(userEmail);
    final userSlotsCollection =
    userDocRef.collection('Slots'); // New collection for storing slots

    try {
      await userSlotsCollection.add({
        'timestamp': FieldValue.serverTimestamp(),
        'time': time,
        'day': DateFormat('EEEE').format(selectedDate),
        'date': Timestamp.fromDate(selectedDate),
        'nextBookingDate': Timestamp.fromDate(nextBookingDate),
        'email':userEmail,
      });

      setState(() {
        hasBookedSlot = true;
        lastBookedDate = DateTime.now();
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Slot Information'),
            content: Text('Slot booked successfully!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Home_Screen1(),
                    ),
                        (route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Slot Information'),
            content: Text('Error booking slot. Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }
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
            "Select Your Slot"
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
          Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('TimeSlots').get(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          QueryDocumentSnapshot<Object?>? document =
                          snapshot.data?.docs[index];
                          String time = document?.get('time') as String;
                          bool isAvailable = availabilityMap.containsKey(time)
                              ? availabilityMap[time]!
                              : true;
                          Color cellColor = isAvailable ? Colors.blue : Colors.red;

                          return GestureDetector(
                            onTap: () {
                              if (!isAvailable) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Slot Information'),
                                      content: Text('This slot is already booked.'),
                                      actions: [
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Slot Booking'),
                                      content: Text(
                                          'Do you want to book the slot at $time?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              availabilityMap[time] = false;
                                              document?.reference
                                                  .update({'available': false});
                                            });
                                            DateTime nextBookingDate =
                                                widget.nextBookingDate ??
                                                    DateTime.now();
                                            storeSlotInformation(
                                                time,
                                                widget.selectedDate,
                                                nextBookingDate);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              color: cellColor,
                              child: Center(
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
        ],
      ),
    );
  }
}
