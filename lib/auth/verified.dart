import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class verified extends StatefulWidget {
  const verified({super.key});

  @override
  State<verified> createState() => _verifiedState();
}

class _verifiedState extends State<verified> {
  @override
  void initState() {
    super.initState();
    sendEmailVerification(); // Call the method to send email verification
  }
  Future<void> sendEmailVerification() async {
    // Send email verification
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }
  @override
  Widget  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Just Do It",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.black),),
        centerTitle: true,
        backgroundColor:  Colors.grey[200],

        actions: [
          IconButton(onPressed: () async {  await FirebaseAuth.instance.currentUser!.delete();
            ;await FirebaseAuth.instance.signOut();GoogleSignIn go=GoogleSignIn(); go.disconnect(); Navigator.of(context).pushReplacementNamed('login'); }, icon:const Icon(Icons.logout))


    ],
      ),
      body:Column(
          children: [
            Text('A verification link has been Sent to your Email '),

          Center(



  child:   ElevatedButton(
          onPressed: () async {
            // Send email verification


            await FirebaseAuth.instance.currentUser!.reload();


            if (FirebaseAuth.instance.currentUser!.emailVerified) {

              Navigator.of(context).pushReplacementNamed('home');
            } else {

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Email Not Verified'),
                    content: Text('Please verify your email before proceeding.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text('Verifie Email'),
        ),


      ),
    ]
      )
    );
  }
}
