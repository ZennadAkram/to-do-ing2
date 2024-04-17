import 'package:flutter/material.dart';
class remove extends StatefulWidget {
  const remove({super.key});

  @override
  State<remove> createState() => _removeState();
}

class _removeState extends State<remove> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finished Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ClipOval(
            child: Image(
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              image: NetworkImage('https://th.bing.com/th/id/OIG3.rhycNLWbqJ_BqQ0wm7ea?pid=ImgGn'),
            ),
          ),
          const SizedBox(height: 20), // Spacer between image and text
          Text(
            'No Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.blue[800]),

          ),
        ],
      ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child:
              Text(
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
