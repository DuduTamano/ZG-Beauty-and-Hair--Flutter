import 'package:flutter/material.dart';

class BottomPrice extends StatefulWidget{
  const BottomPrice({Key? key, required this.shoppingName, required this.shoppingPrice, required this.hairPrice,
    required this.sizeNumList, required this.currentSizeIndex}) : super(key: key);

  final String shoppingName;
  final int shoppingPrice;
  final String hairPrice;
  final List<String> sizeNumList;
  final int currentSizeIndex;
 // final List<String> priceList;

  @override
  _BottomPriceState createState() => _BottomPriceState();
}

class _BottomPriceState extends State<BottomPrice> {

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
      textDirection: TextDirection.rtl,
      child: existed ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -5),
                  blurRadius: 20,
                  color: Colors.black12.withOpacity(0.4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('מחיר סופי'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[
                        Text('${widget.hairPrice} \₪',
                          style: TextStyle(
                            color: Colors.redAccent[100],
                            fontSize: 30,
                            fontFamily: 'rubik_bold',),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -5),
                  blurRadius: 20,
                  color: Colors.black12.withOpacity(0.4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('מחיר סופי'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[
                        Text('${widget.shoppingPrice} \₪',
                          style: TextStyle(
                            color: Colors.redAccent[100],
                            fontSize: 30,
                            fontFamily: 'rubik_bold',),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
