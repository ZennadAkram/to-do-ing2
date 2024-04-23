import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth/login.dart';
import 'auth/signup.dart';
import "settings.dart";
import 'add.dart';
import 'finished.dart';
import 'important.dart';
import 'package:firebase_core/firebase_core.dart';




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

      home:FirebaseAuth.instance.currentUser == null ? const login() :const homepage(),
      debugShowCheckedModeBanner: false,
      title: 'Just Do It',
      routes: {
        'add':(context)=>const add(),
        'remove':(context)=>const remove(),
        'important':(context)=>const important(),
        'settings':(context) =>const SettingsPage(),
        'signup':(context)=>const signup(),
        'login':(context)=>const login(),
        'home':(context)=>const homepage(),
      },
    );
  }
}


class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO-DO-LIST',

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon:const Icon( Icons.search,size: 35,),

            onPressed: (){},
          )
        ],

        backgroundColor: Colors.lightBlue[200],
        centerTitle: true,
      ),

      body: const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Image(
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              image: NetworkImage('https://th.bing.com/th/id/OIG2.Eq6BmVMWgsbb2FQaqIXG?pid=ImgGn'),
            ),
          ),
          SizedBox(height: 20), // Spacer between image and text

        ],
      ),
      ),





      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color:  Color(0xFF0FE14F),
              ),
              child:Text(
                'Menu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ) ,
            ),
            ListTile(
              leading: const Icon(
                Icons.home,

              ),
              title: const Text("Home Page",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.pop(context);

              },
            ),
            ListTile(
              leading: const Icon(
                Icons.work_history,
              ),
              title: const Text('Activities',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap: (){
                // Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('add');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.check_box,

              ),
              title: const Text('Completed',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap:(){
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('remove');
              } ,
            ),
            ListTile(
              leading: const Icon(
                Icons.star_border,
              ),
              title: const Text('Important',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('important');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,

              ),
              title: const Text('Settings',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap:(){
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('settings');
              } ,
            ),
          ],
        ),

      ),
    );
  }
}

