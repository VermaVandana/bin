import 'package:WashBuddy/AuthScr/admn_login.dart';
import 'package:WashBuddy/AuthScr/login.dart';
import 'package:flutter/material.dart';

import 'newReg.dart';

class Auth_Scr extends StatefulWidget {
  const Auth_Scr({Key? key}) : super(key: key);

  @override
  State<Auth_Scr> createState() => _Auth_ScrState();
}

class _Auth_ScrState extends State<Auth_Scr> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end : const FractionalOffset(1.0, 0.0),
                    stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            "WashBuddy",

          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: "Lobster",
          )

      ),

        centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock,color: Colors.white,),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.person,color: Colors.white,),
                text: "Register",
              ),
              Tab(
                icon: Icon(Icons.person,color: Colors.white,),
                text: "Admin Login",
              )
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 7,
          ),
      ),
        body: Container(

          child: TabBarView(
            children:[
              Loginscreen(),
              NRegisterScr(),
              AdminLogin(),
            ],
          ),
        ),
      ),
    );
  }
}
