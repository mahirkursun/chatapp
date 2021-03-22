import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'goruntuleme/sohbetodasi_ekrani.dart';
import 'helper/dogrulama.dart';
import 'helper/yardimcifonk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool kullaniciIsLoggedIn = false;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    getLoggedInState();
  }

  getLoggedInState() async {
    await YardimciFonksiyon.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        kullaniciIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Colors.teal[100],
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: kullaniciIsLoggedIn ? SohbetOdasi() : Dogrulama(),
    );
  }
}
