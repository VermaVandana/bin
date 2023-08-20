import 'package:WashBuddy/AuthScr/authscrn.dart';
import 'package:WashBuddy/global/global.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Washer {
  final String washerId;
  final String washerName;
  final String washerEmail;
  bool isRemoved;
  bool isSaved; // To track if the washer is saved to 'girls' collection

  Washer({
    required this.washerId,
    required this.washerName,
    required this.washerEmail,
    this.isRemoved = false,
    this.isSaved = false,
  });
}

class WasherScreen extends StatefulWidget {
  @override
  _WasherScreenState createState() => _WasherScreenState();
}

class _WasherScreenState extends State<WasherScreen> {
  List<Washer> washers = [];
  Set<String> savedEmails = Set<String>();

  @override
  void initState() {
    super.initState();
    _loadSavedEmails(); // Load saved emails when the widget initializes
  }

  Future<void> _loadSavedEmails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedEmails = prefs.getStringList('saved_emails')?.toSet() ?? Set<String>();
    });
  }

  Future<void> _saveSavedEmails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('saved_emails', savedEmails.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('washer').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          washers = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Washer(
              washerId: doc.id,
              washerName: data['washerName'],
              washerEmail: data['washerEmail'],
              isSaved: savedEmails.contains(data['washerEmail']),
            );
          }).toList();

          return ListView.separated(
            itemCount: washers.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              Washer washer = washers[index];
              if (!washer.isRemoved) {
                return ListTile(
                  title: Text(
                    washer.washerName,
                    style: TextStyle(
                      color: washer.isSaved ? Colors.green : Colors.black,
                      decoration: washer.isSaved ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    washer.washerEmail,
                    style: TextStyle(
                      color: washer.isSaved ? Colors.green : Colors.black,
                      decoration: washer.isSaved ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!washer.isSaved && !washer.isRemoved)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: () {
                            if (!savedEmails.contains(washer.washerEmail)) {
                              _saveWasherToGirlsCollection(washer);
                              setState(() {
                                washer.isSaved = true;
                                savedEmails.add(washer.washerEmail);
                                _saveSavedEmails(); // Save the updated saved emails to local storage
                              });
                            }
                          },
                          icon: Icon(Icons.check, color: Colors.white),
                          label: Text('Approve'),
                        ),
                      if (!washer.isSaved && !washer.isRemoved)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            _removeWasher(index, washer.washerId);
                          },
                          icon: Icon(Icons.close, color: Colors.white),
                          label: Text('Delete'),
                        ),
                      if (washer.isSaved)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            _removeSavedWasher(index, washer.washerEmail);
                          },
                          icon: Icon(Icons.close, color: Colors.white),
                          label: Text('Delete'),
                        ),
                    ],
                  ),
                  tileColor: washer.isSaved ? Colors.green.withOpacity(0.2) : Colors.white,
                );
              } else {
                return SizedBox.shrink(); // Return an empty SizedBox to hide the removed row
              }
            },
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

  void _saveWasherToGirlsCollection(Washer washer) {
    FirebaseFirestore.instance.collection('girls').add({
      'name': washer.washerName,
      'email': washer.washerEmail,
    });
  }

  void _removeWasher(int index, String washerId) {
    FirebaseFirestore.instance.collection('washer').doc(washerId).delete();

    setState(() {
      washers[index].isRemoved = true;
    });
  }

  void _removeSavedWasher(int index, String email) {
    savedEmails.remove(email);
    setState(() {
      washers[index].isSaved = false;
      _saveSavedEmails(); // Save the updated saved emails to local storage
    });
  }


}

