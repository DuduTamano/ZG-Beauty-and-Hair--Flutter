import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({Key? key, required this.shoppingDec}) : super(key: key);

  final String shoppingDec;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool isExpanded = false;


  void _expand() {
    setState(() {
      isExpanded ? isExpanded = false : isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 18.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    "תיאור המוצר",
                    style: TextStyle(
                        fontFamily: 'rubik',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 26.0,
                    right: 18.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,

                  child: AnimatedCrossFade(
                    firstChild: Text(
                      widget.shoppingDec,
                      maxLines: 2,
                      style: TextStyle(
                          fontFamily: 'rubik',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 15),
                    ),
                    secondChild: Text(
                      widget.shoppingDec,
                      style: TextStyle(
                          fontFamily: 'rubik',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 15),
                    ),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: kThemeAnimationDuration,
                  ),
                ),
              ),

            //  SizedBox(height: 2),

              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: GestureDetector(
                      onTap: _expand,
                      child: isExpanded ? Column(
                        children: [
                          Icon(IconlyBroken.arrowUp2,
                              color: Colors.black),
                          Text('הצג מידע קצר'),
                        ],
                      )
                          : Column(
                        children: [
                          Text('הצג מידע מלא'),
                          Icon(IconlyBroken.arrowDown2,
                              color: Colors.black)
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
