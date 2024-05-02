import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_Do_It/NotificationService.dart';
import 'package:just_Do_It/auth/verified.dart';
import 'package:timezone/data/latest.dart';
import 'auth/login.dart';
import 'auth/signup.dart';
import "settings.dart";
import 'add.dart';
import 'finished.dart';
import 'important.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print(message.notification?.body);
  print(message.notification?.title);
}



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAXd-s0ErOUlcjdz3t7Hnq8_IgLWxKJuto",
        appId: "1:358500859496:android:80d3c210caea4fc58405dd",
        messagingSenderId: "358500859496",
        projectId: "my-first-project--to-do",
  ),
  )

:await Firebase.initializeApp();

  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().initNotification();
  tz.initializeTimeZones();
  runApp(const MyApp());

}




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home:FirebaseAuth.instance.currentUser == null ? const login() :const add(),
      debugShowCheckedModeBanner: false,
      title: 'Just Do It',
      routes: {
        'important':(context)=>const add(),
        'remove':(context)=>const remove(),
        'add':(context)=>const important(),
        'settings':(context) =>const SettingsPage(),
        'signup':(context)=>const signup(),
        'login':(context)=>const login(),
         'verif':(context)=>verified(),
        'home':(context)=>home(),
      },
    );
  }
}
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool _isVisible = false;

  @override
  @override
  void initState() {
    super.initState();
    // Delay the visibility change to simulate a gradual appearance
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isVisible = true;
      });
      // Navigate to the other page after 3 seconds
      Timer(Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => important()), // Replace 'OtherPage()' with the actual class of your other page
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: Duration(seconds: 3), // Duration of the fade-in animation
        opacity: _isVisible ? 1.0 : 0.0, // Set opacity based on visibility
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/OIG5.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),

    );
  }
}



sendmessage(title,message) async{
  var headersList = {
    'Accept': '*/*',
    'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    'Content-Type': 'application/json',
    'Authorization': 'key=AAAAU3hQ_mg:APA91bELVi1rE07lY1UULai5b10eErCCBMWywH76GYOp3awUnwRiIi6rfV6Er7Pw6sUSwqyrwAMFVsl7X1_PdBhvgzW9qGMQpIp0vGqhFkDklvVnUHAJQXMFt6YXjwR8xk_X9KMD0mu8'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "eZMmIWpoTnO27kIC1SdDxm:APA91bF4fikjp5P8oBY6JEqlfxadjUlF9mfc5coRWFgYD62Tdb4N1tYeVORIxhS-DpBEjAszmSBqUZMkQ0xQvZ9pFKiQghnW3jLK7nkigf74-CZENUou5160DwYE8J-qOlvU3bZaO-li",
    "notification": {
      "title": title,
      "body": message
    }
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);


  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  }
  else {
    print(res.reasonPhrase);
  }

}
