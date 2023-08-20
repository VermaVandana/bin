
import 'package:WashBuddy/main_screen/homenew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Rule extends StatefulWidget {
  const Rule({super.key});

  @override
  State<Rule> createState() => _RuleState();
}

class _RuleState extends State<Rule> {
  Stream<QuerySnapshot> querySnapshot = FirebaseFirestore.instance.collection('Rules').snapshots();
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
    "Rules",

    style: TextStyle(
    fontSize: 30,
    color: Colors.white,
    fontFamily: "Lobster",
    )

    ),

    centerTitle: true,
      ),
      body: StreamBuilder(
        stream: querySnapshot,
        builder: (BuildContext context,AsyncSnapshot snapshot)
        {
          if (snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          const SizedBox(height: 15,);

          final data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx,index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      data[index]['r1'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r2'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r3'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r4'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r5'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r6'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r7'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r8'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r9'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r10'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r11'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r12'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r13'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r14'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,),

                    Text(
                      data[index]['r15'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15,)


                  ],
                ),
              );


              },
          );
        },
      ),
      //drawer: buildDrawer(context),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[200]
        ,
        child: ElevatedButton(
          onPressed: _handleSubmit,
          child: Text('I Agree',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide.none,
            ),
          ),
        ),
      ),

    ),
    );
  }
}