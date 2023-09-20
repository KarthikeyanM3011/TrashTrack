import 'package:TrashTrack/login_screen.dart';
import 'package:TrashTrack/homepage.dart';
import 'package:TrashTrack/searchpage.dart';
import 'package:TrashTrack/trashpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'stuffs.dart';

class HomePage extends StatefulWidget {
  // const HomePage({super.key});
  final String email;
  HomePage({required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List pages=[Homepage_screen(),SearchPage(),TrashTrach_screen(),TrashTrach_screen()];
  int selectedpage=0;
  Map<String,dynamic>? details;
  
  Future<void> userdetails() async{
    try{
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("UserDetails").doc(widget.email).get();
      if(documentSnapshot.exists){
        details= documentSnapshot.data() as Map<String,dynamic>;
        final username=details?['name']??'';
      }
    }
    catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userdetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(builder: ((context) {
          return IconButton(onPressed: (){Scaffold.of(context).openDrawer();}, icon: Icon(Icons.person));
        }))
      ),
      // drawer: MyDrawer(),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  // You can add a user's profile picture here.
                  // child: Image.asset('assets/profile.png'),
                ),
                SizedBox(height: 10),
                Text(
                  details?['name']??'',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              ],
            ),
              decoration: BoxDecoration(
                color: Colors.blue,
                
              ),
              ),
            ListTile(
              
              leading: Icon(Icons.person),
              title: Text('User Mail'),
              subtitle: Text(details?['email']?? ' '),
              trailing: Icon(Icons.mail),
            ),

          ],
        ),
      ),
      body: pages[selectedpage],
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        currentIndex: selectedpage,
        onTap: (value) {
          setState(() {
            print(value);
            selectedpage = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(right:7.0,left:7),
              child: Icon(Icons.home,color: selectedpage==0? Colors.blue:Colors.white,),
            ),
            label: 'Home',
            backgroundColor: Colors.green,
            ),
            
            BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(right:7.0,left:7),
              child: Icon(Icons.search,color: selectedpage==1? Colors.blue:Colors.white),
            ),
            label: 'Search',
            backgroundColor: Colors.green,
            ),

            BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(right:7.0,left:7),
              child: Icon(Icons.delete,color: selectedpage==2? Colors.blue:Colors.white),
            ),
            label: 'Trash',
            backgroundColor: Colors.green,
            ),

            BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(right:7.0,left:7),
              child: Icon(Icons.schedule,color: selectedpage==3? Colors.blue:Colors.white),
            ),
            label: 'Schedule',
            backgroundColor: Colors.green,
            )
        ]
        ),
    );
  }
}