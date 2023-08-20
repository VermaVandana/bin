import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => toggleTimeSlots(),
          child: Text('Toggle All Time Slots'),
        ),
      ),
    );
  }

  // Implement the function to toggle all time slots
  void toggleTimeSlots() {
    final firestore = FirebaseFirestore.instance;
    final timeSlotsRef = firestore.collection('TimeSlots');

    // Determine the new value (true) for available
    final newState = true;

    // Prepare a list of batch updates
    final batchUpdates = <Future>[];

    // Fetch all the time slots
    timeSlotsRef.get().then((snapshot) {
      // Loop through all time slots and add them to the batch updates list
      snapshot.docs.forEach((doc) {
        batchUpdates.add(doc.reference.update({'available': newState}));
      });

      // Execute all batch updates simultaneously
      Future.wait(batchUpdates).then((_) {
        print('Time slots updated successfully!');
      }).catchError((error) {
        print('Error updating time slots: $error');
      });
    }).catchError((error) {
      print('Error fetching time slots: $error');
    });
  }
}
