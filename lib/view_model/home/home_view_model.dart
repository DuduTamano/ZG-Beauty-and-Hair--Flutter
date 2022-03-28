import 'package:flutter/cupertino.dart';
import 'package:zg_beauty_and_hair/model/image_model.dart';
import 'package:zg_beauty_and_hair/model/user_model.dart';

abstract class HomeViewModel{
  Future<UserModel> displayUserProfiles(BuildContext context, String phoneNumber);
  Future<List<ImageModel>> displayBanner();
  Future<List<ImageModel>> displayLookBook();

  bool isStaff(BuildContext context);
}