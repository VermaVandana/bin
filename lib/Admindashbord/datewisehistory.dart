import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(AllHistoryn());
}

class AllHistoryn extends StatefulWidget {
  @override
  State<AllHistoryn> createState() => _AllHistorynState();
}

class _AllHistorynState extends State<AllHistoryn> {
  late DateTime _selectedDate = DateTime.now();
  String _fetchedData = '';

  Future<void> fetchData() async {
    try {
      final startOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      final endOfDay = startOfDay.add(Duration(days: 1));

      final Query query = FirebaseFirestore.instance
          .collectionGroup('Slots')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay);

      final QuerySnapshot querySnapshot = await query.get();

      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      if (documents.isNotEmpty) {
        String data = '';
        for (final doc in documents) {
          final Email = doc['email'];
          final Time_Slot = doc['time'];// Document ID
          final date = doc['date']?.toDate();
          final nextBookingDate = doc['nextBookingDate']?.toDate();

          data += ' Email: $Email\n Time_Slot: $Time_Slot\n Booked_Date: $date\n Next_BookingDate: $nextBookingDate\n\n';
        }

        setState(() {
          _fetchedData = data;
        });
      } else {
        setState(() {
          _fetchedData = 'No slots found for this date.';
        });
      }
    } on FirebaseException catch (e) {
      print('Firestore Error: ${e.message}');
      setState(() {
        _fetchedData = 'Firestore Error: ${e.message}';
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _fetchedData = 'Error fetching data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _fetchedData = ''; // Clear existing data
                    });
                    fetchData();
                  }
                },
                child: Text('Pick Date'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_fetchedData),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
