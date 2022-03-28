import 'package:flutter/material.dart';
import 'package:zg_beauty_and_hair/utils/utils.dart';

abstract class MainViewModel{
  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState);
}