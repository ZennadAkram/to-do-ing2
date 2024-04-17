import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import'package:flutter/material.dart';
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
  List<Task> tasks=[];
  bool show=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Important Tasks",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue[900],

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
      body:show ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ClipOval(
            child: Image(
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              image: NetworkImage('https://th.bing.com/th/id/OIG2.0Qpx4xQBAa7U.o_e14LY?w=1024&h=1024&rs=1&pid=ImgDetMain'),
            ),
          ),
          const SizedBox(height: 20), // Spacer between image and text
          Text(
            'No Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.blue[800]),

          ),
        ],
      ),
      )
      :Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Important Tasks', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

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
activeColor: Colors.blue[900],
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

                 }


                )


              ),
            );

      }

    ),
          ),
    ],
      ),
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
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
          title: Text('Add Important Tasks'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             TextField(
               controller: t3,
               decoration: const InputDecoration(
                 hintText: "Enter Task"
               ),
             ) ,
               TextField(
                controller: t4,
                decoration: const InputDecoration(
                  hintText: 'Enter Description'
                ),
              ),
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
              },
                  child: const Text('Add')
              )
            ],
          ),
        );
        }


    );
  }
  CollectionReference taskli = FirebaseFirestore.instance.collection('important');

  Future<void> addUser(Task task) async {

    try {
      await taskli.add({
        'Task': task.title,
        'Description': task.description,
        'completed': task.isCompleted,
      });
    } catch (e) {
      print("Failed to add task: $e");
    }

  }
  void gettasks() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('important').get();

    tasks.addAll(querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Task task = Task();
      task.id=doc.id;
      task.title = data['Task'] ?? '';
      task.description = data['Description'] ?? '';
      task.isCompleted = data['completed'] ?? false;
      return task;
    }));

    setState(() {

    });
  }


  @override
  void initState(){

    show=false;

    gettasks();


    super.initState();


  }
  Future<void> deleteUser(Task task) async {
    try {
      await taskli.doc(task.id).delete();
      print("Task Deleted");
    } catch (error) {
      print("Failed to delete task: $error");
    }
  }
  Future<void> updateUser(Task task) {
    return taskli
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
