import 'package:WashBuddy/Widgits/app_drawer.dart';
import 'package:WashBuddy/global/global.dart';
import 'package:WashBuddy/main_screen/homenew.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactDetail extends StatefulWidget {
  const ContactDetail({Key? key}) : super(key: key);

  @override
  State<ContactDetail> createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot> querySnapshot =
  FirebaseFirestore.instance.collection('Contact').snapshots();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _handleSubmit() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home_Screen1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          key: _scaffoldKey,
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
          title: Text(
            "Contact"
          ),
          leading: GestureDetector(
            onTap: _openDrawer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  sharedPrefrences!.getString("photoUrl")!,
                ),
                radius: 12 * 12,
              ),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),

        drawer: buildDrawer1(context),




        body: StreamBuilder(
          stream: querySnapshot,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (ctx, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('images/7.jpg'),
                    radius: 8 * 8,
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Name: ',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data[index]['Name'],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                ],
                ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Designation: ',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        data[index]['Designation'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        data[index]['hname'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Phone: ',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        data[index]['Mobile'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Email: ',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        data[index]['Email'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 15,
                  ),
                    Text("............................................................"
                    ,
                    textAlign: TextAlign.center,),

                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Name: ',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          data[index]['Name2'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Designation: ',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          data[index]['Designation2'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        data[index]['hname'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Phone: ',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          data[index]['Mobile2'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Email: ',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          data[index]['Email2'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),

      ),
    );
  }
}
