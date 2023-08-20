import 'package:WashBuddy/Admindashbord/togglebutton.dart';
import 'package:flutter/material.dart';

import 'allhistory.dart';
import 'approvegirlscr.dart';
import 'datewisehistory.dart';

class AdminAuth_Scr extends StatefulWidget {
  const AdminAuth_Scr({Key? key}) : super(key: key);

  @override
  State<AdminAuth_Scr> createState() => _AdminAuth_ScrState();
}

class _AdminAuth_ScrState extends State<AdminAuth_Scr> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Changed to match the number of tabs
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
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: "Lobster",
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.approval, color: Colors.white),
                text: "Approve ID",
              ),
              Tab(
                icon: Icon(Icons.reset_tv_sharp, color: Colors.white),
                text: "Reset Slots",
              ),
              Tab(
                icon: Icon(Icons.schedule, color: Colors.white),
                text: "Today Schedule",
              ),
              Tab(
                icon: Icon(Icons.details, color: Colors.white),
                text: "User Detail",
              ),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 3, // Reduced the indicator weight
            labelColor: Colors.white, // Selected tab text color
            unselectedLabelColor: Colors.white54, // Unselected tab text color
            labelStyle: TextStyle(fontSize: 12), // Adjust the font size here
            unselectedLabelStyle: TextStyle(fontSize: 12),
          ),
        ),
        body: TabBarView(
          children: [
            // Replace these with your desired widget components
            //PlaceholderWidget(),
             WasherScreen(),
            //PlaceholderWidget(), //
            ResetButton(),
            //PlaceholderWidget(), //
            AllHistoryn() ,
            AllHistory()
          ],
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Placeholder Content", // Replace with actual content
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
