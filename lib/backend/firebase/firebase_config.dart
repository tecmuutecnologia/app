import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAWdeiw8IN6htXW8Hj2z7KaYbrYrhqkXXI",
            authDomain: "project-tecmuu-app.firebaseapp.com",
            projectId: "project-tecmuu-app",
            storageBucket: "project-tecmuu-app.appspot.com",
            messagingSenderId: "874818729754",
            appId: "1:874818729754:web:0731f758902a5dc7afdea3",
            measurementId: "G-28FT11ZF4L"));
  } else {
    await Firebase.initializeApp();
  }
}
