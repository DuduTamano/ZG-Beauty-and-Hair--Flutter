import 'package:flutter/material.dart';

class TextHairColor extends StatefulWidget {
  const TextHairColor({Key? key}) : super(key: key);
  
  @override
  _TextHairColorState createState() => _TextHairColorState();
}

class _TextHairColorState extends State<TextHairColor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('כל התוספות מגיעות בגוון טבעי',
              style: TextStyle(
                  fontFamily: 'rubik',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: 5.0,),
        Container(
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 35.0,
            backgroundImage: AssetImage('assets/images/brazilian.png'),
          ),
        ),
      ],
    );
  }
}
