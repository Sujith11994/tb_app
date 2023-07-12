import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tb_app/home.dart';

class MyName extends StatelessWidget {
  final String email;
  final String name;
  final String photoUrl;
    // final GoogleSignIn _googleSignIn = GoogleSignIn();


   MyName({required this.email,required this.name, required this.photoUrl});
  final TextEditingController nameController = TextEditingController();
  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Enter Name'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0), // Adjust the padding here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter name of the patient',
                style: TextStyle(
                  fontSize: 20
                  
                  ,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                    border: Border.all(width: 1, color: Color.fromARGB(220, 224, 224, 224)),
                    borderRadius: BorderRadius.circular(10)),
                    width: 2.0,
                  
                 
                
                child: TextField(
                  style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 117, 117, 117)),
                  controller: nameController,
                  decoration: InputDecoration(
                    // labelText: 'Enter name of the patient',
                    
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                
                child: ElevatedButton(
                  
                  onPressed: () {
                    
                    String patientName = nameController.text;
                    Navigator.push(
                      context,
                      
                      MaterialPageRoute(
                        builder: (context) => MyHome(patientName: patientName,photoUrl: photoUrl,name: name,email: email,),
                      ),
                    );
                  },
                  
                  child: Text('Next',style: TextStyle(fontSize: 18,),),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 94, 76, 175),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


