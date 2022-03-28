import 'package:flutter/material.dart';

class HairSize extends StatefulWidget {
  const HairSize({Key? key, required this.price}) : super(key: key);

  final int? price;

  @override
  _HairSizeState createState() => _HairSizeState();
}

class _HairSizeState extends State<HairSize> {

  int currentSizeIndex = 0;

  final sizeNumList = ["14", "16", "18", "20", "22", "24", "26"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            child: Row(
              children: [
                Container(
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: sizeNumList.map((item) {
                      var index = sizeNumList.indexOf(item);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentSizeIndex = index;
                            var priceList = ["200", "400", "600", "800", "1000", "1200", "1400"];

                         //   ScaffoldMessenger.of(context)
                           //     .showSnackBar(SnackBar(content: Text('${priceList[index]}')));
                            print(priceList[index]);
                          });
                        },
                        child: sizeItem(item, index == currentSizeIndex, context),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget sizeItem(String size, bool isSelected, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 5.0),
    child: Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade700 : Colors.white,
          border: Border.all(
            width: 2.0,
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: [
            BoxShadow(
                color:
                isSelected ? Colors.black.withOpacity(.5) : Colors.black12,
                offset: Offset(0.0, 5.0),
                blurRadius: 5.0)
          ]),
      child: Center(
        child: Text(size,
            style:
            TextStyle(color: isSelected ? Colors.white : Colors.black, fontFamily: 'rubik',)),
      ),
    ),
  );
}