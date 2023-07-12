import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:tb_app/home.dart';
import 'package:tb_app/switch.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginIn(),
    );
  }
}

class LoginIn extends StatefulWidget {
  LoginIn({Key? key}) : super(key: key);

  @override
  State<LoginIn> createState() => _LoginInState();
}

class _LoginInState extends State<LoginIn> {
  String? predicted;
  String prediction = '';
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  late String name;
  late String photoUrl;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 27, right: 27),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img1.png',
                width: 300,
                height: 300,
            ),
            SizedBox(height: 60.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 37, 121, 200),
                onPrimary: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              icon: FaIcon(FontAwesomeIcons.google),
              onPressed: () async {
                try {
                  final GoogleSignInAccount? account =
                      await _googleSignIn.signIn();
                  if (account != null) {
                    // The user is signed in, you can access the user's details here.
                    // For example, you can get the user's name, photo, and email address:
                    print('User Name: ${account.displayName}');
                    print('User Photo: ${account.photoUrl}');
                    print('User Email: ${account.email}');
                    // Continue with the desired logic using the retrieved data
                    name = account.displayName!;
                    photoUrl = account.photoUrl!;
                    email = account.email;
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) =>
                            MyNewScreen(name: name, photoUrl: photoUrl, email: email),
                      ),
                    );
                  }
                } catch (error) {
                  print('Google Sign-In error: $error');
                }
              },
              label: const Text(
                '  Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
