import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:zg_beauty_and_hair/flutter_icons_design/custom_icons_icons.dart';
import 'package:zg_beauty_and_hair/flutter_icons_design/shopping_icon_icons.dart';
import 'package:zg_beauty_and_hair/screens/booking_screen.dart';
import 'package:zg_beauty_and_hair/screens/home_screen.dart';
import 'package:zg_beauty_and_hair/screens/user_history_screen.dart';
import 'package:zg_beauty_and_hair/shopping_screens/shopping_screen.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getFooter(),
      body: getBody(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: activeTab,
      children: [
        HomePage(),
        ShoppingScreen(),
        BookingScreen(),
        UserHistory(),
      ],
    );
  }

  Widget getFooter() {
    List items = [
      IconlyBroken.home,
      Shopping_icon.shopping,
      CustomIcons.booking,
      IconlyBroken.calendar,
    ];

    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            return IconButton(
                icon: Icon(
                  items[index],
                  color: activeTab == index ? Colors.black : Colors.black26,
                ),
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    activeTab = index;
                  });
                },
            );
          }),
        ),
      ),
    );
  }
}
