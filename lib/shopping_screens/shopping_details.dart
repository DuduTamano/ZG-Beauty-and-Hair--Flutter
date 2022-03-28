import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:zg_beauty_and_hair/shopping_screens/product_details/bottom_price.dart';
import 'package:zg_beauty_and_hair/shopping_screens/product_details/image_product.dart';
import 'package:zg_beauty_and_hair/shopping_screens/product_details/product_description.dart';
import 'package:zg_beauty_and_hair/shopping_screens/product_details/text_hair_color.dart';
import 'package:zg_beauty_and_hair/shopping_screens/product_details/text_product.dart';
import 'package:zg_beauty_and_hair/shopping_screens/shopping_screen.dart';
import 'package:zg_beauty_and_hair/state/category_state.dart';


class ShoppingDetailsScreen extends StatefulWidget {
  const ShoppingDetailsScreen({Key? key, required this.shoppingPrice, required this.shoppingDec,
    required this.shoppingImage, required this.shoppingName}) : super(key: key);

  final int shoppingPrice;
  final String shoppingDec;
  final String shoppingImage;
  final String shoppingName;


  @override
  _ShoppingDetailsScreenState createState() => _ShoppingDetailsScreenState();
}
class _ShoppingDetailsScreenState extends State<ShoppingDetailsScreen> {
  final CategoryStateController categoryStateController = Get.find();

  bool isHair = false;

  int currentPriceIndex = 0;
  int currentColorIndex = 0;
  int currentSizeIndex = 0;

  final sizeNumList = ["14", "16", "18", "20", "22", "24", "26"];
  final priceList = ["200", "400", "600", "800", "1000", "1200", "1400"];


  @override
  Widget build(BuildContext context) {
    List<String> hair = [ "גלי סגור", "גלי פתוח", "קלוז'ר", "פרונטל 360", "ברזילאי חלק"];

    String shoppingHair = '${widget.shoppingName}';

    bool existed = false;
    hair.forEach((item) {
      if(item.contains(shoppingHair)){
        existed = true;
      }
    });

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 150),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${categoryStateController.selectedCategory.value.name}',
                    style: TextStyle(
                        fontFamily: 'rubik',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        fontSize: 18, letterSpacing: 2),),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(IconlyBroken.arrowLeft2, color: Colors.black),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ShoppingScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              //product name
              TextProduct(shoppingName: widget.shoppingName),

              //product image
              ImageProduct(shoppingImage: widget.shoppingImage),

              //text hair color
              existed ? TextHairColor() : Container(),

              //hair size
              existed ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 5,
                              left: 15.0,
                              right: 20.0,
                              bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              Text("בחרי אורך שיער",
                                style: TextStyle(
                                    fontFamily: 'rubik',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                    fontSize: 25),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(
                        left: 20.0,
                        right: 10.0),
                      child: Stack(
                        children: [
                          Wrap(
                            children: List.generate(sizeNumList.length, (index) {
                              var index2 = int.parse(priceList[index]);
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    currentSizeIndex = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                        color: currentSizeIndex == index ? Colors.grey.shade700 : Colors.white,
                                        border: Border.all(
                                          width: 2.0,
                                          color: Colors.grey.shade400,
                                        ),
                                        borderRadius: BorderRadius.circular(50.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                              currentSizeIndex == index ? Colors.black.withOpacity(.5) : Colors.black12,
                                              offset: Offset(0.0, 5.0),
                                              blurRadius: 5.0)
                                        ]),
                                    child: Center(
                                      child: Text(sizeNumList[index],
                                          style:
                                          TextStyle(color: currentSizeIndex == index ? Colors.white : Colors.black, fontFamily: 'rubik',)),
                                    ),
                                  ),
                                ),
                              );
                            }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ) : Container(),

              //product description
              ProductDescription(shoppingDec: widget.shoppingDec),
              // SizedBox(height: 8,),
            ],
          ),
        ),

        //product price
        bottomNavigationBar: BottomPrice(shoppingName: widget.shoppingName, shoppingPrice: widget.shoppingPrice,
          hairPrice: priceList[currentSizeIndex], sizeNumList: sizeNumList, currentSizeIndex: currentSizeIndex),
      ),
    );
  }
}