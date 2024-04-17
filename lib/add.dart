import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class add extends StatefulWidget {
 const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  List<Task> tasks=[];
  bool show =true;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Activities",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white),),
       // centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(

              decoration: BoxDecoration(
               color: Colors.blue,

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
                Navigator.of(context).pushReplacementNamed('home');

              },
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
      body:  show ? Center( child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


            const ClipOval(
              child: Image(
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://th.bing.com/th/id/OIG1.bJntFHgjhAjJba1dRPHL?w=1024&h=1024&rs=1&pid=ImgDetMain'),
              ),
            ),

           const SizedBox(height: 20), // Spacer between image and text

             Text(
            'Add tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.blue),

          ),
        ],
      )

      )

          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Pending Tasks', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

        ),

      Expanded(child: ListView.builder(
padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      Task task = tasks[index];

      return Container(

          decoration: BoxDecoration(

           color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(

          title: Text(task.title,style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text(task.description,style: TextStyle(

        color: Colors.grey
      ),),

      leading: Checkbox(
      checkColor: Colors.green,
      value: task.isCompleted,
      onChanged: (value) {
      setState(() {
      task.isCompleted = value!;
      updateUser(task);

      });
      },
      ),
       trailing: PopupMenuButton<int>(
         itemBuilder: (context) => [
           PopupMenuItem(
             value: 1,

             child: ListTile(
               leading: Icon(
                 Icons.mode_edit,
               ),
               title: Text('Edit'),
             ),
           ),
           PopupMenuItem(
             value: 2,
             child: ListTile(
               leading: Icon(
                 Icons.delete,
               ),
               title: Text('Delete'),
             ),
           ),

         ],
         onSelected: (value) {
           switch (value) {
             case 1:
showDialog(context: context,
    builder: (BuildContext context){
  TextEditingController t3=TextEditingController();
  TextEditingController t4=TextEditingController();
  return AlertDialog(
    title: Text('Editing'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: t3,
            decoration: InputDecoration(
              hintText: 'Task',
            ),
          ),
          TextField(
            controller: t4,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
          ),
          TextButton(onPressed:(){
            setState(() {
              task.title=t3.text;
              task.description=t4.text;
              updateUser(task);
            });
            Navigator.pop(context);
          }, child:Text('Edit',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))
        ],

      ),

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
         },
       ),
      ),

      );
    },
      ),
      ),
    ],
      ),

    backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed:() {

          _addTask();


        },



        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
 void _addTask() {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       TextEditingController titleController = TextEditingController();
       TextEditingController descriptionController = TextEditingController();

       return AlertDialog(
         title: Text('Add Task'),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             TextField(
               controller: titleController,
               decoration: InputDecoration(labelText: 'Title'),
             ),
             TextField(
               controller: descriptionController,
               decoration: InputDecoration(labelText: 'Description'),
             ),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () {
               Task task=Task();
               setState(() {
                  task.title=titleController.text;
                 task.description=descriptionController.text;
                 task.isCompleted=false;

                 tasks.add(task);
                 show=false;


               });
               Navigator.pop(context);
               addUser(task);
             },
             child: Text('Add'),
           ),
         ],
       );
     },
   );
 }
  CollectionReference tasklist = FirebaseFirestore.instance.collection('task');

  Future<void> addUser(Task task) async {

      try {
        String userUid = getCurrentUserUid();
        if(userUid.isNotEmpty) {
          await tasklist.doc(userUid).collection('user_tasks').add({

            'Task': task.title,
            'Description': task.description,
            'completed': task.isCompleted,
          });
        }
      } catch (e) {
        print("Failed to add task: $e");
      }

  }
  void gettasks() async {
    String userUid = getCurrentUserUid();
    if(userUid.isNotEmpty) {
      QuerySnapshot querySnapshot = await tasklist.doc(userUid).collection('user_tasks').get();

      tasks.addAll(querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Task task = Task();
        task.id = doc.id;
        task.title = data['Task'] ?? '';
        task.description = data['Description'] ?? '';
        task.isCompleted = data['completed'] ?? false;
        return task;
      }));
    }
    setState(() {

    });
  }


  @override
void initState(){

  show = false;

    gettasks();

  super.initState();


}
  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : '';
  }
  Future<void> deleteUser(Task task) async {
    try {
      String userUid = getCurrentUserUid();
      await tasklist.doc(userUid).collection('user_tasks').doc(task.id).delete();

      print("Task Deleted");
    } catch (error) {
      print("Failed to delete task: $error");
    }
  }
  Future<void> updateUser(Task task) {
    return tasklist
        .doc(getCurrentUserUid())
        .collection('user_tasks')
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
class Task {
  late String title;
  late String description;
  late bool isCompleted;
  late String id;

}