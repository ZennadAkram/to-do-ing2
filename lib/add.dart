import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        title: const Text("Just Do It",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
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

                  title: Text(task.title,style: const TextStyle(fontWeight: FontWeight.bold),),
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
                  trailing: PopupMenuButton<int>(
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
  Future<List<Task>> gettasks() async {
    List<Task> tasks1=[];
    //tasks.clear();
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
        tasks1.add(task);
        setState(() {

        });
        return task;
      }));
    }

    setState(() {

    });
    return tasks1;


  }


  @override
  void initState(){
    show=false;
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

