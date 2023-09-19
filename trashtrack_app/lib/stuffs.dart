import 'package:flutter/material.dart';

Widget txtfld(TextEditingController add,String txt){
  return Container(
    child :Padding(
              padding: const EdgeInsets.only(top:20.0,bottom: 5,left: 20,right: 20),
              child: TextField(
                controller: add,
                decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: txt,
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 73, 72, 72),
                fontWeight: FontWeight.w400,
                fontSize: 12,
                
              ))),
            ),
  );
}

void showsnackbar(BuildContext context,String info,int duration){
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(info),
    duration: Duration(seconds: duration),
  ));
}
