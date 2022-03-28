import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:zg_beauty_and_hair/flutter_icons_design/custom_icons_icons.dart';
import 'package:zg_beauty_and_hair/screens/booking_screen.dart';
import 'package:zg_beauty_and_hair/screens/home_screen.dart';
import 'package:zg_beauty_and_hair/shopping_screens/shopping_screen.dart';
import 'package:zg_beauty_and_hair/screens/user_history_screen.dart';
import 'package:zg_beauty_and_hair/flutter_icons_design/shopping_icon_icons.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    if(selectedIndex == 0){
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: buildPages(selectedIndex),
          bottomNavigationBar: buildBottomNavigation(),
        ),
      );
    } else{
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: buildPages(selectedIndex),
        //  bottomNavigationBar: buildBottomNavigation(),
        ),
      );
    }
  }

  Widget buildBottomNavigation() {
    final inactiveColor = Colors.grey;
    final activeColor = Colors.black;

    return BottomNavyBar(
      animationDuration: Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      backgroundColor: Colors.white,
      selectedIndex: selectedIndex,
      onItemSelected: (index){
        setState(() => this.selectedIndex = index);
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
            icon: Icon(IconlyBroken.home),
            title: Text('מסך הבית'),
            inactiveColor: inactiveColor,
            activeColor: activeColor,
            textAlign: TextAlign.center
        ),
        BottomNavyBarItem(
            icon: Icon(Shopping_icon.shopping),
            title: Text('חנות'),
            inactiveColor: inactiveColor,
            activeColor: activeColor,
            textAlign: TextAlign.center
        ),
        BottomNavyBarItem(
            icon: Icon(CustomIcons.booking),
            title: Text('קביעת תורים'),
            inactiveColor: inactiveColor,
            activeColor: activeColor,
            textAlign: TextAlign.center
        ),
        BottomNavyBarItem(
            icon: Icon(IconlyBroken.calendar),
            title: Text('התורים שלי'),
            inactiveColor: inactiveColor,
            activeColor: activeColor,
            textAlign: TextAlign.center
        ),
      ],
    );
  }

  Widget buildPages(int index){
    List<Widget> pages = [
      HomePage(),
      ShoppingScreen(),
      BookingScreen(),
      UserHistory(),
    ];

    return IndexedStack(
    index: selectedIndex,
    children: pages,
    );
  }
}



