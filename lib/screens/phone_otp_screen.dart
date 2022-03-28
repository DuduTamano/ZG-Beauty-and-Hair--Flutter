import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:zg_beauty_and_hair/colors/constants.dart';
import 'package:zg_beauty_and_hair/model/user_model.dart';
import 'package:zg_beauty_and_hair/navigation_screen/navigation_bar.dart';
import 'package:zg_beauty_and_hair/dialog/register_dialog.dart';
import 'package:zg_beauty_and_hair/screens/home_screen.dart';
import 'package:zg_beauty_and_hair/screens/phone_auth.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/view_model/main/main_view_model_imp.dart';

class OPTScreen extends StatefulWidget {
  OPTScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  _OPTScreenState createState() => _OPTScreenState();
}

class _OPTScreenState extends State<OPTScreen> {
  final _scaffoldkey1 = GlobalKey<FormState>();
  final _scaffoldkey2 = GlobalKey<FormState>();
  final _scaffoldkey3 = GlobalKey<FormState>();
  final _scaffoldkey4 = GlobalKey<FormState>();
  final scaffoldState = new GlobalKey<ScaffoldState>();


  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.black45,
    ),
  );

  bool isLoggedIn = false;
  bool otpSent = false;
  String? uid;
  String? _verificationCode;

  void next({String? value, FocusNode? focusNode}){
    if(value!.length == 1) {
      focusNode!.requestFocus();
    }
  }

  final mainViewModel = MainViewModelImp();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldkey1,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneAuth()));
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black,),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0 / 3,
              top: 20.0 / 3,
              left: 20.0 / 3,
              right: 20.0 / 3,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40.0,
                  ),
                  RichText(
                    textDirection: TextDirection.rtl,
                    text: TextSpan(
                      text: 'אנא הקשי הזיני את הקוד \n שנשלח אליך לנייד  ',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.black26,
                        fontSize: 18.0,
                        letterSpacing: 1.0,
                        wordSpacing: 1.0,
                      ),
                      children: [
                        TextSpan(
                          text: widget.phoneNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: _scaffoldkey2,
                        child: PinPut(
                            fieldsCount: 6,
                            textStyle: const TextStyle(fontSize: 23.0, color: Colors.black),
                            eachFieldWidth: 42.0,
                            eachFieldHeight: 50.0,
                            focusNode: _pinPutFocusNode,
                            controller: _pinPutController,
                            submittedFieldDecoration: pinPutDecoration,
                            selectedFieldDecoration: pinPutDecoration,
                            followingFieldDecoration: pinPutDecoration,
                            pinAnimationType: PinAnimationType.fade,
                            onSubmit: (pin) async {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithCredential(PhoneAuthProvider.credential(
                                    verificationId: _verificationCode!, smsCode: pin))
                                    .then((value) async {});
                              } catch (e) {
                                FocusScope.of(context).unfocus();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('קוד שגוי!')));
                              }
                            }
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Code expires in:  ',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: kTextColorLight,
                          ),
                        ),
                        TweenAnimationBuilder(
                            tween: IntTween(
                                begin: 60, end: 0),
                            duration: const Duration(seconds: 60),
                            builder: (context, int value, child) =>
                                Text('${value.toInt()}',
                                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black
                                  ),)),
                      ],
                    ),
                  ),
                  TextButton(onPressed: (){
                    _verifyPhone();
                  },
                    child:
                    Text(
                      'שלח שוב',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(13.0),
                  ),
                  SafeArea(
                    child: Container(
                    constraints: BoxConstraints(
                    minWidth: 250,
                    ),
                      child: ElevatedButton.icon(
                        label: Text('כניסה'),
                        style: ElevatedButton.styleFrom(primary: Colors.black, elevation: 5),
                        icon: const Icon(Icons.phone, color: Colors.white),
                        onPressed: () async {

                          DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('Users')
                              .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                                  .get();

                          if(snapshot.exists){
                            print('משתמש קיים');

                            final data = snapshot.data() as Map<String, dynamic>;
                            var userModel = UserModel.fromJson(data);

                            if(userModel.isStaff == true)
                            {
                              Navigator.push(
                                context, MaterialPageRoute(builder: (context) => HomePage(),),);
                            }
                            else
                            {
                              Navigator.push(
                                context, MaterialPageRoute(builder: (context) => BottomNavigation(),),);
                            }
                        } else {
                            print('משתמש לא קיים');

                            ShowRegisterDialog(context, FirebaseFirestore.instance.collection('Users'), scaffoldState);
                          }

                          },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+972${widget.phoneNumber}',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) async {
      if(FirebaseAuth.instance.currentUser != null) {
        setState(() {
          isLoggedIn = true;
          uid = FirebaseAuth.instance.currentUser!.uid;
        });
      } else {
        print("Filed to sign in");
      }
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    setState(() {
      _verificationCode = verificationId;
      otpSent = true;
    });
  }

  void codeSent(String verificationId, [int? a]) {
    setState(() {
      _verificationCode = verificationId;
      otpSent = true;
    });
  }

  void verificationFailed(FirebaseAuthException exception) {
    print(exception.message);
    setState(() {
      Duration(seconds: 60);
      isLoggedIn = false;
      otpSent = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

}