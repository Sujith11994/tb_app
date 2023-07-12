//import 'package:tb_app/home.dart';
//import 'package:tb_app/sign.dart' show MyLogin;
// import 'package:_flutter/otp.dart';
// import 'package:_flutter/phone.dart';
// import 'package:_flutter/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tb_app/sign.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'sign',
    routes: {
      
      'sign': (context) => MyLogin(),
      
      
    },
  ));
}
  