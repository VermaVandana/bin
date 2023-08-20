
import 'package:WashBuddy/Admindashbord/adminDashboard.dart';
import 'package:WashBuddy/Admindashbord/adminDashboardHome.dart';
import 'package:WashBuddy/Admindashbord/approvegirlscr.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(AdminLogin());
}


class AdminLogin extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn(BuildContext context) async {
    final String enteredEmail = _emailController.text.trim();
    final String enteredPassword = _passwordController.text;

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('adminDetail') // Replace with your Firestore collection name
        .where('email', isEqualTo: enteredEmail)
        .get();

    if (snapshot.size == 1) {
      final DocumentSnapshot userDoc = snapshot.docs.first;
      final String storedPassword = userDoc['Password']; // Replace with the field name for the password

      if (storedPassword == enteredPassword) {
        // User authenticated, proceed to the desired screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminAuth_Scr()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Authentication Failed'),
              content: Text('Invalid email or password.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Authentication Failed'),
            content: Text('Invalid email or password.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 30),
            Container(
              alignment: Alignment.bottomCenter,
              child: CircleAvatar(
                backgroundImage: AssetImage('images/8.png'),
                radius: 12 * 12,
              ),
            ),
            Form(
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),

                ],
              ),
            ),
            ElevatedButton(
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              onPressed: () => _signIn(context),
            ),
          ],
        ),
      ),
    );
  }
}
