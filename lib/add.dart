import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:just_Do_It/NotificationService.dart';
import 'package:http/http.dart' as http;
import 'package:vm_service/vm_service.dart' as vm;

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {


  late String userEmail = '';

  List<Task> tasks=[];
  int i=1;
  DateFormat minuteFormat = DateFormat('mm');

  bool show =true;
  @override
  Widget build(BuildContext context) {

    return  Scaffold(

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
      body:  show ? const Center( child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          ClipOval(
            child: Image(
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                image: AssetImage('assets/images/OIG2.jpg')
            ),
          ),

          SizedBox(height: 20),// Spacer between image and text

          Text(
            'Add tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:Color(0xFF0FE14F) ),

          ),

        ],
      )

      )

          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Pending Tasks', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800),),

          ),

          Expanded(child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              Task task = tasks[index];

              return Container(

                decoration: BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(

                  title:
              Text(task.title,style: const TextStyle(fontWeight: FontWeight.bold),),




                  subtitle: Text(task.description,style: const TextStyle(

                      color: Colors.grey
                  ),),

                  leading: Checkbox(
                    checkColor: Colors.white,

                    value: task.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        task.isCompleted = value!;
                        updateUser(task);

                      });
                    },
                    activeColor: Color(0xFF0FE14F),

                    side:const BorderSide(width: 2,color:  Color(0xFF0FE14F)),
                  ),
                  trailing:Row(
                    mainAxisSize: MainAxisSize.min,

              children: [

                if (task.date != null)

                  Text(
                  '${task.date!.hour}:${minuteFormat.format(task.date!)} ${task.date!.day}/${task.date!.month}/${task.date!.year}',
                  ),
                PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,

                        child: ListTile(
                          leading: Icon(
                            Icons.mode_edit,
                          ),
                          title: Text('Edit'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: ListTile(
                          leading: Icon(
                            Icons.delete,
                                 color: Colors.red,

                          ),

                          title: Text('Delete',style: TextStyle(color: Colors.red),),
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
                                  title: const Text('Editing'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: t3,
                                        decoration: const InputDecoration(
                                          hintText: 'Task',
                                        ),
                                      ),
                                      TextField(
                                        controller: t4,
                                        decoration: const InputDecoration(
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
                                      }, child:const Text('Edit',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))

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
              ],
                  ),
                ),

              );
            },
          ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
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
        Task task=Task();

        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),

          actions: [

            CupertinoButton(
              onPressed: () {
                _selected(context, task);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.time),
                  SizedBox(width: 8), // Adjust the spacing between icon and text
                  Text("Set Reminder"),
                ],
              ),
            ),
            TextButton(
              onPressed: () {

                setState((){


                  task.title=titleController.text;
                  task.description=descriptionController.text;
                  task.isCompleted=false;


                  tasks.add(task);
                  show=false;


                });

                if (task.date != null) {
                  print(task.date?.year);
                  NotificationService().scheduleNotification(id: i,
                      title: task.title,
                      body: task.description,
                      scheduledNotificationDateTime: task.date!);
                  //NotificationService().startAlarm(task.title, task.description, i, task.date!);
                }
                i++;
                Navigator.pop(context);
                addUser(task);
               tasks.clear();
               gettasks();

              },
              child: const Text('Add'),
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
      if (userUid.isNotEmpty) {
        Map<String, dynamic> taskData = {
          'Task': task.title,
          'Description': task.description,
          'completed': task.isCompleted,
        };

        // Check if task.date is not null and add 'time' field accordingly
        if (task.date != null) {
          taskData['time'] = Timestamp.fromDate(task.date!);

        }

        await tasklist.doc(userUid).collection('user_tasks').add(taskData);
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
           QuerySnapshot querySnapshot = await tasklist.doc(userUid).collection('user_tasks').get();

      tasks.addAll(querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Task task = Task();

        task.id = doc.id;
        task.title = data['Task'] ?? '';
        task.description = data['Description'] ?? '';
        task.isCompleted = data['completed'] ?? false;
        task.date = data['time'] != null ? (data['time'] as Timestamp).toDate() : null;


        tasks1.add(task);
        setState(() {

        });
        return task;
      }));
    }


    return tasks1;


  }
void gett() async{
  String? tok =await FirebaseMessaging.instance.getToken();
  print('--+');
  print(tok);
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

  @override
  void initState(){


    super.initState();
 fetchTasks();







  }


  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;

    print(userEmail);
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



  getemaiadress(){
    return FirebaseAuth.instance.currentUser?.email;
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
  _selected(BuildContext context, Task task) async {
    final DateTime? pick = await showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pick != null) {
      final TimeOfDay? ptime = await showTimePicker(

        context: context,
        initialTime: TimeOfDay.now(),

      );

      if (ptime != null) {
        setState(() {
          task.date = DateTime(

            pick.year,
            pick.month,
            pick.day,
            ptime.hour,
            ptime.minute,
          );
        });
      } else {
        // Handle the case where the user cancels the time picker
        // Optionally, you can provide feedback to the user or take other actions
        // For example:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Time selection cancelled')));
      }
    } else {
      // Handle the case where the user cancels the date picker
      // Optionally, you can provide feedback to the user or take other actions
      // For example:
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Date selection cancelled')));
    }
  }




}
class Task {
  late String title;
  late String description;
  late bool isCompleted;
  late String id;

  DateTime ? date;

}


