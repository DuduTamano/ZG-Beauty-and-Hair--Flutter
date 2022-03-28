import 'package:flutter/material.dart';

class TextProduct extends StatefulWidget {

  const TextProduct({Key? key, required this.shoppingName, }) : super(key: key);

  final String shoppingName;

  @override
  _TextProductState createState() => _TextProductState();
}

class _TextProductState extends State<TextProduct> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              child: Text(widget.shoppingName,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 45,
                  fontFamily: 'rubik_bold',),
              ),
            ),
          ),
        ],
      ),
    );
  }
}