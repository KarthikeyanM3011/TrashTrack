import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TrashTrack/stuffs.dart';
import 'package:TrashTrack/login_screen.dart';

class Homepage_screen extends StatefulWidget {
  const Homepage_screen({super.key});

  @override
  State<Homepage_screen> createState() => _Homepage_screenState();
}

class _Homepage_screenState extends State<Homepage_screen> {

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
    return Center(
        child: Column(
          children: [
            Text('Will be ready soon'),
            BottomAppBar(
              
            ),

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
    );
  }
}