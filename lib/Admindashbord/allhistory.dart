import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(AllHistory());
}

class AllHistory extends StatefulWidget {
  @override
  State<AllHistory> createState() => _AllHistoryState();
}

class _AllHistoryState extends State<AllHistory> {

  final TextEditingController _emailController = TextEditingController();

  String _fetchedData = '';

  Future<void> fetchData() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .collection('Slots')
            .get();

        final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

        if (documents.isNotEmpty) {
          String data = '';
          for (final doc in documents) {
            final time = doc['time'];
            final date = doc['nextBookingDate']?.toDate();

            final timestamp = doc['timestamp']?.toDate(); // Convert Timestamp to DateTime

            data += 'Time_Slot: $time\n, Booked_Date: $timestamp\n, Next Booking Date: $date\n\n';
          }

          setState(() {
            _fetchedData = data;
          });
        } else {
          setState(() {
            _fetchedData = 'No slots found for this email.';
          });
        }
      } catch (e) {
        print('Error fetching data: $e');
        setState(() {
          _fetchedData = 'Error fetching data.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField( // Add the email text field
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Email', // Placeholder text for the field
                ),
              ),
            ),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Slots'),
            ),
            SizedBox(height: 20),
            Text(_fetchedData),
          ],
        ),
      ),
    );
  }
}




