import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/user_ref.dart';
import 'package:zg_beauty_and_hair/main.dart';
import 'package:zg_beauty_and_hair/model/user_model.dart';
import 'package:zg_beauty_and_hair/screens/home_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
 // late SimpleHiddenDrawerController _controller;


  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
   // _controller = SimpleHiddenDrawerController.of(context);
  /*  _controller.addListener(() {
      if (_controller.state == Scaffold.of(context).isDrawerOpen) {
        _animationController.forward();
      }

      if (_controller.state == Scaffold.of(context).hasEndDrawer) {
        _animationController.reverse();
      }
    }); */
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.cyan,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 50, left: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.black,
                          backgroundImage: AssetImage('assets/icons/zg_logo.png'),
                        ),
                        SizedBox(width: 20),
                        FutureBuilder(
                          future: getUserProfiles(context, FirebaseAuth.instance.currentUser!.phoneNumber!),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting)
                              return Center(child: CircularProgressIndicator(),);
                            else {
                              var userModel = snapshot.data as UserModel;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${userModel.name}',
                                    style: TextStyle(fontSize: 20, color: Colors.black),
                                  ),
                                  Text('${userModel.phoneNumber.replaceAll("+972", "0")}',
                                    style: TextStyle(fontSize: 18),),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Setting',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(' | ', style: TextStyle(color: Colors.white)),
                        SizedBox(
                          width: 20,
                        ),
                        Text('logout',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
