import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  void _showErrorDialog(String title, String description) {
    print('Showing error dialog: $title - $description'); // Add this line for debugging
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title,
      desc: description,
    ).show();
  }
  TextEditingController username=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(

        children: [
          Container(height: 60,),
          const Center(
            child: ClipOval(
              child:Image(
          image: NetworkImage('https://th.bing.com/th/id/OIG2.0Qpx4xQBAa7U.o_e14LY?w=1024&h=1024&rs=1&pid=ImgDetMain'),
              height: 100,
              width: 100,
              ),
            ),

          ),
          Container(height: 20,),

              Container(
               padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [  const Text('Username',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
               Container(height: 20,),
               TextFormField(
               controller: username,
                 decoration: InputDecoration(
                   filled: true,
                   fillColor: Colors.grey[200],
                   hintText: 'Enter Your Name',
                   hintStyle: const TextStyle(
                     fontWeight: FontWeight.w400,
                      fontSize: 20
                   ),
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(50),
                   )
                 ),
               ),
                Container(height: 20,),
                const Text('Email',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),

                TextFormField(
                 controller: email,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],

                      hintText: 'Enter Your Email',
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      )
                  ),
                ),Container(height: 20,),
                const Text('Password',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),

                TextFormField(
                controller: password,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Enter Password',
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      )
                  ),
                ),
                Container(height: 20,),
                const Text('Confirm Password',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),

                TextFormField(

                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Enter Confirm Password',
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      )
                  ),
                ),
            ],

          ),
    ),
          Container(height: 50,),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child:MaterialButton(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(50)
           ),
              height: 50,

              color: Colors.blue,
              onPressed: () async {
                try {
                  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  Navigator.of(context).pushReplacementNamed('home');
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    _showErrorDialog('Error', 'weak-password: ${e.message}');
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    _showErrorDialog('Error', 'email-already-in-use: ${e.message}');
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              },

              child: const Text('Registre',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold


              ),))
          ),
      ],
      ),

    );
  }
}
