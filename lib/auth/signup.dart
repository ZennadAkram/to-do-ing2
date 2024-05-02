import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
  TextEditingController passconf=TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(

        children: [
          Container(height: 60,),
           Center(
            child: ClipOval(

          child:  Image.asset('assets/images/logo.jpg', height: 100, width: 100,),


            ),

          ),


              Container(
               padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Container(height: 70,),
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
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
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
                  controller: passconf,
                  obscureText: _obscureText1,
                  decoration: InputDecoration(
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText1 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                      ),
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
               if(passconf.text==password.text) {
                 try {
                   final credential = await FirebaseAuth.instance
                       .createUserWithEmailAndPassword(
                     email: email.text,
                     password: password.text,
                   );
                   Navigator.of(context).pushReplacementNamed('verif');
                 } on FirebaseAuthException catch (e) {
                   if (e.code == 'weak-password') {
                     _showErrorDialog('Error', 'weak-password: ${e.message}');
                     print('The password provided is too weak.');
                   } else if (e.code == 'email-already-in-use') {
                     _showErrorDialog(
                         'Error', 'email-already-in-use: ${e.message}');
                     print('The account already exists for that email.');
                   }
                 } catch (e) {
                   print(e);
                 }
               }else{
                 _showErrorDialog('Error', 'The Confirmed password is not correct');
               }
                  
                },
              child: const Text('Sign Up',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold


              ),))
          ),
          Container(height: 40,),
          Center(
        child:   Text.rich(TextSpan(
            children: [
              const TextSpan(

                  text: "Already  Have an Account? ",
                  style: TextStyle(
                      fontSize: 15
                  )

              ),
              TextSpan(
                text: 'Login',
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold

                ),
                recognizer: TapGestureRecognizer()..onTap=(){
                  Navigator.of(context).pushReplacementNamed('login');
                },

              ),
            ],
          ),

          ),
          )

    ],
      ),


    );
  }
}
