import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
class Task {
 late String title;
 late String description;
 late bool isCompleted;
 late String id;


}
class important extends StatefulWidget {
  const important({super.key});

  @override
  State<important> createState() => _importantState();
}

class _importantState extends State<important> {
   late String userEmail='' ;



  List<Task> tasks=[];
  bool show=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Just Do It",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(

              decoration: BoxDecoration(
                color:  Color(0xFF0FE14F),

              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipOval(

                          child:FirebaseAuth.instance.currentUser?.photoURL != null ? Image.network(
                            FirebaseAuth.instance.currentUser?.photoURL   ?? '', // Use the result of getProfileImage(), or an empty string if null
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              :Image.asset('assets/images/logo.jpg', width: 50,
                            height: 50,)
                      ),
                      TextButton(onPressed: () async {
                        await FirebaseAuth.instance.signOut();GoogleSignIn go=GoogleSignIn(); go.disconnect(); Navigator.of(context).pushReplacementNamed('login');
                      }

                          , child:Row(

                            children: [
                              Text('Logout ',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),

                              Icon(Icons.logout,color: Colors.red,)
                            ],
                          )
                      )
                    ],

                  ),


                  // Display the user's image
                  SizedBox(height: 10),
                  Text(
                    'Just Do It',
                    style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),

                ],
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.work_history,
              ),
              title: const Text('Activities',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.pop(context);

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
      body:show ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

           ClipOval(
             child: Image.asset('assets/images/OIG2.jpg'),

           ),


          const SizedBox(height: 20), // Spacer between image and text
          Text(
            'No Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:  Color(0xFF0FE14F),),

          ),
        ],
      ),
      )
      :Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Tasks', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

    ),
          Expanded(
         child:  ListView.builder(

          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        itemCount: tasks.length,
          itemBuilder: (context, index) {
            Task task=tasks[index];
            return Container(


              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(

                title: Text(task.title),
                subtitle: Text(task.description),
                leading: Checkbox( value: task.isCompleted, onChanged: (bool? value) {
                  setState(() {
                    task.isCompleted=value!;
                    updateUser(task);
                  });


                },

                  activeColor: Color(0xFF0FE14F),
                  side:const BorderSide(width: 2,color:  Color(0xFF0FE14F)),
                ),

                trailing: PopupMenuButton<int>(
                  itemBuilder: (context)=>[
                    const PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          leading: Icon(
                            Icons.edit
                          ),
                          title: Text('Edit'),
                        )

                    ),
                    const PopupMenuItem(
                        value: 2,
                        child: ListTile(
                          leading: Icon(
                              Icons.delete
                          ),
                          title: Text('Delete'),
                        )

                    )
                  ],
                  onSelected: (value){
                   switch(value){
                     case 1:
                     showDialog(context: context,
                         builder: (BuildContext context ){
                           TextEditingController t1=TextEditingController();
                           TextEditingController t2=TextEditingController();
                       return AlertDialog.adaptive(
                         title: Text('Edit'),
                         content: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             TextField(
                               controller: t1,

                               decoration: const InputDecoration(
                                 hintText: 'Enter the Task',
                               ),
                             ),
                             TextField(
                               controller: t2,

                               decoration: const InputDecoration(
                                 hintText: 'Enter the Description',
                               ),
                             ),

                           ],
                         ),
                         actions: [
                           TextButton(onPressed: (){
                             setState(() {
                               if(t1.text.isNotEmpty) {
                                 task.title = t1.text;
                               }
                               if(t2.text.isNotEmpty) {
                                 task.description = t2.text;
                               }
                               updateUser(task);
                             });
                             Navigator.pop(context);
                           },

                               child:const Text('Edit')
                           )
                         ],
                       );

                     }
                     );
                     break;
                     case 2:
                     setState(() {
                       tasks.remove(task);
                       deleteUser(task);
                       if(tasks.isEmpty){
                         show=true;
                       }
                     });

                     break;
                     default:
                     break;
                   }

                 }


                )


              ),
            );

      }

    ),
          ),
    ],
      ),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0FE14F),

        onPressed: (){
          add();
        },
        child: const Icon(
          Icons.add,
          color:Colors.white ,
          size: 40,
        ),
      ),
    );
  }
  void add(){
    showDialog(context: context,
        builder: (BuildContext context){
      TextEditingController t3=TextEditingController();
      TextEditingController t4=TextEditingController();
        return AlertDialog(
          title: const Text('Add Tasks'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             TextField(
               controller: t3,
               decoration: const InputDecoration(
                 hintText: "Enter Task"
               ),
             ) ,
               Container(height: 10,),
               TextField(
                controller: t4,
                decoration: const InputDecoration(
                  hintText: 'Enter Description'
                ),
              ),

            ],

          ),
          actions: [
            TextButton(onPressed: (){
              Task task =Task();
              setState(() {
                task.title=t3.text;
                task.description=t4.text;
                task.isCompleted=false;
                tasks.add(task);
                show=false;
              });
              Navigator.pop(context);
              addUser(task);
              tasks.clear();
              gettasks();
            },
                child: const Text('Add')
            )
          ],
        );
        }


    );
  }
   CollectionReference tasklist = FirebaseFirestore.instance.collection('important');
   String? getProfileImage() {

     String? photoUrl = FirebaseAuth.instance.currentUser?.photoURL;

     // Return the photo URL if it's not null, or return a valid placeholder image URL
     return photoUrl ?? 'images/logo.jpg';
   }
   Future<void> addUser(Task task) async {

     try {
       String userUid = getCurrentUserUid();
       if (userUid.isNotEmpty) {
         Map<String, dynamic> taskData = {
           'Task': task.title,
           'Description': task.description,
           'completed': task.isCompleted,
         };

         // Check if task.date is not null and add 'time' field accordingly


         await tasklist.doc(userUid).collection('user_tasks1').add(taskData);
       }

     } catch (e) {
       print("Failed to add task: $e");
     }

   }
   Future<List<Task>> gettasks() async {
     List<Task> tasks1=[];
     //tasks.clear();
     String userUid = getCurrentUserUid();
     String? g=FirebaseAuth.instance.currentUser?.email;
     if(userUid.isNotEmpty) {
       QuerySnapshot querySnapshot = await tasklist.doc(userUid).collection('user_tasks1').get();

       tasks.addAll(querySnapshot.docs.map((doc) {
         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
         Task task = Task();

         task.id = doc.id;
         task.title = data['Task'] ?? '';
         task.description = data['Description'] ?? '';
         task.isCompleted = data['completed'] ?? false;



         tasks1.add(task);
         setState(() {

         });
         return task;
       }));
     }


     return tasks1;


   }

   String getCurrentUserUid() {
     User? user = FirebaseAuth.instance.currentUser;

     print(userEmail);
     return user != null ? user.uid : '';
   }
  @override
  void initState(){

    super.initState();
    fetchTasks();

  }
   void fetchTasks() async {
     User? user = FirebaseAuth.instance.currentUser;
     if (user != null) {
       List<Task> fetchedTasks = await gettasks(); // Assume getTasks() fetches tasks from Firestore
       setState(() {
         tasks = fetchedTasks;
         show = tasks.isEmpty; // Update show based on fetched tasks
       });
     }
   }
   Future<void> deleteUser(Task task) async {
     try {
       String userUid = getCurrentUserUid();
       await tasklist.doc(userUid).collection('user_tasks1').doc(task.id).delete();

       print("Task Deleted");
     } catch (error) {
       print("Failed to delete task: $error");
     }
   }
   Future<void> updateUser(Task task) {

     return tasklist
         .doc(getCurrentUserUid())
         .collection('user_tasks1')
         .doc(task.id)
         .update({'Task':task.title,
       'Description': task.description,
       'completed':task.isCompleted
     }
     )

         .then((value) => print("User Updated"))
         .catchError((error) => print("Failed to update user: $error"));
   }

}
