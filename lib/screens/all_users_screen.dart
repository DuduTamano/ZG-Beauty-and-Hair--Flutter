import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/user_ref.dart';
import 'package:zg_beauty_and_hair/model/user_model.dart';
import 'package:zg_beauty_and_hair/screens/home_screen.dart';

class AllUsersPage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Icon(IconlyBroken.arrowLeft2, color: Colors.black,),
            ),
          ),

          body: FutureBuilder(
            future: getAllUsers(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator(),
                );
              else {
                // final data = snapshot.requireData;
                var data = snapshot.data as List<UserModel>;
                if(data.length == 0)
                  return Center(
                    child: Text('You have no booking in this date'),
                  );
                else
                return Scaffold(
                  body: Column(
                    children: [
                    Text(
                    '(${data.length})רשימת כל הלקוחות ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontFamily: 'rubik_bold',
                    ),
                    ),
                      SizedBox(height: 10),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Card(
                                elevation: 8,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius:
                                BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),),
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10, right: 10),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 35.0,
                                              backgroundColor: Colors.black,
                                              backgroundImage: AssetImage('assets/icons/zg_logo.png'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10.0,),
                                                  Text('Z&G Beauty and Hair',
                                                    style: TextStyle(fontSize: 18,
                                                      fontFamily: 'elephant',
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,),
                                                  ),
                                                  SizedBox(height: 2.5,),
                                                  Text('שם הלקוחה: ${data[index].name}',
                                                    style: TextStyle(fontSize: 16.0,
                                                      fontFamily: 'rubik',
                                                      color: Colors.black54,),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Text('מספר נייד: ${data[index].phoneNumber}',
                                                    style: TextStyle(fontSize: 16.0,
                                                      fontFamily: 'rubik',
                                                      color: Colors.black54,),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Text('כתובת: ${data[index].address}',
                                                    style: TextStyle(fontSize: 16.0,
                                                      fontFamily: 'rubik',
                                                      color: Colors.black54,),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Text('תאריך הצטרפות: ',
                                                    style: TextStyle(fontSize: 16.0,
                                                      fontFamily: 'rubik',
                                                      color: Colors.black54,),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                );
              }
            },
          ),

        ),
    );
    }
}
