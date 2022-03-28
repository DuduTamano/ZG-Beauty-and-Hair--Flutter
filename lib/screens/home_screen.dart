import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zg_beauty_and_hair/colors/constants.dart';
import 'package:zg_beauty_and_hair/fcm/fcm_notification_handler.dart';
import 'package:zg_beauty_and_hair/flutter_icons_design/custom_icons_icons.dart';
import 'package:zg_beauty_and_hair/flutter_icons_design/shopping_icon_icons.dart';
import 'package:zg_beauty_and_hair/main.dart';
import 'package:zg_beauty_and_hair/model/image_model.dart';
import 'package:zg_beauty_and_hair/navigation_screen/drawer_screen.dart';
import 'package:zg_beauty_and_hair/screens/booking_screen.dart';
import 'package:zg_beauty_and_hair/screens/user_history_screen.dart';
import 'package:zg_beauty_and_hair/shopping_screens/shopping_screen.dart';
import 'package:zg_beauty_and_hair/view_model/home/home_view_model.dart';
import 'package:zg_beauty_and_hair/view_model/home/home_view_model_imp.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final homeViewModel = HomeViewModelImp();

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawer = false;

  @override
  void initState() {
    super.initState();

    //Get token
    FirebaseMessaging.instance.getToken()
        .then((value) => print('Token $value'));

    //Subscribe topic, example name is: demoSubscribe
    FirebaseMessaging.instance.subscribeToTopic(
        FirebaseAuth.instance.currentUser!.uid)
        .then((value) => print('Success'));

    //Setup message display
    initFirebaseMessagingHandler(channel!);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
          ..scale(isDrawer ? 0.85 : 1.00)
        ..rotateZ(isDrawer ? -50 : 0),
        duration: Duration(milliseconds: 250),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: Center(
                child: FutureBuilder(
                  future: homeViewModel.displayUserProfiles(
                      context, FirebaseAuth.instance.currentUser!.phoneNumber!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      return Column(
                          children: [
                            homeViewModel.isStaff(context)
                                ? IconButton(
                                icon: Icon(Icons.exit_to_app,
                                    size: 30,
                                    color: Colors.black),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => SplashScreen(),),);
                                })
                                : isDrawer ? IconButton(
                              icon: Icon(
                                IconlyBroken.arrowLeft2, size: 33.0,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  xOffset = 0;
                                  yOffset = 0;
                                 // scaleFactor = 1;
                                  isDrawer = false;
                                  // _key.currentState!.openDrawer();
                                });
                              },
                            ) : IconButton(
                              icon: Icon(
                                Icons.drag_indicator_outlined, size: 33.0,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  xOffset = 290;
                                  yOffset = 80;
                                 // scaleFactor = 0.8;
                                  isDrawer = true;

                                });
                              },
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
              title: const Center(
                child: Image(
                  height: 80,
                  width: 80,
                  image: AssetImage('assets/images/zglogo.png'),
                ),
              ),
              actions: [
                FutureBuilder(
                  future: homeViewModel.displayUserProfiles(context, FirebaseAuth.instance.currentUser!.phoneNumber!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      return Container(
                        child: Column(
                          children: [
                            homeViewModel.isStaff(context) ?
                            IconButton(
                              icon: Icon(Icons.admin_panel_settings,
                                  size: 40,
                                  color: Colors.black),
                              onPressed: () =>
                                  Navigator.of(context).pushNamed('/staffHome'),
                              padding: EdgeInsets.only(right: 40, top: 5),)
                                : Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Center(
                                  child: IconButton(onPressed: () {},
                                    iconSize: 30.0,
                                    padding: const EdgeInsets.only(
                                      right: 20,
                                    ),
                                    icon: SvgPicture.asset(
                                        'assets/icons/shopping-cart.svg'),),

                                ),
                                Positioned(
                                  left: -8,
                                  top: 20,
                                  child: Container(
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: kOutlineInputColor,
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '0',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

           // drawer: DrawerScreen(),

            //Menu
            body: Menu(context, homeViewModel),

          ),
      ),
    );
  }
}

Widget Menu(BuildContext context, HomeViewModel homeViewModel) {
  return SingleChildScrollView(
    child: FutureBuilder(
      future: homeViewModel.displayUserProfiles(
          context, FirebaseAuth.instance.currentUser!.phoneNumber!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          return Container(
            child: Column(
              children: [
                homeViewModel.isStaff(context)
                    ? Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(
                                  context, '/history'),
                          child: Container(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,
                                  children: [
                                    Icon(Icons.history, size: 30,),
                                    Text('History',
                                      style: GoogleFonts.robotoMono(),)
                                  ],
                                ),
                              ),),),
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingScreen(),),),

                            child: Container(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart, size: 30,),
                                      Text('Shopping',
                                        style: GoogleFonts.robotoMono(),)
                                    ],
                                  ),
                                ),),),
                          )),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(
                                  context, '/booking'),
                          child: Container(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,
                                  children: [
                                    Icon(Icons.book_online, size: 30,),
                                    Text('Booking',
                                      style: GoogleFonts.robotoMono(),)
                                  ],
                                ),
                              ),),),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(
                                  context, '/all_users'),
                          child: Container(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,
                                  children: [
                                    Icon(CupertinoIcons.checkmark_rectangle, size: 30,),
                                    Text('אנשי קשר',
                                      style: GoogleFonts.robotoMono(),)
                                  ],
                                ),
                              ),),),
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(),

                //Banner
                FutureBuilder(
                    future: homeViewModel.displayBanner(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),);
                      else {
                        var banners = snapshot.data as List<ImageModel>;
                        return CarouselSlider(
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                aspectRatio: 3.0,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3)
                            ),
                            items: banners.map((e) =>
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        8),
                                    child: Image.network(e.image),
                                  ),
                                )).toList()
                        );
                      }
                    }),
                Padding(padding: const EdgeInsets.all(8),
                  child: Row(children: [
                  ],
                  ),
                ),

                //Lookbook
                FutureBuilder(
                    future: homeViewModel.displayLookBook(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else {
                        var lookbook = snapshot.data as List<ImageModel>;
                        return Column(
                          children: lookbook.map((e) =>
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(e.image),
                                ),
                              ),
                          ).toList(),
                        );
                      }
                    }),

              ],
            ),
          );
        }
      },
    ),
  );
}