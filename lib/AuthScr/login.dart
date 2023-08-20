import 'package:WashBuddy/Widgits/error_dialog.dart';
import 'package:WashBuddy/Widgits/loading_dialog.dart';
import 'package:WashBuddy/global/global.dart';
import 'package:WashBuddy/main_screen/rules.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgits/customtextfeild.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void showErrorSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showErrorSnackbar('Password reset email sent to $email');
    } catch (error) {
      showErrorSnackbar('Error sending password reset email: $error');
    }
  }

  Future<bool> isEmailExistsInGirlsCollection(String email) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("girls")
        .where("email", isEqualTo: email)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  formValidation() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Check if the entered email exists in the 'girls' collection
      bool isEmailExists = await isEmailExistsInGirlsCollection(emailController.text.trim());

      if (isEmailExists) {
        // Login
        LoginNow();
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please Enter Correct email/Password",
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Please Enter Correct email/Password",
          );
        },
      );
    }
  }

  LoginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: "Checking Credentials",
        );
      },
    );
    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: error.message.toString(),
          );
        },
      );
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const Rule()));
      });
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance.collection("washer").doc(currentUser.uid).get().then((snapshot) async {
      await sharedPrefrences!.setString("uid", currentUser.uid);
      await sharedPrefrences!.setString("email", snapshot.data()!["washerEmail"]);
      await sharedPrefrences!.setString("name", snapshot.data()!["washerName"]);
      await sharedPrefrences!.setString("photoUrl", snapshot.data()!["washerAvtarUrl"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              backgroundImage: AssetImage('images/1.jpg'),
              radius: 12 * 12,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Textfield(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObsecre: false,
                ),
                Textfield(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecre: true,
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
              primary: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: () {
              formValidation();
            },
          ),
          TextButton(
            onPressed: () {
              String email = emailController.text.trim();
              resetPassword(email);
            },
            child: const Text(
              'Forgot Password',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color(0xff4c505b),
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
