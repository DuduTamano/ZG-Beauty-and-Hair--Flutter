import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key,required this.title,required this.onTap}) : super(key: key);
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // max width
        height: 55.0,
        child: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle2!
                  .copyWith(color: Colors.white, fontSize: 18.0),
            )),
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
            )),
      ),
    );
  }
}
