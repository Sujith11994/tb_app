import 'package:flutter/material.dart';
import 'package:tb_app/urban.dart';
import 'package:tb_app/name.dart';




class MyNewScreen extends StatelessWidget {
  final String email;
  final String name;
  final String photoUrl;
    // final GoogleSignIn _googleSignIn = GoogleSignIn();


   MyNewScreen({required this.email,required this.name, required this.photoUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('My New Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 94, 76, 175),
                onPrimary: Colors.white,
                // minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                   context,
                    PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => MyName(name: name, photoUrl: photoUrl,email:email),
              ),
          );
              },
              child: Text('TUBERCULOSIS'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 94, 76, 175),
                onPrimary: Colors.white,
                // minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyUrban(),
                  ),
                );
              },
              child: Text('URBAN SOUND'),
            ),
          ],
        ),
      ),
    );
  }
}
