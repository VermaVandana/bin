import 'package:cloud_firestore/cloud_firestore.dart';

// Function to fetch unapproved candidates
Future<List<DocumentSnapshot>> getUnapprovedCandidates() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('candidates')
      .where('approvalStatus', isEqualTo: 'pending')
      .get();
  return snapshot.docs;
}
