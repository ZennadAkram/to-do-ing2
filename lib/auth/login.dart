import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';


class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool _obscureText = true;
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
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:ListView(
        children: [
        Column(
           crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(height: 50,),
           Center(

         child:ClipOval(

            child: Image.asset('assets/images/logo.jpg', height: 100, width: 100,),
        ),
          ),

            Container(
              alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            child:const Text('Login',style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),),
            ),
             Container(height: 20,),
             const Text("    Email",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child:   TextFormField(
             controller: email,
              decoration: InputDecoration(
                hintText: 'Enter Your Email ',
                hintStyle: const TextStyle(color: Colors.grey ),
                filled: true,
                fillColor: Colors.grey[200],
               border:OutlineInputBorder( borderRadius: BorderRadius.circular(50.0),),


              ),

            ),
            ),
            const Text("    Password",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child:   TextFormField(
                obscureText: _obscureText,

               controller: password,
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

                  hintText: 'Enter Your Password',

                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50)
                  ),


                ),
              ),
            ),

            Container(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () async {
                  await  FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Reset Email Sent to ${email.text}'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },

                  child: Text('Forget Password?   ',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w400),),
                )
              ],
            ),
],
        ),
           Container(height: 20,),
           Container(
             margin:const EdgeInsets.fromLTRB(20, 0, 20, 0),

          child:  MaterialButton(
            height: 60,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
             color: Colors.blue,
             child: const Text('Login',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
               onPressed:() async {

                 try {
                   final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                     email: email.text,
                     password: password.text,
                   );
                   if(FirebaseAuth.instance.currentUser!.emailVerified) {
                     Navigator.of(context).pushReplacementNamed('home');
                   }else
                     {
                       Navigator.of(context).pushReplacementNamed('verif');
                     }
                 } on FirebaseAuthException catch (e) {

                   if (e.code == 'auth/user-not-found') {
                     _showErrorDialog('Error', 'Wrong Email or Password..');
                   } else if (e.code == 'invalid-credential') {

                     _showErrorDialog('Error', 'Wrong Email or Password.');
                   } else {

                     _showErrorDialog('Error', 'An error occurred: ${e.message}');
                   }
                 }
               }


           ),
           ),
          Container(height: 30,),


             Container(
               margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
             child:
             MaterialButton(

              height: 60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.red,
              child:const Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [ Text('Login With Google ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),


              ],
             ),
                onPressed:() async {

                await signInWithGoogle();

                },



             ),
             ),
                 Container(height: 30,),
            Center(
             child:  Text.rich(TextSpan(
            children: [
              const TextSpan(

                text: "Don't Have an Account?  ",
                style: TextStyle(
                  fontSize: 15
                )

              ),
              TextSpan(
                text: 'Sign Up',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold

                ),
                recognizer: TapGestureRecognizer()..onTap=(){
               Navigator.pushNamed(context, 'signup');
              },

              ),
            ],
          ),

          ),
            ),
    ],

        ),
    );

  }
  Future<UserCredential> signInWithGoogle() async {

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    Navigator.of(context).pushReplacementNamed('home');

    return await FirebaseAuth.instance.signInWithCredential(credential);

  }
}
