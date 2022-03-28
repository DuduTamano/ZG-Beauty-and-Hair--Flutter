import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/shopping_ref.dart';
import 'package:zg_beauty_and_hair/model/category_model.dart';
import 'package:zg_beauty_and_hair/screens/home_screen.dart';
import 'package:zg_beauty_and_hair/shopping_screens/category_horizontal.dart';
import 'package:zg_beauty_and_hair/shopping_screens/category_vertical.dart';
import 'package:zg_beauty_and_hair/state/category_state.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key,
  }) : super(key: key);

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  int currentIndex = 0;
  bool isList = false;

  final CategoryStateController categoryStateController = Get.put(CategoryStateController());

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: isList ? Icon(Icons.apps, color: Colors.black,) : Icon(Icons.list, color: Colors.black),
              onPressed: (){
              setState(() {
                isList = !isList;
              });
            },
            ),
          ],
          leading: IconButton(
            icon: Icon(IconlyBroken.arrowLeft2, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          ),
        body: FutureBuilder(
          future: getCategories(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator(),
              );
            else {
              var categories = snapshot.data as List<CategoryModel>;
              if (categories.length == 0)
                return Center(child: Text('רשימת ריקה'),);
              else
                return Column(
                  children: [
                    Text('רשימת המוצרים שלנו',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontFamily: 'rubik_bold',
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    isList ? Container(
                      clipBehavior: Clip.none,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: SingleChildScrollView(
                                    child: Row(
                                      children: List.generate(
                                        categories.length, (index) =>
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                currentIndex = index;
                                                categoryStateController.selectedCategory.value = categories[index];

                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${categories[index].name}',
                                                    style: TextStyle(
                                                        fontFamily: 'rubik_bold',
                                                        fontSize: 15,
                                                        color: currentIndex == index ? Colors.black : Colors.black26
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 20 /4),
                                                    height: 3,
                                                    width: 30,
                                                    color: currentIndex == index ? Colors.black : Colors.transparent,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              height: MediaQuery.of(context).size.height/1.35,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: CategoryVertical(id: categories[currentIndex].docId),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Directionality(
                        textDirection: TextDirection.rtl,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              categories.length, (index) => Padding(
                              padding: const EdgeInsets.only(right: 10.0, left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentIndex = index;
                                    categoryStateController.selectedCategory.value = categories[index];
                                  });
                                },
                                child: Material(
                                  elevation: currentIndex == index ? 16.0 : 0.0,
                                  color: Colors.transparent,
                                  shadowColor: Colors.grey.withOpacity(0.6),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 50),
                                    padding: EdgeInsets.symmetric(
                                      vertical: currentIndex == index ? 18.0 : 0.0,
                                      horizontal: currentIndex == index ? 25 : 00,
                                    ),
                                    decoration: BoxDecoration(
                                      color: currentIndex == index ? Colors.black87 : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('${categories[index].name}',
                                      style: TextStyle(
                                          fontFamily: 'rubik_bold',
                                          fontSize: 15,
                                          color: currentIndex == index ? Colors.white : Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ),
                          ),
                        )
                    ),

                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Expanded(
                        child: isList ? Container(): CategoryHorizontal(id: categories[currentIndex].docId),
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}