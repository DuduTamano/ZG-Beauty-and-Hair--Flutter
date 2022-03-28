import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ntp/ntp.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zg_beauty_and_hair/navigation_screen/navigation_bar.dart';
import 'package:zg_beauty_and_hair/fcm/fcm_background_handler.dart';
import 'package:zg_beauty_and_hair/screens/barber_booking_history_screen.dart';
import 'package:zg_beauty_and_hair/screens/booking_screen.dart';
import 'package:zg_beauty_and_hair/screens/done_services_screen.dart';
import 'package:zg_beauty_and_hair/screens/home_screen.dart';
import 'package:zg_beauty_and_hair/screens/all_users_screen.dart';
import 'package:zg_beauty_and_hair/screens/phone_auth.dart';
import 'package:zg_beauty_and_hair/screens/staff_home_screen.dart';
import 'package:zg_beauty_and_hair/screens/user_history_screen.dart';
import 'package:zg_beauty_and_hair/state/category_state.dart';
import 'package:zg_beauty_and_hair/utils/utils.dart';
import 'package:zg_beauty_and_hair/view_model/main/main_view_model_imp.dart';
import 'colors/constants.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
AndroidNotificationChannel? channel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Setup Firebase
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  //Flutter Local Notifications
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  channel = AndroidNotificationChannel(
      'dudu.t', 'DUDU', importance: Importance.max);

  await flutterLocalNotificationsPlugin!
  .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel!);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, badge: true, sound: true);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white),
    );
    return MaterialApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("he", "IL"),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Z&G Beauty and Hair',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/staffHome':
            return PageTransition(
                settings: settings,
                child: StaffHome(),
                type: PageTransitionType.fade);

          case '/doneService':
            return PageTransition(
                settings: settings,
                child: DoneServices(),
                type: PageTransitionType.fade);

          case '/home':
            return PageTransition(
                settings: settings,
                child: HomePage(),
                type: PageTransitionType.fade);

          case '/all_users':
            return PageTransition(
                settings: settings,
                child: AllUsersPage(),
                type: PageTransitionType.fade);

          case '/history':
            return PageTransition(
                settings: settings,
                child: UserHistory(),
                type: PageTransitionType.fade);

          case '/booking':
            return PageTransition(
                settings: settings,
                child: BookingScreen(),
                type: PageTransitionType.fade);

          case '/bookingHistory':
            return PageTransition(
                settings: settings,
                child: BarberHistoryScreen(),
                type: PageTransitionType.fade);
          default:
            return null;
        }
      },

      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),//at top left
              bottomRight: Radius.circular(10.0), // at top right
            ),
            gapPadding: 0,
          ),

        ),

      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  final scaffoldState = new GlobalKey<ScaffoldState>();

  late final AnimationController _controler = AnimationController(vsync: this,
      duration: const Duration(seconds: 2))..repeat(reverse: true);

  late final Animation<double> _animation =
  CurvedAnimation(parent: _controler, curve: Curves.elasticOut);

  double element = 10;
  double spacingstart = 1;
  double spacingend = 1;

  bool isPressed = false;

  @override
  void dispose() {
    _controler.dispose();
    super.dispose();
  }

  final mainViewModel = MainViewModelImp();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(left: 0.0, top: 120.0, right: 0.0, bottom: 0.0)),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Z',
                      style: TextStyle(
                          fontSize: 60.0,
                          fontFamily: 'elephant',
                          letterSpacing: 2.0,
                          color: Colors.black,
                          shadows: [
                            BoxShadow(
                                color: kTextColorDark,
                                blurRadius: 0
                            ),
                          ]
                      ),
                    ),
                    RotationTransition(turns: _animation,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 15.0, right: 0.0, bottom: 0.0),
                        child: Text(
                          '&',
                          style: TextStyle(
                              fontSize: 35.0,
                              fontFamily: 'elephant',
                              letterSpacing: 2.0,
                              color: Colors.black,
                              shadows: [
                                BoxShadow(
                                    color: kTextColorDark,
                                    blurRadius: 0
                                ),
                              ]
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'G',
                      style: TextStyle(
                          fontSize: 60.0,
                          fontFamily: 'elephant',
                          letterSpacing: 2.0,
                          color: Colors.black,
                          shadows: [
                            BoxShadow(
                                color: kTextColorDark,
                                blurRadius: 0
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                const Padding(
                    padding: EdgeInsets.all(0)
                ),
                const Text(
                  'Beauty and Hair',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'elephant',
                      color: Colors.black,
                      shadows: [
                        BoxShadow(
                            color: kTextColorDark,
                            blurRadius: 1
                        ),
                      ]
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 290),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                        future: mainViewModel.checkLoginState(context, false, scaffoldState),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                            ),
                            );
                          else {
                            var userState = snapshot.data;
                            if(userState == LOGIN_STATE.LOGGED)
                            {
                              return Container();
                            }
                            else { //If user not login before then return button
                              return Center(
                                child: GestureDetector(
                                  onTapDown: (d) {
                                    setState(() {
                                      element = 0;
                                      spacingstart = 1;
                                      spacingend = 20;

                                      isPressed = true;
                                    });
                                  },
                                  onTapUp: (d) {
                                    setState(() {
                                      element = 0;
                                      spacingstart = 20;
                                      spacingend = 1;

                                      isPressed = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    height: 50,
                                    width: 150,
                                    alignment: Alignment.center,
                                    duration: const Duration(milliseconds: 500),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: isPressed ? Colors.grey.shade200 : Colors.black,
                                      boxShadow: [
                                        BoxShadow(
                                          color: isPressed ? Colors.grey : Colors.black45,
                                          offset: const Offset(1, 10),
                                          blurRadius: 25,
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: (){
                                        Navigator.push(
                                          context, MaterialPageRoute(
                                          builder: (context) => PhoneAuth(),),);
                                      },
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
                                      icon: SvgPicture.asset('assets/icons/phone.svg', width: 20.0 ,height: 30.0, color: Colors.white),
                                      label: TweenAnimationBuilder(
                                        curve: Curves.easeOutCubic,
                                        duration: Duration(milliseconds: 100),
                                        tween: Tween<double>(begin: spacingstart, end: spacingend),
                                        builder: (context, double spacingstart, child){
                                          return Text(
                                            'כניסה',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              letterSpacing: spacingstart,
                                              fontWeight: FontWeight.w500
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}