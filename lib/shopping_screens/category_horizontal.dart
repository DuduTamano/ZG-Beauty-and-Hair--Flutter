import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/shopping_ref.dart';
import 'package:zg_beauty_and_hair/model/category_model.dart';
import 'package:zg_beauty_and_hair/model/shopping_items.dart';
import 'package:zg_beauty_and_hair/shopping_screens/shopping_details.dart';
import 'package:zg_beauty_and_hair/shopping_screens/shopping_screen.dart';
import 'package:zg_beauty_and_hair/state/category_state.dart';
import 'package:zg_beauty_and_hair/state/shopping_items_state.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/widgets/common/common_widgets.dart';

class CategoryHorizontal extends StatefulWidget {
  const CategoryHorizontal({Key? key, required this.id}) : super(key: key);

  final String? id;

  @override
  _CategoryHorizontalState createState() => _CategoryHorizontalState();
}

class _CategoryHorizontalState extends State<CategoryHorizontal> {


  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: getShoppingItems(widget.id),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator(),);
            else {
              var shopping = snapshot.data as List<ShoppingModel>;
              if(shopping.length == 0)
                return Center(
                  child: Text('no data'),
                );
              else
                return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: shopping.length,
                    padding: EdgeInsets.all(2.0),
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                    itemBuilder: (BuildContext context, int index){
                      return Transform.translate(
                        offset: Offset(0, index.isOdd ? 0 : 25),
                        child: InkWell(
                          child: GestureDetector(
                            onTap: (){
                              var shoppingPrice = shopping[index].price;
                              var shoppingDec = shopping[index].dec;
                              var shoppingImage = shopping[index].image;
                              var shoppingName = shopping[index].name;

                              Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingDetailsScreen(shoppingPrice: shoppingPrice,
                                  shoppingDec: shoppingDec, shoppingImage: shoppingImage, shoppingName: shoppingName)));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Card(
                                semanticContainer: true,
                                elevation: 8,
                                shadowColor: Colors.black,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.network(shopping[index].image,
                                        fit: BoxFit.contain,
                                        width: 140,),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Center(
                                        child: Text(
                                          '${shopping[index].name}',
                                          style: TextStyle(
                                            fontFamily: 'rubik',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Center(
                                        child: Text(
                                          '\₪ ${shopping[index].price}',
                                          style: TextStyle(
                                            fontFamily: 'rubik_bold',
                                            color: Colors.black,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(1, index.isEven ? 1.8 : 1.8),
                );
            }
          },
        ),
      ),
    );
  }
}

