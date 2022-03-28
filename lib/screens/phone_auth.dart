import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zg_beauty_and_hair/colors/constants.dart';
import 'package:zg_beauty_and_hair/main.dart';
import 'package:zg_beauty_and_hair/screens/phone_otp_screen.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {

  bool validate = false;
  TextEditingController phoneNumberController = TextEditingController();

  //alert dialog
  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: const [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
          ),
          SizedBox(width: 8,),
          Text('אנא המתיני')
        ],
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context, builder: (BuildContext context) {
      return alert;
    });
  }

  @override
  void dispose() {
    showAlertDialog(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black,),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: kDefaultPadding,),
                  Text(
                    'ברוכה הבאה', textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      shadows: [
                        const BoxShadow(
                          color: Colors.yellow,
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding,),
                  Text(
                    'בבקשה הזיני את המספר נייד שלך',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: kTextColorLight,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.0,
                      wordSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding * 3,),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        const SizedBox(width: 0,),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            onChanged: (value) {
                              if(value.length == 10) {
                                setState(() {
                                  validate = true;
                                });
                              } if(value.length < 10) {
                                setState(() {
                                  validate = false;
                                });
                              }
                            },
                            autofocus: true,
                            maxLength: 10,
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            keyboardAppearance: Brightness.dark,
                            decoration: InputDecoration(
                              hintTextDirection: TextDirection.rtl,
                              labelText: 'מספר נייד',
                              hintText: 'הקלדי את מספר הנייד',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 15.0, 15.0, 15.0
                                ),
                                child: SvgPicture.asset('assets/icons/phone.svg', width: 20.0 ,height: 30.0,),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                gapPadding: 0,
                              ),
                              focusColor: kPrimartColor,
                              hoverColor: kPrimartColor,
                              fillColor: kPrimartColor,
                              hintStyle: const TextStyle(color: kTextColorDark),
                              labelStyle: const TextStyle(color: kTextColorDark),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)
                                ),
                                gapPadding: 0,
                                borderSide: BorderSide(color: kOutlineInputColor, width: 0.4),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)
                                ),
                                gapPadding: 0,
                                borderSide: BorderSide(color: Colors.black26, width: 0.5),
                              ),
                            ),
                          ),),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(
                    left: 0.0, top: 0.0, right: 0.0, bottom: 0.0,
                  ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: AbsorbPointer(
                        absorbing: validate ? false : true,
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 250,
                          ),
                          child: ElevatedButton(
                            child: Text(
                              'הבא',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: validate
                                  ? MaterialStateProperty.all(Colors.black)
                                  : MaterialStateProperty.all(Colors.grey),

                            ),

                            onPressed: () {
                              String number = '${phoneNumberController.text}';

                              Navigator.push(
                                context, MaterialPageRoute(builder: (context) => OPTScreen(phoneNumber: number,),),);

                            },
                          ),
                        ),
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
}
