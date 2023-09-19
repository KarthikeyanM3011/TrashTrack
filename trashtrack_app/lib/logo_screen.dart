import 'package:TrashTrack/details_screen.dart';
import 'package:TrashTrack/home_screen.dart';
import 'package:TrashTrack/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Logo_Screen extends StatefulWidget {
  const Logo_Screen({super.key});

  @override
  State<Logo_Screen> createState() => _Logo_ScreenState();
}

class _Logo_ScreenState extends State<Logo_Screen> {

  Future<void> navigatepage()async{
  User? user=FirebaseAuth.instance.currentUser;
  await Future.delayed(Duration(seconds: 7));
  if(user==null){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Log_In()));
  }
  else if(user!=null){
    String usermail= user.email??'karthikeyan';
    print(usermail);
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("UserDetails").doc(usermail).get();
    print(documentSnapshot.data());
    if(documentSnapshot.exists){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
    }
    else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DetailsPage()));
    }
  }
  
}

@override
  void initState() {
    super.initState();
    navigatepage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: Container(
              height: 200,
              width: 200,
              child: Image.asset('assets/logo.png')
              ),
          ),
        ),
      ),
    );
  }
}

