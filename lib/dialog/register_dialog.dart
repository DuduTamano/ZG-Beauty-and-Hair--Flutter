import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:zg_beauty_and_hair/model/user_model.dart';
import 'package:zg_beauty_and_hair/navigation_screen/navigation_bar.dart';
import 'package:zg_beauty_and_hair/screens/home_screen.dart';

void ShowRegisterDialog(BuildContext context, CollectionReference userRef, GlobalKey<ScaffoldState> scaffoldState) {
  //If user info doesn't available, show dialog
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var phoneNumberController = TextEditingController();

  Timestamp now = Timestamp.now();
  DateTime dateTime = now.toDate();

  var dateNow = DateFormat('MM/dd/yyyy hh:mm a').format(dateTime);

  Alert(
      context: context,
      title: 'עדכון פרופיל',
      content: Column(
        children: [
          SizedBox(height: 20.0),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              prefixIcon: Icon(Icons.account_circle, color: Colors.black),
              labelText: 'שם מלא',
              labelStyle: TextStyle(color: Colors.black),
            ),controller: nameController,
          ),
          SizedBox(height: 10.0),
          TextField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)
              ),
              prefixIcon: Icon(Icons.home, color: Colors.black),
              labelText: 'כתובת',
              labelStyle: TextStyle(color: Colors.black),
            ),controller: addressController,),
          SizedBox(height: 10.0),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone, color: Colors.black,),
              labelText: '${FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+972", "0")}',
              labelStyle: TextStyle(color: Colors.black),
              enabled: false,
            ),controller: phoneNumberController,
            style: TextStyle(color: Colors.black),),
          SizedBox(height: 10.0),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text('ביטול', style: TextStyle(color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context), color: Colors.black12,
        ),
        DialogButton(
          child: Text('עדכן', style: TextStyle(color: Colors.white)
          ),
          onPressed: () {
            //Update to server
            userRef.doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                .set({
              'name' : nameController.text,
              'address' : addressController.text,
              'phoneNumber' : '${FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+972", "0")}',
              'created' : '$dateNow',
            }).then((value) async {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('UPDATE PROFILES SUCCESSFULLY!')));

              await Future.delayed(Duration(seconds: 1), (){
                FirebaseAuth.instance.currentUser!.getIdToken().then((token) async {
                  CollectionReference userRef = FirebaseFirestore
                      .instance.collection('Users');
                  DocumentSnapshot snapshotUser = await userRef.doc(
                      FirebaseAuth.instance.currentUser!.phoneNumber)
                      .get();

                  final data = snapshotUser.data() as Map<String, dynamic>;
                  var userModel = UserModel.fromJson(data);

                  if(userModel.isStaff == true){
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HomePage(),),);
                  } else
                  {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => BottomNavigation(),),);
                  }
                });
              });
            }).catchError((e){
              Navigator.of(context).pop();
              ScaffoldMessenger.of(scaffoldState.currentContext!)
                  .showSnackBar(SnackBar(content: Text('$e')));
            });
          }, color: Colors.black,),
      ]
  ).show();
}