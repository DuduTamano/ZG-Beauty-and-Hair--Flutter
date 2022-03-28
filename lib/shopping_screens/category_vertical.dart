import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/shopping_ref.dart';
import 'package:zg_beauty_and_hair/model/category_model.dart';
import 'package:zg_beauty_and_hair/model/shopping_items.dart';
import 'package:zg_beauty_and_hair/shopping_screens/shopping_details.dart';
import 'package:zg_beauty_and_hair/state/category_state.dart';

class CategoryVertical extends StatefulWidget {
  const CategoryVertical({Key? key, required this.id}) : super(key: key);

  final String? id;
  @override
  _CategoryVerticalState createState() => _CategoryVerticalState();
}

class _CategoryVerticalState extends State<CategoryVertical> {

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                    childAspectRatio: 2.3,
                  ),
                  itemCount: shopping.length,
                  padding: EdgeInsets.all(2.0),
                  itemBuilder: (BuildContext context, int index){
                    return Transform.translate(
                      offset: Offset(0, index.isOdd ? 0 : 0),
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
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Column(
                              children: [
                                Card(
                                  semanticContainer: true,
                                  elevation: 8,
                                  shadowColor: Colors.black,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: AspectRatio(
                                          aspectRatio: 0.80,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Image.network(shopping[index].image,
                                                fit: BoxFit.contain,
                                                width: 150),
                                          ),
                                        ),
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 50),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(top: 10),
                                                child: Center(
                                                  child: Container(
                                                    width: 130,
                                                    child: Text(
                                                      '${shopping[index].name}',
                                                      style: TextStyle(
                                                        fontFamily: 'rubik',
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey[600],
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: Container(
                                                  padding: EdgeInsets.only(bottom: 15, left: 50),
                                                  child: Center(
                                                    child: Text(
                                                      '${shopping[index].price} \₪',
                                                      style: TextStyle(
                                                        fontFamily: 'rubik_bold',
                                                        color: Colors.black,
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}