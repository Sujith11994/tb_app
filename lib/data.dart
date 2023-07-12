import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:tb_app/home.dart';
import 'package:tb_app/name.dart';
import 'package:tb_app/sign.dart';



class MyData extends StatelessWidget {
  final String email;
  final String name;
  final String photoUrl;
  final String patientName;
    final GoogleSignIn _googleSignIn = GoogleSignIn();


   MyData({required this.email,required this.name, required this.photoUrl, required this.patientName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        elevation: 0,
        iconTheme: IconThemeData(size: 35),
         backgroundColor: Colors.transparent, // Set the AppBar color to transparent
          foregroundColor: Colors.grey.shade700,
      ),
      drawer: Drawer(
        child: ListView(
          padding:
              EdgeInsets.only(top: 60, left: 0), // Adjust the vertical padding
          itemExtent: 50.0,
          children: [
            ListTile(
              
              leading: CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                radius: 25,
                
              ),

              title: Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
            ),
            // ListTile(
            //   contentPadding: EdgeInsets.only(left: 25,),
            //   leading: FaIcon(FontAwesomeIcons.solidEnvelope),
            //   title: Text(email, style: TextStyle(fontSize: 15)),
            // ),
            // const Padding(padding:EdgeInsets.only(top: double.minPositive) ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 24),
              leading: FaIcon(FontAwesomeIcons.house),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.push(
                   context,
                    PageRouteBuilder(
                transitionDuration: Duration(microseconds: 500),
                pageBuilder: (_, __, ___) => MyName(email:email,name: name,photoUrl: photoUrl,),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
          );
              },
            ),
          //   ListTile(
          //     contentPadding: EdgeInsets.only(left: 24),
          //     leading: FaIcon(FontAwesomeIcons.solidCircleQuestion),
          //     title: const Text(
          //       "Help",
          //       style: TextStyle(fontSize: 15),
          //     ),
          //     onTap: () {
          //       Navigator.push(
          //          context,
          //           PageRouteBuilder(
          //       transitionDuration: Duration(microseconds: 500),
          //       pageBuilder: (_, __, ___) => MyHome(email:email,name: name,photoUrl: photoUrl,patientName: patientName,),
          //       transitionsBuilder: (_, animation, __, child) {
          //         return FadeTransition(
          //           opacity: animation,
          //           child: child,
          //         );
          //       },
          //     ),
          // );
          //     },
          //   ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 25),
              leading: FaIcon(FontAwesomeIcons.lock),
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                _googleSignIn.signOut().then((value) {}).catchError((e) {});
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyLogin(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return Center(
                child: Text('No History',style: TextStyle(fontSize: 25),),
              );
            }

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                final data = document.data() as Map<String, dynamic>;
                
                // Extract the desired fields from the data map
                final date = data['date'] as String;
                final time = data['time'] as String;
                final predicted = data['prediction'] as String;
                final patientName = data['patientName'] as String;

                return ListTile(
                  
                  title: Text('Prediction: $predicted, Name: $patientName'),
                  subtitle: Text('Date: $date, Time: $time'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
