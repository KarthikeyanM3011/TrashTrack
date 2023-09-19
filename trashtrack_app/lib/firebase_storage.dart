import 'package:TrashTrack/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'stuffs.dart';
import 'globalvariables.dart';
class adduser{
  final TextEditingController fname;
  final TextEditingController lname;
  final TextEditingController flat;
  final String street;
  final String city;
  final int points=0;
  final String email;
  final TextEditingController phone;
  bool added=false;

  adduser(this.fname,this.lname,this.flat,this.street,this.city,this.email,this.phone);


bool adduser1(BuildContext context){
  try{
    FirebaseFirestore.instance.collection("UserDetails").doc(email).set({
      "user_id":email.split('@'),
      "name": fname.text+' '+lname.text,
      "email": email,
      "flat": flat.text,
      "street":street,
      "city":city,
      "points":points,
      "phone":phone.text,
    });
    isdetailsfilled=true;
    showsnackbar(context, 'Your UserId is ${email.split('@')[0]}', 3);
    return true;
  }
  catch(e){
    return false;
  }
}
}