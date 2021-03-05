import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musculaquiz/app/utils/config.dart';

import 'Home.dart';
import 'Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // name: APP_NAME,
    options: FirebaseOptions(
      appId: FIREBASE_ANDROID_APP_CODE,
      apiKey: FIREBASE_API_KEY,
      messagingSenderId: FIREBASE_PROJECT_NUMBER,
      projectId: FIREBASE_PROJECT_ID,
      databaseURL: FIREBASE_DATABASE_URL,
    ),
  );

  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
        primaryColor: Color(0xff00A696), accentColor: Color(0xff25D366)),
    debugShowCheckedModeBanner: false,
  ));

/*
  FirebaseFirestore.instance
  .collection("usuarios")
  .doc("001")
  .set({"nome":"mario  saviotti junior"});
*/
}
