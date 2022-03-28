import 'package:flutter/material.dart';

class ImageProduct extends StatefulWidget {
  const ImageProduct({Key? key, required this.shoppingImage}) : super(key: key);

  final String shoppingImage;

  @override
  _ImageProductState createState() => _ImageProductState();
}

class _ImageProductState extends State<ImageProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260.0,
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                child: Image.network(
                  widget.shoppingImage,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
