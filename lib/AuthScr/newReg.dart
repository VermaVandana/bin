import 'dart:io';
import 'package:WashBuddy/AuthScr/authscrn.dart';
import 'package:WashBuddy/global/global.dart';
import 'package:WashBuddy/Widgits/customtextfeild.dart';
import 'package:WashBuddy/Widgits/error_dialog.dart';
import 'package:WashBuddy/Widgits/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

class NRegisterScr extends StatefulWidget {
  const NRegisterScr({Key? key}) : super(key: key);

  @override
  State<NRegisterScr> createState() => _NRegisterScrState();
}

class _NRegisterScrState extends State<NRegisterScr> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController anyController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String WashImageUrl = "";

  Future<void> _getImage() async
  {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }


  Future<void> formValidation() async
  {



    // Check if enteredEmail exists in registeredEmails



    if (imageXFile == null) {

      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please Select an Image",
            );

          }
      );
    }


    else
    {
      if(passwordController.text == confirmpassController.text)
      {

        if(confirmpassController.text.isNotEmpty && nameController.text.isNotEmpty && emailController.text.isNotEmpty  && phoneController.text.isNotEmpty) {
          // start uploading Data
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(
                  message: "Registering Account",
                );
              }
          );

          String filename = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("Wash").child(filename);
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            WashImageUrl = url;

            //save info to firestore
            authenticateWasherAndSignUp();

          });
        }
        else
        {
          showDialog(
              context: context,
              builder:(c)
              {
                return ErrorDialog(
                  message: "Please Fill required Filled",
                );
              }
          );

        }

      }

      else
      {
        showDialog(
            context: context,
            builder:(c)
            {
              return ErrorDialog(
                message: "Password do not Match..!",
              );
            }
        );

      }
    }

  }
  void authenticateWasherAndSignUp() async
  {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    ).then((auth){
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder:(c)
          {
            return ErrorDialog(
              message: error.message.toString(),
            );
          }
      );

    });

    if(currentUser != null)
    {
      saveDataToFirestore(currentUser!).then((value){
        Navigator.pop(context);
        //send User to homePage
        Route newRoute = MaterialPageRoute(builder: (c)=>Auth_Scr());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }


  Future saveDataToFirestore(User currentUser) async
  {
    FirebaseFirestore.instance.collection("washer").doc(currentUser.uid).set({
      "washerUID": currentUser.uid,
      "washerEmail": currentUser.email,
      "washerName": nameController.text.trim(),
      "washerAvtarUrl": WashImageUrl,
      "phone": phoneController.text.trim(),

    });
    //save data locally
    sharedPrefrences = await SharedPreferences.getInstance();
    await sharedPrefrences!.setString("uid", currentUser.uid);
    await sharedPrefrences!.setString("email", currentUser.email.toString());
    await sharedPrefrences!.setString("name", nameController.text.trim());
    await sharedPrefrences!.setString("photoUrl", WashImageUrl);

  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10,),
            InkWell(
                onTap: ()
                {
                  _getImage();
                },
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null ? null : FileImage(File(imageXFile!.path)),
                  child: imageXFile == null
                      ?
                  Icon(
                    Icons.add_photo_alternate,
                    size: MediaQuery.of(context).size.width *0.20,
                    color: Colors.grey,
                  ) :null,
                )
            ),

            const SizedBox(height: 10,),

            Form(
              key: _formKey,
              child : Column(
                children: [
                  Textfield(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Name",
                    isObsecre: false,
                  ),

                  Textfield(
                    data: Icons.mobile_friendly,
                    controller: phoneController,
                    hintText: "Mobile Number",
                    isObsecre: false,
                  ),

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

                  Textfield(
                    data: Icons.lock,
                    controller: confirmpassController,
                    hintText: "Confirm Password",
                    isObsecre: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height:30,),
            ElevatedButton(
                child: const Text(
                  "Register",
                  style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold,),
                ),
                style : ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  padding:  EdgeInsets.symmetric(horizontal:50, vertical: 10),
                ),
                onPressed: ()
                {
                  formValidation();
                }
            ),
            const SizedBox(height: 30,),

          ],
        ),

      ),
    );
  }
}
