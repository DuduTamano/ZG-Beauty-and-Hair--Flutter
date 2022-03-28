import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zg_beauty_and_hair/model/user_model.dart';
import 'package:zg_beauty_and_hair/navigation_screen/navigation_bar.dart';
import 'package:zg_beauty_and_hair/root/root.dart';
import 'package:zg_beauty_and_hair/screens/home_screen.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/utils/utils.dart';
import 'package:zg_beauty_and_hair/view_model/main/main_view_model.dart';


class MainViewModelImp implements MainViewModel {
  @override
  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState) async {
    if(!context.read(forceReload).state) {
      await Future.delayed(Duration(seconds: fromLogin == true ? 0:1)).then((value) => {
        FirebaseAuth.instance.currentUser!.getIdToken().then((token) async {

              //Force reload state
          context.read(forceReload).state = true;

          //If get token
          print('$token');
          context.read(userToken).state = token;

          //Check user in Firestore
          CollectionReference userRef = FirebaseFirestore.instance.collection('Users');
          DocumentSnapshot snapshotUser = await userRef
              .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
              .get();

          //Force reload state
          context.read(forceReload).state = true;
          if(snapshotUser.exists)
          {

            final data = snapshotUser.data() as Map<String, dynamic>;
            var userModel = UserModel.fromJson(data);

            Navigator.push(
              context, MaterialPageRoute(builder: (context) => RootApp(),),);

          /*  if(userModel.isStaff == true){
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage(),),);
            } else
              {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BottomNavigation(),),);
              } */
          }
        })
      });
    }
    return FirebaseAuth.instance.currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;
  }

}