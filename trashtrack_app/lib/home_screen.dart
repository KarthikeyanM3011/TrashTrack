import 'package:TrashTrack/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'stuffs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> signout()async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Log_In()));
    }
    catch(e){
      showsnackbar(context, 'Unknown Error Occurred', 3);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Will be ready soon'),

            ElevatedButton(
              onPressed: (){
                signout();
              },
              child: Text(
                'SignOut',
                style: TextStyle(fontSize: 15),
                ),)
          ],
        ),
        
      ),
    );
  }
}