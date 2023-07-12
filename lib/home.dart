import 'dart:async' show Future;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'dart:io';
//import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tb_app/data.dart';
import 'package:tb_app/sign.dart';
// import 'package:flutter/services.dart' show rootBundle;

class MyHome extends StatefulWidget {
  final String name;
  final String photoUrl;
  final String email;
  final String patientName;
  MyHome(
      {required this.name,
      required this.photoUrl,
      required this.email,
      required this.patientName});
  @override
  State<MyHome> createState() => _MyHomeState(
      name: name, photoUrl: photoUrl, email: email, patientName: patientName);
}

class _MyHomeState extends State<MyHome> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late String name;
  late String photoUrl;
  late String email;
  late String patientName;
  _MyHomeState(
      {required this.name,
      required this.photoUrl,
      required this.email,
      required this.patientName});
  String? _filePath;
  String? tbStatus;
  String? _fileName;
  String? predicted = '';
  final audioplayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String groundtruth = '';
  List<String> prediction = [];

  Future<void> addDataToFirebase(
      String email, String predicted, String patientName) async {
    DateTime now = DateTime.now();
    String date = DateTime.now().toIso8601String().split('T')[0];
    String time = now.hour.toString().padLeft(2, '0') +
        ':' +
        now.minute.toString().padLeft(2, '0');

    try {
      await FirebaseFirestore.instance
          .collection(email) // Use the email as the name of the collection
          .doc() // Generate a unique document ID
          .set({
        'date': date,
        'time': time,
        'prediction': predicted,
        'patientName': patientName // Add patientName field to the document
      });
      print('Data added to Firebase');
    } catch (error) {
      print('Failed to add data: $error');
      throw error; // Rethrow the error for error handling outside the function
    }
  }

  Future<void> uploadAudio(File audioFile) async {
    final url =
        "http://13.233.48.201/predict"; // Change this to your Flask back-end URL
    var request = await http.MultipartRequest('POST', Uri.parse(url));
    request.files
        .add(await http.MultipartFile.fromPath('audio', audioFile.path));
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    setState(() {
      // prediction = responseData;
      prediction = responseData.split(',');
      if (prediction.length >= 2) {
        predicted = prediction[0];
        groundtruth = prediction[1];
      }
    });
    print(responseData);
    print(predicted);
    print(groundtruth);
  }

  // Future<void> uploadAudio(File audioFile) async {
  //   final url =
  //       'http://tbdetection-production.up.railway.app//predict'; // Change this to your Flask back-end URL
  //   var request = await http.MultipartRequest('POST', Uri.parse(url));
  //   request.files
  //       .add(await http.MultipartFile.fromPath('audio', audioFile.path));
  //   var response = await request.send();
  //   var responseData = await response.stream.bytesToString();
  //   setState(() {
  //     prediction = responseData;
  //   });
  //   print(responseData);
  // }

  // Future<void> pickWavFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['wav'],
  //   );

  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     setState(() {
  //       _filePath = file.path;
  //       _fileName = file.name;
  //     });
  //   }
  // }

  Future pickWavFile() async {
    audioPlayer1.setReleaseMode(ReleaseMode.stop);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (result != null) {
      final file = result.files.first;
      final filePath = file.path;
      if (filePath != null) {
        audioPlayer1.setSourceUrl(filePath);
        setState(() {
          _filePath = filePath;
          _fileName = file.name;
        });
      }
    }
  }

  //Audio player 1
  final audioPlayer1 = AudioPlayer();
//Audio player 2
  final audioPlayer2 = AudioPlayer();
  bool isPlaying1 = false;
  bool isPlaying2 = false;
  Duration duration1 = Duration.zero;
  Duration duration2 = Duration.zero;
  Duration position1 = Duration.zero;
  Duration position2 = Duration.zero;

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    super.initState();

    //setAudio();
    //loadAudio();

    audioPlayer1.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying1 = state == PlayerState.playing;
      });
    });

    audioPlayer2.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying2 = state == PlayerState.playing;
      });
    });

    audioPlayer1.onDurationChanged.listen((newDuration) {
      setState(() {
        duration1 = newDuration;
      });
    });

    audioPlayer2.onDurationChanged.listen((newDuration) {
      setState(() {
        duration2 = newDuration;
      });
    });

    audioPlayer1.onPositionChanged.listen((newPosition) {
      setState(() {
        position1 = newPosition;
      });
    });

    audioPlayer2.onPositionChanged.listen((newPosition) {
      setState(() {
        position2 = newPosition;
      });
    });
  }

  Future setAudio() async {
    audioPlayer1.setReleaseMode(ReleaseMode.stop);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );
    if (result != null) {
      final file = File(result.files.single.path!);
      audioPlayer1.setSourceUrl(file.path);
      setState(() {
        _filePath = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(size: 35),

        backgroundColor:
            Colors.transparent, // Set the AppBar color to transparent
        foregroundColor: Colors.black,
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
              // subtitle: SizedBox(child: Text(email)),
            ),
            //
            ListTile(
              contentPadding: EdgeInsets.only(left: 25),
              leading: FaIcon(FontAwesomeIcons.database),
              title: const Text(
                "History",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(microseconds: 500),
                    pageBuilder: (_, __, ___) => MyData(
                      email: email,
                      name: name,
                      photoUrl: photoUrl,
                      patientName: patientName,
                    ),
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
            // ListTile(
            //   contentPadding: EdgeInsets.only(left: 24),
            //   leading: FaIcon(FontAwesomeIcons.solidCircleQuestion),
            //   title: const Text(
            //     "Help",
            //     style: TextStyle(fontSize: 15),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       PageRouteBuilder(
            //         transitionDuration: Duration(microseconds: 500),
            //         pageBuilder: (_, __, ___) => MyHome(
            //           email: email,
            //           name: name,
            //           photoUrl: photoUrl,
            //           patientName: patientName,
            //         ),
            //         transitionsBuilder: (_, animation, __, child) {
            //           return FadeTransition(
            //             opacity: animation,
            //             child: child,
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
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
      body: Container(
        margin: EdgeInsets.only(left: 27, right: 27),
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: pickWavFile,
                child: Text('Select audio file'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 94, 76, 175),),
              ),
              SizedBox(height: 20),
              _filePath != null
                  ? Text('Selected file: $_fileName')
                  : Text('No file selected'),
              SizedBox(height: 20),
              Slider(
                min: 0,
                max: duration1.inSeconds.toDouble(),
                value: position1.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position1 = Duration(seconds: value.toInt());
                  await audioPlayer1.seek(position1);

                  await audioPlayer1.resume();
                },
                activeColor: const Color.fromARGB(255, 69, 173, 168),
                inactiveColor: Colors.black12,
                thumbColor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position1.inSeconds)),
                    Text(formatTime((duration1 - position1).inSeconds)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 35,
                backgroundColor: Color.fromARGB(255, 94, 76, 175),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(
                    isPlaying1 ? Icons.pause : Icons.play_arrow,
                  ),
                  iconSize: 50,
                  onPressed: () async {
                    if (isPlaying1) {
                      await audioPlayer1.pause();
                    } else {
                      await audioPlayer1.resume();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 50,
                height: 30, //<-- SEE HERE
              ),
              ElevatedButton(
                onPressed: () async {
                  print(_fileName);

                  await uploadAudio(File(_filePath ?? ""));

                  // print('Prediction : $prediction');
                  // print("Grount truth : $tbStatus");

                  print(_filePath);
                  await addDataToFirebase(email, predicted!, patientName);
                },
                child: Text('Predict'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 94, 76, 175),),
              ),
              SizedBox(
                height: 30, //<-- SEE HERE
              ),
              predicted != ''
                  ? Text(
                      'PREDICTION : $predicted',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // color: Color.fromARGB(255, 201, 4, 4),
                      ),
                    )
                  : Text(''),
              SizedBox(
                height: 30, //<-- SEE HERE
              ),
              if (groundtruth != 'Label Unknown') Text("GROUND TRUTH : $groundtruth",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // color: Color.fromARGB(255, 201, 4, 4),
                      ),) else Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
